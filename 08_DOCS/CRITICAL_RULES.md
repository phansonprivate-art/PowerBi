# ⚠️ 11 KRITISCHE REGELN – NIEMALS BRECHEN!

> **AKTUALISIERT nach Phase 2/3 Learnings (2026-03-30)**

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

## REGEL 6: Measure-Tabelle heißt "Measure" (nicht "_Measures")

### ✅ RICHTIG
```json
{
  "SourceRef": { "Entity": "Measure" },
  "Property": "Bilanz Ist"
}
```
```
tableName: "Measure"   ← in MCP measure_operations
```

### ❌ FALSCH
```json
{ "SourceRef": { "Entity": "_Measures" } }   ← Existiert nicht!
{ "SourceRef": { "Entity": "Measures"  } }   ← Existiert nicht!
```

**Folge:** Visual rendert leer — keine Fehlermeldung in PBI Desktop!

**Prüfen:** `tables\Measure.tmdl` im TMDL-Export ansehen.

---

## REGEL 7: PowerShell 5 – Join-Path nur 2 Argumente

### ✅ RICHTIG
```powershell
[IO.Path]::Combine($BASE, $page, "visuals", $vid, "visual.json")
```

### ❌ FALSCH
```powershell
Join-Path $BASE $page "visuals" $vid "visual.json"
# Fehler: "Join-Path : Der Parameter "AdditionalChildPath" kann nicht..."
```

**Und:** `$_.DirectoryName` ist `$null` für `DirectoryInfo`-Objekte.
Immer `$_.Parent.FullName` für Ordner verwenden.

---

## REGEL 8: `query` MUSS innerhalb von `visual` sein (NICHT Top-Level!)

### ✅ RICHTIG
```json
{
  "visual": {
    "visualType": "cardVisual",
    "query": {
      "queryState": {...}
    }
  }
}
```

### ❌ FALSCH
```json
{
  "visual": {...},
  "query": {...}    ← Schema erlaubt "query" NICHT als Top-Level Property!
}
```

**Folge:** `Property 'query' has not been defined and the schema does not allow additional properties.`

---

## REGEL 9: `queryState` ist ein Object (NICHT Array!) mit Rollen als Keys

### ✅ RICHTIG
```json
"queryState": {
  "Values": { "projections": [...] },
  "Category": { "projections": [...] }
}
```

### ❌ FALSCH
```json
"queryState": [
  { "Command": "SetBindingRef", "Binding": {...} }
]
```

**Folge:** `Invalid type. Expected Object but got Array. Path 'visual.query.queryState'`

---

## REGEL 10: Measures MÜSSEN in TMDL-Dateien stehen (nicht nur In-Memory)

### ✅ RICHTIG
```
1. Measure via MCP erstellen (In-Memory SSAS)
2. Measure in Measure.tmdl TMDL-Datei eintragen
3. PBI Desktop lädt beides konsistent
```

### ❌ FALSCH
```
1. Measure nur via MCP erstellen
2. TMDL-Datei nicht aktualisiert
→ PBI Desktop: "Felder, die korrigiert werden müssen: (Measure) Bilanz Ist"
```

**Folge:** Visuals zeigen "Mit einem oder mehreren Feldern gibt es Probleme"

---

## REGEL 11: Template hat nur 2 Seiten – 3. Seite manuell erstellen

### ✅ RICHTIG
```
1. create-project.ps1 erstellt 2 Seiten aus Template
2. Für Seite 3+: Ordner manuell kopieren
3. page.json anpassen (name, displayName)
4. pages.json aktualisieren (pageOrder Array)
```

### ❌ FALSCH
```
1. Erwarten dass create-project.ps1 3+ Seiten erstellt
→ Nur $ReportPage1 und $ReportPage2 werden ersetzt!
```

---

## Übersicht: Was ist ERLAUBT / VERBOTEN

| Feature | Erlaubt | Verboten | Grund |
|---------|---------|----------|-------|
| version in definition.pbism | "4.2" | "1.0.0", "1" | Schema v4.2 nur! |
| settings in definition.pbism | {} (optional) | Nicht vorhanden | MUSS da sein |
| semanticModel in .pbip | ❌ | ✅ | Report-only PBIP! |
| SourceRef in visual.json | Entity | Source | Nur Entity Valid |
| query Position | Innerhalb visual{} | Top-Level | Schema 2.7.0 verbietet es! |
| queryState Typ | Object {} mit Rollen | Array [] mit Commands | Schema erwartet Object! |
| queryState Format | {Values:{projections:[]}} | [{Command:"SetBindingRef"}] | Altes Format ungültig! |
| Measures in TMDL | ✅ Pflicht | ❌ Nur In-Memory | PBIP braucht TMDL! |
| Template Seiten | Max 2 automatisch | 3+ erwartet | Manuell kopieren! |
| Property-Wert | Aus TMDL | MCP erfunden | TMDL Truth! |
| Measure-Tabelle in visual.json | "Measure" | "_Measures", "Measures" | Exakter TMDL-Name! |
| Join-Path in PS5 | [IO.Path]::Combine() | Join-Path a b c d | PS5 max. 2 Argumente |

---

## Checklist: Bin ich Compliant?

```
[ ] Alle TMDL-Feldnamen exakt übernommen (nicht angepasst)?
[ ] definition.pbism version = "4.2" (nicht "1.0.0")?
[ ] .pbip artifacts nur "report" (kein "semanticModel")?
[ ] Alle visual.json SourceRef = "Entity" (nicht "Source")?
[ ] Measure-Tabelle = "Measure" (nicht "_Measures")?
[ ] CHECK 7 durchgelaufen mit PASS?
[ ] query innerhalb visual{} (nicht Top-Level)?
[ ] queryState als Object {} (nicht Array [])?
[ ] Measures in TMDL-Datei eingetragen (nicht nur MCP)?
[ ] 3+ Seiten? Manuell kopiert und pages.json aktualisiert?

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
