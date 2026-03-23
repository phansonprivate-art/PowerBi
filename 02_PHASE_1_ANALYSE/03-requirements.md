# PHASE 1: SCHRITT 3 – Anforderungsdokumentation

## Use Cases aus vorhandenen Daten ableiten

**Frage:** Was kann der User mit diesen Daten anfangen?

### Beispiel aus Feldern

```
Verfügbare Felder:
- Jahr, Quartal, Monat (Zeit)
- Kategorie, Subkategorie, Produkt (Produkt)
- Land, Region, Stadt (Geo)
- Umsatz, Deckungsbeitrag (Metriken)

→ Use Cases:
  1. "Umsatz by Jahr" → Trendanalyse
  2. "Umsatz by Kategorie" → Top/Bottom Produkte
  3. "Umsatz by Land" → Geographische Performance
  4. "YoY Vergleich" → Zeitintelligenz
```

---

## Measures definieren (mit Time Intelligence)

### Kategorisierung

```
01_Basis Measures:
  - Umsatz          = SUM(Fact[Amount])
  - Deckungsbeitrag = SUM(Fact[Contribution])
  - Anzahl Transaktionen = COUNT(Fact[ID])

02_Zeitintelligenz:
  - Umsatz YoY      = [Umsatz] / [Umsatz PY]
  - Umsatz YTD      = TOTALYTD([Umsatz], DIM_Kalender[Datum])
  - Umsatz LM       = [Umsatz PM]

03_Vergleiche:
  - vs. Ziel
  - vs. Durchschnitt
```

---

## Mapping: Kennzahl → Seite

```json
{
  "Seite": "Overview",
  "Visuals": [
    {
      "Name": "Sales_Card",
      "Measure": "Umsatz",
      "Dimension": (keine - nur Measure)
    },
    {
      "Name": "Sales_by_Category",
      "Visual": "BarChart",
      "Dimension": "DIM_Produkt[Kategorie]",
      "Measure": "Umsatz"
    }
  ]
}
```

---

## WICHTIG: Fehlende Felder?

```
⚠️ STOPP – Explizit MELDEN, KEIN Ersatz erfinden!

Bsp: "User braucht 'Kundensegment' aber ist nicht in Daten"
→ Dokumentieren: "❌ FEHLT: Kundensegment"
→ Nicht: "OK, nehme stattdessen Region"
```

---

## Anforderungs-Template

```markdown
# Anforderungsdokumentation: {PROJEKTNAME}

## Use Cases

### UC-1: Umsatztrends
- Beschreibung: Visualisiere Umsatz-Entwicklung über Zeit
- Dimension: Jahr/Quartal/Monat
- Maße: [Umsatz]
- Filter: Kategorie (optional)
- Seite: Overview
- Begründung: KPI Monitoring

### UC-2: Produktperformance
- Beschreibung: Top/Bottom Produkte
- Dimension: Produkt / Kategorie
- Maße: [Umsatz], [Deckungsbeitrag]
- Filter: Jahr, Region (optional)
- Seite: Details
- Begründung: Sales Analysis

## Measures

| Name | Formel | Display Folder | Format |
|------|--------|----------------|--------|
| Umsatz | SUM(Fact[Amount]) | 01_Basis | €#,##0.00 |
| Umsatz YoY | [Umsatz]/[Umsatz PY] | 02_Zeitintelligenz | ±#,##0.0% |

## Fehlende Felder

- ❌ FEHLT: Kundensegment
- ❌ FEHLT: Marktanteil (extern Daten nötig)
- ⚠️ EINGESCHRÄNKT: Profit (Costs nicht vorhanden)

## Signoff

- [x] Anforderungen mit Stakeholder abgestimmt
- [x] Alle Felder verfügbar
- [x] Keine Blocking Issues
```

---

## Checkliste Anforderungen

- [ ] Alle Use Cases identifiziert?
- [ ] Jeder UC hat Dimension + Measure?
- [ ] Time Intelligence geplant?
- [ ] Alle Measures definiert?
- [ ] Display Folders zugeordnet?
- [ ] Fehlende Felder dokumentiert (nicht erfunden)?
- [ ] Stakeholder Signoff erfolgt?
- [ ] Keine offenen Fragen?

**→ Wenn alles ✅, dann zu PHASE 2**
