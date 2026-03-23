# PHASE 3: CHECK 4 – Schema-Versionen

## Zu prüfende Versionen

### definition.pbism

```powershell
$file = Get-Content "...\definition.pbism" -Raw | ConvertFrom-Json
$file.version -eq "4.2"    # ✅ MUST be 4.2
$file.'$schema'.Contains('definitionProperties/1.0.0')  # ✅
```

- [ ] `version: "4.2"` ✅
- [ ] Schema: `definitionProperties/1.0.0` ✅

### version.json

```powershell
$file = Get-Content "...\version.json" -Raw | ConvertFrom-Json
$file.version -eq "2.0.0"    # ✅ MUST be 2.0.0
```

- [ ] `version: "2.0.0"` ✅

### report.json

```powershell
$file = Get-Content "...\report.json" -Raw | ConvertFrom-Json
$file.'$schema'.Contains('report/3.0.0')  # ✅
```

- [ ] Schema: `report/3.0.0` ✅

### page.json

```powershell
Get-ChildItem "...\pages\*\page.json" -Recurse | ForEach-Object {
    $file = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if (-not $file.'$schema'.Contains('page/2.1.0')) {
        Write-Error "❌ $($_.FullName) wrong schema"
    }
}
```

- [ ] Schema: `page/2.1.0` ✅

### visual.json

```powershell
Get-ChildItem "...\visuals\*\visual.json" -Recurse | ForEach-Object {
    $file = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if (-not $file.'$schema'.Contains('visualContainer/2.7.0')) {
        Write-Error "❌ $($_.FullName) wrong schema"
    }
}
```

- [ ] Schema: `visualContainer/2.7.0` ✅

### pages.json

```powershell
$file = Get-Content "...\pages.json" -Raw | ConvertFrom-Json
$file.'$schema'.Contains('pagesMetadata/1.0.0')  # ✅
```

- [ ] Schema: `pagesMetadata/1.0.0` ✅

---

## Checkliste

| Datei | Schema | Version | ✅ | ❌ |
|-------|--------|---------|----|----|
| definition.pbism | definitionProperties/1.0.0 | 4.2 | | |
| version.json | versionMetadata/1.0.0 | 2.0.0 | | |
| report.json | report/3.0.0 | - | | |
| page.json | page/2.1.0 | - | | |
| visual.json | visualContainer/2.7.0 | - | | |
| pages.json | pagesMetadata/1.0.0 | - | | |

**→ Alle ✅?**
- **JA** → CHECK 5
- **NEIN** → Versionen korrigieren, CHECK 4 wiederholen
