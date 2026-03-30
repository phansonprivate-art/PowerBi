# PHASE 1: SCHRITT 3 – Anforderungsdokumentation
# Projekt: Lucanet_Finance | Stand: 2026-03-24 ✅ ABGESCHLOSSEN

---

## Modell-Übersicht

| Parameter | Wert |
|-----------|------|
| Projektname | `Lucanet_Finance` |
| Seiten | Bilanz · GuV · Cashflow |
| Semantic Model | `Lucanet - Finance` (Port 61279) |
| Template | `09_TEMPLATE\Template.pbip` |

---

## Use Cases

### UC-1: GuV – Ist/Plan-Trendanalyse
- **Seite:** GuV
- **Beschreibung:** Umsatz und operatives Ergebnis im Ist/Plan-Vergleich über Zeit
- **Dimensions:** Datum (Jahr/Monat), AccountStructure (Kontenebene), PartnerStructure, DataLevel
- **Measures:** `GuV Ist`, `GuV Plan`, `GuV Ist Operatives Ergebnis`, `GuV Plan Operatives Ergebnis`, `GuV Ist Umsatzerlöse`
- **Time Intelligence:** YTD, YoY, Delta
- **Begründung:** Kern-KPI für Finance-Reporting

### UC-2: GuV – Monatsvergleich (YoY)
- **Seite:** GuV
- **Beschreibung:** Aktueller Monat vs. Vorjahresmonat
- **Measures:** `GuV Ist Delta`, `GuV Ist Delta %`, `GuV Plan Delta`, `GuV Plan Delta %`
- **Begründung:** Abweichungsanalyse Ist vs. Vorjahr

### UC-3: Bilanz – Bilanzpositionen Ist/Plan
- **Seite:** Bilanz
- **Beschreibung:** Bilanzpositionen im Ist/Plan-Vergleich nach Kontenstruktur
- **Filter:** `AccountStructure[AccountLevel1] = "Bilanz"` (nach TMDL validieren!)
- **Measures:** `Bilanz Ist` ⚠️, `Bilanz Plan` ⚠️ (in Phase 2 erstellen)
- **Begründung:** Bilanz-Reporting für Finance-Team

### UC-4: Cashflow – CF-Positionen
- **Seite:** Cashflow
- **Beschreibung:** Cashflow-Positionen tabellarisch/als Pivot nach CF-Kategorien
- **Filter:** `AccountStructure[AccountLevel1] = "Cashflow"` (nach TMDL validieren!)
- **Measures:** `CF Ist` ⚠️, `CF Plan` ⚠️ (in Phase 2 erstellen)
- **Begründung:** Liquiditäts-Übersicht

---

## Measures-Plan

| Name | Formel (Entwurf) | Display Folder | Format | Status |
|------|-----------------|----------------|--------|--------|
| `GuV Ist` | vorhanden | Standard | €#,##0 | ✅ |
| `GuV Plan` | vorhanden | Standard | €#,##0 | ✅ |
| `GuV Ist Operatives Ergebnis` | vorhanden | Standard | €#,##0 | ✅ |
| `GuV Plan Operatives Ergebnis` | vorhanden | Standard | €#,##0 | ✅ |
| `GuV Ist Umsatzerlöse` | vorhanden | Standard | €#,##0 | ✅ |
| `GuV Ist ACT` … `GuV Plan Op.Erg. YoY Total %` | vorhanden (40×) | Time Intelligence\01–07 | variabel | ✅ |
| `Bilanz Ist` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Bilanz", DataLevel[DataLevelName]="Ist")` | Standard | €#,##0 | ✅ erstellt |
| `Bilanz Plan` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Bilanz", DataLevel[DataLevelName]="Plan")` | Standard | €#,##0 | ✅ erstellt |
| `CF Ist` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Cashflow", DataLevel[DataLevelName]="Ist")` | Standard | €#,##0 | ✅ erstellt |
| `CF Plan` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Cashflow", DataLevel[DataLevelName]="Plan")` | Standard | €#,##0 | ✅ erstellt |

> ✅ AccountLevel1-Werte via TMDL bestätigt: `"Bilanz"` und `"Cashflow"` korrekt.
> ⚠️ **Formel-Hinweis:** `CALCULATE([GuV Ist], AccountLevel1="Bilanz")` → **BLANK** (Filterkonflikt). Immer direkt `SUM(Facts[Value])` verwenden.

---

## Seiten-Design

### Seite 1: GuV (Template-Basis: $ReportPage1)

| Visual | Typ | Measure(s) | Dimension |
|--------|-----|-----------|-----------|
| KPI-Card 1 | cardVisual | `GuV Ist YTD Total` + `GuV Ist YoY Total %` | – |
| KPI-Card 2 | cardVisual | `GuV Plan YTD Total` + `GuV Plan YoY Total %` | – |
| KPI-Card 3 | cardVisual | `GuV Ist Operatives Ergebnis YTD Total` | – |
| KPI-Card 4 | cardVisual | `GuV Ist Umsatzerlöse` | – |
| Line Chart | lineChart | `GuV Ist ACT`, `GuV Plan ACT` | `Datum[Monat]` |
| Donut | donutChart | `GuV Ist` | `AccountStructure[AccountLevel2]` |
| Bar Chart | clusteredBarChart | `GuV Ist`, `GuV Plan` | `PartnerStructure[Partner]` |
| 100% Stacked | hundredPercentStackedColumnChart | `GuV Ist`, `GuV Ist Operatives Ergebnis` | `Datum[Quartal]` |
| Gauge oben | gauge | `GuV Ist YTD Total` | Target: `GuV Plan YTD Total` |
| Gauge unten | gauge | `GuV Ist Operatives Ergebnis YTD Total` | Target: `GuV Plan Operatives Ergebnis YTD Total` |
| Slicer links 1 | slicer | – | `Datum[Jahr]` |
| Slicer links 2 | slicer | – | `Datum[Monat]` |
| Slicer links 3 | slicer | – | `PartnerStructure[Partner]` |
| Slicer links 4 | slicer | – | `AccountStructure[AccountLevel1]` |
| Slicer oben 1 | slicer | – | `DataLevel[DataLevelName]` |
| Slicer oben 2 | slicer | – | `Datum[Quartal]` |
| Slicer oben 3 | slicer | – | `AccountStructure[AccountLevel2]` |

### Seite 2: Bilanz (Template-Basis: $ReportPage1)

| Visual | Typ | Measure(s) | Dimension |
|--------|-----|-----------|-----------|
| KPI-Card 1 | cardVisual | `Bilanz Ist` ⚠️ | – |
| KPI-Card 2 | cardVisual | `Bilanz Plan` ⚠️ | – |
| KPI-Card 3 | cardVisual | `Bilanz Ist` YTD ⚠️ | – |
| KPI-Card 4 | cardVisual | Delta Bilanz Ist vs Plan ⚠️ | – |
| Line Chart | lineChart | `Bilanz Ist`, `Bilanz Plan` | `Datum[Monat]` |
| Donut | donutChart | `Bilanz Ist` | `AccountStructure[AccountLevel2]` |
| Bar Chart | clusteredBarChart | `Bilanz Ist`, `Bilanz Plan` | `AccountStructure[AccountLevel3]` |
| 100% Stacked | hundredPercentStackedColumnChart | `Bilanz Ist` | `Datum[Quartal]` |
| Gauge oben | gauge | `Bilanz Ist` YTD ⚠️ | Target: `Bilanz Plan` YTD ⚠️ |
| Gauge unten | gauge | analog | – |
| Slicers | analog GuV | – | Datum, Partner, AccountLevel |

### Seite 3: Cashflow (Template-Basis: $ReportPage2)

| Visual | Typ | Measure(s) | Dimension |
|--------|-----|-----------|-----------|
| Card Ist | cardVisual | `CF Ist` ⚠️ + YoY% ⚠️ | – |
| Card Plan | cardVisual | `CF Plan` ⚠️ + YoY% ⚠️ | – |
| Donut | donutChart | `CF Ist` | `AccountStructure[AccountLevel2]` |
| Table | tableEx | `CF Ist`, `CF Plan`, Delta | `AccountStructure[AccountLevel3]` |
| Pivot | pivotTable | `CF Ist`, `CF Plan` | Rows: AccountLevel · Cols: Datum[Monat] |
| Bar Chart | clusteredBarChart | `CF Ist`, `CF Plan` | `Datum[Monat]` |
| Slicers | analog GuV | – | Datum, DataLevel, AccountLevel |

---

## ⚠️ Fehlende / Zu klärende Felder

| Was | Wo | Priorität |
|-----|----|-----------|
| `Bilanz Ist` / `Bilanz Plan` | ✅ In Phase 2 erstellt | – |
| `CF Ist` / `CF Plan` | ✅ In Phase 2 erstellt | – |
| AccountLevel1-Werte ("Bilanz"/"Cashflow") | ✅ Via TMDL bestätigt | – |
| Spaltenname `Datum[Monatsname]` / `[Jahr]` / `[Quartal]` | ✅ Via TMDL bestätigt | – |
| PartnerStructure: `PartnerName` | ✅ Via TMDL bestätigt | – |

---

## ✅ Status-Checkliste

- [x] Alle Use Cases identifiziert (UC-1 bis UC-4)
- [x] Jeder UC hat Dimension + Measure
- [x] Time Intelligence geplant (vorhandene Measures nutzen)
- [x] Alle bestehenden Measures dokumentiert (48 Stück)
- [x] Fehlende Measures identifiziert (4 Stück) und Formelansatz definiert
- [x] Display Folders zugeordnet
- [x] Fehlende Felder dokumentiert (NICHT erfunden, mit ⚠️ markiert)
- [x] Seiten-Layout pro Seite definiert (Visual × Measure × Dimension)
- [ ] Stakeholder-Signoff (optional)
- [x] **→ Weiter zu PHASE 2**
