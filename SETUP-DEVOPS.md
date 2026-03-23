# Azure DevOps Setup für Power BI PBIP Automation

## 1️⃣ Azure DevOps Repository erstellen

```powershell
# 1. Neues Repo in Azure DevOps anlegen
# https://dev.azure.com/{Organization}/{Project}/_git

# 2. Local Repository initialisieren
cd C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION
git init
git config user.email "your@email.com"
git config user.name "Your Name"

# 3. Remote hinzufügen (URL von DevOps kopieren)
git remote add origin https://dev.azure.com/{org}/{proj}/_git/POWER_BI_PBIP_AUTOMATION

# 4. Initial commit
git add .
git commit -m "Initial: PBIP Automation Framework"

# 5. Auf DevOps pushen
git push -u origin main
```

---

## 2️⃣ Branch-Strategie

```
main/
  └─ (nur validierte, produktive Templates)

develop/
  └─ (Entwicklungs-Zweig, wird tested)

feature/*
  └─ (z.B. feature/add-time-intelligence)

hotfix/*
  └─ (z.B. hotfix/schema-version-fix)
```

---

## 3️⃣ Azure Pipeline Setup (CI/CD)

### Datei: `azure-pipelines.yml` (im Root)

```yaml
trigger:
  branches:
    include:
    - main
    - develop
    - feature/*

pr:
  branches:
    include:
    - main
    - develop

pool:
  vmImage: 'windows-latest'

variables:
  pythonVersion: '3.11'
  targetDir: '$(Build.SourcesDirectory)/POWER_BI_PBIP_AUTOMATION'

stages:
- stage: Validate
  displayName: 'Validation Checks'
  jobs:
  - job: CheckSchema
    displayName: 'Check Schema Versions'
    steps:
    - task: UsePythonVersion@0
      inputs:
        versionSpec: '$(pythonVersion)'
    - script: |
        pip install jsonschema
        python $(targetDir)/05_AUTOMATION_SCRIPTS/validate-json-syntax.py
      displayName: 'JSON Syntax Check'
    
    - script: |
        python $(targetDir)/05_AUTOMATION_SCRIPTS/validate-visuals.py
      displayName: 'Visual Field Validation'
      continueOnError: false

  - job: CheckForbiddenPatterns
    displayName: 'Check Forbidden Patterns'
    steps:
    - script: |
        # Check für "version": "1.0.0" in definition.pbism
        findstr /R /C:"\"version\": \"1" $(targetDir) && exit 1 || exit 0
      displayName: 'No v1.0.0 in definition.pbism'

    - script: |
        # Check für "Source" statt "Entity"
        findstr /C:"\"Source\":" $(targetDir)\**\visual.json && exit 1 || exit 0
      displayName: 'No Source (use Entity)'

- stage: Security
  displayName: 'Security Scan'
  dependsOn: Validate
  condition: succeeded()
  jobs:
  - job: CredentialScan
    displayName: 'Scan for Credentials'
    steps:
    - task: CredScan@3
      inputs:
        toolMajorVersion: 'V2'
        outputFormat: 'sarif'
        suppressionsFile: '$(Build.SourcesDirectory)/.credscan-suppression.json'

- stage: Documentation
  displayName: 'Documentation Check'
  dependsOn: Validate
  condition: succeeded()
  jobs:
  - job: CheckReadme
    displayName: 'Verify README exists'
    steps:
    - script: |
        if not exist "$(targetDir)/README.md" (
          echo "ERROR: README.md missing"
          exit 1
        )
      displayName: 'README Check'
```

---

## 4️⃣ Pull Request Template

Datei: `docs/pull_request_template.md`

```markdown
## Beschreibung
[Was wird geändert?]

## Typ der Änderung
- [ ] Bug Fix
- [ ] Neue Feature
- [ ] Schema Aktualisierung
- [ ] Template Verbesserung
- [ ] Dokumentation

## Checkliste
- [ ] Code folgt den Style Guidelines?
- [ ] Keine PBIP Geheimnisse committed?
- [ ] TMDL Feldnamen korrekt?
- [ ] Alle JSON Dateien valid?
- [ ] Visual.json SourceRef = "Entity" (nicht "Source")?
- [ ] version.json auf "4.2" checked?

## Related Issues
[Referenzen zu Work Items]

## Testing
[Wie wurde getestet?]
```

---

## 5️⃣ Protect main Branch

**In Azure DevOps:**

```
Project Settings → Repositories → {Repo Name}
  → Policies → main Branch
  
✅ Require a minimum number of reviewers: 1
✅ Allow requestors to approve: OFF
✅ Require all comments resolved: ON
✅ Require a successful build: ON
```

---

## 6️⃣ Work Items verlinken

```
Git Commit Message Beispiel:

git commit -m "Fix visual.json Entity ref #123"
                               ↑
                           Work Item ID

→ Automatisch verlinkt in DevOps Backlog
```

---

## 7️⃣ GitOps für Fabric Deployment

```yaml
# (Optional) Datei: deploy-to-fabric.yml

trigger:
  branches:
    include:
    - main

stages:
- stage: DeployToFabric
  displayName: 'Deploy TMDL to Fabric'
  jobs:
  - job: DeploySemanticModel
    steps:
    - task: PowerShellScript@2
      inputs:
        scriptPath: '$(targetDir)/05_AUTOMATION_SCRIPTS/deploy-tmdl.ps1'
        arguments: |
          -Source "$(Build.SourcesDirectory)/POWER_BI_PBIP_AUTOMATION/06_TEMPLATES"
          -WorkspaceName "Production"
          -ModelName "SemanticModel"
```

---

## Checkliste Git Setup

- [ ] Azure DevOps Project erstellt?
- [ ] Local repo initialized + remote added?
- [ ] `.gitignore` committed?
- [ ] `azure-pipelines.yml` im Root?
- [ ] Branch Policies für main?
- [ ] Pull Request Template erstellt?
- [ ] Credentials in `.gitignore` excluded?
- [ ] Erstes Deployment ohne Fehler?

**→ Git ist ready für Team-Collaboration!**
