# EINGABE-PARAMETER (Projekt-Setup)

Fülle diese Parameter **VOR** dem Start aus. Alle nachfolgenden Pfade leiten sich davon ab.

## Pflicht-Parameter

```
PROJEKTNAME    = "Lucanet_Finance"
ZIELORDNER     = "C:\Users\phant\OneDrive\Desktop\Power BI\"
TEMPLATE_PFAD  = "C:\Users\phant\OneDrive\Desktop\Power BI\Template"
```

## Automatisch abgeleitete Pfade

```
PBIP-Projektordner   = {ZIELORDNER}\{PROJEKTNAME}
                     = C:\Users\sphan\...\Desktop\Claude\Sons_Final_Result

Report-Ordner        = {ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.Report
                     = C:\Users\sphan\...\Desktop\Claude\Sons_Final_Result\Sons_Final_Result.Report

SemanticModel-Ordner = {ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel
                     = C:\Users\sphan\...\Desktop\Claude\Sons_Final_Result\Sons_Final_Result.SemanticModel

TMDL-Ordner          = {ZIELORDNER}\{PROJEKTNAME}\{PROJEKTNAME}.SemanticModel\definition
                     = C:\Users\sphan\...\Desktop\Claude\Sons_Final_Result\Sons_Final_Result.SemanticModel\definition
```

## Template-Struktur analysieren

```
{TEMPLATE_PFAD}
├── *.SemanticModel/
│   ├── definition/
│   │   ├── database.tmdl
│   │   ├── model.tmdl
│   │   ├── tables/
│   │   │   ├── DIM_*.tmdl
│   │   │   └── _Measures.tmdl
│   │   └── .platform
│   └── definition.pbism
│
└── *.Report/
    ├── definition/
    │   ├── pages.json
    │   ├── report.json
    │   ├── version.json
    │   ├── .relationships
    │   ├── pages/            ← Pro Seite ein Ordner
    │   │   ├── page.json
    │   │   └── visuals/
    │   │       ├── visual1/
    │   │       │   └── visual.json
    │   │       └── visual2/
    │   │           └── visual.json
    │   └── .platform
    └── definition.pbir
```

## CRITICAL: TMDL = Einzige Quelle der Wahrheit

> **Feldnamen für visual.json AUSSCHLIESSLICH aus {TMDL-Ordner}\tables\*.tmdl lesen!**
> 
> MCP liefert Feldnamen des aktuellen Modells, aber das ZIELMODELL kann ANDERE Feldnamen haben.
>
> ❌ NIEMALS MCP-Spaltennamen direkt in visual.json übernehmen!
> ✅ Nur TMDL-Feldnamen verwenden (nach Export in Schritt 5A)

---

**Status vor Start: [ ] Alle Parameter gesetzt**
