# Phase 2 – queryState Bindings für alle 3 Seiten
param()
$ErrorActionPreference = "Stop"

$BASE = "C:\Users\phant\OneDrive\Desktop\Power BI\Lucanet_Finance\Lucanet_Finance.Report\definition\pages"

function vpath($page, $vid) {
    [IO.Path]::Combine($BASE, $page, "visuals", $vid, "visual.json")
}
function proj($e,$p) { @{Expression=@{SourceRef=@{Entity=$e};Property=$p}} }
function meas($n)    { proj "Measure" $n }
function sg($x)      { @{Projections=@($x)} }
function mg($xs)     { @{Projections=$xs} }
function qs($groups) {
    @{ query = @{ queryState = @( @{
        Command = "SetBindingRef"
        Binding = @{ Primary = @{ Groupings = $groups } }
    })}}
}

$PAGES = @{

# ─── Bilanz ───────────────────────────────────────────────────────────────────
"229ddded65ba36c359e6" = @{
    "e08628bf944cfaa394aa" = qs @(sg(meas "Bilanz Ist"))
    "d93a0fe333574e926bf1" = qs @(sg(meas "Bilanz Plan"))
    "2ca0b3beb589aaa2b08f" = qs @(sg(meas "GuV Ist Operatives Ergebnis"))
    "2944e88e9e19749cc43c" = qs @(sg(meas "GuV Ist Umsatzerloese"))   # Platzhalter – Umlaut-safe
    "1bd6318a220328291dc7" = qs @(sg(meas "Bilanz Ist"); sg(meas "Bilanz Plan"))
    "eb41d0ead52d830e5a5c" = qs @(sg(proj "Datum" "Monatsname"); mg @(meas "Bilanz Ist",meas "Bilanz Plan"))
    "63d36d9765455fe7ad89" = qs @(sg(proj "AccountStructure" "AccountLevel2"); sg(meas "Bilanz Ist"))
    "c71eef900b3d4510139b" = qs @(sg(proj "AccountStructure" "AccountLevel3"); mg @(meas "Bilanz Ist",meas "Bilanz Plan"))
    "a82eb6d4e9afa712dc6a" = qs @(sg(proj "Datum" "Quartal"); mg @(meas "Bilanz Ist",meas "Bilanz Plan"))
    "931b4c92c97d6039e8cc" = qs @(sg(proj "Datum" "Jahr"))
    "8cc6e4db50533063f6fc" = qs @(sg(proj "DataLevel" "DataLevelName"))
    "518806cf32a0093060e1" = qs @(sg(proj "Datum" "Quartal"))
    "a0dd37d5b71d498ad32f" = qs @(sg(proj "PartnerStructure" "PartnerName"))
    "0622d919c6179c53593f" = qs @(sg(proj "AccountStructure" "AccountLevel2"))
    "c2f60dee8b9024afd427" = qs @(sg(proj "Datum" "Monatsname"))
    "aeafdbbfac1040fd94f3" = qs @(sg(proj "AccountStructure" "AccountLevel1"))
}

# ─── GuV ──────────────────────────────────────────────────────────────────────
"ca650288acf4f449ebac" = @{
    "f563e92dd75ffd96a26d" = qs @(sg(meas "GuV Ist YTD Total"))
    "059feeeae13dc8b22f56" = qs @(sg(meas "GuV Plan YTD Total"))
    "8027f3d8e4e5f01d538d" = qs @(sg(proj "AccountStructure" "AccountLevel2"); sg(meas "GuV Ist"))
    "b39b0c860e17e4ee094d" = qs @(sg(proj "AccountStructure" "AccountLevel3"); mg @(meas "GuV Ist",meas "GuV Plan"))
    "f98c0af677831b1d2c5e" = qs @(mg @(proj "AccountStructure" "AccountLevel3",meas "GuV Ist",meas "GuV Plan"))
    "91418a362eee14190eb7" = qs @(mg @(proj "AccountStructure" "AccountLevel2",meas "GuV Ist"); sg(proj "Datum" "Monatsname"))
    "7911a50b56d8bf47455d" = qs @(sg(proj "Datum" "Jahr"))
    "0464fdc862d0bcdf81ca" = qs @(sg(proj "DataLevel" "DataLevelName"))
    "fa7e47c601622e86f7ab" = qs @(sg(proj "Datum" "Quartal"))
    "255d73fc0186781ab6c5" = qs @(sg(proj "PartnerStructure" "PartnerName"))
    "82c9e6a7e9e0e7e70178" = qs @(sg(proj "AccountStructure" "AccountLevel2"))
    "37ce51d562eb71da26d7" = qs @(sg(proj "Datum" "Monatsname"))
    "241f2d5209bed09b2b77" = qs @(sg(proj "AccountStructure" "AccountLevel1"))
}

# ─── Cashflow ─────────────────────────────────────────────────────────────────
"a1b2c3d4e5f6789012ab" = @{
    "f563e92dd75ffd96a26d" = qs @(sg(meas "CF Ist"))
    "059feeeae13dc8b22f56" = qs @(sg(meas "CF Plan"))
    "8027f3d8e4e5f01d538d" = qs @(sg(proj "AccountStructure" "AccountLevel2"); sg(meas "CF Ist"))
    "b39b0c860e17e4ee094d" = qs @(sg(proj "AccountStructure" "AccountLevel3"); mg @(meas "CF Ist",meas "CF Plan"))
    "f98c0af677831b1d2c5e" = qs @(mg @(proj "AccountStructure" "AccountLevel3",meas "CF Ist",meas "CF Plan"))
    "91418a362eee14190eb7" = qs @(mg @(proj "AccountStructure" "AccountLevel2",meas "CF Ist"); sg(proj "Datum" "Monatsname"))
    "7911a50b56d8bf47455d" = qs @(sg(proj "Datum" "Jahr"))
    "0464fdc862d0bcdf81ca" = qs @(sg(proj "DataLevel" "DataLevelName"))
    "fa7e47c601622e86f7ab" = qs @(sg(proj "Datum" "Quartal"))
    "255d73fc0186781ab6c5" = qs @(sg(proj "PartnerStructure" "PartnerName"))
    "82c9e6a7e9e0e7e70178" = qs @(sg(proj "AccountStructure" "AccountLevel2"))
    "37ce51d562eb71da26d7" = qs @(sg(proj "Datum" "Monatsname"))
    "241f2d5209bed09b2b77" = qs @(sg(proj "AccountStructure" "AccountLevel1"))
}
}

$ok = 0; $skip = 0
foreach ($pageId in $PAGES.Keys) {
    foreach ($vid in $PAGES[$pageId].Keys) {
        $p = vpath $pageId $vid
        if (-not (Test-Path $p)) {
            Write-Host "  SKIP $vid" -ForegroundColor Yellow
            $skip++
            continue
        }
        $d = Get-Content $p -Raw -Encoding UTF8 | ConvertFrom-Json
        Add-Member -InputObject $d -MemberType NoteProperty -Name "query" -Value $PAGES[$pageId][$vid].query -Force
        $d | ConvertTo-Json -Depth 50 | Set-Content $p -Encoding UTF8 -NoNewline
        Write-Host "  OK $vid" -ForegroundColor Green
        $ok++
    }
}

# GuV Ist Umsatzerlöse – Measure-Name mit Umlaut korrekt setzen
$umsatz_ids = @("2944e88e9e19749cc43c")
foreach ($uid in $umsatz_ids) {
    $p = vpath "229ddded65ba36c359e6" $uid
    if (Test-Path $p) {
        $raw = Get-Content $p -Raw -Encoding UTF8
        $raw = $raw -replace '"GuV Ist Umsatzerloese"', '"GuV Ist Umsatzerlöse"'
        Set-Content $p -Value $raw -Encoding UTF8 -NoNewline
        Write-Host "  OK Umlaut-Fix $uid" -ForegroundColor Cyan
    }
}

# Cashflow Titel
$tp = vpath "a1b2c3d4e5f6789012ab" "9c5d1feb56e7e1d63d76"
if (Test-Path $tp) {
    $d = Get-Content $tp -Raw -Encoding UTF8 | ConvertFrom-Json
    $d.visual.objects.general[0].properties.paragraphs[0].textRuns[0].value = "Cashflow"
    $d | ConvertTo-Json -Depth 50 | Set-Content $tp -Encoding UTF8 -NoNewline
    Write-Host "  OK Cashflow-Titel" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Fertig: $ok OK, $skip Skipped" -ForegroundColor Cyan
