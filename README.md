# POWER BI PBIP Automation Framework

## 📋 Overview

Vollautomatisiertes System zur Erstellung und Verwaltung von Power BI PBIP Projekten (PBI Desktop March 2026+) mit Azure DevOps Integration.

**Letzte Aktualisierung:** März 2026  
**Kompatibilität:** PBIR Enhanced Format v4.2+

---

## 🎯 Use Case

Schnelle, wiederverwendbare Erstellung von Power BI PBIP Projekten mit:
- ✅ Vollständiger Docu­mentation (Phase 1-3)
- ✅ Automation Scripts (Python, PowerShell)
- ✅ Vorlagen (JSON, TMDL)
- ✅ CI/CD via Azure DevOps
- ✅ Validierung vor PBI Desktop öffnen

---

## 📁 Ordnerstruktur

```
POWER_BI_PBIP_AUTOMATION/
├── .github/
│   ├── workflows/
│   │   └── validate.yml           ← GitHub Actions CI/CD
│   └── pull_request_template.md
├── 00_KONFIGURATION/              ← Eingabe-Parameter
├── 01_SCHEMAS_REFERENCE/          ← Nachschlagewerk (Versionen, Regeln)
├── 02_PHASE_1_ANALYSE/            ← Anforderungen (MCP, 09_TEMPLATE, Reqs)
├── 03_PHASE_2_UMSETZUNG/          ← Technische Umsetzung (noch zu bauen)
├── 04_PHASE_3_VALIDIERUNG/        ← Checks 0-8 (noch zu bauen)
├── 05_AUTOMATION_SCRIPTS/         ← Python/PS Skripte (noch zu bauen)
├── 06_TEMPLATES/                  ← JSON/TMDL Vorlagen (noch zu bauen)
├── 07_TROUBLESHOOTING/            ← FAQ, Common Errors (noch zu bauen)
├── 08_DOCS/                       ← Overviews & Critical Rules (noch zu bauen)
├── .gitignore
├── SETUP-GITHUB.md                ← GitHub Setup Anleitung
└── README.md                      ← Dieses Dokument
```

---

## 🚀 Quick Start

### 1) Parameter setzen

Öffne: [00_KONFIGURATION/parameters.md](00_KONFIGURATION/parameters.md)

```
PROJEKTNAME   = "Sons_Final_Result"
ZIELORDNER    = "C:\Users\sphan\...\Desktop\Claude"
TEMPLATE_PFAD = "C:\Users\sphan\...\Desktop\Claude\09_TEMPLATE"
```

### 2) Phase 1 durcharbeiten

- [02_PHASE_1_ANALYSE/01-mcp-connection.md](02_PHASE_1_ANALYSE/01-mcp-connection.md)
- [02_PHASE_1_ANALYSE/02-template-analysis.md](02_PHASE_1_ANALYSE/02-template-analysis.md)
- [02_PHASE_1_ANALYSE/03-requirements.md](02_PHASE_1_ANALYSE/03-requirements.md)

### 3) Phase 2 programmieren

- [03_PHASE_2_UMSETZUNG/](03_PHASE_2_UMSETZUNG/) (wird fortgeführt)

### 4) Phase 3 validieren

- [04_PHASE_3_VALIDIERUNG/](04_PHASE_3_VALIDIERUNG/) (wird fortgeführt)

---

## 🔑 11 Kritische Regeln

⚠️ **NIEMALS brechen:**

1. **TMDL = Einzige Feldquelle** — Feldnamen nur aus `.tmdl` lesen
2. **version: "4.2" in definition.pbism** — nicht "1.0.0"
3. **.pbip artifacts = NUR Report** — kein "semanticModel"
4. **visual.json SourceRef = "Entity"** — nicht "Source"
5. **CHECK 7 VOR PBI Desktop öffnen** — Feldnamen validieren
6. **Entity für Measures = "Measure"** — nicht "_Measures"
7. **Property = exakter TMDL-Feldname** — keine MCP-Namen
8. **query INNERHALB visual{}** — nicht Top-Level
9. **queryState = Object {}** — nicht Array []
10. **Measures in TMDL-Datei eintragen** — MCP = nur In-Memory
11. **Template max 2 Seiten** — 3. Seite manuell kopieren

→ [08_DOCS/CRITICAL_RULES.md](08_DOCS/CRITICAL_RULES.md)

---

## 📚 Referenzen

| Thema | Link |
|-------|------|
| Versionsnummern | [00_KONFIGURATION/platform-versions.md](00_KONFIGURATION/platform-versions.md) |
| Semantic Model Schema | [01_SCHEMAS_REFERENCE/semantic-model.md](01_SCHEMAS_REFERENCE/semantic-model.md) |
| Report Struktur | [01_SCHEMAS_REFERENCE/report-structure.md](01_SCHEMAS_REFERENCE/report-structure.md) |
| Visual.json Regeln | [01_SCHEMAS_REFERENCE/visual-formats.md](01_SCHEMAS_REFERENCE/visual-formats.md) |
| MCP Integration | [02_PHASE_1_ANALYSE/01-mcp-connection.md](02_PHASE_1_ANALYSE/01-mcp-connection.md) |
| GitHub Setup | [SETUP-GITHUB.md](SETUP-GITHUB.md) |

---

## 🔄 Workflow

```
START
  ↓
Parameter setzen (00_KONFIGURATION)
  ↓
Phase 1: Anforderungen + Analyse (02_PHASE_1_ANALYSE)
  ↓
Phase 2: TMDL Export + Files erstellen (03_PHASE_2_UMSETZUNG)
  ↓
Phase 3: Validierung vor PBI öffnen (04_PHASE_3_VALIDIERUNG)
  ↓
Checks 0-8 ALLE PASS?
  ├─ JA → In PBI Desktop öffnen, Refresh + Publish
  └─ NEIN → Fehler fixen, zurück zu Phase 2
```

---

## 🛠️ Tools & Requirements

- **Power BI Desktop** March 2026 v2.152.882.0+
- **Python** 3.11+ (für Validierung)
- **PowerShell** 5.1+ (für Deployment)
- **GitHub** Account (private Repo für CI/CD)
- **Git** 2.40+ (local development)
- **VS Code** + Copilot (optional aber empfohlen)

---

## 📞 Support & FAQ

- Häufige Fehler → [07_TROUBLESHOOTING/common-errors.md](07_TROUBLESHOOTING/common-errors.md)
- Schema Mismatches → [07_TROUBLESHOOTING/schema-mismatch.md](07_TROUBLESHOOTING/schema-mismatch.md)
- TMDL Feldnamen → [07_TROUBLESHOOTING/tmdl-field-mapping.md](07_TROUBLESHOOTING/tmdl-field-mapping.md)
- MCP Referenz → [07_TROUBLESHOOTING/mcp-commands-reference.md](07_TROUBLESHOOTING/mcp-commands-reference.md)

---

## 📄 Lizenz & Konventionen

- Framework ist privat (`.gitignore` für Secrets)
- Alle Pfade: Windows Format (`C:\...`)
- JSON immer mit 2-Spaces Indentation
- TMDL Feldnamen: PascalCase (z.B. `Jahr`, `MonatJahrKurz`)

---

**Status:** 🟡 In Progress – Phase 2 & 3 noch zu bauen
