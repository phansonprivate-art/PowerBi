# PHASE 3: CHECK 6 – Datei-Vollständigkeit

## Zu prüfende Dateien

### ✅ CHECK 6.1: pages.json vorhanden?

```powershell
Test-Path "...\Report\definition\pages.json"
```

- [ ] `pages.json` vorhanden?

---

### ✅ CHECK 6.2: Für jedem pageOrder-Eintrag ein Ordner?

```powershell
$pages = Get-Content "...\pages.json" -Raw | ConvertFrom-Json
$pages_folder = Get-ChildItem "...\pages\" -Directory

$pages.pageOrder | ForEach-Object {
    $folder_exists = $pages_folder | Where-Object { $_.Name -eq $_ }
    if (-not $folder_exists) {
        Write-Error "❌ Ordner für Seite $_  fehlt"
    }
}
```

- [ ] Alle Seiten aus `pageOrder` haben Ordner?

---

### ✅ CHECK 6.3: Jede Seite hat page.json?

```powershell
Get-ChildItem "...\pages\*" -Directory | ForEach-Object {
    $page_json = Join-Path $_.FullName "page.json"
    if (-not (Test-Path $page_json)) {
        Write-Error "❌ page.json fehlt in $($_.Name)"
    }
}
```

- [ ] Jeder Seiten-Ordner hat `page.json`?

---

### ✅ CHECK 6.4: Jeder Visual hat visual.json?

```powershell
Get-ChildItem "...\visuals\*" -Directory -Recurse | ForEach-Object {
    $visual_json = Join-Path $_.FullName "visual.json"
    if (-not (Test-Path $visual_json)) {
        Write-Error "❌ visual.json fehlt in $($_.Name)"
    }
}
```

- [ ] Jeder Visual-Ordner hat `visual.json`?

---

### ✅ CHECK 6.5: .platform vorhanden (2x)?

```powershell
$sm_platform = Test-Path "...\SemanticModel\.platform"
$report_platform = Test-Path "...\Report\definition\.platform"

if (-not $sm_platform) { Write-Error "❌ .platform in SemanticModel fehlt" }
if (-not $report_platform) { Write-Error "❌ .platform in Report fehlt" }
```

- [ ] `.platform` in SemanticModel vorhanden?
- [ ] `.platform` in Report vorhanden?

---

### ✅ CHECK 6.6: definition.pbism + definition.pbir?

```powershell
$sm_def = Test-Path "...\SemanticModel\definition.pbism"
$report_def = Test-Path "...\Report\definition.pbir"

if (-not $sm_def) { Write-Error "❌ definition.pbism fehlt" }
if (-not $report_def) { Write-Error "❌ definition.pbir fehlt" }
```

- [ ] `definition.pbism` vorhanden?
- [ ] `definition.pbir` vorhanden?

---

## Statusbericht

- [ ] pages.json vorhanden?
- [ ] Alle pageOrder Ordner existieren?
- [ ] Alle Seiten haben page.json?
- [ ] Alle Visuals haben visual.json?
- [ ] 2x .platform vorhanden?
- [ ] definition.pbism + definition.pbir?

**→ Alle ✅?**
- **JA** → CHECK 7 (KRITISCH!)
- **NEIN** → Fehler beheben, CHECK 6 wiederholen
