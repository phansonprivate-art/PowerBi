# PHASE 2: SCHRITT 4 – Measures via MCP erstellen

## Vorbereitung

**Aus Phase 1 haben wir dokumentiert:**
- Use Cases (wer braucht welche KPI?)
- Measures Namen + Formeln
- Display Folders (01_Basis, 02_Zeitintelligenz, etc.)
- Format Strings (€, %, etc.)

---

## Ablauf: Measures anlegen

### 1️⃣ Basis-Measures erstellen

**via MCP → measure_operations**

```
Operation: Create
Definitions: [
  {
    "name": "Umsatz",
    "expression": "SUM(Fact[Amount])",
    "tableName": "_Measures",
    "displayFolder": "01_Basis",
    "formatString": "€#,##0.00",
    "description": "Gesamtumsatz"
  },
  {
    "name": "Deckungsbeitrag",
    "expression": "SUM(Fact[Contribution])",
    "tableName": "_Measures",
    "displayFolder": "01_Basis",
    "formatString": "€#,##0.00"
  }
]
```

**Status:** ✅ Umgesetzte Measures dokumentieren oder ❌ Fehler → Debug

---

### 2️⃣ Zeitintelligenz Measures

```
Operation: Create
Definitions: [
  {
    "name": "Umsatz PY",
    "expression": "CALCULATE([Umsatz], SAMEPERIODLASTYEAR(DIM_Kalender[Datum]))",
    "tableName": "_Measures",
    "displayFolder": "02_Zeitintelligenz",
    "formatString": "€#,##0.00"
  },
  {
    "name": "Umsatz YoY %",
    "expression": "DIVIDE([Umsatz] - [Umsatz PY], [Umsatz PY])",
    "tableName": "_Measures",
    "displayFolder": "02_Zeitintelligenz",
    "formatString": "±#,##0.0%"
  },
  {
    "name": "Umsatz YTD",
    "expression": "TOTALYTD([Umsatz], DIM_Kalender[Datum])",
    "tableName": "_Measures",
    "displayFolder": "02_Zeitintelligenz",
    "formatString": "€#,##0.00"
  }
]
```

---

### 3️⃣ Vergleichs-Measures (optional)

```
Operation: Create
Definitions: [
  {
    "name": "Umsatz vs. Ziel",
    "expression": "[Umsatz] - [Ziel]",
    "tableName": "_Measures",
    "displayFolder": "03_Vergleiche",
    "formatString": "€#,##0.00"
  }
]
```

---

## Checkliste Measures

- [ ] Alle Basis-Measures erstellt?
- [ ] Alle Zeitintelligenz-Measures erstellt?
- [ ] Display Folders konsistent?
- [ ] Format Strings korrekt (€, %, etc.)?
- [ ] Descriptions dokumentiert?
- [ ] Keine Fehler bei MCP Create?
- [ ] Via DAX Validator getestet?

**→ Wenn alles ✅, dann zu SCHRITT 5A: TMDL Export**
