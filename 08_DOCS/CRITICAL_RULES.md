# ⚠️ 5 KRITISCHE REGELN – NIEMALS BRECHEN!

Die zentrale Quelle für "was ist erlaubt, was nicht".

---

## REGEL 1: TMDL = Einzige Feldquelle

### ✅ RICHTIG
```
Feldname → TMDL Datei lesen → visual.json Property setzen
```

### ❌ FALSCH
```
MCP sagt Property-Name → Direkt in visual.json übernehmen
❌ NIEMALS erfinden oder abkürzen
```

### Beispiel
```
TMDL hat: "Kategorie"
MCP sagt: "Category"
→ visual.json MUSS "Kategorie" verwenden (nicht "Category"!)
```

**Speichern unter:** `{TMDL-Ordner}\TMDL-Feldliste.json`

---

## REGEL 2: version = "4.2" in definition.pbism

### ✅ RICHTIG
```json
{
  "$schema": "...definitionProperties/1.0.0/schema.json",
  "version": "4.2",
  "settings": {}
}
```

### ❌ FALSCH
```json
{ "version": "1.0.0" }              ← NIEMALS
{ "version": "1" }                  ← NIEMALS
{ "version": "4" }                  ← FALSCH (muss 4.2 sein)
```

**Folge:** PBI Desktop kann das Projekt nicht laden!

---

## REGEL 3: .pbip artifacts = NUR Report

### ✅ RICHTIG
```json
{
  "artifacts": [
    {
      "report": {
        "path": "Sons_Final_Result.Report"
      }
    }
  ]
}
```

### ❌ FALSCH
```json
{
  "artifacts": [
    {
      "report": {...},
      "semanticModel": {...}    ← NIEMALS!
    }
  ]
}
```

**Folge:** PBI Projekt fehlerhaft importiert!

---

## REGEL 4: visual.json SourceRef = "Entity"

### ✅ RICHTIG
```json
{
  "SourceRef": {
    "Entity": "DIM_Produkt"
  },
  "Property": "Kategorie"
}
```

### ❌ FALSCH
```json
{
  "SourceRef": {
    "Source": "DIM_Produkt"    ← NIEMALS "Source"!
  }
}
```

**Folge:** Visual zeigt Fehler in PBI Desktop!

---

## REGEL 5: CHECK 7 vor PBI Desktop öffnen

### ✅ RICHTIG
```
1. TMDL exportieren (Schritt 5A)
2. Phase 2 ALLE Dateien erstellen
3. CHECK 0-7 laufen
4. ALLE PASS?
   JA  → PBI Desktop öffnen ✅
   NEIN → Fehler beheben → zurück zu CHECK 0 
```

### ❌ FALSCH
```
1. Dateien halbfertig
2. Direkt in PBI Desktop öffnen
→ Runtime Errors überall!
```

**Folge:** Verschwendete Zeit bei Debugging!

---

## Übersicht: Was ist ERLAUBT / VERBOTEN

| Feature | Erlaubt | Verboten | Grund |
|---------|---------|----------|-------|
| version in definition.pbism | "4.2" | "1.0.0", "1" | Schema v4.2 nur! |
| settings in definition.pbism | {} (optional) | Nicht vorhanden | MUSS da sein |
| semanticModel in .pbip | ❌ | ✅ | Report-only PBIP! |
| SourceRef in visual.json | Entity | Source | Nur Entity Valid |
| query in visual.json | queryState | prototypeQuery, filters | Top-Level Query |
| Top-Level filters in visual.json | ❌ In queryState | ✅ Top-Level | In queryState! |
| Top-Level filterConfig | ❌ | ✅ | Nicht supported |
| Property-Wert | Aus TMDL | MCP erfunden | TMDL Truth! |

---

## Checklist: Bin ich Compliant?

```
[ ] Alle TMDL-Feldnamen exakt übernommen (nicht angepasst)?
[ ] definition.pbism version = "4.2" (nicht "1.0.0")?
[ ] .pbip artifacts nur "report" (kein "semanticModel")?
[ ] Alle visual.json SourceRef = "Entity" (nicht "Source")?
[ ] CHECK 7 durchgelaufen mit PASS?

Alle JA? → Du bist REGELKONFORM ✅
Ein NEIN? → STOPP – Regel prüfen → Korrigieren!
```

---

## Bei Unsicherheit: Fragen?

```
1. Schau hier: CRITICAL_RULES.md ← Du bist hier
2. Schau dort: 01_SCHEMAS_REFERENCE/ ← Schema Details
3. Check: 04_PHASE_3_VALIDIERUNG/check-7 ← Feldlisten
4. Suche GitHubIssues → ask for review
```

**Die Regeln sind nicht optional – sie sind die Foundation des Ganzen!**
