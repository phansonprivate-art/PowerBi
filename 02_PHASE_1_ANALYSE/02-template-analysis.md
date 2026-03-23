# PHASE 1: SCHRITT 2 – Template-Analyse

## Analysiere die Template-Struktur

```
{TEMPLATE_PFAD}\*.Report
├── definition/
│   ├── pages.json              ← Seiten-Reihenfolge
│   ├── report.json             ← Globale Settings
│   └── pages/
│       ├── PageID-1/           ← Z.B. "Overview", "Details", "Raw Data"
│       │   ├── page.json       ← Layout: x, y, width, height, z
│       │   └── visuals/
│       │       ├── Visual1/visual.json
│       │       ├── Visual2/visual.json
│       │       └── Visual3/visual.json
│       ├── PageID-2/
│       │   ├── page.json
│       │   └── visuals/
```

---

## Zu extrahieren pro Seite

### A) Seiten-Metadaten (aus pages.json)

```json
{
  "pageOrder": [
    "Overview",
    "Details", 
    "Raw"
  ]
}
```

**Checkliste:**
- [ ] Wie viele Seiten vom Template?
- [ ] In welcher Reihenfolge?
- [ ] Neue Seiten? Alte Seiten weg?

---

### B) Pro Seite: page.json Struktur

```json
{
  "name": "Overview",
  "displayName": "Übersicht",
  "displayOption": "FitToPage",
  "visualContainers": [
    {
      "x": 0,
      "y": 0,
      "width": 320,
      "height": 180,
      "z": 1000,
      "name": "Visual_Sales"
    }
  ],
  "objects": {
    "background": [...],
    "outspace": [...]
  }
}
```

**Zu dokumentieren:**
- [ ] Alle Visual-Positionen (x, y, width, height, z)
- [ ] Background-Farben?
- [ ] Outspace (Hintergrund außerhalb)?
- [ ] Special objects (Navigation, Filter, etc.)?

---

### C) Pro Visual: visual.json Struktur

```json
{
  "name": "Visual_Sales",
  "visual": {
    "visualType": "table",       ← oder "barChart", "lineChart", etc.
    "objects": {
      "general": [...]           ← Formatierung
    }
  },
  "query": {
    "queryState": [
      {
        "Binding": {
          "Primary": {
            "Groupings": [...]
          }
        }
      }
    ]
  }
}
```

**Zu dokumentieren pro Visual:**
- [ ] Visual-Type? (table, barChart, lineChart, card, etc.)
- [ ] Welche Felder werden verwendet? (Spalten → TMDL Namen!)
- [ ] Filter?
- [ ] Formatierungen? (DecimalPlaces, FontSize, etc.)
- [ ] Sorting?

---

## Design-Analyse

### Farbpalette

```
Primär:    #... (HEX)
Sekundär:  #...
Akzent:    #...
Neutral:   #...

→ In alle neuen Visuals inkl. Pages übernehmen
```

### Layout-Grid

```
Typischer Seitenaufbau?
- Header (y=0-100)?
- Left Panel (x=0-80)?
- Main Area (x=80-360)?
- Right Panel (x=360-400)?

→ Konsistenz über alle Seiten
```

### Navigation

```json
→ Gibt es Buttons zum Seitenwechsel?
→ Bookmarks?
→ Filter-Panel?
```

---

## Template-Mapping Dokument (als Ausgabe)

**Beispiel:**

| Seite | Visuals | Types | Fields | Notes |
|-------|---------|-------|--------|-------|
| Overview | 3 | Table, Card, Chart | Jahr, Umsatz, Deckungsbeitrag | Topbar |
| Details | 5 | Table, 4x Card | Alle Felder | Bei Bedarf scrollen |
| Raw | 1 | Table | * | Alle Spalten, sortierbar |

---

## Checkliste Template-Analyse

- [ ] Seitenstruktur erfasst?
- [ ] Visual-Positionen dokumentiert?
- [ ] Visual-Types identifiziert?
- [ ] Feldnamen aus TMDL extrahiert?
- [ ] Farbpalette notiert?
- [ ] Layout-Grid erfasst?
- [ ] Mapping Dokument erstellt?
- [ ] Template-Kopie in {ZIELORDNER} für finale Sanity Checks?
