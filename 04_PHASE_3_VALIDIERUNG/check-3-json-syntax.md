# PHASE 3: CHECK 3 – JSON Syntax Validierung

## Alle JSON Dateien auf Syntax prüfen

### PowerShell Script

```powershell
$base = "C:\Users\sphan\...\Sons_Final_Result"
$errors = @()

Get-ChildItem -Path $base -Filter "*.json" -Recurse | ForEach-Object {
    try {
        $content = Get-Content $_.FullName -Raw
        $parsed = $content | ConvertFrom-Json
        Write-Host "✅ $($_.FullName)"
    } catch {
        $errors += "$($_.FullName): $($_.Exception.Message)"
        Write-Host "❌ $($_.FullName)"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "`n❌ JSON SYNTAX ERRORS FOUND:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" }
    exit 1
} else {
    Write-Host "`n✅ ALL JSON VALID" -ForegroundColor Green
    exit 0
}
```

### Python Script (Alternative)

```python
import json
import glob
import os

base = r"C:\Users\sphan\...\Sons_Final_Result"
errors = []

for json_file in glob.glob(os.path.join(base, '**', '*.json'), recursive=True):
    try:
        with open(json_file, 'r', encoding='utf-8') as f:
            json.load(f)
        print(f"✅ {json_file}")
    except json.JSONDecodeError as e:
        errors.append(f"{json_file}: {e}")
        print(f"❌ {json_file}")

if errors:
    print(f"\n❌ JSON SYNTAX ERRORS FOUND:")
    for e in errors:
        print(f"  - {e}")
    exit(1)
else:
    print(f"\n✅ ALL JSON VALID")
    exit(0)
```

---

## Was wird geprüft?

- ✅ definition.pbism
- ✅ definition.pbir
- ✅ version.json
- ✅ report.json
- ✅ pages.json
- ✅ page.json (alle Seiten)
- ✅ visual.json (alle Visuals)
- ✅ .pbip

---

## Status

- [ ] Alle JSON Dateien syntaktisch valid?
- [ ] Keine Parser-Fehler?

**→ Alle ✅?**
- **JA** → CHECK 4
- **NEIN** → Fehler korrigieren, CHECK 3 wiederholen
