# Schema-Versionen & Platform-Standards (FEST – NIEMALS ÄNDERN)

## PBI Desktop Versionen

```
AKTUELL:  PBI Desktop March 2026 (v2.152.882.0)
FORMAT:   PBIR Enhanced Format
```

> **WICHTIG:** Alle Schema-URLs unten stammen direkt aus dem funktionierenden Template in `06_TEMPLATES/`.
> Bei Abweichungen gilt IMMER das Template als Referenz!

---

## SEMANTIC MODEL – Schema Versionen

### definition.pbism

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/semanticModel/definitionProperties/1.0.0/schema.json",
  "version": "4.2",
  "settings": {}
}
```

| Feld | Wert | Beschreibung |
|------|------|-------------|
| `$schema` | `fabric/item/semanticModel/definitionProperties/1.0.0` | Konstant |
| `version` | `"4.2"` | **CRITICAL**: nicht `"1.0.0"`! |
| `settings` | `{}` | Leer erlaubt, aber MUSS da sein |

### .platform (SemanticModel + Report)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/gitIntegration/platformProperties/2.0.0/schema.json",
  "metadata": {
    "type": "SemanticModel",
    "displayName": "{PROJEKTNAME}"
  },
  "config": {
    "version": "2.0",
    "logicalId": "{UUID}"
  }
}
```

> `.platform` nutzt `fabric/gitIntegration/platformProperties/2.0.0` — NICHT `fabric/pbip/...`!

---

## REPORT – Schema Versionen

### definition.pbir

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definitionProperties/2.0.0/schema.json",
  "version": "4.0",
  "datasetReference": {
    "byPath": {
      "path": "../{PROJEKTNAME}.SemanticModel"
    }
  }
}
```

### version.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/versionMetadata/1.0.0/schema.json",
  "version": "2.0.0"
}
```

### report.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/report/3.2.0/schema.json",
  "themeCollection": {
    "baseTheme": {
      "name": "CY26SU02",
      "reportVersionAtImport": {
        "visual": "2.6.0",
        "report": "3.1.0",
        "page": "2.3.0"
      },
      "type": "SharedResources"
    }
  }
}
```

> `report.json` MUSS `themeCollection` enthalten. `layoutOptimization` ist OPTIONAL.
> Schema-Version ist `report/3.2.0` (nicht `3.0.0`!).

### pages.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/pagesMetadata/1.0.0/schema.json",
  "pageOrder": ["{pageId1}", "{pageId2}"],
  "activePageName": "{pageId}"
}
```

### page.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/page/2.1.0/schema.json",
  "name": "{pageId}",
  "displayName": "Seitenname",
  "displayOption": "FitToPage",
  "height": 1080,
  "width": 1920
}
```

### visual.json

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "{visualId}",
  "position": { "x": 0, "y": 0, "z": 1000, "height": 180, "width": 320 },
  "visual": {
    "visualType": "slicer",
    "objects": {}
  }
}
```

---

## PBIP ROOT – {PROJEKTNAME}.pbip

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/pbipProperties/1.0.0/schema.json",
  "version": "1.0",
  "artifacts": [
    {
      "report": {
        "path": "{PROJEKTNAME}.Report"
      }
    }
  ],
  "settings": {
    "enableAutoRecovery": true
  }
}
```

> `.pbip` nutzt `fabric/pbip/pbipProperties/1.0.0` — NICHT `fabric/pbip/pbip/1.0.0`!
> `"version": "1.0"` (nicht `"3.0"`!)

**VERBOTEN:**
```json
"semanticModel": {...}    ← NIEMALS in artifacts!
```

---

## Schema-URL Übersicht (Quick Reference)

| Datei | Schema-URL-Pfad | Version |
|-------|----------------|---------|
| `.pbip` | `fabric/pbip/pbipProperties/1.0.0` | `"1.0"` |
| `.platform` | `fabric/gitIntegration/platformProperties/2.0.0` | `"2.0"` |
| `definition.pbism` | `fabric/item/semanticModel/definitionProperties/1.0.0` | `"4.2"` |
| `definition.pbir` | `fabric/item/report/definitionProperties/2.0.0` | `"4.0"` |
| `version.json` | `fabric/item/report/definition/versionMetadata/1.0.0` | `"2.0.0"` |
| `report.json` | `fabric/item/report/definition/report/3.2.0` | - |
| `pages.json` | `fabric/item/report/definition/pagesMetadata/1.0.0` | - |
| `page.json` | `fabric/item/report/definition/page/2.1.0` | - |
| `visual.json` | `fabric/item/report/definition/visualContainer/2.7.0` | - |

> **Alle Versionen vor PBI Desktop öffnen via CHECK 4 validieren!**
