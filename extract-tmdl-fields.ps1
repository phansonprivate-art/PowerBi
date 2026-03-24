#Requires -Version 5.1
<#
.SYNOPSIS
Extract fields (columns & measures) from TMDL files and create TMDL-Feldliste.json

.PARAMETER TmdlPath
Path to the TMDL tables folder

.EXAMPLE
.\extract-tmdl-fields.ps1 -TmdlPath "TMDL_EXPORT/definition/tables"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$TmdlPath
)

$ErrorActionPreference = "Stop"

# Convert to absolute path
$TmdlPath = Resolve-Path $TmdlPath
Write-Host "📂 TMDL Path: $TmdlPath" -ForegroundColor Cyan

# Container for all fields
$AllFields = @{}

# Get all .tmdl files (except relationships)
$TmdlFiles = Get-ChildItem -Path $TmdlPath -Filter "*.tmdl" -File | `
    Where-Object { $_.Name -notmatch "relationships|database|model" }

Write-Host "📄 Found $($TmdlFiles.Count) table files" -ForegroundColor Yellow

foreach ($File in $TmdlFiles) {
    $TableName = $File.BaseName
    $EntityName = $TableName  # TMDL table names = Entity names
    
    Write-Host "  Processing table: $TableName" -ForegroundColor Green
    
    # Read file content
    $Content = Get-Content -Path $File.FullName -Raw
    
    $Columns = @()
    $Measures = @()
    
    # Extract columns (pattern: "column ColumnName")
    $ColumnMatches = [regex]::Matches($Content, '^\s+column\s+(\S+)', [System.Text.RegularExpressions.RegexOptions]::Multiline)
    foreach ($Match in $ColumnMatches) {
        $ColumnName = $Match.Groups[1].Value
        $Columns += $ColumnName
    }
    
    # Extract measures (pattern: "measure MeasureName")
    $MeasureMatches = [regex]::Matches($Content, '^\s+measure\s+(\S+)', [System.Text.RegularExpressions.RegexOptions]::Multiline)
    foreach ($Match in $MeasureMatches) {
        $MeasureName = $Match.Groups[1].Value
        $Measures += $MeasureName
    }
    
    # Store in dictionary
    $AllFields[$EntityName] = @{
        "columns" = $Columns
        "measures" = $Measures
    }
    
    Write-Host "    ├─ Columns: $($Columns.Count)" -ForegroundColor Gray
    Write-Host "    └─ Measures: $($Measures.Count)" -ForegroundColor Gray
}

# Create JSON structure (TMDL-Feldliste.json)
$JsonOutput = @{
    "generatedAt" = (Get-Date -Format "o")
    "totalEntities" = $AllFields.Count
    "entities" = $AllFields
} | ConvertTo-Json -Depth 10

# Save output file
$OutputFile = Join-Path -Path (Split-Path $TmdlPath -Parent) -ChildPath "TMDL-Feldliste.json"
$JsonOutput | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host ""
Write-Host "✅ Field extraction complete!" -ForegroundColor Green
Write-Host "📋 Output: $OutputFile" -ForegroundColor Cyan
Write-Host ""

# Display summary
Write-Host "SUMMARY:" -ForegroundColor Yellow
$AllFields.GetEnumerator() | foreach {
    $TotalFields = $_.Value.columns.Count + $_.Value.measures.Count
    Write-Host "  $($_.Key): $($_.Value.columns.Count) columns + $($_.Value.measures.Count) measures = $TotalFields total" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Total Entities: $($AllFields.Count)" -ForegroundColor Cyan
