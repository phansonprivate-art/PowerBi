# Fix visual.json files:
# - Add required 'name' (= folder name)
# - Keep 'position'
# - Move visualType, displayName, config, visualMapping, objects, dataRoles under 'visual' sub-object
# - All those properties are forbidden at root level per schema

$pagesDir = 'C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance\Lucanet_Finance.Report\definition\pages'

$total = 0

foreach ($pageDir in Get-ChildItem -Path $pagesDir -Directory) {
  $visualsDir = Join-Path $pageDir.FullName "visuals"
  if (-not (Test-Path $visualsDir)) { continue }

  foreach ($visualDir in Get-ChildItem -Path $visualsDir -Directory) {
    $vcName = $visualDir.Name
    $vjPath = Join-Path $visualDir.FullName "visual.json"
    if (-not (Test-Path $vjPath)) { continue }

    $vj = Get-Content $vjPath -Raw | ConvertFrom-Json

    $newVis = [ordered]@{}
    $newVis['$schema'] = $vj.'$schema'
    $newVis['name']    = $vcName

    # Position stays at root
    if ($null -ne $vj.position) { $newVis['position'] = $vj.position }

    # Visual-specific content goes into 'visual' sub-object
    $visualContent = [ordered]@{}
    if ($null -ne $vj.visualType)    { $visualContent['visualType']   = $vj.visualType }
    if ($null -ne $vj.displayName)   { $visualContent['displayName']  = $vj.displayName }
    if ($null -ne $vj.config)        { $visualContent['config']       = $vj.config }
    if ($null -ne $vj.visualMapping) { $visualContent['visualMapping'] = $vj.visualMapping }
    if ($null -ne $vj.objects)       { $visualContent['objects']      = $vj.objects }
    if ($null -ne $vj.dataRoles)     { $visualContent['dataRoles']    = $vj.dataRoles }

    if ($visualContent.Count -gt 0) {
      $newVis['visual'] = $visualContent
    }

    $newVisJson = ConvertTo-Json $newVis -Depth 30
    [System.IO.File]::WriteAllText($vjPath, $newVisJson, [System.Text.UTF8Encoding]::new($false))
    $total++
  }
}

Write-Host "Updated $total visual.json files"
