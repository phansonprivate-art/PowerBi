# PHASE 3: CHECK 2 – PBIP ROOT Struktur

## Prüfpunkte

### ✅ CHECK 2.1: {PROJEKTNAME}.pbip existiert

```powershell
Test-Path "C:\Users\sphan\...\Sons_Final_Result\Sons_Final_Result.pbip"
```

- [ ] `.pbip` Datei vorhanden?

---

### ✅ CHECK 2.2: Keine "semanticModel" in artifacts

```powershell
$pbip = Get-Content ".pbip" -Raw | ConvertFrom-Json
$pbip.artifacts | Where-Object { $_.semanticModel } | Measure-Object | Select-Object -ExpandProperty Count
# Result must be: 0
```

**❌ VERBOTEN:**
```json
"artifacts": [
  {
    "semanticModel": {...}    ← NIEMALS!
  }
]
```

- [ ] `"semanticModel"` ist NICHT in artifacts?

---

### ✅ CHECK 2.3: NUR "report" in artifacts

```powershell
$pbip = Get-Content ".pbip" -Raw | ConvertFrom-Json
$pbip.artifacts[0].report.path  # Must exist and contain "Report" path
```

**✅ RICHTIG:**
```json
"artifacts": [
  {
    "report": {
      "path": "Sons_Final_Result.Report"
    }
  }
]
```

- [ ] `"report"` mit korrektem Pfad vorhanden?

---

## Status

| Punkt | ✅ | ❌ |
|-------|----|----|
| .pbip existiert | | |
| Kein "semanticModel" in artifacts | | |
| NUR "report" in artifacts | | |
| Report Pfad korrekt | | |

**→ Alle ✅?**
- **JA** → CHECK 3
- **NEIN** → Fehler beheben, CHECK 2 wiederholen
