# PHASE 2: SCHRITT 6 – page.json & visual.json generieren

## page.json (Pro Seite)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\{PageID}\page.json`

### Template:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/page/2.1.0/schema.json",
  "name": "{PageID}",
  "displayName": "Übersicht",
  "displayOption": "FitToPage",
  "height": 1080,
  "width": 1920,
  "objects": {
    "background": [
      {
        "properties": {
          "image": {
            "image": {
              "name": { "expr": { "Literal": { "Value": "''" } } },
              "url": { "expr": { "Literal": { "Value": "''" } } }
            }
          },
          "transparency": { "expr": { "Literal": { "Value": "0D" } } }
        }
      }
    ]
  }
}
```

### Wichtig:
- `name` = Ordnername (PFLICHT!)
- `displayOption`: "FitToPage"
- `height` + `width`: PFLICHT wenn displayOption != "Dynamic"
- `objects`: Aus Template übernehmen
- KEIN `visualContainers` (VERBOTEN in PBIR Enhanced!)
- KEIN `version` Top-Level
- KEIN `ordinal` Top-Level
- KEIN `filters` Top-Level
- KEIN `config` Top-Level

---

## visual.json (Pro Visual)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\{PageID}\visuals\{VisualID}\visual.json`

### PBIR Enhanced Format Struktur:

In PBIR Enhanced Format hat `visual.json` eine strikte Struktur:
- **Root-Ebene**: `$schema`, `name`, `position`, `visual`
- **`visual` Sub-Objekt**: `visualType`, `objects`, `drillFilterOtherVisuals`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "{VisualID}",
  "position": {
    "x": 0,
    "y": 0,
    "z": 1000,
    "height": 180,
    "width": 320,
    "tabOrder": 0
  },
  "visual": {
    "visualType": "slicer",
    "objects": {},
    "drillFilterOtherVisuals": true
  }
}
```

### Beispiel: Slicer (Dropdown)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "abc123def456",
  "position": {
    "x": 24.8,
    "y": 551.5,
    "z": 17000,
    "height": 75.9,
    "width": 208.6,
    "tabOrder": 13000
  },
  "visual": {
    "visualType": "slicer",
    "objects": {
      "data": [
        {
          "properties": {
            "mode": {
              "expr": {
                "Literal": {
                  "Value": "'Dropdown'"
                }
              }
            }
          }
        }
      ]
    },
    "drillFilterOtherVisuals": true
  }
}
```

### Beispiel: Card Visual (Measure)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "card_umsatz_01",
  "position": {
    "x": 0,
    "y": 0,
    "z": 1000,
    "height": 180,
    "width": 320
  },
  "visual": {
    "visualType": "card",
    "objects": {
      "calloutValue": [
        {
          "properties": {
            "textSize": {
              "expr": {
                "Literal": {
                  "Value": "28D"
                }
              }
            }
          }
        }
      ]
    }
  }
}
```

---

### KRITISCHE REGELN FÜR visual.json (PBIR Enhanced)

| Regel | Richtig | Falsch |
|-------|---------|--------|
| **Schema** | `item/report/definition/visualContainer/2.7.0` | `pbip/report/visualContainer/...` |
| **Root-Ebene** | Nur `$schema`, `name`, `position`, `visual` | `displayName`, `config`, `dataRoles`, `query` |
| **`visual` Sub-Objekt** | `visualType`, `objects`, `drillFilterOtherVisuals` | `displayName`, `config`, `visualMapping` |
| **`name`** | = Ordnername (PFLICHT) | Fehlend |
| **`position`** | Root-Ebene mit x,y,z,height,width | In `visual` Sub-Objekt |
| **Entity** | `"Entity": "DIM_Kalender"` | `"Source": "..."` |
| **Property** | Aus TMDL-Feldliste | Von MCP erfunden |

> **PBIR Enhanced Format**: Visuals haben KEINE `query`, `dataRoles`, `visualMapping` oder `config` Properties!
> Data Binding wird über die PBI Desktop UI konfiguriert, nicht über visual.json.
> `visual.json` definiert nur: Position, Typ, Formatierung (objects).

---

## Checkliste page.json & visual.json

- [ ] page.json Schema = `item/report/definition/page/2.1.0`?
- [ ] page.json hat `name` = Ordnername?
- [ ] page.json hat `width` + `height`?
- [ ] page.json hat KEIN `visualContainers`?
- [ ] visual.json Schema = `item/report/definition/visualContainer/2.7.0`?
- [ ] visual.json hat `name` = Ordnername?
- [ ] visual.json hat `position` auf Root-Ebene?
- [ ] visual.json hat `visual.visualType`?
- [ ] visual.json hat KEINE verbotenen Root-Properties?
- [ ] Alle visual.json JSON-valid?

**Wenn all PASS, zu PHASE 3: Validierung**
