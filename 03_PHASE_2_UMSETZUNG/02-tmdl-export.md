# PHASE 2: SCHRITT 5A – TMDL Export & Feldlisten-Extraktion

## ⚠️ DAS IS DER KRITISCHSTE SCHRITT!

Hier entsteht die **TMDL-Feldliste = Einzige Quelle der Wahrheit** für visual.json Feldnamen.

---

## Schritt 1: TMDL exportieren

**via MCP → database_operations**

```
Operation: ExportToTmdlFolder
Request: {
  "tmdlFolderPath": "{TMDL-Ordner}"
}
```

**Ziel-Struktur nach Export:**

```
{TMDL-Ordner}\
├── database.tmdl
├── model.tmdl
└── tables\
    ├── DIM_Kalender.tmdl
    ├── DIM_Produkt.tmdl
    ├── DIM_Kunde.tmdl
    ├── DIM_Einzelhandel.tmdl
    ├── Fact_Sales.tmdl
    └── _Measures.tmdl
```

📌 **Wichtig:** Speicherpfad exakt wie in `parameters.md` definiert!

---

## Schritt 2: TMDL-Feldliste extrahieren

**Python Script (ausführen nach Export):**

```python
import os
import re
import json

# Basis-Pfad aus Parameters
TMDL_ORDNER = r"C:\Users\sphan\...\Sons_Final_Result\Sons_Final_Result.SemanticModel\definition\tables"

# Regex Patterns
COLUMN_PATTERN = r'^\s+column\s+(?P<name>\S+)'
MEASURE_PATTERN = r"^\s+measure\s+'?(?P<name>[^'=\n]+)'?"

# Feldliste erstellen
valid_fields = {}

for tmdl_file in os.listdir(TMDL_ORDNER):
    if not tmdl_file.endswith('.tmdl'):
        continue
    
    table_name = tmdl_file.replace('.tmdl', '')
    file_path = os.path.join(TMDL_ORDNER, tmdl_file)
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Spalten extrahieren
    columns = re.findall(COLUMN_PATTERN, content, re.MULTILINE)
    
    # Measures extrahieren (nur in _Measures.tmdl)
    measures = []
    if '_Measures' in table_name:
        measures = re.findall(MEASURE_PATTERN, content, re.MULTILINE)
    
    valid_fields[table_name] = {
        'columns': columns,
        'measures': measures,
        'all': columns + measures
    }

# Speichern als JSON
output_file = os.path.join(TMDL_ORDNER, '..', 'TMDL-Feldliste.json')
with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(valid_fields, f, indent=2, ensure_ascii=False)

print(f"✅ TMDL-Feldliste erstellt: {output_file}")
print(json.dumps(valid_fields, indent=2, ensure_ascii=False))
```

---

## Schritt 3: TMDL-Feldliste DOKUMENTIEREN

**Ausgabe Beispiel:**

```json
{
  "DIM_Kalender": {
    "columns": ["Jahr", "Quartal", "MonatJahrKurz", "Datum", "Wochentag"],
    "measures": [],
    "all": ["Jahr", "Quartal", "MonatJahrKurz", "Datum", "Wochentag"]
  },
  "DIM_Produkt": {
    "columns": ["Kategorie", "Subkategorie", "Produktname", "SKU"],
    "measures": [],
    "all": ["Kategorie", "Subkategorie", "Produktname", "SKU"]
  },
  "DIM_Kunde": {
    "columns": ["Land", "Beruf", "Branche_DE", "KundenID"],
    "measures": [],
    "all": ["Land", "Beruf", "Branche_DE", "KundenID"]
  },
  "DIM_Einzelhandel": {
    "columns": ["LandName", "Bundesland_DE", "Stadt"],
    "measures": [],
    "all": ["LandName", "Bundesland_DE", "Stadt"]
  },
  "Fact_Sales": {
    "columns": ["Amount", "Contribution", "Quantity", "TransactionID"],
    "measures": [],
    "all": ["Amount", "Contribution", "Quantity", "TransactionID"]
  },
  "_Measures": {
    "columns": [],
    "measures": ["Umsatz", "Deckungsbeitrag", "Umsatz YoY %", "Umsatz YTD"],
    "all": ["Umsatz", "Deckungsbeitrag", "Umsatz YoY %", "Umsatz YTD"]
  }
}
```

### ⚠️ DIESE LISTE IST HEILIG!

**Speichern unter:**
```
{TMDL-Ordner}\TMDL-Feldliste.json
```

**Und NOCHMAL in:**
```
{ZIELORDNER}\{PROJEKTNAME}\TMDL-FELDLISTE.md
```

---

## Schritt 4: Sanity Checks auf TMDL-Export

```
[ ] Alle .tmdl Dateien vorhanden?
[ ] database.tmdl hat "namespace", "name"?
[ ] model.tmdl hat "tables: ["DIM_*", "Fact_*", "_Measures"]?
[ ] _Measures.tmdl hat alle geplanten Measures?
[ ] Keine Syntax-Fehler in TMDL?
[ ] TMDL-Feldliste.json ist valid JSON?
```

---

## ❌ HÄUFIGE FEHLER

| Fehler | Ursache | Lösung |
|--------|--------|--------|
| "Measure XYZ nicht in _Measures.tmdl" | Export incomplete | TMDL-Ordner löschen, erneut exportieren |
| "Spalte hat Leerzeichen" | TMDL Parser schwach bei Spezialzeichen | Feldname in visual.json exakt abgleichen |
| JSON zeigt statt "Kategorie" → "category" | Sprache im TMDL | TMDL Datei öffnen, echte Namen extrahieren |
| "TMDL-Feldliste.json invalid" | Regex fehler | Manuell korrigieren oder Encoding checken |

---

## Checkliste Schritt 5A

- [ ] TMDL exportiert in {TMDL-Ordner}?
- [ ] Python Skript gelaufen?
- [ ] TMDL-Feldliste.json vorhanden?
- [ ] Alle Tabellen + Spalten drin?
- [ ] Alle Measures in _Measures?
- [ ] JSON valid (kein Parser-Fehler)?
- [ ] **Feldliste an zentraler Stelle dokumentiert?**

**→ Falls alle PASS, dann zu SCHRITT 5B: Dateistruktur erstellen**

**→ Falls FAIL, Phase 2 Schritt 4 & 5A wiederholen**
