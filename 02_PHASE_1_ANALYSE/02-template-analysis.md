# PHASE 1: SCHRITT 2 – Template-Analyse
# Projekt: Lucanet_Finance | Stand: 2026-03-24 ✅ ABGESCHLOSSEN

---

## Template-Pfad

```
C:\Users\phant\.claude\PowerBi\09_TEMPLATE\Template.pbip
→ Template.Report\definition\pages\
```

---

## Technische Eckdaten

| Parameter | Wert |
|-----------|------|
| Canvas | 1920 × 1080 px |
| Schema (Visual) | `visualContainer/2.7.0` |
| Schema (Page) | `page/2.1.0` |
| Theme | `CY26SU02` (SharedResources) |
| SourceRef-Format | `{"SourceRef": {"Entity": "..."}}` ✅ (Regel 4 korrekt) |

---

## Seite 1: `$ReportPage1` (229ddded65ba36c359e6) – 28 Visuals

### Layout-Skizze (1920×1080)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  [Titel "$ReportPage1" – weiß, 24pt, bold]     [Slicer][Slicer][Slicer] top │
├──────────┬───────────────────────────────────────────────────────┬───────────┤
│ Slicer   │ [Card Group]  [Card Group]  [Card Group]  [Card Group]│ [Gauge]   │
│ Slicer   │                                                        │ [Gauge]   │
│ Slicer   │ [Line Chart – Trend über Zeit, 1185×458px]             │           │
│ Slicer   ├─────────────────┬──────────────────┬──────────────────┤           │
│ Slicer   │ [Donut 380×263] │ [Bar 381×263]    │ [100% Stack      │           │
│ [Clear]  │                 │                  │  782×263]        │           │
└──────────┴─────────────────┴──────────────────┴──────────────────┴───────────┘
```

### Visual-Inventar

| Visual-ID (Kurzform) | Typ | Position (x,y) | Größe (w×h) | Binding |
|---------------------|-----|----------------|-------------|---------|
| `2abca457` (Group) | group | 290, 129 | 380×155 | – |
| `4cc60085` (Group) | group | 691, 129 | 381×155 | – |
| `2d06fcfc` (Group) | group | 1093, 129 | 381×155 | – |
| `dc1ea63d` (Group) | group | 1496, 128 | 381×155 | – |
| `e08628bf` | cardVisual | in Group 1 | 381×155 | `Measure[Bilanz Ist]` |
| `d93a0fe3` | cardVisual | in Group 2 | 381×155 | `Measure[Bilanz Plan]` |
| `2ca0b3be` | cardVisual | in Group 3 | 381×155 | `Measure[GuV Ist Operatives Ergebnis]` |
| `2944e88e` | cardVisual | in Group 4 | 381×155 | `Measure[GuV Ist Umsatzerlöse]` |
| `eb41d0ea` | lineChart | 290, 299 | 1185×458 | `Datum[Monatsname]` × `Bilanz Ist`, `Bilanz Plan` |
| `63d36d97` | donutChart | 290, 772 | 380×263 | `AccountStructure[AccountLevel2]` × `Bilanz Ist` |
| `c71eef90` | clusteredBarChart | 691, 772 | 381×263 | `AccountStructure[AccountLevel3]` × `Bilanz Ist`, `Bilanz Plan` |
| `a82eb6d4` | hundredPercentStackedColumnChart | 1093, 772 | 782×263 | `Datum[Quartal]` × `Bilanz Ist`, `Bilanz Plan` |
| `1bd6318a` | gauge | 1495, 540 | 381×217 | `Bilanz Ist` + `Bilanz Plan` |
| `68dcee2e` | gauge | 1496, 299 | 381×229 | (kein Binding – Seite Bilanz) |
| `518806cf` | slicer (Dropdown) | 1668, 13 | 209×76 | `Datum[Quartal]` |
| `8cc6e4db` | slicer (Dropdown) | 1459, 13 | 209×76 | `DataLevel[DataLevelName]` |
| `931b4c92` | slicer (Dropdown) | 1250, 13 | 209×76 | `Datum[Jahr]` |
| `0622d919` | slicer (Dropdown) | 25, 551 | 209×76 | `AccountStructure[AccountLevel2]` |
| `c2f60dee` | slicer (Dropdown) | 25, 648 | 209×76 | `Datum[Monatsname]` |
| `aeafdbb` | slicer (Dropdown) | 25, 757 | 209×76 | `AccountStructure[AccountLevel1]` |
| `a0dd37d5` | slicer (Dropdown) | 25, 452 | 209×76 | `PartnerStructure[PartnerName]` |
| `32e2ae2a` | textbox | 275, 24 | 374×65 | "$ReportPage1" |
| `ebfde11d` | actionButton | 53, 883 | 155×39 | "Clear all slicers" |

**Zusammenfassung:** 4 KPI-Cards · 1 Line · 1 Donut · 1 Bar · 1 100%-Stack · 2 Gauges · 7 Slicers · 1 Button · 1 Textbox · 4 Groups

---

## Seite 2: `$ReportPage2` (ca650288acf4f449ebac) – 16 Visuals

### Layout-Skizze (1920×1080)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  [Titel "$ReportPage2" – weiß, 24pt, bold]     [Slicer][Slicer][Slicer] top │
├──────────┬──────────────────────┬──────────────┬────────────────────────────┤
│ Slicer   │ [Card: Ist + YoY]    │ [Donut       │ [Table 833×410]            │
│ Slicer   │  286×128             │  420×244]    │                            │
│ Slicer   │ [Card: Plan + YoY]   │              │ [Pivot Table 833×449]      │
│ Slicer   │  286×124             ├──────────────┘                            │
│ Slicer   │                      │                                            │
│ [Clear]  │ [Bar Chart (Group)   │                                            │
│          │  716×622]            │                                            │
└──────────┴──────────────────────┴────────────────────────────────────────────┘
```

### Visual-Inventar

| Visual-ID (Kurzform) | Typ | Position (x,y) | Größe (w×h) | Binding |
|---------------------|-----|----------------|-------------|---------|
| `f563e92d` | cardVisual | 287, 134 | 286×129 | `Measure[GuV Ist YTD Total]` (GuV) / `Measure[CF Ist]` (CF) |
| `059feeea` | cardVisual | 289, 263 | 286×124 | `Measure[GuV Plan YTD Total]` (GuV) / `Measure[CF Plan]` (CF) |
| `8027f3d8` | donutChart | 585, 142 | 420×244 | `AccountStructure[AccountLevel2]` × `GuV Ist` / `CF Ist` |
| `f98c0af6` | tableEx | 1031, 142 | 833×410 | `AccountStructure[AccountLevel3]`, `GuV Ist`, `GuV Plan` (oder CF) |
| `91418a36` | pivotTable | 1031, 579 | 833×449 | `[AccountLevel2, GuV Ist]` × `Datum[Monatsname]` |
| `bee7d47e` (Group) | group | 289, 407 | 716×622 | – |
| `b39b0c86` | clusteredBarChart | in Group | 716×622 | `AccountStructure[AccountLevel3]` × `GuV Ist`, `GuV Plan` |
| `fa7e47c6` | slicer (Dropdown) | 1668, 13 | 209×76 | `Datum[Quartal]` |
| `0464fdc8` | slicer (Dropdown) | 1459, 13 | 209×76 | `DataLevel[DataLevelName]` |
| `7911a50b` | slicer (Dropdown) | 1250, 13 | 209×76 | `Datum[Jahr]` |
| `82c9e6a7` | slicer (Dropdown) | 25, 551 | 209×76 | `AccountStructure[AccountLevel2]` |
| `37ce51d5` | slicer (Dropdown) | 25, 648 | 209×76 | `Datum[Monatsname]` |
| `241f2d52` | slicer (Dropdown) | 25, 757 | 209×76 | `AccountStructure[AccountLevel1]` |
| `255d73fc` | slicer (Dropdown) | 25, 452 | 209×76 | `PartnerStructure[PartnerName]` |
| `9c5d1feb` | textbox | 275, 24 | 374×65 | Seitenname (GuV / Cashflow) |
| `63eaa5de` | actionButton | 53, 883 | 155×39 | "Clear all slicers" |

**Zusammenfassung:** 2 Multi-Metric Cards · 1 Donut · 1 Table · 1 Pivot · 1 Bar (in Group) · 7 Slicers · 1 Button · 1 Textbox · 1 Group

---

## Gemeinsame Struktur (beide Seiten)

| Element | Detail |
|---------|--------|
| Linke Slicer-Spalte | x=25, y=452/551/648/757, je 209×76 px |
| Obere Slicer-Zeile | x=1250/1459/1668, y=13, je 209×76 px |
| Titel-Textbox | x=275, y=24, 374×65, weiß/bold/24pt |
| Clear-Button | x=53, y=883, 155×39, Bookmark-Action |
| Hintergrund | Leer (kein Bild) – kann angepasst werden |

---

## Zuordnung für Lucanet_Finance

| Projektseite | Template-Basis | Begründung |
|-------------|---------------|------------|
| **GuV** | `$ReportPage1` (28 Visuals) | Line/Gauge ideal für Ist-Plan-Trend + 4 KPI-Cards |
| **Bilanz** | `$ReportPage1` (28 Visuals) | Gleiche KPI-Struktur, andere Kontenfilter |
| **Cashflow** | `$ReportPage2` (16 Visuals) | Table/Pivot ideal für CF-Positionen, kompakter |

---

## ⚠️ Entity-Mapping bei Umsetzung

> Template-Visuals referenzieren noch Generic-Entities (leer).
> In Phase 2 werden diese mit echten Lucanet-Entities befüllt:

| Visual-Typ | Entity | Property (✅ TMDL-bestätigt) |
|------------|--------|----------------------------|
| Slicer Jahr | `Datum` | `Jahr` |
| Slicer Monat | `Datum` | `Monatsname` |
| Slicer Quartal | `Datum` | `Quartal` |
| Slicer Partner | `PartnerStructure` | `PartnerName` |
| Slicer AccountLevel1 | `AccountStructure` | `AccountLevel1` |
| Slicer AccountLevel2 | `AccountStructure` | `AccountLevel2` |
| Slicer DataLevel | `DataLevel` | `DataLevelName` |
| Cards / Charts Bilanz | `Measure` | `Bilanz Ist`, `Bilanz Plan` |
| Cards / Charts GuV | `Measure` | `GuV Ist YTD Total`, `GuV Plan YTD Total` |
| Cards / Charts CF | `Measure` | `CF Ist`, `CF Plan` |

---

## ✅ Status-Checkliste

- [x] Template-Pfad identifiziert
- [x] Beide Seiten vollständig analysiert
- [x] Visual-Typen inventarisiert
- [x] Positionen und Größen dokumentiert
- [x] Data-Binding-Struktur (SourceRef Entity) verstanden
- [x] Seiten-Zuordnung für Lucanet_Finance entschieden
- [x] Weiter zu **SCHRITT 3 (Anforderungsdokumentation)**
