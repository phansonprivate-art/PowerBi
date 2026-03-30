<#
.SYNOPSIS
    Erstellt ein neues PBIP-Projekt aus dem festen 09_TEMPLATE.

.DESCRIPTION
    - Kopiert 09_TEMPLATE nach ZIELORDNER\PROJEKTNAME
    - Benennt alle Template.*-Ordner/-Dateien auf PROJEKTNAME um
    - Ersetzt $ReportPage1, $ReportPage2, ... dynamisch mit echten Seitentiteln

.PARAMETER Projektname
    Name des neuen Projekts (z.B. "Lucanet_Finance")

.PARAMETER Zielordner
    Zielverzeichnis für das neue Projekt (z.B. "C:\Users\phant\OneDrive\Desktop\Power BI")

.PARAMETER Seiten
    Komma-getrennte Liste der Seitentitel (z.B. "Bilanz,GuV,Cashflow")

.EXAMPLE
    .\create-project.ps1 -Projektname "Lucanet_Finance" -Zielordner "C:\Users\phant\OneDrive\Desktop\Power BI" -Seiten "Bilanz,GuV,Cashflow"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Projektname,

    [Parameter(Mandatory = $true)]
    [string]$Zielordner,

    [Parameter(Mandatory = $true)]
    [string]$Seiten
)

$ErrorActionPreference = "Stop"

# ─── Konfiguration ───────────────────────────────────────────────────────────
$TemplatePfad  = Join-Path $PSScriptRoot "09_TEMPLATE"
$ProjektPfad   = Join-Path $Zielordner $Projektname
$SeitenListe   = $Seiten -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# ─── Vorab-Prüfungen ─────────────────────────────────────────────────────────
if (-not (Test-Path $TemplatePfad)) {
    Write-Error "09_TEMPLATE nicht gefunden: $TemplatePfad"
    exit 1
}

if (Test-Path $ProjektPfad) {
    Write-Error "Zielordner existiert bereits: $ProjektPfad"
    exit 1
}

if ($SeitenListe.Count -eq 0) {
    Write-Error "Mindestens eine Seite muss angegeben werden."
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  PBIP Projekt erstellen" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Projektname : $Projektname" -ForegroundColor Yellow
Write-Host "  Zielordner  : $Zielordner" -ForegroundColor Yellow
Write-Host "  Projektpfad : $ProjektPfad" -ForegroundColor Yellow
Write-Host "  Seiten      : $($SeitenListe -join ', ')" -ForegroundColor Yellow
Write-Host ""

# ─── Schritt 1: Template kopieren ────────────────────────────────────────────
Write-Host "1/4 09_TEMPLATE kopieren..." -ForegroundColor Cyan
Copy-Item -Path $TemplatePfad -Destination $ProjektPfad -Recurse -Force
Write-Host "    OK: $ProjektPfad" -ForegroundColor Green

# ─── Schritt 2: Ordner & Dateien von "Template" auf PROJEKTNAME umbenennen ───
Write-Host "2/4 Template → $Projektname umbenennen..." -ForegroundColor Cyan

Get-ChildItem -Path $ProjektPfad -Recurse -Depth 5 |
    Where-Object { $_.Name -like "*Template*" } |
    Sort-Object { $_.FullName.Length } -Descending |
    ForEach-Object {
        $ElternPfad = if ($_ -is [System.IO.DirectoryInfo]) { $_.Parent.FullName } else { $_.DirectoryName }
        $Neu = Join-Path $ElternPfad ($_.Name -replace "Template", $Projektname)
        Rename-Item -Path $_.FullName -NewName $Neu -Force
    }

Write-Host "    OK: Alle 'Template'-Namen ersetzt" -ForegroundColor Green

# ─── Schritt 3: Platzhalter in Dateiinhalten ersetzen ─────────────────────────
Write-Host "3/4 Platzhalter ersetzen..." -ForegroundColor Cyan

$ReportPfad  = Join-Path $ProjektPfad "$Projektname.Report"
$PagesPfad   = Join-Path $ReportPfad "definition\pages"

$DateiTypen  = @("*.json", "*.tmdl", "*.pbip", "*.pbir", "*.pbism", ".platform", ".relationships")
$AlleDateien = Get-ChildItem -Path $ProjektPfad -Recurse -File |
    Where-Object { $DateiTypen | ForEach-Object { $_.Name -like $_ } | Select-Object -First 1 }

foreach ($Datei in $AlleDateien) {
    $Inhalt = Get-Content -Path $Datei.FullName -Raw -Encoding UTF8
    if (-not $Inhalt) { continue }

    $Geaendert = $false

    # $ReportPageN → N-ter Seitentitel (1-basiert)
    for ($i = 1; $i -le $SeitenListe.Count; $i++) {
        $Platzhalter = "`$ReportPage$i"
        if ($Inhalt -match [regex]::Escape($Platzhalter)) {
            $Inhalt    = $Inhalt -replace [regex]::Escape($Platzhalter), $SeitenListe[$i - 1]
            $Geaendert = $true
            Write-Host "    Ersetzt: $Platzhalter → $($SeitenListe[$i-1])  in $($Datei.Name)" -ForegroundColor Gray
        }
    }

    # "Template" im Dateiinhalt → PROJEKTNAME (z.B. in .pbip artifacts path)
    if ($Inhalt -match "Template") {
        $Inhalt    = $Inhalt -replace "Template", $Projektname
        $Geaendert = $true
    }

    if ($Geaendert) {
        Set-Content -Path $Datei.FullName -Value $Inhalt -Encoding UTF8 -NoNewline
    }
}

Write-Host "    OK: Alle Platzhalter ersetzt" -ForegroundColor Green

# ─── Schritt 4: Konsistenz-Check ─────────────────────────────────────────────
Write-Host "4/4 Konsistenz-Check..." -ForegroundColor Cyan

$TemplateSeitenAnzahl = (Get-ChildItem -Path $PagesPfad -Directory).Count

if ($SeitenListe.Count -gt $TemplateSeitenAnzahl) {
    Write-Host ""
    Write-Host "  WARNUNG: Template hat $TemplateSeitenAnzahl Seiten-Ordner," -ForegroundColor Yellow
    Write-Host "  aber $($SeitenListe.Count) Seiten wurden angegeben." -ForegroundColor Yellow
    Write-Host "  Fehlende Seiten-Ordner müssen manuell ergänzt werden:" -ForegroundColor Yellow
    for ($i = $TemplateSeitenAnzahl + 1; $i -le $SeitenListe.Count; $i++) {
        Write-Host "    → Seite $i : '$($SeitenListe[$i-1])' fehlt noch" -ForegroundColor Yellow
    }
} elseif ($SeitenListe.Count -lt $TemplateSeitenAnzahl) {
    Write-Host "  HINWEIS: Template hat $TemplateSeitenAnzahl Seiten-Ordner," -ForegroundColor Yellow
    Write-Host "  aber nur $($SeitenListe.Count) Seiten angegeben." -ForegroundColor Yellow
    Write-Host "  Nicht benötigte Seiten-Ordner prüfen und ggf. löschen." -ForegroundColor Yellow
}

# ─── Fertig ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  PROJEKT ERSTELLT!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Pfad: $ProjektPfad" -ForegroundColor Green
Write-Host ""
Write-Host "Nächste Schritte:" -ForegroundColor Yellow
Write-Host "  1. TMDL exportieren  → Phase 2 Schritt 2 (tmdl-export.md)" -ForegroundColor White
Write-Host "  2. Measures via MCP  → Phase 2 Schritt 1 (measures-creation.md)" -ForegroundColor White
Write-Host "  3. visual.json       → Phase 2 Schritt 4 (report-files.md)" -ForegroundColor White
Write-Host "  4. Validierung       → Phase 3 CHECK 0-8" -ForegroundColor White
Write-Host ""
