# TROUBLESHOOTING – Häufige Fehler & Lösungen

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
Template-Version falsch kopiert
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
Template hatte SemanticModel Referenz
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
visual.json kopiert von altem Template (alte Schema)
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
Measure in visual.json referenziert, aber nicht in _Measures.tmdl
```

### Lösung
```
1. TMDL-Feldliste.json öffnen
2. "_Measures" Sektion prüfen
3. Measure existiert? NEIN → Phase 2 Schritt 1 (MCP create)
4. Existiert? JA → visual.json Feldname korrigieren
5. CHECK 8 wiederholen
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
