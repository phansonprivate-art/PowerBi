# Visual.json Format-Regeln (visualContainer/2.7.0)

> **AKTUALISIERT nach Phase 2/3 Learnings (2026-03-30)**
> Alle Fehler aus der Lucanet_Finance-Implementierung sind hier eingeflossen.

## REGEL A: `query` MUSS innerhalb von `visual` sein (NICHT Top-Level!)

```json
✅ RICHTIG:
{
  "$schema": "...visualContainer/2.7.0/schema.json",
  "name": "abc123",
  "position": {...},
  "visual": {
    "visualType": "cardVisual",
    "query": {
      "queryState": {...}
    }
  }
}

❌ FALSCH (Schema-Fehler: "Property 'query' has not been defined"):
{
  "name": "abc123",
  "visual": {...},
  "query": {            ← NIEMALS auf Top-Level!
    "queryState": {...}
  }
}
```

**Fehler in PBI Desktop:**
`Property 'query' has not been defined and the schema does not allow additional properties.`

---

## REGEL B: `queryState` ist ein OBJECT (nicht Array!) mit Rollen als Keys

```json
✅ RICHTIG:
"query": {
  "queryState": {
    "Values": {
      "projections": [...]
    },
    "Category": {
      "projections": [...]
    }
  }
}

❌ FALSCH (Schema-Fehler: "Expected Object but got Array"):
"query": {
  "queryState": [
    {
      "Command": "SetBindingRef",
      "Binding": {...}
    }
  ]
}
```

**Fehler in PBI Desktop:**
`Invalid type. Expected Object but got Array. Path 'visual.query.queryState'`

---

## REGEL C: SourceRef MUST BE "Entity"

```json
✅ RICHTIG:
{ "SourceRef": { "Entity": "AccountStructure" } }

❌ FALSCH:
{ "SourceRef": { "Source": "AccountStructure" } }
```

---

## REGEL D: Property = Feldname aus TMDL

```json
✅ RICHTIG (aus TMDL Feldliste):
{ "Property": "AccountLevel2" }

❌ FALSCH (MCP-Name oder erfunden):
{ "Property": "Account Level 2" }
```

---

## Projection-Format (innerhalb queryState)

Jede Projection hat 3 Felder: `field`, `queryRef`, `nativeQueryRef`

### Measure-Projection
```json
{
  "field": {
    "Measure": {
      "Expression": {
        "SourceRef": { "Entity": "Measure" }
      },
      "Property": "Bilanz Ist"
    }
  },
  "queryRef": "Measure.Bilanz Ist",
  "nativeQueryRef": "Bilanz Ist"
}
```

### Column-Projection
```json
{
  "field": {
    "Column": {
      "Expression": {
        "SourceRef": { "Entity": "AccountStructure" }
      },
      "Property": "AccountLevel2"
    }
  },
  "queryRef": "AccountStructure.AccountLevel2",
  "nativeQueryRef": "AccountLevel2"
}
```

---

## Rollen-Namen pro Visual-Typ

| Visual Type | Rollen | Beschreibung |
|-------------|--------|--------------|
| `cardVisual` | `Values` | Hauptwert (Measure) |
| `slicer` | `Values` | Feld zum Filtern (Column) |
| `lineChart` | `Category`, `Y` | X-Achse (Column), Y-Achse (Measures) |
| `donutChart` | `Category`, `Y` | Segmente (Column), Werte (Measure) |
| `clusteredBarChart` | `Category`, `Y` | Kategorien (Column), Werte (Measures) |
| `hundredPercentStackedColumnChart` | `Category`, `Y` | Kategorien (Column), Werte (Measures) |
| `gauge` | `Y`, `TargetValue` | Ist-Wert, Soll-Wert (Measures) |
| `tableEx` | `Values` | Spalten (Columns + Measures gemischt) |
| `pivotTable` | `Rows`, `Values` | Zeilen (Columns), Werte (Measures) |

---

## Verbotene Strukturen in visual.json

```
❌ "query" auf Top-Level (neben "name", "position", "visual")
❌ "queryState" als Array [...]
❌ "filterConfig" auf Top-Level
❌ "filters" auf Top-Level
❌ "prototypeQuery" irgendwo
❌ "SetBindingRef" / "Command" / "Binding" (altes Format!)
❌ "dataRoles" in visual (PBI generiert das selbst)
❌ Entity "_Measures" (heißt "Measure")
```

---

## Vollständiges Beispiel: Card Visual mit Measure

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "e08628bf944cfaa394aa",
  "position": {
    "x": 0, "y": 0, "z": 5000,
    "height": 155, "width": 380, "tabOrder": 5000
  },
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
                  "Expression": {
                    "SourceRef": { "Entity": "Measure" }
                  },
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

## Vollständiges Beispiel: Slicer mit Column

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.7.0/schema.json",
  "name": "0622d919c6179c53593f",
  "position": {
    "x": 24, "y": 551, "z": 17000,
    "height": 75, "width": 208, "tabOrder": 13000
  },
  "visual": {
    "visualType": "slicer",
    "objects": {
      "data": [{"properties": {"mode": {"expr": {"Literal": {"Value": "'Dropdown'"}}}}}]
    },
    "drillFilterOtherVisuals": true,
    "query": {
      "queryState": {
        "Values": {
          "projections": [
            {
              "field": {
                "Column": {
                  "Expression": {
                    "SourceRef": { "Entity": "AccountStructure" }
                  },
                  "Property": "AccountLevel1"
                }
              },
              "queryRef": "AccountStructure.AccountLevel1",
              "nativeQueryRef": "AccountLevel1"
            }
          ]
        }
      }
    }
  }
}
```

## Vollständiges Beispiel: Line Chart mit Category + Y

```json
{
  "visual": {
    "visualType": "lineChart",
    "drillFilterOtherVisuals": true,
    "query": {
      "queryState": {
        "Category": {
          "projections": [
            {
              "field": {
                "Column": {
                  "Expression": { "SourceRef": { "Entity": "Datum" } },
                  "Property": "Monatsname"
                }
              },
              "queryRef": "Datum.Monatsname",
              "nativeQueryRef": "Monatsname"
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

## Validierungs-Checkliste

- [ ] `query` ist innerhalb von `visual` (nicht Top-Level)?
- [ ] `queryState` ist ein Object `{}` (nicht Array `[]`)?
- [ ] Rollen-Keys stimmen mit Visual-Typ überein (Values, Category, Y, etc.)?
- [ ] Jede Projection hat `field`, `queryRef`, `nativeQueryRef`?
- [ ] Alle `"Entity"` sind gültige Tabellennamen aus TMDL?
- [ ] Alle `"Property"` sind in der TMDL-Feldliste vorhanden?
- [ ] Measures nutzen `"Measure"` als Entity (nicht `"_Measures"`)?
- [ ] Kein `"SetBindingRef"`, `"Command"`, `"Binding"` (altes Format)?
