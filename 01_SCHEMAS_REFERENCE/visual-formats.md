# Visual.json Format-Regeln (visualContainer/2.7.0)

## SourceRef MUST BE ENTITY!

```json
✅ RICHTIG:
{
  "SourceRef": {
    "Entity": "DIM_Produkt"
  }
}

❌ FALSCH:
{
  "SourceRef": {
    "Source": "DIM_Produkt"
  }
}
```

---

## Property = Feldname aus TMDL

```json
✅ RICHTIG (aus TMDL Feldliste):
{
  "Expression": {
    "SourceRef": {"Entity": "DIM_Produkt"},
    "Property": "Kategorie"
  }
}

❌ FALSCH (MCP-Name, TMDL hat anderen Namen):
{
  "Expression": {
    "SourceRef": {"Entity": "DIM_Produkt"},
    "Property": "Category"        ← MCP sagt "Category", aber TMDL hat "Kategorie"!
  }
}
```

---

## Query-Struktur (queryState only)

```json
✅ RICHTIG:
"query": {
  "queryState": [
    {
      "Command": "SetBindingRef",
      "Binding": {...}
    }
  ]
}

❌ VERBOTEN:
"query": {
  "prototypeQuery": [...],    ← NEIN!
  "filters": [...]              ← NEIN!
}
```

---

## Verbotene Top-Level Felder in visual.json

```json
❌ "filterConfig": ...        ← NIEMALS
❌ "filters": ...             ← NIEMALS
❌ "prototypeQuery": ...      ← NIEMALS
❌ "projections": ...         ← NIEMALS (in "visual", OK in "query.queryState")
```

---

## Measures in visual.json

```json
✅ RICHTIG (Measure und Entity getrennt):
{
  "Expression": {
    "Measure": {
      "Expression": {
        "SourceRef": {
          "Entity": "_Measures"
        },
        "Property": "Umsatz"      ← Aus TMDL Feldliste
      }
    }
  }
}
```

---

## Häufige Visual-Typen

| Type | Binding Art | Beispiel |
|------|-------------|----------|
| `table` | Projections mit Columns | Spalten aus Tabelle |
| `barChart` | Axis + Values | Kategorie auf X, Measure auf Y |
| `lineChart` | Axis + Values | Zeit auf X, Measure auf Y |
| `card` | Values | Ein Measure |
| `gauge` | Target + Values | Ist-Wert vs. Sollwert |

---

## Vollständiges Beispiel: Tabelle

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/visualContainer/2.7.0/schema.json",
  "name": "Visual_Sales_Table",
  "visual": {
    "visualType": "table",
    "objects": {
      "general": [
        {
          "properties": {
            "formatString": {"text": "#,0.00"}
          }
        }
      ]
    },
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
                      "SourceRef": {"Entity": "DIM_Kalender"},
                      "Property": "Jahr"
                    }
                  },
                  {
                    "Expression": {
                      "SourceRef": {"Entity": "DIM_Produkt"},
                      "Property": "Kategorie"
                    }
                  },
                  {
                    "Expression": {
                      "SourceRef": {"Entity": "_Measures"},
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

## Validierungs-Checkliste

- [ ] Alle `"Entity"` sind gültige Tabellennamen aus TMDL?
- [ ] Alle `"Property"` sind in der TMDL-Feldliste vorhanden?
- [ ] Keine Top-Level `"filters"` oder `"filterConfig"`?
- [ ] `"query"` nur `"queryState"` (keine `"prototypeQuery"`)?
- [ ] Measures über `"_Measures"` Entity referenziert?
