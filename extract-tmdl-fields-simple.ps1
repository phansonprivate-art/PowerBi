param([string]$TmdlPath)

$TmdlPath = Resolve-Path $TmdlPath
Write-Host "Extracting TMDL fields from: $TmdlPath" -ForegroundColor Cyan

$AllFields = @{}
$Files = Get-ChildItem -Path $TmdlPath -Filter "*.tmdl" -File | Where-Object {$_.Name -notmatch "database|model|relationships"}

foreach ($File in $Files) {
    $TableName = $File.BaseName
    $Content = Get-Content -Path $File.FullName -Raw
    
    $Columns = @()
    $Measures = @()
    
    # Split by lines and process
    $Lines = $Content -split "`n"
    foreach ($Line in $Lines) {
        if ($Line -match '^\s+column\s+(\S+)') {
            $Columns += $matches[1]
        }
        if ($Line -match '^\s+measure\s+(\S+)') {
            $Measures += $matches[1]
        }
    }
    
    $AllFields[$TableName] = @{
        "columns" = $Columns
        "measures" = $Measures
    }
    
    Write-Host "$TableName`: $($Columns.Count) cols, $($Measures.Count) measures"
}

$Output = @{
    "generatedAt" = (Get-Date -Format "o")
    "totalEntities" = $AllFields.Count
    "entities" = $AllFields
} | ConvertTo-Json -Depth 10

$OutputPath = Join-Path (Split-Path $TmdlPath -Parent) "TMDL-Feldliste.json"
$Output | Set-Content -Path $OutputPath -Encoding UTF8

Write-Host "`nOutput saved to: $OutputPath" -ForegroundColor Green
