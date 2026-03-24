# EINGABE-PARAMETER (Projekt-Setup)

## Pflicht-Parameter

```
PROJEKTNAME  = "Lucanet_Finance"
ZIELORDNER   = "C:\Users\phant\OneDrive\Desktop\Power BI"
SEITEN       = "Bilanz, GuV, Cashflow"   ← komma-getrennt, Reihenfolge = $ReportPage1, $ReportPage2, ...
```

## Projekt erstellen

```powershell
.\create-project.ps1 -Projektname {PROJEKTNAME} `
                     -Zielordner  {ZIELORDNER} `
                     -Seiten      {SEITEN}
```

> `TEMPLATE_PFAD` wird automatisch ermittelt: `<Repo-Verzeichnis>\09_TEMPLATE`
> Das Projekt wird in `ZIELORDNER\PROJEKTNAME` erstellt — nicht im Repo.

## CRITICAL: TMDL = Einzige Quelle der Wahrheit

> **Feldnamen für visual.json AUSSCHLIESSLICH aus `PROJEKTNAME.SemanticModel\definition\tables\*.tmdl` lesen!**
>
> ❌ NIEMALS MCP-Spaltennamen direkt in visual.json übernehmen!
> ✅ Nur TMDL-Feldnamen verwenden (nach Export in Phase 2 Schritt 2)

---

**Status vor Start: [ ] Alle Parameter gesetzt**
