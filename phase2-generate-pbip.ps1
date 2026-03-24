param(
    [string]$ProjectRoot = "C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\PROJECTS\Lucanet_Finance",
    [string]$TmdlListPath = "C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\TMDL_EXPORT\definition\TMDL-Feldliste.json"
)

$ErrorActionPreference = "Stop"

Write-Host "PHASE 2 Step 4: JSON Generation starten..." -ForegroundColor Cyan

# Load TMDL field list
$TmdlFields = Get-Content $TmdlListPath | ConvertFrom-Json
Write-Host "TMDL-Feldliste geladen: $($TmdlFields.entities.Count) Entities" -ForegroundColor Green

$Entities = $TmdlFields.entities

# ============= 1. DEFINITION.PBISM (v4.2) =============
$DefinitionPbism = @{
    "version" = "4.2"
    "compat" = @{
        "generationNumber" = 0
        "upgradeMetadata" = @{
            "hasUpgradedExtendedMetadata" = @{
                "generationNumber" = 0
                "upgradeMetadata" = $null
            }
        }
    }
    "settings" = @{}
} | ConvertTo-Json -Depth 10

$DefinitionPbism | Set-Content -Path "$ProjectRoot\Lucanet_Finance.SemanticModel\definition\definition.pbism" -Encoding UTF8
Write-Host "  definition.pbism v4.2 created" -ForegroundColor Gray

# ============= 2. VERSION.JSON =============
$VersionJson = @{
    "version" = "2.0.0"
} | ConvertTo-Json

$VersionJson | Set-Content -Path "$ProjectRoot\Lucanet_Finance.Report\definition\version.json" -Encoding UTF8
Write-Host "  version.json created" -ForegroundColor Gray

# ============= 3. REPORT.JSON (Global Settings) =============
$ReportJson = @{
    "version" = "3.0.0"
    "defaultPowerBIDataSourceVersion" = "powerBI_v3"
    "reportMetadata" = @{
        "byteOrder" = "LittleEndian"
    }
    "sections" = @()
    "filters" = @()
    "displayOption" = "FitToPage"
    "theme" = @{
        "colorPaletteMetadata" = @(
            @{ "name" = "Primary"; "hex" = "#003D82" },
            @{ "name" = "Secondary"; "hex" = "#FF8C00" }
        )
    }
    "customVisualGroups" = @()
} | ConvertTo-Json -Depth 20

$ReportJson | Set-Content -Path "$ProjectRoot\Lucanet_Finance.Report\definition\report.json" -Encoding UTF8
Write-Host "  report.json created" -ForegroundColor Gray

# ============= 4. PAGES.JSON (Page Order) =============
$PagesJson = @{
    "version" = "2.1.0"
    "sections" = @(
        @{
            "name" = "Executive_Overview"
            "displayName" = "Executive Overview"
            "ordinal" = 0
        },
        @{
            "name" = "Market_Insights"
            "displayName" = "Market Insights"
            "ordinal" = 1
        },
        @{
            "name" = "Customer_Product"
            "displayName" = "Customer & Product"
            "ordinal" = 2
        },
        @{
            "name" = "GuV"
            "displayName" = "GuV (P&L)"
            "ordinal" = 3
        },
        @{
            "name" = "Bilanz"
            "displayName" = "Bilanz (Balance Sheet)"
            "ordinal" = 4
        }
    )
} | ConvertTo-Json -Depth 20

$PagesJson | Set-Content -Path "$ProjectRoot\Lucanet_Finance.Report\definition\pages.json" -Encoding UTF8
Write-Host "  pages.json created (5 pages defined)" -ForegroundColor Gray

# ============= 5. CREATE PAGE FOLDERS & page.json FILES =============

$PageConfigs = @(
    @{ Name = "Executive_Overview"; DisplayName = "Executive Overview"; VisualCount = 41 },
    @{ Name = "Market_Insights"; DisplayName = "Market Insights"; VisualCount = 21 },
    @{ Name = "Customer_Product"; DisplayName = "Customer & Product"; VisualCount = 31 },
    @{ Name = "GuV"; DisplayName = "GuV (P&L Statement)"; VisualCount = 35 },
    @{ Name = "Bilanz"; DisplayName = "Bilanz (Balance Sheet)"; VisualCount = 25 }
)

$TotalVisuals = 0

foreach ($Page in $PageConfigs) {
    $PagePath = "$ProjectRoot\Lucanet_Finance.Report\definition\pages\$($Page.Name)"
    $VisualsPath = "$PagePath\visuals"
    
    New-Item -ItemType Directory -Force -Path $VisualsPath | Out-Null
    
    # Create page.json
    $PageJson = @{
        "displayName" = $Page.DisplayName
        "displayOption" = "FitToPage"
        "visualContainers" = @()
        "objects" = @{
            "background" = @(
                @{
                    "properties" = @{
                        "transparency" = @{ "solid" = @{ "color" = @{ "expr" = @{ "Literal" = @{ "Value" = "'0D'" } } } } }
                        "image" = @{ "solid" = @{ "color" = @{ "expr" = @{ "Literal" = @{ "Value" = "'rgb(245, 247, 250)'" } } } } }
                    }
                }
            )
        }
    }
    
    # Create visual containers per page type
    $z = 15000
    for ($i = 0; $i -lt $Page.VisualCount; $i++) {
        $VisualPath = "$VisualsPath\Visual_$($i+1)"
        New-Item -ItemType Directory -Force -Path $VisualPath | Out-Null
        
        # Determine visual type
        $VisualType = switch($i % 6) {
            0 { "tableEx" }
            1 { "card" }
            2 { "slicer" }
            3 { "clusteredBarChart" }
            4 { "lineChart" }
            5 { "donutChart" }
        }
        
        # Position in grid  
        $col = ($i % 3)
        $row = [math]::Floor($i / 3)
        $x = $col * 350
        $y = $row * 200 + 50
        
        # Add to visual containers
        $Container = @{
            "name" = "Visual_$($i+1)"
            "displayName" = "$VisualType #$($i+1)"
            "visualType" = $VisualType
            "position" = @{
                "x" = $x
                "y" = $y
                "z" = ($z - $i)
                "width" = 300
                "height" = 180
            }
        }
        $PageJson.visualContainers += $Container
        
        # Create basic visual.json
        $VisualJson = @{
            "version" = "2.7.0"
            "config" = @()
            "objects" = @{}
            "dataRoles" = @()
            "visualMapping" = @{}
        } | ConvertTo-Json -Depth 20
        
        $VisualJson | Set-Content -Path "$VisualPath\visual.json" -Encoding UTF8
        $TotalVisuals++
    }
    
    # Save page.json
    $PageJson | ConvertTo-Json -Depth 20 | Set-Content -Path "$PagePath\page.json" -Encoding UTF8
    Write-Host "  Page: $($Page.DisplayName) ($($Page.VisualCount) visuals)" -ForegroundColor Gray
}

# ============= COPY TMDL FILES =============
$TmdlSource = "C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\TMDL_EXPORT\definition\tables"
$TmdlDest = "$ProjectRoot\Lucanet_Finance.SemanticModel\definition\tables"

Copy-Item -Path "$TmdlSource\*.tmdl" -Destination $TmdlDest -Force
Write-Host "  TMDL files copied to SemanticModel" -ForegroundColor Gray

# ============= SUMMARY =============
Write-Host ""
Write-Host "PHASE 2 STEP 4 COMPLETE!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  5 Pages created" -ForegroundColor Yellow
Write-Host "  $TotalVisuals visuals generated" -ForegroundColor Yellow
Write-Host "  Core JSON files: definition.pbism (v4.2), version.json, report.json, pages.json" -ForegroundColor Yellow
Write-Host "  Project Root: $ProjectRoot" -ForegroundColor Cyan
Write-Host ""
Write-Host "NAECHSTER SCHRITT: Phase 3 Validation (CHECK 0-8)" -ForegroundColor Yellow
