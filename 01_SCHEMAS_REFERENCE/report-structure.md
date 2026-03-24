# PBIP Report – Dateistruktur & Schemas

## Gesamt-Struktur

```
{PROJEKTNAME}.Report/
├── definition/
│   ├── .platform                    ← platformProperties/2.0.0
│   ├── definition.pbir              ← definitionProperties/2.0.0
│   ├── version.json                 ← versionMetadata/1.0.0
│   ├── report.json                  ← report/3.0.0
│   ├── pages.json                   ← pagesMetadata/1.0.0 [PFLICHT]
│   ├── .relationships
│   └── pages/
│       ├── {PageID}/
│       │   ├── page.json            ← page/2.1.0
│       │   └── visuals/
│       │       ├── {VisualID}/
│       │       │   └── visual.json  ← visualContainer/2.7.0
│       │       └── {VisualID}/
│       │           └── visual.json
│       └── {PageID}/
│           ├── page.json
│           └── visuals/
│
└── definition.pbir
```

---

## pages.json (PFLICHT!)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/pagesMetadata/1.0.0/schema.json",
  "pageOrder": [
    "PageID-1",
    "PageID-2",
    "PageID-3"
  ]
}
```

**Wichtig:**
- ✅ `pageOrder` muss ALLE Seiten in korrekter Reihenfolge enthalten
- ✅ IDs müssen Ordnernamen in `pages/` entsprechen
- ✅ **Datei ist PFLICHT – fehlende Datei = Fehler beim Import in PBI**

---

## page.json (Pro Seite)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/page/2.1.0/schema.json",
  "name": "PageID-1",
  "displayName": "Übersicht",
  "displayOption": "FitToPage",
  "visualContainers": [
    {
      "x": 0,
      "y": 0,
      "width": 320,
      "height": 180,
      "z": 1000,
      "name": "Visual1"
    }
  ],
  "objects": {
    "background": [
      {
        "properties": {
          "fill": {
            "solid": {
              "color": {
                "value": "#FFFFFF"
              }
            }
          }
        }
      }
    ]
  }
}
```

**Verboten in page.json:**
- ❌ `"ordinal"`
- ❌ `"filters"` (Top-Level)
- ❌ `"config"` (Top-Level)

---

## visual.json (Beispiel: Table Visual)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json",
  "name": "Visual1",
  "visual": {
    "visualType": "table",
    "objects": {},
    "dataRoles": [
      {
        "name": "Values",
        "kind": "GroupingHorizontal",
        "displayName": "Werte"
      }
    ]
  },
  "query": {
    "queryState": [
      {
        "Command": "SetBindingRef",
        "Binding": {
          "Primary": {
            "Groupings": [
              {
                "Projections": [
                  {
                    "Expression": {
                      "SourceRef": {
                        "Entity": "DIM_Kalender"
                      },
                      "Property": "Jahr"
                    }
                  }
                ]
              }
            ]
          }
        }
      }
    ]
  }
}
```

**Kritische Regeln für visual.json:**

| Regel | ✅ Richtig | ❌ Falsch |
|-------|-----------|----------|
| **SourceRef** | `{"Entity": "..."}` | `{"Source": "..."}` |
| **Property** | Nur TMDL-Feldnamen | MCP-Namen |
| **query** | Nur `queryState` | `"prototypeQuery"` oder `"filters"` |
| **Top-Level filter** | ❌ Verboten | ✅ In queryState |

---

## report.json, definition.pbir, version.json

Typische Werte – meist **von 09_TEMPLATE kopieren**:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/report/3.0.0/schema.json",
  "id": "UUID",
  "displayName": "{PROJEKTNAME}",
  "description": ""
}
```

---

## .relationships (Empty in Report)

```json
[]
```

---

## Checkliste Report-Struktur

- [ ] `pages.json` existiert und ist korrekt?
- [ ] Alle PageIDs in `pages.json` haben entsprechende Ordner?
- [ ] Jeder Visual hat eigene `visual.json`?
- [ ] Kein `"filters"` Top-Level in `visual.json`?
- [ ] Entity nutzt korrekten TMDL-Feldnamen?
- [ ] `.platform` vorhanden?
