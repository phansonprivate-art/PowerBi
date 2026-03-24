# Fix visual.json: inside 'visual' sub-object, keep only visualType + objects
# Remove: displayName, config, visualMapping, dataRoles (all forbidden)

$pagesDir = 'C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance\Lucanet_Finance.Report\definition\pages'
$total = 0

foreach ($pageDir in Get-ChildItem -Path $pagesDir -Directory) {
  $visualsDir = Join-Path $pageDir.FullName "visuals"
  if (-not (Test-Path $visualsDir)) { continue }

  foreach ($visualDir in Get-ChildItem -Path $visualsDir -Directory) {
    $vjPath = Join-Path $visualDir.FullName "visual.json"
    if (-not (Test-Path $vjPath)) { continue }

    $vj = Get-Content $vjPath -Raw | ConvertFrom-Json

    $newVis = [ordered]@{}
    $newVis['$schema'] = $vj.'$schema'
    $newVis['name']    = $vj.name
    if ($null -ne $vj.position) { $newVis['position'] = $vj.position }

    # visual sub-object: only visualType and objects allowed
    if ($null -ne $vj.visual) {
      $visualSub = [ordered]@{}
      if ($null -ne $vj.visual.visualType) { $visualSub['visualType'] = $vj.visual.visualType }
      if ($null -ne $vj.visual.objects)    { $visualSub['objects']    = $vj.visual.objects }
      if ($visualSub.Count -gt 0) { $newVis['visual'] = $visualSub }
    }

    $newVisJson = ConvertTo-Json $newVis -Depth 30
    [System.IO.File]::WriteAllText($vjPath, $newVisJson, [System.Text.UTF8Encoding]::new($false))
    $total++
  }
}

Write-Host "Updated $total visual.json files"
