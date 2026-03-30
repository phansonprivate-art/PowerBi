# PHASE 1: SCHRITT 1 – MCP Verbindung & Metadaten
# Projekt: Lucanet_Finance | Stand: 2026-03-24 ✅ ABGESCHLOSSEN

---

## ✅ Verbindung

| Parameter | Wert |
|-----------|------|
| PBI Desktop | "Lucanet - Finance" |
| Port | `61279` |
| ConnectionString | `Data Source=localhost:61279;Application Name=MCP-PBIModeling` |
| Status | ✅ Verbunden |

---

## ✅ Datenbank

| Parameter | Wert |
|-----------|------|
| **DatabaseID** | `33fc1078-7c99-4449-a1b4-09d6df87e161` |
| Model | `Model` |
| CompatibilityLevel | `1600` |
| Sprache | `1031` (Deutsch) |
| Zuletzt verarbeitet | 2026-03-18 |

---

## ✅ Tabellen (6)

| Tabelle | Spalten | Typ |
|---------|---------|-----|
| `Facts` | 9 | Faktentabelle |
| `AccountStructure` | 8 | DIM – Kontenstruktur (Bilanz/GuV/CF-Hierarchie) |
| `DataLevel` | 7 | DIM – Datenebene (Ist / Plan) |
| `PartnerStructure` | 19 | DIM – Partner / Gesellschaft |
| `Datum` | 15 | DIM – Kalender |
| `Measure` | 1 + 48 Measures | Measure-Tabelle |

**Modell-Typ:** Star-Schema ✅

---

## ✅ Measures (48) – Tabelle: `Measure`

### Standard

| Measure | Beschreibung |
|---------|-------------|
| `GuV Ist` | Ist-Werte GuV |
| `GuV Plan` | Plan-Werte GuV |
| `GuV Ist Operatives Ergebnis` | Ist-Werte op. Ergebnis |
| `GuV Plan Operatives Ergebnis` | Plan-Werte op. Ergebnis |
| `GuV Ist Umsatzerlöse` | Ist-Umsatz |
| `Date_Min` / `Date_Max` / `Max_Year` | Datums-Hilfsmeasures |

### Time Intelligence (je Basis-Measure × 3 Serien)

| Folder | Measures |
|--------|---------|
| `01 Current Period` | `…ACT` (4×) |
| `02 Last Year` | `…LY` (4×) |
| `03 YoY Variance (Monthly)` | `…Delta`, `…Delta %` (8×) |
| `04 YTD` | `…YTD` (4×) |
| `05 LYTD` | `…LYTD` (4×) |
| `06 YTD Total` | `…YTD Total`, `…LYTD Total` (8×) |
| `07 YoY Variance (YTD)` | `…YoY Total`, `…YoY Total %` (8×) |

**Basis-Serien:** GuV Ist · GuV Plan · GuV Ist Operatives Ergebnis · GuV Plan Operatives Ergebnis

**Time Intelligence:** ✅ Vollständig vorhanden

### ✅ Neue Measures (in Phase 2 erstellt)

| Measure | DAX-Formel (validiert) | Status |
|---------|----------------------|--------|
| `Bilanz Ist` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Bilanz", DataLevel[DataLevelName]="Ist")` | ✅ |
| `Bilanz Plan` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Bilanz", DataLevel[DataLevelName]="Plan")` | ✅ |
| `CF Ist` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Cashflow", DataLevel[DataLevelName]="Ist")` | ✅ |
| `CF Plan` | `CALCULATE(SUM(Facts[Value]), AccountStructure[AccountLevel1]="Cashflow", DataLevel[DataLevelName]="Plan")` | ✅ |

> ⚠️ **Wichtig:** `CALCULATE([GuV Ist], AccountLevel1="Bilanz")` liefert **BLANK** — `GuV Ist` filtert intern schon auf `AccountLevel1="GuV"`, das ist ein Filterkonflikt. Immer direkt `SUM(Facts[Value])` verwenden!

---

## ✅ Beziehungen (4) – alle aktiv, Many-to-One, OneDirection

| Von | → | Zu |
|-----|---|----|
| `Facts.ReportElementID` | → | `AccountStructure.ReportElementID` |
| `Facts.PartnerID` | → | `PartnerStructure.PartnerID` |
| `Facts.DataLevelID` | → | `DataLevel.DataLevelID` |
| `Facts.KEY_DATE` | → | `Datum.KEY_DATE` |

---

## ⚠️ KRITISCHE WARNUNG

```
❌ column_operations NUR zur Orientierung!

Die ECHTEN Spaltennamen kommen aus TMDL files (nach Export in Phase 2).
MCP kann sagen "AccountLevel1", aber TMDL hat ggf. anderen Namen
→ IMMER TMDL verwenden, nicht MCP!
```

---

## ✅ Status-Checkliste

- [x] PBI Desktop läuft ("Lucanet - Finance", Port 61279)
- [x] MCP Verbindung erfolgreich
- [x] DatabaseID: `33fc1078-7c99-4449-a1b4-09d6df87e161`
- [x] 6 Tabellen inventarisiert
- [x] 48 Measures inventarisiert (inkl. Display Folders)
- [x] 4 Beziehungen dokumentiert
- [x] Fehlende Measures für Bilanz & Cashflow identifiziert
- [x] 4 neue Measures in Phase 2 erstellt (Bilanz Ist/Plan, CF Ist/Plan)
- [x] Weiter zu **SCHRITT 2 (Template-Analyse)**
