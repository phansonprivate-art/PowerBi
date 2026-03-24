# PHASE 2: SCHRITT 5B – PBIP Dateistruktur erstellen

## Quelle: Template aus `06_TEMPLATES/`

> Alle Schema-URLs und Dateiinhalte unten sind direkt aus dem funktionierenden Template abgeleitet.
> Bei Unsicherheit: Datei direkt aus `06_TEMPLATES/` kopieren und Projektnamen anpassen.

## REIHENFOLGE IST BINDEND:

```
1. .platform (SemanticModel)  — aus Template kopieren + anpassen
2. definition.pbism            — aus Template kopieren
3. .pbip ROOT Datei            — aus Template kopieren + Pfad anpassen
4. .platform (Report)          — aus Template kopieren + anpassen
5. definition.pbir             — aus Template kopieren + Pfad anpassen
6. Report Dateien (version.json, report.json)
7. pages.json
8. page.json pro Seite
9. visual.json pro Visual
```

---

## A) .platform (SemanticModel)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel\.platform`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/gitIntegration/platformProperties/2.0.0/schema.json",
  "metadata": {
    "type": "SemanticModel",
    "displayName": "{PROJEKTNAME}"
  },
  "config": {
    "version": "2.0",
    "logicalId": "{NEUE-UUID-GENERIEREN}"
  }
}
```

> Speichern als: `.platform` (KEIN `.json` Suffix!)
> UUID generieren mit: `[guid]::NewGuid().ToString()` (PowerShell) oder `uuid.uuid4()` (Python)

---

## B) definition.pbism (SemanticModel)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel\definition.pbism`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/semanticModel/definitionProperties/1.0.0/schema.json",
  "version": "4.2",
  "settings": {}
}
```

**MUSS:**
- `"version": "4.2"` (nicht `"1.0.0"`)
- `"settings": {}` vorhanden

---

## C) {PROJEKTNAME}.pbip (ROOT)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.pbip`

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

**NIEMALS:**
- `"semanticModel"` in artifacts!
- Nur **Report** Referenz!
- Schema ist `pbipProperties` (nicht `pbip`)!
- Version ist `"1.0"` (nicht `"3.0"`)!

---

## D) .platform (Report)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\.platform`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/gitIntegration/platformProperties/2.0.0/schema.json",
  "metadata": {
    "type": "Report",
    "displayName": "{PROJEKTNAME}"
  },
  "config": {
    "version": "2.0",
    "logicalId": "{NEUE-UUID-GENERIEREN}"
  }
}
```

---

## E) definition.pbir

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition.pbir`

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

---

## F) version.json

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\version.json`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/versionMetadata/1.0.0/schema.json",
  "version": "2.0.0"
}
```

---

## G) report.json

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\report.json`

Am besten direkt aus Template kopieren. Minimal-Version:

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

> `themeCollection` ist PFLICHT.
> `resourcePackages` + `settings` + `objects` aus Template übernehmen für volle Funktionalität.

---

## H) pages.json (PFLICHT!)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\pages.json`

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/pagesMetadata/1.0.0/schema.json",
  "pageOrder": [
    "{pageId1}",
    "{pageId2}"
  ],
  "activePageName": "{pageId1}"
}
```

**IDs müssen den Ordnernamen in `pages/` entsprechen!**

---

## I) Ordnerstruktur für Pages

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\definition\pages\`

Pro Seite ein Ordner:

```
pages/
├── pages.json
├── {pageId1}/
│   ├── page.json
│   └── visuals/
│       ├── {visualId1}/
│       │   └── visual.json
│       └── {visualId2}/
│           └── visual.json
└── {pageId2}/
    ├── page.json
    └── visuals/
        └── {visualId3}/
            └── visual.json
```

---

## J) StaticResources (Theme kopieren!)

**Pfad:** `{ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report\StaticResources\SharedResources\BaseThemes\CY26SU02.json`

> Diese Datei aus dem Template kopieren! Ohne sie fehlt das Base Theme.

---

## Checkliste Dateistruktur

- [ ] .pbip ROOT hat NUR "report" in artifacts?
- [ ] .pbip Schema = `pbipProperties/1.0.0` (NICHT `pbip/1.0.0`)?
- [ ] definition.pbism version = "4.2"?
- [ ] definition.pbism Schema = `item/semanticModel/definitionProperties/1.0.0`?
- [ ] Beide .platform Dateien vorhanden mit `gitIntegration/platformProperties/2.0.0`?
- [ ] definition.pbir Schema = `item/report/definitionProperties/2.0.0`?
- [ ] pages.json pageOrder = Alle Seiten?
- [ ] Seiten-Ordner entsprechen pageOrder Namen?
- [ ] CY26SU02.json Theme kopiert?

**Wenn alle Strukturen vorhanden, dann zu SCHRITT 6: Report Content**
