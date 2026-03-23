# WORKFLOW – Durchführung Step-by-Step

**Für Anfänger:** Schritt für Schritt durchgehen (ca. 3-4 Stunden)  
**Für Experten:** Können Schritte parallelisieren

---

## Phase 1: Analyse & Planung (1-2 Stunden)

```
START
  ↓
[ ] 1.1 Parameter ausfüllen
      → parameters.md
  ↓
[ ] 1.2 MCP Verbindung
      → 02_PHASE_1_ANALYSE/01-mcp-connection.md
      - Tabellen inventarisieren
      - Measures dokumentieren
      - Relationships prüfen
  ↓
[ ] 1.3 Template analysieren
      → 02_PHASE_1_ANALYSE/02-template-analysis.md
      - Seiten-Struktur
      - Visual-Typen + Positionen
      - Farbpalette
  ↓
[ ] 1.4 Anforderungen dokumentieren
      → 02_PHASE_1_ANALYSE/03-requirements.md
      - Use Cases
      - Measures mit Formeln
      - Mapping auf Seiten
  ↓
Phase 1 READY ✅
```

---

## Phase 2: Technische Umsetzung (1-2 Stunden)

```
START
  ↓
[ ] 2.1 Measures via MCP erstellen
      → 03_PHASE_2_UMSETZUNG/01-measures-creation.md
      - Basis Measures
      - Zeitintelligenz Measures
  ↓
[ ] 2.2 TMDL exportieren + Feldlisten extrahieren
      → 03_PHASE_2_UMSETZUNG/02-tmdl-export.md
      # ⚠️ KRITISCH!
      - MCP ExportToTmdlFolder
      - extract-tmdl-fields.py laufen
      - TMDL-Feldliste.json überprüfen
  ↓
[ ] 2.3 PBIP Dateistruktur erstellen
      → 03_PHASE_2_UMSETZUNG/03-platform-creation.md
      - .platform (2x)
      - definition.pbism + definition.pbir
      - .pbip ROOT
      - Report-Struktur (pages.json, etc.)
  ↓
[ ] 2.4 Report Content (page.json + visual.json)
      → 03_PHASE_2_UMSETZUNG/04-report-files.md
      # ⚠️ Visual.json: TMDL-Feldnamen aus Schritt 2.2 verwenden!
      - page.json pro Seite
      - visual.json pro Visual (SourceRef.Entity + Property)
  ↓
Phase 2 READY ✅
```

---

## Phase 3: Validierung (30-45 Min)

```
START
  ↓
[ ] 3.0 TMDL-Feldliste prüfen
      → 04_PHASE_3_VALIDIERUNG/check-0-tmdl-validation.md
      # GATE: Falls FEHLT → Zurück zu Phase 2.2!
  ↓
[ ] 3.1 Semantic Model Struktur
      → 04_PHASE_3_VALIDIERUNG/check-1-semantic-structure.md
  ↓
[ ] 3.2 PBIP ROOT Struktur
      → 04_PHASE_3_VALIDIERUNG/check-2-pbip-root.md
  ↓
[ ] 3.3 JSON Syntax
      → 04_PHASE_3_VALIDIERUNG/check-3-json-syntax.py
      Command: python3 validate-json-syntax.py --pbip-path "..."
  ↓
[ ] 3.4 Schema-Versionen
      → 04_PHASE_3_VALIDIERUNG/check-4-schema-versions.md
      - version 4.2 in definition.pbism?
      - version 2.0.0 in version.json?
  ↓
[ ] 3.5 Verbotene Felder
      → 04_PHASE_3_VALIDIERUNG/check-5-forbidden-fields.md
      - Kein "filterConfig"?
      - Kein "Source" (nur "Entity")?
  ↓
[ ] 3.6 Datei-Vollständigkeit
      → 04_PHASE_3_VALIDIERUNG/check-6-file-completeness.md
      - pages.json vorhanden?
      - Alle Visual-Ordner haben visual.json?
  ↓
[ ] 3.7 TMDL Feldvalidierung (KRITISCHSTE STEP!)
      → 04_PHASE_3_VALIDIERUNG/check-7-tmdl-fields.py
      Command: python3 validate-visuals.py --pbip-path "..." --tmdl-list "..."
      # Falls FAIL: Zurück zu Phase 2.4, visual.json Feldnamen korrigieren!
  ↓
[ ] 3.8 Daten-Integrität (optional via MCP)
      → 04_PHASE_3_VALIDIERUNG/check-8-data-integrity.md
      - Measure-Referenzen OK?
      - Relationships OK?
  ↓
Alle Checks PASS? ✅
  YES → Phase 3 FREIGABE
  NO  → Fehler beheben → CHECK 0 wiederholen
  ↓
Phase 3 READY ✅
```

---

## Phase 4: Go-Live (15 Min)

```
START
  ↓
[ ] 4.1 PBI Desktop öffnen
      File → Open → {PROJEKTNAME}.pbip
  ↓
[ ] 4.2 Refresh durchführen
      Ctrl+R
      # Alle Visuals sollten ohne Fehler laden!
  ↓
[ ] 4.3 Visual Validation
      - Alle Visuals zeigen Daten?
      - Keine roten Fehler?
      - Filter funktionieren?
  ↓
[ ] 4.4 Publish zu Fabric
      File → Publish
      - Workspace wählen
      - Name bestätigen
      - Publish
  ↓
✅ FERTIG – Projekt läuft in Fabric!
```

---

## Häufige Fehler & Schnelle Fixes

| Problem | Fehler Meldung | Lösung |
|---------|----------------|--------|
| **Schritt 2.2 übersprungen** | "TMDL-Feldliste.json nicht vorhanden" | CHECK 0 schlägt fehl → Zurück zu 2.2 |
| **Falsche Feldnamen** | "DIM_Produkt.Category not in TMDL" | TMDL-Feldliste prüfen, visual.json korrigieren (z.B. "Kategorie") |
| **version 1.0.0** | "definition.pbism schema mismatch" | CHECK 4 prüft → version "4.2" setzen |
| **"Source" statt "Entity"** | "SourceRef invalid" | CHECK 5 prüft → zu "Entity" ändern |
| **PBI Desktop error beim Öffnen** | "Projekt konnte nicht geladen werden" | CHECK 7 vor öffnen durchführen! |

---

## Git Workflow

```
# Nach Phase 1
git add .
git commit -m "Phase 1: Requirements + Template Analysis"

# Nach Phase 2
git add .
git commit -m "Phase 2: TMDL Export + PBIP Structure"

# Nach Phase 3
git add .
git commit -m "Phase 3: All Validation Checks PASS ✅"

# Go-Live
git tag -a v1.0.0 -m "Production Release"
git push origin --all --tags
```

---

## Zeitbudget

| Phase | Dauer | Kritisch | Notes |
|-------|-------|----------|-------|
| Phase 1 | 1-2h | Nein | Parallels OK |
| Phase 2 | 1-2h | **JA** | Sequential! |
| Phase 3 | 30min | **JA** | CHECK 7 is Gate! |
| Phase 4 | 15min | Nein | Go-Live |
| **TOTAL** | **3-4h** | - | Erste Iteration |

**Nächste Iterationen:** 30-60 Min (Template nutzen)

---

## Troubleshooting-Checkliste

Falls irgendwo FAIL:

1. Überprüfe CHECKs 0-7 in dieser Reihenfolge
2. CHECK 7 ist das Wichtigste (TMDL Feldnamen)
3. Wenn mehrdeutig → `07_TROUBLESHOOTING/common-errors.md`
4. Wenn noch unklar → Review `08_DOCS/CRITICAL_RULES.md`
5. Wenn immer noch nicht → GitHub Issue + Description + Error Log

**→ Niemals die CRITICAL_RULES brechen!**
