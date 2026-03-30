# PowerBi PBIP Automation Framework

## Übersicht
Dieses Repo ist ein Automation-Framework zum Erstellen von Power BI PBIP-Projekten.
**Projekte werden NICHT im Repo erstellt** – sie landen im `ZIELORDNER` des Nutzers.

## Wichtige Regeln
- Template liegt immer in `09_TEMPLATE/` (nie nach Pfad fragen – automatisch erkennen)
- Projekt-Output geht in `ZIELORDNER\PROJEKTNAME` (nicht ins Repo)
- Platzhalter `$ReportPage1`, `$ReportPage2` werden beim Erstellen dynamisch ersetzt
- TMDL = einzige Quelle der Wahrheit für Feldnamen in visual.json (nie MCP-Namen direkt übernehmen)

## Ordnerstruktur
```
00_KONFIGURATION/     ← parameters.md (Pflicht-Parameter: PROJEKTNAME, ZIELORDNER, SEITEN)
01_SCHEMAS_REFERENCE/ ← Technische Schema-Referenzen
02_PHASE_1_ANALYSE/   ← Phase 1: Analyse & Planung
03_PHASE_2_UMSETZUNG/ ← Phase 2: Implementierung
04_PHASE_3_VALIDIERUNG/ ← Phase 3: Validierung (8 Checks)
05_AUTOMATION_SCRIPTS/  ← Python: extract-tmdl-fields.py, validate-visuals.py, validate-json-syntax.py
06_TMDL_EXPORT/       ← Arbeitsbereich für TMDL-Exports
07_TROUBLESHOOTING/   ← Häufige Fehler & Lösungen
08_DOCS/              ← WORKFLOW.md, CRITICAL_RULES.md
09_TEMPLATE/          ← Referenz-Template (read-only, wird kopiert)
create-project.ps1    ← Hauptskript: kopiert Template → ZIELORDNER, ersetzt Platzhalter
```

## Projekt erstellen
Parameter in `00_KONFIGURATION/parameters.md` setzen, dann:
```powershell
.\create-project.ps1 -Projektname {PROJEKTNAME} -Zielordner {ZIELORDNER} -Seiten {SEITEN}
```

## Template-Platzhalter
| Platzhalter | Ersetzt durch | Vorkommen |
|---|---|---|
| `$ReportPage1` | Erster Seitentitel aus SEITEN | page.json + textbox visual.json |
| `$ReportPage2` | Zweiter Seitentitel aus SEITEN | page.json + textbox visual.json |

## 5 kritische Regeln (niemals brechen)
1. Feldnamen aus TMDL lesen – nicht aus MCP
2. `definition.pbism` version = `"4.2"`
3. `.pbip` artifacts = nur Report (kein semanticModel)
4. visual.json SourceRef = `"Entity"` (nicht `"Source"`)
5. CHECK 7 (TMDL-Feldvalidierung) vor jedem PBI Desktop-Open
