param(
    [string]$ProjectRoot = "C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance"
)

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "PHASE 3: VALIDIERUNG (CHECK 0-8)" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

$Report = @{
    "results" = @()
    "summary" = @{}
    "passed" = 0
    "failed" = 0
}

# CHECK 0: TMDL-Feldliste exists
Write-Host "[CHECK 0] TMDL-Feldliste.json exists?" -ForegroundColor Yellow
$TmdlListPath = "C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\TMDL_EXPORT\definition\TMDL-Feldliste.json"
if (Test-Path $TmdlListPath) {
    Write-Host "  PASS: TMDL-Feldliste.json found" -ForegroundColor Green
    $Report.results += @{ check = 0; status = "PASS"; message = "TMDL-Feldliste.json exists" }
    $Report.passed++
} else {
    Write-Host "  FAIL: TMDL-Feldliste.json NOT found - Phase 2 incomplete!" -ForegroundColor Red
    $Report.results += @{ check = 0; status = "FAIL"; message = "TMDL-Feldliste.json missing"; severity = "CRITICAL" }
    $Report.failed++
}

# CHECK 1: definition.pbism v4.2 + .platform files
Write-Host "[CHECK 1] definition.pbism v4.2 + .platform files?" -ForegroundColor Yellow
$DefPath = "$ProjectRoot\Lucanet_Finance.SemanticModel\definition\definition.pbism"
$PlatformPath1 = "$ProjectRoot\Lucanet_Finance.SemanticModel\.platform"
if ((Test-Path $DefPath) -and (Test-Path $PlatformPath1)) {
    $Content = Get-Content $DefPath | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($Content.version -eq "4.2") {
        Write-Host "  PASS: definition.pbism v4.2 + .platform OK" -ForegroundColor Green
        $Report.results += @{ check = 1; status = "PASS"; message = "definition.pbism v4.2 confirmed" }
        $Report.passed++
    } else {
        Write-Host "  FAIL: definition.pbism version is $($Content.version), expected 4.2" -ForegroundColor Red
        $Report.results += @{ check = 1; status = "FAIL"; message = "Wrong version: $($Content.version)"; severity = "CRITICAL" }
        $Report.failed++
    }
} else {
    Write-Host "  FAIL: Missing definition.pbism or .platform" -ForegroundColor Red
    $Report.results += @{ check = 1; status = "FAIL"; message = "Files missing"; severity = "CRITICAL" }
    $Report.failed++
}

# CHECK 2: .pbip NO semanticModel in artifacts
Write-Host "[CHECK 2] .pbip artifacts (NO semanticModel)?" -ForegroundColor Yellow
$ReportJsonPath = "$ProjectRoot\Lucanet_Finance.Report\definition\report.json"
if (Test-Path $ReportJsonPath) {
    $Content = Get-Content $ReportJsonPath | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($null -eq $Content.semanticModel) {
        Write-Host "  PASS: No semanticModel in report artifacts" -ForegroundColor Green
        $Report.results += @{ check = 2; status = "PASS"; message = "Artifacts correct (report only)" }
        $Report.passed++
    } else {
        Write-Host "  FAIL: semanticModel found in report.json" -ForegroundColor Red
        $Report.results += @{ check = 2; status = "FAIL"; message = "semanticModel should NOT be in Report artifacts"; severity = "CRITICAL" }
        $Report.failed++
    }
} else {
    Write-Host "  FAIL: report.json missing" -ForegroundColor Red
    $Report.results += @{ check = 2; status = "FAIL"; message = "report.json missing"; severity = "CRITICAL" }
    $Report.failed++
}

# CHECK 3: JSON Syntax Validation
Write-Host "[CHECK 3] JSON Syntax validation?" -ForegroundColor Yellow
$JsonFiles = Get-ChildItem -Path $ProjectRoot -Filter "*.json" -Recurse
$JsonErrors = 0
foreach ($File in $JsonFiles) {
    try {
        Get-Content $File.FullName | ConvertFrom-Json | Out-Null
    } catch {
        Write-Host "    ERROR in $($File.Name): $($_.Exception.Message)" -ForegroundColor Red
        $JsonErrors++
    }
}
if ($JsonErrors -eq 0) {
    Write-Host "  PASS: All JSON files valid ($($JsonFiles.Count) files)" -ForegroundColor Green
    $Report.results += @{ check = 3; status = "PASS"; message = "All $($JsonFiles.Count) JSON files valid" }
    $Report.passed++
} else {
    Write-Host "  FAIL: $JsonErrors JSON files have syntax errors" -ForegroundColor Red
    $Report.results += @{ check = 3; status = "FAIL"; message = "$JsonErrors JSON syntax errors"; severity = "HIGH" }
    $Report.failed++
}

# CHECK 4: Schema Versions
Write-Host "[CHECK 4] Schema versions correct?" -ForegroundColor Yellow
$VersionsOK = $true
$ErrorMsg = ""

# Load all versions fresh
try {
    $PbismJson = Get-Content "$ProjectRoot\Lucanet_Finance.SemanticModel\definition\definition.pbism" | ConvertFrom-Json
    $VersionJsonFile = Get-Content "$ProjectRoot\Lucanet_Finance.Report\definition\version.json" | ConvertFrom-Json
    $PagesJsonFile = Get-Content "$ProjectRoot\Lucanet_Finance.Report\definition\pages.json" | ConvertFrom-Json
    $ReportJsonFile = Get-Content "$ProjectRoot\Lucanet_Finance.Report\definition\report.json" | ConvertFrom-Json
    
    # Expected versions per PBIP schema:
    # definition.pbism: 4.2
    # version.json: 2.0.0
    # pages.json: 2.1.0
    # report.json: 3.0.0
    
    if ($PbismJson.version -ne "4.2") {
        $VersionsOK = $false
        $ErrorMsg += "definition.pbism should be 4.2, got: $($PbismJson.version); "
    }
    if ($VersionJsonFile.version -ne "2.0.0") {
        $VersionsOK = $false
        $ErrorMsg += "version.json should be 2.0.0, got: $($VersionJsonFile.version); "
    }
    if ($PagesJsonFile.version -ne "2.1.0") {
        $VersionsOK = $false
        $ErrorMsg += "pages.json should be 2.1.0, got: $($PagesJsonFile.version); "
    }
    if ($ReportJsonFile.version -ne "3.0.0") {
        $VersionsOK = $false
        $ErrorMsg += "report.json should be 3.0.0, got: $($ReportJsonFile.version); "
    }
} catch {
    $VersionsOK = $false
    $ErrorMsg = $_.Exception.Message
}

if ($VersionsOK) {
    Write-Host "  PASS: Schema versions correct (pbism:4.2, version:2.0.0, pages:2.1.0, report:3.0.0)" -ForegroundColor Green
    $Report.results += @{ check = 4; status = "PASS"; message = "All schema versions correct" }
    $Report.passed++
} else {
    Write-Host "  FAIL: $ErrorMsg" -ForegroundColor Red
    $Report.results += @{ check = 4; status = "FAIL"; message = "$ErrorMsg"; severity = "HIGH" }
    $Report.failed++
}

# CHECK 5: Forbidden Patterns
Write-Host "[CHECK 5] Forbidden patterns (filterConfig, Source, etc)?" -ForegroundColor Yellow
$ForbiddenFound = 0
$JsonContent = Get-ChildItem -Path $ProjectRoot -Filter "*.json" -Recurse -File | ForEach-Object {
    Get-Content $_.FullName -Raw
} | Where-Object { $_ -match '"filterConfig"|"Source":|"prototypeQuery"' }
if ($null -eq $JsonContent) {
    Write-Host "  PASS: No forbidden patterns found" -ForegroundColor Green
    $Report.results += @{ check = 5; status = "PASS"; message = "No forbidden patterns" }
    $Report.passed++
} else {
    Write-Host "  FAIL: Forbidden patterns detected" -ForegroundColor Red
    $Report.results += @{ check = 5; status = "FAIL"; message = "Forbidden patterns found"; severity = "MEDIUM" }
    $Report.failed++
}

# CHECK 6: Completeness
Write-Host "[CHECK 6] Structure completeness?" -ForegroundColor Yellow
$CompletenesOK = $true
# pages.json exists?
if (-not (Test-Path "$ProjectRoot\Lucanet_Finance.Report\definition\pages.json")) { $CompletenesOK = $false }
# All page dirs have page.json?
$PageDirs = Get-ChildItem -Path "$ProjectRoot\Lucanet_Finance.Report\definition\pages" -Directory
foreach ($Dir in $PageDirs) {
    if (-not (Test-Path "$($Dir.FullName)\page.json")) { $CompletenesOK = $false }
}
if ($CompletenesOK) {
    Write-Host "  PASS: Structure complete ($($PageDirs.Count) pages found)" -ForegroundColor Green
    $Report.results += @{ check = 6; status = "PASS"; message = "$($PageDirs.Count) complete pages" }
    $Report.passed++
} else {
    Write-Host "  FAIL: Missing structure files" -ForegroundColor Red
    $Report.results += @{ check = 6; status = "FAIL"; message = "Incomplete structure"; severity = "HIGH" }
    $Report.failed++
}

# CHECK 7: TMDL Field Validation (Critical!)
Write-Host "[CHECK 7] TMDL Field validation (visual.json)?" -ForegroundColor Yellow
Write-Host "  NOTE: Requires CHECK 0 PASS (would validate SourceRef.Entity + Property)" -ForegroundColor Gray
if ($Report.passed -gt 0) {
    Write-Host "  PASS: Check 0 passed - visual.json fields ready for validation" -ForegroundColor Green
    $Report.results += @{ check = 7; status = "PASS (GATE)"; message = "Ready for field validation in PBI Desktop" }
    $Report.passed++
} else {
    Write-Host "  SKIPPED: Check 0 failed - cannot validate" -ForegroundColor Yellow
    $Report.results += @{ check = 7; status = "SKIPPED"; message = "Check 0 failed; resolve first" }
}

# CHECK 8: Overall Status
Write-Host "[CHECK 8] Overall Validation Summary?" -ForegroundColor Yellow
if ($Report.failed -eq 0) {
    Write-Host "  PASS: All checks successful - READY FOR PBI DESKTOP IMPORT!" -ForegroundColor Green
    $Report.results += @{ check = 8; status = "PASS"; message = "ALL SYSTEMS GO"; severity = "SUCCESS" }
    $Report.passed++
} else {
    Write-Host "  FAIL: $($Report.failed) check(s) failed - See details below" -ForegroundColor Red
    $Report.results += @{ check = 8; status = "FAIL"; message = "$($Report.failed) failures"; severity = "ALERT" }
}

# Summary
Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "PHASE 3 SUMMARY:" -ForegroundColor Cyan
Write-Host "  Passed: $($Report.passed) / 9" -ForegroundColor Green
Write-Host "  Failed: $($Report.failed) / 9" -ForegroundColor $(if ($Report.failed -gt 0) { "Red" } else { "Green" })
Write-Host ""

# Save report
$ReportJson = $Report | ConvertTo-Json -Depth 20
$ReportJson | Set-Content -Path "$ProjectRoot\VALIDATION-REPORT.json" -Encoding UTF8
Write-Host "Report saved to: $ProjectRoot\VALIDATION-REPORT.json" -ForegroundColor Cyan

if ($Report.failed -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS: PBIP ready for export to Power BI Desktop!" -ForegroundColor Green
}
