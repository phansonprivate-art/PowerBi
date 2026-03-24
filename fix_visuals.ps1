$pagesDir = 'C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance\Lucanet_Finance.Report\definition\pages'

foreach ($pageDir in Get-ChildItem -Path $pagesDir -Directory) {
    $pageName = $pageDir.Name
    $pageJsonPath = Join-Path $pageDir.FullName 'page.json'
    if (-not (Test-Path $pageJsonPath)) { continue }

    $pageJson = Get-Content $pageJsonPath -Raw | ConvertFrom-Json
    $visualContainers = $pageJson.visualContainers

    if ($null -eq $visualContainers) {
        Write-Host "No visualContainers in $pageName (already cleaned)"
        continue
    }

    # Remove visualContainers and version from page.json, add name
    $newPage = [ordered]@{}
    $newPage['$schema']      = $pageJson.'$schema'
    $newPage['name']         = $pageName
    if ($null -ne $pageJson.displayName)  { $newPage['displayName']  = $pageJson.displayName }
    if ($null -ne $pageJson.displayOption){ $newPage['displayOption'] = $pageJson.displayOption }
    if ($null -ne $pageJson.objects)      { $newPage['objects']       = $pageJson.objects }

    $newPageJson = ConvertTo-Json $newPage -Depth 30
    [System.IO.File]::WriteAllText($pageJsonPath, $newPageJson, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Fixed page.json: $pageName"

    # Move container metadata into each visual.json
    $updated = 0
    foreach ($vc in $visualContainers) {
        $vcName = $vc.name
        $visualJsonPath = Join-Path $pageDir.FullName "visuals\$vcName\visual.json"
        if (-not (Test-Path $visualJsonPath)) {
            Write-Host "  MISSING visual.json for $vcName"
            continue
        }

        $vj = Get-Content $visualJsonPath -Raw | ConvertFrom-Json

        $newVis = [ordered]@{}
        $newVis['$schema'] = $vj.'$schema'
        if ($null -ne $vc.position)     { $newVis['position']     = $vc.position }
        if ($null -ne $vc.visualType)   { $newVis['visualType']   = $vc.visualType }
        if ($null -ne $vc.displayName)  { $newVis['displayName']  = $vc.displayName }
        if ($null -ne $vj.config)       { $newVis['config']       = $vj.config }
        if ($null -ne $vj.visualMapping){ $newVis['visualMapping'] = $vj.visualMapping }
        if ($null -ne $vj.objects)      { $newVis['objects']      = $vj.objects }
        if ($null -ne $vj.dataRoles)    { $newVis['dataRoles']    = $vj.dataRoles }
        # version intentionally omitted

        $newVisJson = ConvertTo-Json $newVis -Depth 30
        [System.IO.File]::WriteAllText($visualJsonPath, $newVisJson, [System.Text.UTF8Encoding]::new($false))
        $updated++
    }
    Write-Host "  -> Updated $updated visual.json files"
}
Write-Host "All done!"
