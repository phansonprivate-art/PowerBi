# PHASE 2: SCHRITT 6 – page.json & visual.json generieren

## page.json (Pro Seite)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\{PageID}\page.json`

### 09_TEMPLATE:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/page/2.1.0/schema.json",
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

### Beispiel: Table Visual mit TMDL Feldnamen

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Table",
  "visual": {
    "visualType": "table",
    "objects": {},
    "dataRoles": [
      {
        "name": "Values",
        "displayName": "Werte",
        "kind": "GroupingHorizontal"
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
                  },
                  {
                    "Expression": {
                      "SourceRef": {
                        "Entity": "DIM_Produkt"
                      },
                      "Property": "Kategorie"
                    }
                  },
                  {
                    "Expression": {
                      "SourceRef": {
                        "Entity": "_Measures"
                      },
                      "Property": "Umsatz"
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

### Beispiel: Card Visual (Measure)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Card",
  "visual": {
    "visualType": "card",
    "objects": {
      "calloutValue": [
        {
          "properties": {
            "textSize": {
              "value": 28
            }
          }
        }
      ]
    }
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
                        "Entity": "_Measures"
                      },
                      "Property": "Umsatz"
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

### Beispiel: Bar Chart (Dimension + Measure)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Chart",
  "visual": {
    "visualType": "barChart",
    "objects": {
      "categoryAxis": [
        {
          "properties": {
            "show": {
              "value": true
            }
          }
        }
      ]
    }
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
                        "Entity": "DIM_Produkt"
                      },
                      "Property": "Kategorie"
                    }
                  }
                ]
              },
              {
                "Projections": [
                  {
                    "Expression": {
                      "SourceRef": {
                        "Entity": "_Measures"
                      },
                      "Property": "Umsatz"
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

---

### ⚠️ KRITISCHE REGELN FÜR visual.json

| Regel | ✅ Richtig | ❌ Falsch |
|-------|-----------|----------|
| **Entity** | `"Entity": "DIM_Kalender"` | `"Source": "..."` |
| **Property** | Aus TMDL-Feldliste | Von MCP erfunden |
| **query** | `"queryState": [...]` | `"prototypeQuery"` |
| **Top-Level** | ❌ Kein `"filters"` | ✅ In `queryState` |
| **SourceRef** | IMMER vorhanden | Darf nie fehlen |
| **Measure Ref** | `"Entity": "_Measures"` + `"Property": "Umsatz"` | Direkt als String |

---

## Automatische Generation (Python)

```python
def generate_table_visual(visual_id, fields_from_tmdl):
    """
    Generiert visual.json aus TMDL-Feldliste
    fields_from_tmdl = {
        "entity": "DIM_Kalender",
        "properties": ["Jahr", "Quartal"]
    }
    """
    
    projections = []
    for prop in fields_from_tmdl["properties"]:
        projections.append({
            "Expression": {
                "SourceRef": {
                    "Entity": fields_from_tmdl["entity"]
                },
                "Property": prop
            }
        })
    
    return {
        "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json",
        "name": visual_id,
        "visual": {
            "visualType": "table",
            "objects": {},
            "dataRoles": [{"name": "Values", "displayName": "Werte", "kind": "GroupingHorizontal"}]
        },
        "query": {
            "queryState": [{
                "Command": "SetBindingRef",
                "Binding": {
                    "Primary": {
                        "Groupings": [{
                            "Projections": projections
                        }]
                    }
                }
            }]
        }
    }
```

---

## Checkliste page.json & visual.json

- [ ] Alle page.json Dateien für jede Seite vorhanden?
- [ ] visual.json in korrekten Ordnern?
- [ ] SourceRef nutzt "Entity" (nicht "Source")?
- [ ] Property-Werte alle aus TMDL-Feldliste?
- [ ] Keine Top-Level "filters" oder "filterConfig"?
- [ ] query nur "queryState" (keine "prototypeQuery")?
- [ ] Alle visual.json JSON-valid?

**→ Wenn all PASS, zu PHASE 3: Validierung**
