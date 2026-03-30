# PHASE 2: SCHRITT 6 – page.json & visual.json generieren

## page.json (Pro Seite)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\{PageID}\page.json`

### 09_TEMPLATE:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/page/2.1.0/schema.json",
  "name": "Page_Overview",
  "displayName": "Übersicht",
  "displayOption": "FitToPage",
  "visualContainers": [
    {
      "x": 0,
      "y": 0,
      "width": 320,
      "height": 180,
      "z": 1000,
      "name": "Visual_Sales_Card",
      "isVisible": true
    },
    {
      "x": 320,
      "y": 0,
      "width": 80,
      "height": 180,
      "z": 1001,
      "name": "Visual_Sales_Chart",
      "isVisible": true
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
    ],
    "outspace": [
      {
        "properties": {
          "fill": {
            "solid": {
              "color": {
                "value": "#F2F2F2"
              }
            }
          }
        }
      }
    ]
  }
}
```

### Wichtig:
- ✅ `displayOption`: "FitToPage"
- ✅ `visualContainers`: Name muss visuellen Ordnernamen entsprechen
- ✅ `x, y, width, height, z`: Aus 09_TEMPLATE übernehmen
- ❌ KEIN `"ordinal"` Top-Level
- ❌ KEIN `"filters"` Top-Level
- ❌ KEIN `"config"` Top-Level

---

## visual.json (Pro Visual)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\{PageID}\visuals\{VisualID}\visual.json`

### Beispiel: Table Visual mit TMDL Feldnamen — KORRIGIERTES FORMAT

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Table",
  "visual": {
    "visualType": "tableEx",
    "objects": {},
    "drillFilterOtherVisuals": true,
    "query": {
      "queryState": {
        "Values": {
          "projections": [
            {
              "field": {
                "Column": {
                  "Expression": { "SourceRef": { "Entity": "AccountStructure" } },
                  "Property": "AccountLevel2"
                }
              },
              "queryRef": "AccountStructure.AccountLevel2",
              "nativeQueryRef": "AccountLevel2"
            },
            {
              "field": {
                "Column": {
                  "Expression": { "SourceRef": { "Entity": "AccountStructure" } },
                  "Property": "AccountLevel3"
                }
              },
              "queryRef": "AccountStructure.AccountLevel3",
              "nativeQueryRef": "AccountLevel3"
            },
            {
              "field": {
                "Measure": {
                  "Expression": { "SourceRef": { "Entity": "Measure" } },
                  "Property": "GuV Ist"
                }
              },
              "queryRef": "Measure.GuV Ist",
              "nativeQueryRef": "GuV Ist"
            }
          ]
        }
      }
    }
  }
}
```

### Beispiel: Card Visual (Measure) — KORRIGIERTES FORMAT

> **ACHTUNG:** `query` muss INNERHALB von `visual` sein! `queryState` ist ein Object mit Rollen-Keys!

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Card",
  "visual": {
    "visualType": "cardVisual",
    "objects": {...},
    "drillFilterOtherVisuals": true,
    "query": {
      "queryState": {
        "Values": {
          "projections": [
            {
              "field": {
                "Measure": {
                  "Expression": { "SourceRef": { "Entity": "Measure" } },
                  "Property": "Bilanz Ist"
                }
              },
              "queryRef": "Measure.Bilanz Ist",
              "nativeQueryRef": "Bilanz Ist"
            }
          ]
        }
      }
    }
  }
}
```

### Beispiel: Bar Chart (Dimension + Measure)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Chart",
  "visual": {
    "visualType": "clusteredBarChart",
    "objects": {...},
    "drillFilterOtherVisuals": true,
    "query": {
      "queryState": {
        "Category": {
          "projections": [
            {
              "field": {
                "Column": {
                  "Expression": { "SourceRef": { "Entity": "AccountStructure" } },
                  "Property": "AccountLevel3"
                }
              },
              "queryRef": "AccountStructure.AccountLevel3",
              "nativeQueryRef": "AccountLevel3"
            }
          ]
        },
        "Y": {
          "projections": [
            {
              "field": {
                "Measure": {
                  "Expression": { "SourceRef": { "Entity": "Measure" } },
                  "Property": "Bilanz Ist"
                }
              },
              "queryRef": "Measure.Bilanz Ist",
              "nativeQueryRef": "Bilanz Ist"
            },
            {
              "field": {
                "Measure": {
                  "Expression": { "SourceRef": { "Entity": "Measure" } },
                  "Property": "Bilanz Plan"
                }
              },
              "queryRef": "Measure.Bilanz Plan",
              "nativeQueryRef": "Bilanz Plan"
            }
          ]
        }
      }
    }
  }
}
```

---

### ⚠️ KRITISCHE REGELN FÜR visual.json

| Regel | ✅ Richtig | ❌ Falsch |
|-------|-----------|----------|
| **Entity** | `"Entity": "DIM_Kalender"` | `"Source": "..."` |
| **Property** | Aus TMDL-Feldliste | Von MCP erfunden |
| **query Position** | Innerhalb `visual{}` | Top-Level (neben name/position) |
| **queryState Typ** | Object `{}` mit Rollen-Keys | Array `[]` mit SetBindingRef |
| **Projection** | `field` + `queryRef` + `nativeQueryRef` | Nur `Expression` |
| **SourceRef** | IMMER `"Entity"` | `"Source"` |
| **Measure Ref** | `"Entity": "Measure"` | `"Entity": "_Measures"` |
| **Measures in TMDL** | Pflicht (Measure.tmdl) | Nur MCP (In-Memory) |

### Umlaute in Measure-Namen

Python schreibt Umlaute als JSON-Unicode-Escape (`ö` → `\u00f6`). Das ist **vollständig valides JSON** — PBI Desktop liest es korrekt. Kein manueller Fix nötig. Für Klartext `ensure_ascii=False` setzen:

```python
json.dump(data, f, indent=2, ensure_ascii=False)
```

---

## Automatische Generation (Python)

> **Hinweis Windows:** `python` öffnet ggf. den Windows Store. Stattdessen `py` (Windows Launcher) verwenden:
> ```
> py 05_AUTOMATION_SCRIPTS\add_query_bindings.py
> ```
> Das fertige Binding-Script liegt unter `05_AUTOMATION_SCRIPTS\add_query_bindings.py`.

```python
# KORRIGIERTES FORMAT (2026-03-30)
def measure_proj(name):
    """Measure-Projection für queryState"""
    return {
        "field": {
            "Measure": {
                "Expression": {"SourceRef": {"Entity": "Measure"}},
                "Property": name
            }
        },
        "queryRef": f"Measure.{name}",
        "nativeQueryRef": name
    }

def column_proj(table, prop):
    """Column-Projection für queryState"""
    return {
        "field": {
            "Column": {
                "Expression": {"SourceRef": {"Entity": table}},
                "Property": prop
            }
        },
        "queryRef": f"{table}.{prop}",
        "nativeQueryRef": prop
    }

def add_binding(visual_data, roles_dict):
    """Fügt queryState-Binding zu einem Visual hinzu.

    roles_dict = {
        "Category": [column_proj("Datum", "Monatsname")],
        "Y": [measure_proj("Bilanz Ist"), measure_proj("Bilanz Plan")]
    }
    """
    qs = {}
    for role, projs in roles_dict.items():
        if not isinstance(projs, list):
            projs = [projs]
        qs[role] = {"projections": projs}
    visual_data["visual"]["query"] = {"queryState": qs}
```

> **Fertige Scripts:** `05_AUTOMATION_SCRIPTS/bind_visuals_v2.py` (produktionsreif, alle 3 Seiten)

---

## Checkliste page.json & visual.json

- [ ] Alle page.json Dateien für jede Seite vorhanden?
- [ ] visual.json in korrekten Ordnern?
- [ ] SourceRef nutzt "Entity" (nicht "Source")?
- [ ] Measure-Entity = "Measure" (nicht "_Measures")?
- [ ] Property-Werte alle aus TMDL-Feldliste?
- [ ] Keine Top-Level "filters" oder "filterConfig"?
- [ ] query nur "queryState" (keine "prototypeQuery")?
- [ ] Alle visual.json JSON-valid?

**→ Wenn all PASS, zu PHASE 3: Validierung**
