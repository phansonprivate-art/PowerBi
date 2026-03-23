# PHASE 3: CHECK 7 – TMDL-Feldvalidierung (KRITISCH!)

## ⚠️ DAS IST DIE WICHTIGSTE VALIDIERUNG!

Wenn diese fehlschlägt → **JEDES VISUAL in PBI Desktop zeigt Fehler!**

---

## Ablauf

### 1) TMDL-Feldliste laden

```python
import json
import glob
import os
import re

# Pfade aus parameters.md
TMDL_ORDNER = r"C:\Users\sphan\...\Sons_Final_Result\Sons_Final_Result.SemanticModel\definition\tables"
PBIP_ORDNER = r"C:\Users\sphan\...\Sons_Final_Result"

# TMDL-Feldliste laden ODER neu erstellen
tmdl_fieldlist_file = os.path.join(TMDL_ORDNER, '..', 'TMDL-Feldliste.json')

if os.path.exists(tmdl_fieldlist_file):
    with open(tmdl_fieldlist_file, 'r', encoding='utf-8') as f:
        valid_fields = json.load(f)
else:
    # Fallback: Erneut extrahieren
    valid_fields = {}
    for tmdl_file in glob.glob(os.path.join(TMDL_ORDNER, '*.tmdl')):
        table_name = os.path.basename(tmdl_file).replace('.tmdl', '')
        with open(tmdl_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        columns = re.findall(r'^\s+column\s+(\S+)', content, re.MULTILINE)
        measures = re.findall(r"^\s+measure\s+'?([^'=\n]+)'?", content, re.MULTILINE)
        
        valid_fields[table_name] = set(columns + measures)
```

### 2) Alle visual.json durchgehen

```python
errors = []

for visual_file in glob.glob(os.path.join(PBIP_ORDNER, '**', 'visual.json'), recursive=True):
    with open(visual_file, 'r', encoding='utf-8') as f:
        visual = json.load(f)
    
    # Entity/Property Kombinationen validieren
    def check_bindings(obj, path=""):
        if isinstance(obj, dict):
            # Look for SourceRef + Property Pattern
            if 'SourceRef' in obj and 'Property' in obj:
                entity = obj['SourceRef'].get('Entity')
                prop = obj['Property']
                
                if entity and prop:
                    if entity not in valid_fields:
                        errors.append(f"{visual_file}: Entity '{entity}' existiert nicht in TMDL")
                    elif prop not in valid_fields[entity]:
                        errors.append(f"{visual_file}: {entity}.{prop} existiert nicht in TMDL")
            
            # Recurse
            for key, value in obj.items():
                check_bindings(value, f"{path}/{key}")
        
        elif isinstance(obj, list):
            for item in obj:
                check_bindings(item, path)
    
    check_bindings(visual)

# Report
if errors:
    print("❌ TMDL FIELD VALIDATION FAILED:")
    for e in errors:
        print(f"  - {e}")
    exit(1)
else:
    print("✅ ALL TMDL FIELDS VALID")
    exit(0)
```

---

## Beispiel Fehler

```
❌ visual.json in "Visual_Sales_Table":
   DIM_Produkt.Category existiert nicht in TMDL
   
Ursache: TMDL hat "Kategorie", nicht "Category"
Lösung: visual.json korrigieren: "Property": "Kategorie"
```

---

## Checkliste

- [ ] TMDL-Feldliste existiert?
- [ ] Script läuft fehlerfrei?
- [ ] Alle Entities in TMDL?
- [ ] Alle Properties in TMDL?
- [ ] Keine Typos?

**→ Alle ✅?**
- **JA** → CHECK 8
- **NEIN** → visual.json Feldnamen korrigieren (anhand TMDL-Feldliste), CHECK 7 wiederholen

**⚠️ KEINE Abkürzungen oder Erfindungen!**
- ❌ "Category" wenn TMDL "Kategorie" hat
- ✅ Exakt dem TMDL-Namen folgen
