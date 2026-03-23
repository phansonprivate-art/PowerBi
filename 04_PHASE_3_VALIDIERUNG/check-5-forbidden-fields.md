# PHASE 3: CHECK 5 – Verbotene Felder

## Zu prüfende Muster

### ✅ CHECK 5.1: visual.json - Kein "filterConfig"

```powershell
Get-ChildItem "...\visual.json" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '"filterConfig"') {
        Write-Error "❌ filterConfig in $($_.FullName)"
    }
}
```

- [ ] Kein `"filterConfig"` Top-Level in visual.json?

### ✅ CHECK 5.2: visual.json - Kein "prototypeQuery"

```powershell
Get-ChildItem "...\visual.json" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '"prototypeQuery"') {
        Write-Error "❌ prototypeQuery in $($_.FullName)"
    }
}
```

- [ ] Kein `"prototypeQuery"` in visual.json Top-Level?

### ✅ CHECK 5.3: visual.json - Kein Top-Level "filters"

```powershell
Get-ChildItem "...\visual.json" -Recurse | ForEach-Object {
    $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if ($json.filters) {
        Write-Error "❌ Top-Level filters in $($_.FullName)"
    }
}
```

- [ ] Kein Top-Level `"filters"` in visual.json?

### ✅ CHECK 5.4: visual.json - SourceRef nutzt "Entity"

```powershell
Get-ChildItem "...\visual.json" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '"Source"\s*:') {
        Write-Error "❌ Source (statt Entity) in $($_.FullName)"
    }
}
```

- [ ] Kein `"Source"` (nur `"Entity"`) in SourceRef?

### ✅ CHECK 5.5: page.json - Kein "ordinal" Top-Level

```powershell
Get-ChildItem "...\page.json" -Recurse | ForEach-Object {
    $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if ($json.ordinal) {
        Write-Error "❌ ordinal in $($_.FullName)"
    }
}
```

- [ ] Kein `"ordinal"` Top-Level in page.json?

### ✅ CHECK 5.6: page.json - Kein Top-Level "filters"

```powershell
Get-ChildItem "...\page.json" -Recurse | ForEach-Object {
    $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if ($json.filters) {
        Write-Error "❌ filters in $($_.FullName)"
    }
}
```

- [ ] Kein Top-Level `"filters"` in page.json?

### ✅ CHECK 5.7: definition.pbism - Kein "version": "1.0.0"

```powershell
$json = Get-Content "...\definition.pbism" -Raw | ConvertFrom-Json
if ($json.version -eq "1.0.0") {
    Write-Error "❌ version 1.0.0 in definition.pbism (must be 4.2)"
}
```

- [ ] Kein `"version": "1.0.0"` in definition.pbism?

### ✅ CHECK 5.8: .pbip - Kein "semanticModel"

```powershell
$json = Get-Content "...\{PROJEKTNAME}.pbip" -Raw | ConvertFrom-Json
$has_semantic = $json.artifacts | Where-Object { $_.semanticModel }
if ($has_semantic) {
    Write-Error "❌ semanticModel in .pbip artifacts"
}
```

- [ ] Kein `"semanticModel"` in `.pbip` artifacts?

---

## Statusbericht

- [ ] Kein "filterConfig" in visual.json?
- [ ] Kein "prototypeQuery"?
- [ ] Kein Top-Level "filters" in visual.json?
- [ ] SourceRef = "Entity" (nicht "Source")?
- [ ] Kein "ordinal" in page.json?
- [ ] Kein "filters" in page.json Top-Level?
- [ ] Kein version "1.0.0" in definition.pbism?
- [ ] Kein "semanticModel" in .pbip?

**→ Alle ✅?**
- **JA** → CHECK 6
- **NEIN** → Fehler beheben, CHECK 5 wiederholen
