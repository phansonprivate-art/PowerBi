# PBIP Semantic Model – definition.pbism Struktur

## Minimal Template (v4.2)

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/model/definitionProperties/1.0.0/schema.json",
  "version": "4.2",
  "settings": {},
  "name": "SemanticModel",
  "description": "Semantic Model für {PROJEKTNAME}",
  "collation": "de-DE",
  "language": 1031,
  "cultures": [
    {
      "name": "de-DE",
      "displayName": "Deutsch"
    }
  ],
  "dataSources": [
    {
      "name": "Quelle1",
      "connectionString": "..."
    }
  ],
  "tables": [],
  "relationships": [],
  "measures": []
}
```

---

## .platform Struktur

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/semanticModel/platformProperties/2.0.0/schema.json",
  "version": "1.0"
}
```

**Pfad:** `{PROJEKTNAME}.SemanticModel\.platform`

---

## Kritische Regeln

| Regel | ✅ Richtig | ❌ Falsch |
|-------|-----------|----------|
| **version** | `"4.2"` | `"1.0.0"` |
| **settings** | `{}` (vorhanden) | Nicht vorhanden |
| **language** | `1031` (Deutsch) oder `1033` (Englisch) | String statt int |
| **$schema** | `definitionProperties/1.0.0` | `definitionProperties/4.2` |

---

## Tabellen-Struktur (aus TMDL)

Jede Tabelle wird NACH TMDL Import definiert:

```json
{
  "name": "DIM_Kalender",
  "description": "Dimension für Zeitintelligenz",
  "columns": [
    {
      "name": "Jahr",
      "dataType": "int64",
      "isKey": false
    },
    {
      "name": "MonatJahrKurz",
      "dataType": "string"
    }
  ]
}
```

⚠️ **Spaltennamen ALWAYS aus TMDL beziehen, nicht von MCP!**
