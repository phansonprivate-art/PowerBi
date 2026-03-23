# Schema-Versionen & Platform-Standards (FEST – NIEMALS ÄNDERN)

## PBI Desktop Versionen

```
✅ AKTUELL:  PBI Desktop March 2026 (v2.152.882.0)
✅ FORMAT:   PBIR Enhanced Format
```

---

## SEMANTIC MODEL – Schema Versionen

### definition.pbism

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/model/definitionProperties/1.0.0/schema.json",
  "version": "4.2",        ← MUSS 4.2 sein (nicht "1.0.0"!)
  "settings": {}           ← MUSS vorhanden sein (auch wenn leer)
}
```

| Feld | Wert | Beschreibung |
|------|------|-------------|
| `$schema` | `definitionProperties/1.0.0` | Konstant |
| `version` | `"4.2"` | **CRITICAL**: nicht `"1.0.0"`! |
| `settings` | `{}` | Leer erlaubt, aber MUSS da sein |

### .platform

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/semanticModel/platformProperties/2.0.0/schema.json"
}
```

---

## REPORT – Schema Versionen

### version.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/versionMetadata/1.0.0/schema.json",
  "version": "2.0.0"       ← (nicht "1.0.0"!)
}
```

### definition.pbir

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/definitionProperties/2.0.0/schema.json",
  "version": "4.0"
}
```

### report.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/report/3.0.0/schema.json"
}
```

### page.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/page/2.1.0/schema.json",
  "displayOption": "FitToPage"
}
```

### visual.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json"
}
```

### pages.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/pagesMetadata/1.0.0/schema.json"
}
```

---

## PBIP ROOT – {PROJEKTNAME}.pbip

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/pbip/1.0.0/schema.json",
  "version": "3.0",
  "artifacts": [
    {
      "report": {
        "path": "{PROJEKTNAME}.Report"
      }
    }
  ]
}
```

**⚠️ VERBOTEN:**
```json
"semanticModel": {...}    ← NIEMALS in artifacts!
```

---

## Checkliste: Versionsnummern

| Datei | Schema | Version | Status |
|-------|--------|---------|--------|
| definition.pbism | definitionProperties/1.0.0 | `4.2` | ✅ |
| .platform (SM) | platformProperties/2.0.0 | - | ✅ |
| version.json | versionMetadata/1.0.0 | `2.0.0` | ✅ |
| definition.pbir | definitionProperties/2.0.0 | `4.0` | ✅ |
| report.json | report/3.0.0 | - | ✅ |
| page.json | page/2.1.0 | - | ✅ |
| visual.json | visualContainer/2.7.0 | - | ✅ |
| pages.json | pagesMetadata/1.0.0 | - | ✅ |
| .platform (Report) | platformProperties/2.0.0 | - | ✅ |
| .pbip | pbip/1.0.0 | `3.0` | ✅ |

**→ Alle Versionen vor PBI Desktop öffnen via CHECK 4 validieren!**
