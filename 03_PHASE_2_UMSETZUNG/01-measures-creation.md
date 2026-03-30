# PHASE 2: SCHRITT 4 – Measures via MCP erstellen

## Vorbereitung

**Aus Phase 1 haben wir dokumentiert:**
- Use Cases (wer braucht welche KPI?)
- Measures Namen + Formeln
- Display Folders (01_Basis, 02_Zeitintelligenz, etc.)
- Format Strings (€, %, etc.)

---

## ⚠️ Wichtige Regeln vor der Erstellung

### Measure-Tabellen-Name
Der korrekte `tableName` lautet **`"Measure"`** (nicht `"_Measures"`, nicht `"Measures"`).
Der genaue Name steht in der TMDL-Datei `tables\Measure.tmdl` — immer dort nachschlagen!

### DAX-Filterkonflikt vermeiden
**Problem:** Vorhandene Measures filtern oft schon intern (z.B. `AccountLevel1 = "GuV"`).
Einen solchen Measure in `CALCULATE(...)` mit einem weiteren `AccountLevel1`-Filter zu wrappen ergibt **BLANK**.

```dax
❌ FALSCH – liefert BLANK:
Bilanz Ist = CALCULATE([GuV Ist], AccountStructure[AccountLevel1] = "Bilanz")
-- GuV Ist filtert schon auf AccountLevel1 = "GuV" → Konflikt!

✅ RICHTIG – direkt auf Basistabelle:
Bilanz Ist = CALCULATE(
    SUM(Facts[Value]),
    AccountStructure[AccountLevel1] = "Bilanz",
    DataLevel[DataLevelName] = "Ist"
)
```

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
    "tableName": "Measure",
    "displayFolder": "01_Basis",
    "formatString": "€#,##0.00",
    "description": "Gesamtumsatz"
  },
  {
    "name": "Deckungsbeitrag",
    "expression": "SUM(Fact[Contribution])",
    "tableName": "Measure",
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
    "tableName": "Measure",
    "displayFolder": "02_Zeitintelligenz",
    "formatString": "€#,##0.00"
  },
  {
    "name": "Umsatz YoY %",
    "expression": "DIVIDE([Umsatz] - [Umsatz PY], [Umsatz PY])",
    "tableName": "Measure",
    "displayFolder": "02_Zeitintelligenz",
    "formatString": "±#,##0.0%"
  },
  {
    "name": "Umsatz YTD",
    "expression": "TOTALYTD([Umsatz], DIM_Kalender[Datum])",
    "tableName": "Measure",
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
    "tableName": "Measure",
    "displayFolder": "03_Vergleiche",
    "formatString": "€#,##0.00"
  }
]
```

---

## ⚠️ WICHTIG: Measures AUCH in TMDL-Datei eintragen!

MCP erstellt Measures nur **im laufenden SSAS** (In-Memory).
Für PBIP-Projekte müssen sie **zusätzlich in der `.tmdl`-Datei** stehen!

```
Pfad: {Projekt}.SemanticModel/definition/tables/Measure.tmdl
```

### TMDL-Format für neue Measures:
```
	measure 'Bilanz Ist' =
			CALCULATE(
			    SUM(Facts[Value]),
			    AccountStructure[AccountLevel1] = "Bilanz",
			    DataLevel[DataLevelName] = "Ist"
			)
		formatString: #,##0
		displayFolder: Standard
		lineageTag: {beliebige-guid}
```

### Warum?
- PBI Desktop lädt das Semantic Model aus TMDL-Dateien
- Measures die nur via MCP im SSAS existieren gehen beim Neustart verloren
- Ohne TMDL-Eintrag: "Felder, die korrigiert werden müssen: (Measure) ..."

**Reihenfolge:**
1. Measure via MCP erstellen (zum Testen im laufenden Modell)
2. Measure in Measure.tmdl eintragen (für Persistenz)
3. Beides muss synchron sein!

---

## Checkliste Measures

- [ ] Alle Basis-Measures erstellt (MCP)?
- [ ] Alle Zeitintelligenz-Measures erstellt?
- [ ] Display Folders konsistent?
- [ ] Format Strings korrekt (€, %, etc.)?
- [ ] Descriptions dokumentiert?
- [ ] Keine Fehler bei MCP Create?
- [ ] **Alle Measures in Measure.tmdl eingetragen?** ← NEU!
- [ ] Via DAX Validator getestet?

**→ Wenn alles ✅, dann zu SCHRITT 5A: TMDL Export**
