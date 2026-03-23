# GitHub Setup für Power BI PBIP Automation

## 1️⃣ GitHub Repository erstellen

```powershell
# 1. Neues Repo auf github.com erstellen
# https://github.com/new
#   - Name: POWER_BI_PBIP_AUTOMATION
#   - Private? Ja
#   - Initialize mit: NEIN (wir committen lokal)

# 2. Local Repository initialisieren
cd C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION
git init
git config user.email "your@github.com"
git config user.name "Your Name"

# 3. Remote hinzufügen (URL von GitHub kopieren)
git remote add origin https://github.com/YOUR_USERNAME/POWER_BI_PBIP_AUTOMATION.git

# 4. Initial commit
git add .
git commit -m "feat: Initial PBIP Automation Framework"

# 5. Branch auf main umbenennen (falls noch master)
git branch -M main

# 6. Auf GitHub pushen
git push -u origin main
```

---

## 2️⃣ GitHub Actions Workflow

**Datei:** `.github/workflows/validate.yml` existiert bereits ✅

Dieser Workflow läuft automatisch bei jedem Push und Pull Request:

```
✅ CHECK 3: JSON Syntax
✅ CHECK 4: Schema Versions
✅ CHECK 5: Forbidden Patterns
✅ CHECK 6: File Completeness
✅ CHECK 7: TMDL Field Validation
```

---

## 3️⃣ Branch-Strategie (empfohlen)

```
main/
  └─ (nur validierte, produktive Templates)

develop/
  └─ (Entwicklungs-Zweig, wird tested)

feature/*
  └─ (z.B. feature/add-time-intelligence)

hotfix/*
  └─ (z.B. hotfix/schema-version-fix)

template/*
  └─ (neue Template-Varianten)
```

---

## 4️⃣ Branch Protection Rules

**In GitHub:**

```
Settings → Branches → Add rule
Branch name pattern: main

✅ Require a pull request before merging
✅ Require approvals: 1
✅ Require status checks to pass before merging
   └─ Select: validate
✅ Require branches to be up to date before merging
```

---

## 5️⃣ Pull Request Template

**Datei:** `.github/pull_request_template.md`

Erstelle diese Datei im Root:

```markdown
## Beschreibung
[Was wird geändert?]

## Typ der Änderung
- [ ] Bug Fix
- [ ] Neue Feature
- [ ] Schema Update
- [ ] Template Verbesserung
- [ ] Dokumentation

## Checkliste
- [ ] Code folgt den Style Guidelines?
- [ ] Keine PBIP Geheimnisse committed?
- [ ] TMDL Feldnamen korrekt?
- [ ] Alle JSON Dateien valid?
- [ ] Visual.json SourceRef = "Entity" (nicht "Source")?
- [ ] version in definition.pbism auf "4.2" geprüft?

## Verwandte Issues
Closes #123

## Testing
[Wie wurde getestet?]
```

---

## 6️⃣ Secrets & Credentials (in GitHub)

Persönliche Daten NICHT in den Code:

```
Settings → Secrets and variables → Actions
  Neue Secret: PBI_WORKSPACE_ID
  Neue Secret: PBI_DATASET_TOKEN
```

**In Skripten nutzen:**
```powershell
$workspace = $env:PBI_WORKSPACE_ID
$token = $env:PBI_DATASET_TOKEN
```

---

## 7️⃣ Workflows lokal testen

**Mit GitHub CLI:**

```powershell
# Installieren: https://cli.github.com/

# Einen Workflow lokal simulieren
gh workflow run validate.yml --ref main

# Status checken
gh workflow view validate
```

---

## 8️⃣ Commits & History

**Gute Commit Messages:**

```bash
# Feature
git commit -m "feat: Add TMDL field validation script"

# Bug Fix
git commit -m "fix: Correct schema version in definition.pbism"

# Docs
git commit -m "docs: Update README with GitHub setup"

# Chore
git commit -m "chore: Update .gitignore for artifacts"
```

→ Später: ```gh log --oneline``` zeigt schöne History

---

## 9️⃣ Workflows im Projekt nutzen

**Beispiel: Deployment Workflow (optional später)**

```yaml
name: Deploy to Fabric

on:
  push:
    branches: [main]
    paths:
      - 'POWER_BI_PBIP_AUTOMATION/06_TEMPLATES/**'

jobs:
  deploy:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy TMDL
        shell: pwsh
        run: |
          # PowerShell Script für Fabric Deployment
          .\POWER_BI_PBIP_AUTOMATION\05_AUTOMATION_SCRIPTS\deploy-tmdl.ps1
        env:
          PBI_TOKEN: ${{ secrets.PBI_DATASET_TOKEN }}
```

---

## ✅ Checkliste GitHub Setup

- [ ] GitHub Account existiert?
- [ ] Neues privates Repo erstellt?
- [ ] Local repo mit `git init` + remote verbunden?
- [ ] `.gitignore` committed?
- [ ] `.github/workflows/validate.yml` vorhanden?
- [ ] Erstes `git push -u origin main` erfolgreich?
- [ ] Branch Protection Rules für main gesetzt?
- [ ] Pull Request Template erstellt?
- [ ] Secrets (falls nötig) in GitHub Settings hinterlegt?
- [ ] GitHub Actions Page zeigt grünen Haken ✅?

**→ GitHub ist ready für Collaboration!**
