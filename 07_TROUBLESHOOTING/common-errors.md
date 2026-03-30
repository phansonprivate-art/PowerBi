# TROUBLESHOOTING – Häufige Fehler & Lösungen

> **AKTUALISIERT nach Phase 2/3 Learnings (2026-03-30)**

---

## ❌ "Property 'query' has not been defined and the schema does not allow additional properties"

### Ursache
```
query wurde als Top-Level Property in visual.json geschrieben (neben name, position, visual).
Schema visualContainer/2.7.0 erlaubt query NUR innerhalb von visual{}.
```

### Lösung
```json
❌ FALSCH:
{
  "name": "...",
  "visual": {...},
  "query": { "queryState": {...} }    ← Top-Level = VERBOTEN
}

✅ RICHTIG:
{
  "name": "...",
  "visual": {
    "visualType": "...",
    "query": { "queryState": {...} }   ← Innerhalb visual = OK
  }
}
```

**Siehe:** CRITICAL_RULES.md Regel 8

---

## ❌ "Invalid type. Expected Object but got Array. Path 'visual.query.queryState'"

### Ursache
```
queryState wurde als Array [...] statt Object {...} geschrieben.
Altes Format mit "Command": "SetBindingRef" ist UNGÜLTIG.
```

### Lösung
```json
❌ FALSCH:
"queryState": [{"Command": "SetBindingRef", "Binding": {...}}]

✅ RICHTIG:
"queryState": {
  "Values": {
    "projections": [
      {
        "field": {"Measure": {"Expression": {"SourceRef": {"Entity": "Measure"}}, "Property": "Bilanz Ist"}},
        "queryRef": "Measure.Bilanz Ist",
        "nativeQueryRef": "Bilanz Ist"
      }
    ]
  }
}
```

**Siehe:** CRITICAL_RULES.md Regel 9, visual-formats.md Regel B

---

## ❌ "Felder, die korrigiert werden müssen: (Measure) Bilanz Ist, (Measure) Bilanz Plan"

### Ursache
```
Measures existieren im laufenden SSAS (via MCP erstellt),
aber NICHT in der Measure.tmdl Datei des PBIP-Projekts.
PBI Desktop lädt Measures aus TMDL, nicht aus dem SSAS-Cache.
```

### Lösung
```
1. Measure.tmdl öffnen:
   {Projekt}.SemanticModel/definition/tables/Measure.tmdl

2. Measure hinzufügen:
   measure 'Bilanz Ist' =
       CALCULATE(SUM(Facts[Value]),
           AccountStructure[AccountLevel1] = "Bilanz",
           DataLevel[DataLevelName] = "Ist")
       formatString: #,##0
       displayFolder: Standard
       lineageTag: {GUID}

3. PBI Desktop schließen und .pbip erneut öffnen
```

**Siehe:** CRITICAL_RULES.md Regel 10

---

## ❌ "Fehler beim Laden des Berichts" (generisch, nur Activity-ID)

### Ursache
```
Meistens: Ein oder mehrere visual.json Dateien haben Schema-Fehler.
PBI Desktop stoppt den gesamten Report-Load wenn EIN Visual fehlerhaft ist.
```

### Lösung
```
1. Alle query-Bindings aus ALLEN Visuals entfernen (Reset):
   python -c "
   import json, glob, os
   for vj in glob.glob('pages/*/visuals/*/visual.json'):
       d = json.load(open(vj))
       if 'query' in d.get('visual', {}):
           del d['visual']['query']
           json.dump(d, open(vj,'w'), indent=2)
   "

2. Report öffnen → Visuals laden als leere Container
3. Bindings einzeln/schrittweise hinzufügen
4. Nach jedem Schritt testen
```

---

## ❌ "Keine Seiten-Tabs sichtbar / Report-Canvas komplett leer"

### Ursache
```
"Fehler beim Laden des Berichts" verhindert das Laden der Report-Definition.
Semantic Model lädt (Daten-Panel zeigt Tabellen), aber Report-Seiten fehlen.
```

### Lösung
```
1. Visual.json Fehler beheben (siehe oben)
2. pages.json prüfen: pageOrder Array muss gültige Ordnernamen enthalten
3. Jeder Ordner in pages/ muss page.json mit passendem "name" haben
```

## ❌ "TMDL-Feldliste.json nicht gefunden"

### Ursache
```
Phase 2 Schritt 2 nicht durchgeführt
oder Feldliste an falschem Ort gespeichert
```

### Lösung
```
1. Gehe zu Phase 2 Schritt 2 (TMDL Export)
2. Stelle sicher:
   - MCP ExportToTmdlFolder war erfolgreich
   - python3 extract-tmdl-fields.py lief
   - TMDL-Feldliste.json existiert in {TMDL-Ordner}/..
3. CHECK 0 wiederholen
```

---

## ❌ "Property 'XYZ' existiert nicht in TMDL"

### Ursache
```
visual.json hat falschen Feldnamen
- MCP sagt "Category", TMDL hat "Kategorie"
- Typo oder Abkürzung erfunden
```

### Lösung
```
1. TMDL-Feldliste.json öffnen
2. Suche nach korrektem Namen
3. visual.json korrigieren:
   "Property": "Kategorie"    ← statt "Category"
4. CHECK 7 wiederholen
```

---

## ❌ JSON Parser Error: "Unexpected token"

### Ursache
```
Syntax-Fehler in JSON (Komma, Klammer, Quote)
```

### Lösung
```
1. Datei in jsonlint.com validieren
2. Fehler lokalisieren (Zeile X)
3. Korrigieren:
   - Fehlendes Komma nach Property?
   - Unclosed String?
   - Extra Komma am Ende?
4. CHECK 3 wiederholen
```

**Beispiel:**
```json
❌ FALSCH:
{
  "name": "Visual1",
  "query": {...}      ← Extra Komma am Ende!
}

✅ RICHTIG:
{
  "name": "Visual1",
  "query": {...}
}
```

---

## ❌ version.json hat "1.0.0"

### Ursache
```
09_TEMPLATE-Version falsch kopiert
```

### Lösung
```
1. Öffne version.json
2. Ändere: "version": "1.0.0"
3. Zu:     "version": "2.0.0"
4. CHECK 4 wiederholen
```

---

## ❌ ".pbip hat

 'semanticModel' in artifacts"

### Ursache
```
09_TEMPLATE hatte SemanticModel Referenz
(das ist für Fabric Workspaces anders)
```

### Lösung
```
1. Öffne {PROJEKTNAME}.pbip
2. Entferne:
   "semanticModel": {...}

3. Behalte NUR:
   "artifacts": [
     {
       "report": {
         "path": "..."
       }
     }
   ]

4. CHECK 2 wiederholen
```

---

## ❌ "SourceRef nutzt 'Source' statt 'Entity'"

### Ursache
```
visual.json kopiert von altem 09_TEMPLATE (alte Schema)
```

### Lösung
```
1. Öffne visual.json
2. Suche: "Source": "..."
3. Ändere zu:
   "SourceRef": {
     "Entity": "..."
   }
4. CHECK 5 wiederholen
```

---

## ❌ "PBI Desktop: Projekt konnte nicht geladen werden"

### Ursache
```
Meistens: CHECK 7 nicht gelaufen
→ Feldname existent, aber in visual.json falsch geschrieben
```

### Lösung
```
1. NICHT in PBI Desktop debuggen!
2. Zurück zu Phase 3
3. CHECK 0-7 nochmal vollständig durchlaufen
4. CHECK 7 besonders prüfen (TMDL Feldnamen)
5. Danach erneut in PBI öffnen
```

---

## ❌ "Measure 'XYZ' existiert nicht"

### Ursache
```
Measure in visual.json referenziert, aber nicht in Measure.tmdl
ODER: Entity heißt "_Measures" statt "Measure"
```

### Lösung
```
1. TMDL-Feldliste.json öffnen
2. "Measure" Sektion prüfen (nicht "_Measures"!)
3. Measure existiert? NEIN → Phase 2 Schritt 1 (MCP create)
4. Existiert? JA → visual.json Entity auf "Measure" korrigieren
5. CHECK 8 wiederholen
```

---

## ❌ "create-project.ps1 crasht: Parameter 'Path' ist NULL"

### Ursache
```
$_.DirectoryName gibt NULL zurück für Directory-Objekte.
(DirectoryName existiert nur bei FileInfo, nicht bei DirectoryInfo)
```

### Lösung
```powershell
# FALSCH:
$ElternPfad = $_.DirectoryName

# RICHTIG:
$ElternPfad = if ($_ -is [System.IO.DirectoryInfo]) {
    $_.Parent.FullName
} else {
    $_.DirectoryName
}
```

---

## ❌ "python: Öffnet Windows Store" / "python nicht gefunden"

### Ursache
```
Windows 10/11 liefert Python-Stub aus dem Store.
"python" im Terminal → Windows Store öffnet sich.
```

### Lösung
```
1. Python 3.x von python.org installieren
2. Danach "py" statt "python" verwenden:
   py add_query_bindings.py     ← Windows Launcher
   python3 script.py            ← Falls PATH gesetzt
```

---

## ❌ "JSON enthält \u00f6 statt ö (Umlaut als Unicode-Escape)"

### Ursache
```
Python json.dump() schreibt Umlaute standardmäßig als \u00f6.
Das sieht falsch aus, ist aber 100% valides JSON.
```

### Verhalten
```
✅ PBI Desktop liest \u00f6 korrekt als ö
✅ Kein Fehler beim Laden
✅ Measure-Bindings funktionieren
```

### Lösung (wenn Klartext gewünscht)
```python
json.dump(data, f, indent=2, ensure_ascii=False)
#                             ^^^^^^^^^^^^^^^^^^
#                             Umlaute direkt schreiben
```

---

## ⚠️ Allgemein: "Was soll ich tun?"

**Checkliste der Checks:**

```
1. Irgendein Fehler → CHECK 0 starten
2. CHECK 0 FAIL    → Zurück zu Phase 2 Schritt 2
3. CHECK 0 PASS    → CHECK 1 starten
4. CHECK 1-6 FAIL  → Fehler lesen, korrigieren, wiederholen
5. CHECK 7 FAIL    → TMDL-Feldliste + visual.json Feldnamen matching
6. CHECK 8 FAIL    → MCP Measures/Relationships validieren
7. ALLE PASS       → PBI Desktop öffnen & testen!
```

**→ Niemals die Reihenfolge durcheinanderwerfen!**

---

## 🆘 Ich komme nicht weiter – Was nun?

```
1. Diese Datei (common-errors.md) nochmal lesen
2. CRITICAL_RULES.md prüfen
3. TMDL-FIELD-MAPPING.md prüfen (Entity vs. Property)
4. GitHub Issue erstellen:
   - Beschreibe was passierte
   - Paste Error-Message
   - Gib welcher CHECK failed
5. Warte auf Code Review
```

---

## Quick Reference: Die 3 häufigsten FAILS

| #1 | TMDL-Feldliste vorhanden? | CHECK 0 |
|----|-----------------------|----|
| #2 | Feldname richtig (anhand TMDL)? | CHECK 7 |
| #3 | version = "4.2" in definition.pbism? | CHECK 4 |

**Wenn mindestens eine davon FAIL → Dahin zurück gehen!**
