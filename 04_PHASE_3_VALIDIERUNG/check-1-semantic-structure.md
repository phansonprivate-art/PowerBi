# PHASE 3: CHECK 1 – Semantic Model Struktur

## Prüfpunkte

### ✅ CHECK 1.1: definition.pbism existiert?

```powershell
Test-Path "C:\Users\sphan\...\Sons_Final_Result\Sons_Final_Result.SemanticModel\definition.pbism"
```

- [ ] Datei vorhanden?

---

### ✅ CHECK 1.2: version = "4.2" (nicht "1.0.0"!)

```powershell
$content = Get-Content -Path "...\definition.pbism" -Raw | ConvertFrom-Json
$content.version -eq "4.2"    # Must be true!
```

- [ ] `version: "4.2"` ✅
- [ ] NICHT `"1.0.0"` ❌

---

### ✅ CHECK 1.3: settings vorhanden

```powershell
$content = Get-Content -Path "...\definition.pbism" -Raw | ConvertFrom-Json
$content.settings -ne $null   # Must exist!
```

- [ ] `"settings": {}` vorhanden?

---

### ✅ CHECK 1.4: .platform existiert

```powershell
Test-Path "C:\Users\sphan\...\Sons_Final_Result\Sons_Final_Result.SemanticModel\.platform"
```

- [ ] `.platform` (SemanticModel) vorhanden?

---

### ✅ CHECK 1.5: TMDL Ordner vollständig

```powershell
$tmdl_path = "...\Sons_Final_Result.SemanticModel\definition"
Test-Path "$tmdl_path\model.tmdl"             # ✅
Test-Path "$tmdl_path\database.tmdl"         # ✅
Test-Path "$tmdl_path\tables"                # ✅
(Get-ChildItem "$tmdl_path\tables\*.tmdl").Count -gt 0  # ✅
```

- [ ] model.tmdl vorhanden?
- [ ] database.tmdl vorhanden?
- [ ] tables/ Ordner vorhanden?
- [ ] Mindestens eine .tmdl in tables/?

---

## Status

| Punkt | ✅ | ❌ |
|-------|----|----|
| definition.pbism existiert | | |
| version = "4.2" | | |
| settings = {} | | |
| .platform existiert | | |
| model.tmdl + database.tmdl | | |
| tables/*.tmdl Dateien | | |

**→ Alle ✅?**
- **JA** → CHECK 2
- **NEIN** → Fehler beheben, CHECK 1 wiederholen
