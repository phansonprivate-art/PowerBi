# EINGABE-PARAMETER (Projekt-Setup)

Fülle diese Parameter **VOR** dem Start aus. Alle nachfolgenden Pfade leiten sich davon ab.

## Pflicht-Parameter

```
PROJEKTNAME    = "Lucanet_Finance"
ZIELORDNER     = "C:\Users\phant\OneDrive\Desktop\Power BI"
TEMPLATE_PFAD  = "C:\Users\phant\.claude\POWER_BI_PBIP_AUTOMATION\06_TEMPLATES"
```

> **TEMPLATE_PFAD** zeigt immer auf `06_TEMPLATES` im Repository.
> **ZIELORDNER** ist das **Final Destination** — dort wird das fertige PBIP-Projekt erstellt (z.B. Desktop, OneDrive, Netzlaufwerk).
> Das Projekt wird **NICHT** mehr unter `PROJECTS/` im Repo erstellt, sondern direkt im ZIELORDNER.

## Automatisch abgeleitete Pfade

```
PBIP-Projektordner   = {ZIELORDNER}\{PROJEKTNAME}
                     → C:\Users\phant\OneDrive\Desktop\Power BI\Lucanet_Finance

Report-Ordner        = {ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report
                     → ...\Lucanet_Finance\Lucanet_Finance.Report

SemanticModel-Ordner = {ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel
                     → ...\Lucanet_Finance\Lucanet_Finance.SemanticModel

TMDL-Ordner          = {ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel\definition
                     → ...\Lucanet_Finance\Lucanet_Finance.SemanticModel\definition
```

## Template-Struktur (06_TEMPLATES)

```
{TEMPLATE_PFAD}
├── Template.pbip                          ← .pbip ROOT
├── Template.pbix                          ← Original PBIX (Referenz)
├── Template.SemanticModel/
│   ├── .pbi/
│   ├── .platform
│   ├── definition.pbism
│   └── definition/
│       ├── database.tmdl
│       ├── model.tmdl
│       ├── cultures/de-DE.tmdl
│       └── tables/Tabelle.tmdl
│
└── Template.Report/
    ├── .pbi/localSettings.json
    ├── .platform
    ├── definition.pbir
    ├── StaticResources/SharedResources/BaseThemes/CY26SU02.json
    └── definition/
        ├── pages.json
        ├── report.json
        ├── version.json
        └── pages/
            ├── {pageId}/
            │   ├── page.json
            │   └── visuals/
            │       └── {visualId}/
            │           └── visual.json
            └── ...
```

## CRITICAL: TMDL = Einzige Quelle der Wahrheit

> **Feldnamen für visual.json AUSSCHLIESSLICH aus {TMDL-Ordner}\tables\*.tmdl lesen!**
>
> MCP liefert Feldnamen des aktuellen Modells, aber das ZIELMODELL kann ANDERE Feldnamen haben.
>
> NIEMALS MCP-Spaltennamen direkt in visual.json übernehmen!
> Nur TMDL-Feldnamen verwenden (nach Export in Schritt 5A)

---

**Status vor Start: [ ] Alle Parameter gesetzt**
