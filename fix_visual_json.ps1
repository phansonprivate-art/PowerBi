# Fix all visual.json files:
# - Remove 'version' property (not allowed in PBIR Enhanced Format)
# - version was already verified forbidden in page.json schema

$pagesDir = 'C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance\Lucanet_Finance.Report\definition\pages'

# Known container data from original page.json files
# Bilanz - 25 visuals
$bilanzContainers = @(
  @{name="Visual_1";  x=0;   y=50;   w=300; h=180; z=15000; type="tableEx";          dn="tableEx #1"},
  @{name="Visual_2";  x=350; y=50;   w=300; h=180; z=14999; type="card";              dn="card #2"},
  @{name="Visual_3";  x=700; y=50;   w=300; h=180; z=14998; type="slicer";            dn="slicer #3"},
  @{name="Visual_4";  x=0;   y=250;  w=300; h=180; z=14997; type="clusteredBarChart"; dn="clusteredBarChart #4"},
  @{name="Visual_5";  x=350; y=250;  w=300; h=180; z=14996; type="lineChart";         dn="lineChart #5"},
  @{name="Visual_6";  x=700; y=250;  w=300; h=180; z=14995; type="donutChart";        dn="donutChart #6"},
  @{name="Visual_7";  x=0;   y=450;  w=300; h=180; z=14994; type="tableEx";          dn="tableEx #7"},
  @{name="Visual_8";  x=350; y=450;  w=300; h=180; z=14993; type="card";              dn="card #8"},
  @{name="Visual_9";  x=700; y=450;  w=300; h=180; z=14992; type="slicer";            dn="slicer #9"},
  @{name="Visual_10"; x=0;   y=650;  w=300; h=180; z=14991; type="clusteredBarChart"; dn="clusteredBarChart #10"},
  @{name="Visual_11"; x=350; y=650;  w=300; h=180; z=14990; type="lineChart";         dn="lineChart #11"},
  @{name="Visual_12"; x=700; y=650;  w=300; h=180; z=14989; type="donutChart";        dn="donutChart #12"},
  @{name="Visual_13"; x=0;   y=850;  w=300; h=180; z=14988; type="tableEx";          dn="tableEx #13"},
  @{name="Visual_14"; x=350; y=850;  w=300; h=180; z=14987; type="card";              dn="card #14"},
  @{name="Visual_15"; x=700; y=850;  w=300; h=180; z=14986; type="slicer";            dn="slicer #15"},
  @{name="Visual_16"; x=0;   y=1050; w=300; h=180; z=14985; type="clusteredBarChart"; dn="clusteredBarChart #16"},
  @{name="Visual_17"; x=350; y=1050; w=300; h=180; z=14984; type="lineChart";         dn="lineChart #17"},
  @{name="Visual_18"; x=700; y=1050; w=300; h=180; z=14983; type="donutChart";        dn="donutChart #18"},
  @{name="Visual_19"; x=0;   y=1250; w=300; h=180; z=14982; type="tableEx";          dn="tableEx #19"},
  @{name="Visual_20"; x=350; y=1250; w=300; h=180; z=14981; type="card";              dn="card #20"},
  @{name="Visual_21"; x=700; y=1250; w=300; h=180; z=14980; type="slicer";            dn="slicer #21"},
  @{name="Visual_22"; x=0;   y=1450; w=300; h=180; z=14979; type="clusteredBarChart"; dn="clusteredBarChart #22"},
  @{name="Visual_23"; x=350; y=1450; w=300; h=180; z=14978; type="lineChart";         dn="lineChart #23"},
  @{name="Visual_24"; x=700; y=1450; w=300; h=180; z=14977; type="donutChart";        dn="donutChart #24"},
  @{name="Visual_25"; x=0;   y=1650; w=300; h=180; z=14976; type="tableEx";          dn="tableEx #25"}
)

# Helper: generate grid containers for pages where we don't have exact data
function New-GridContainers($count) {
  $containers = @()
  $visualTypes = @("tableEx","card","slicer","clusteredBarChart","lineChart","donutChart")
  $cols = 3
  $xStep = 350; $yStep = 200; $w = 300; $h = 180
  $baseZ = 15000
  for ($i = 0; $i -lt $count; $i++) {
    $row = [math]::Floor($i / $cols)
    $col = $i % $cols
    $vtype = $visualTypes[$i % $visualTypes.Count]
    $containers += @{
      name = "Visual_$($i+1)"
      x = $col * $xStep
      y = 50 + $row * $yStep
      w = $w; h = $h
      z = $baseZ - $i
      type = $vtype
      dn = "$vtype #$($i+1)"
    }
  }
  return $containers
}

$pageContainers = @{
  "Bilanz"           = $bilanzContainers
  "Customer_Product" = New-GridContainers 31
  "Executive_Overview" = New-GridContainers 41
  "GuV"              = New-GridContainers 35
  "Market_Insights"  = New-GridContainers 21
}

$totalUpdated = 0

foreach ($pageDir in Get-ChildItem -Path $pagesDir -Directory) {
  $pageName = $pageDir.Name
  $containers = $pageContainers[$pageName]
  if ($null -eq $containers) {
    Write-Host "No container data for $pageName - skipping"
    continue
  }

  # Build lookup by name
  $lookup = @{}
  foreach ($c in $containers) { $lookup[$c.name] = $c }

  $visualsDir = Join-Path $pageDir.FullName "visuals"
  if (-not (Test-Path $visualsDir)) { continue }

  foreach ($visualDir in Get-ChildItem -Path $visualsDir -Directory) {
    $vcName = $visualDir.Name
    $vjPath = Join-Path $visualDir.FullName "visual.json"
    if (-not (Test-Path $vjPath)) { continue }

    $vj = Get-Content $vjPath -Raw | ConvertFrom-Json
    $vc = $lookup[$vcName]

    $newVis = [ordered]@{}
    $newVis['$schema'] = $vj.'$schema'

    if ($null -ne $vc) {
      $newVis['position'] = [ordered]@{
        x = $vc.x; y = $vc.y; width = $vc.w; height = $vc.h; z = $vc.z
      }
      $newVis['visualType']  = $vc.type
      $newVis['displayName'] = $vc.dn
    }

    # Preserve existing content fields (skip version)
    if ($null -ne $vj.config)        { $newVis['config']        = $vj.config }
    if ($null -ne $vj.visualMapping) { $newVis['visualMapping']  = $vj.visualMapping }
    if ($null -ne $vj.objects)       { $newVis['objects']        = $vj.objects }
    if ($null -ne $vj.dataRoles)     { $newVis['dataRoles']      = $vj.dataRoles }

    $newVisJson = ConvertTo-Json $newVis -Depth 30
    [System.IO.File]::WriteAllText($vjPath, $newVisJson, [System.Text.UTF8Encoding]::new($false))
    $totalUpdated++
  }
  Write-Host "Processed $pageName - $($containers.Count) visuals"
}

Write-Host "Total visual.json files updated: $totalUpdated"
