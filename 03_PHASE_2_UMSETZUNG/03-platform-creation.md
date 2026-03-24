# PHASE 2: SCHRITT 5B – PBIP Dateistruktur erstellen

## REIHENFOLGE IST BINDEND:

```
1. .platform (SemanticModel)
2. definition.pbism
3. .pbip ROOT Datei
4. .platform (Report)
5. Report Dateien (definition.pbir, version.json, etc.)
6. pages.json
7. page.json pro Seite
8. visual.json pro Visual
```

---

## A) .platform (SemanticModel)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel\.platform`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/semanticModel/platformProperties/2.0.0/schema.json",
  "version": "1.0"
}
```

✅ **Speichen als:** `.platform` (KEIN `.json` Suffix!)

---

## B) definition.pbism (SemanticModel)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel\definition.pbism`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/model/definitionProperties/1.0.0/schema.json",
  "version": "4.2",
  "settings": {},
  "name": "{PROJEKTNAME}",
  "description": "Semantic Model für {PROJEKTNAME}",
  "collation": "de-DE",
  "language": 1031,
  "cultures": [
    {
      "name": "de-DE",
      "displayName": "Deutsch"
    }
  ]
}
```

**⚠️MUSS:**
- `"version": "4.2"` (nicht `"1.0.0"`)
- `"settings": {}` vorhanden

---

## C) {PROJEKTNAME}.pbip (ROOT)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.pbip`

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

**⚠️ NIEMALS:**
- ❌ `"semanticModel"` in artifacts!
- ❌ Nur **Report** Referenz!

---

## D) .platform (Report)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\.platform`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/platformProperties/2.0.0/schema.json",
  "version": "1.0"
}
```

---

## E) definition.pbir

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition.pbir`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/definitionProperties/2.0.0/schema.json",
  "version": "4.0"
}
```

---

## F) version.json

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\version.json`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/versionMetadata/1.0.0/schema.json",
  "version": "2.0.0"
}
```

---

## G) report.json

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\report.json`

(Von 09_TEMPLATE kopieren: `C:\Users\phant\.claude\PowerBi\09_TEMPLATE\09_TEMPLATE.Report\definition\report.json`):

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/report/3.0.0/schema.json",
  "id": "UUID-oder-random-string",
  "displayName": "{PROJEKTNAME}",
  "description": ""
}
```

---

## H) pages.json (PFLICHT!)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages.json`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/pbip/report/pagesMetadata/1.0.0/schema.json",
  "pageOrder": [
    "Page_Overview",
    "Page_Details",
    "Page_RawData"
  ]
}
```

**IDs müssen den Ordnernamen in `pages/` entsprechen!**

---

## I) .relationships (Empty)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\.relationships`

```json
[]
```

---

## J) Ordnerstruktur für Pages

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\`

Pro Seite ein Ordner:

```
pages/
├── Page_Overview/
│   ├── page.json
│   └── visuals/
│       ├── Visual_Sales_Card/
│       │   └── visual.json
│       ├── Visual_Sales_Chart/
│       │   └── visual.json
│       └── Visual_Sales_Table/
│           └── visual.json
├── Page_Details/
│   ├── page.json
│   └── visuals/
│       ├── Visual_Breakdown/
│       │   └── visual.json
│       └── ...
└── Page_RawData/
    ├── page.json
    └── visuals/
        └── Visual_Raw_Table/
            └── visual.json
```

---

## Checkliste Dateistruktur

- [ ] .pbip ROOT hat NUR "report" in artifacts?
- [ ] definition.pbism version = "4.2"?
- [ ] Alle .platform Dateien vorhanden (2x)?
- [ ] pages.json pageOrder = Alle Seiten?
- [ ] Seiten-Ordner entsprechen pageOrder Namen?
- [ ] .relationships existiert (leer)?

**→ Wenn alle Strukturen vorhanden, dann zu SCHRITT 6: Report Content**
