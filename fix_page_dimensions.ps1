# Add width and height to all page.json files
# Required when displayOption != Dynamic

$pagesDir = 'C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance\Lucanet_Finance.Report\definition\pages'

# Page canvas dimensions (width x height in PBI canvas units)
# Calculated from max visual extents + padding
$pageDimensions = @{
  "Bilanz"             = @{ width = 1280; height = 1920 }  # 25 visuals, max y=1830
  "Customer_Product"   = @{ width = 1280; height = 2560 }  # 31 visuals
  "Executive_Overview" = @{ width = 1280; height = 3200 }  # 41 visuals
  "GuV"                = @{ width = 1280; height = 2800 }  # 35 visuals
  "Market_Insights"    = @{ width = 1280; height = 1600 }  # 21 visuals
}

foreach ($pageDir in Get-ChildItem -Path $pagesDir -Directory) {
  $pageName = $pageDir.Name
  $pageJsonPath = Join-Path $pageDir.FullName "page.json"
  if (-not (Test-Path $pageJsonPath)) { continue }

  $pj = Get-Content $pageJsonPath -Raw | ConvertFrom-Json
  $dims = $pageDimensions[$pageName]
  if ($null -eq $dims) { Write-Host "No dims for $pageName"; continue }

  $newPage = [ordered]@{}
  $newPage['$schema']      = $pj.'$schema'
  $newPage['name']         = $pj.name
  if ($null -ne $pj.displayName)  { $newPage['displayName']  = $pj.displayName }
  if ($null -ne $pj.displayOption){ $newPage['displayOption'] = $pj.displayOption }
  $newPage['width']  = $dims.width
  $newPage['height'] = $dims.height
  if ($null -ne $pj.objects) { $newPage['objects'] = $pj.objects }

  $newPageJson = ConvertTo-Json $newPage -Depth 30
  [System.IO.File]::WriteAllText($pageJsonPath, $newPageJson, [System.Text.UTF8Encoding]::new($false))
  Write-Host "Fixed $pageName -> $($dims.width)x$($dims.height)"
}

Write-Host "Done!"
