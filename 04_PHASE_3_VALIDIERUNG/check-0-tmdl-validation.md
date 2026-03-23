# PHASE 3: CHECK 0 – TMDL-Feldliste Validierung

## GATE: Ist TMDL-Feldliste vorhanden?

**Vor jedem weiteren Check: STOPP und prüfen**

```
[ ] {TMDL-Ordner}\tables\*.tmdl existieren?
[ ] TMDL-Feldliste.json vorhanden (aus Schritt 5A)?
[ ] TMDL-Feldliste.json ist valid JSON?
```

---

## Falls NEIN:

```
❌ STOPP – Gehe zurück zu Phase 2 SCHRITT 5A

1. TMDL erneut exportieren via MCP
2. Python Script zur Feldlisten-Extraktion laufen lassen
3. TMDL-Feldliste.json überprüfen

Erst dann weitermachen mit CHECK 1!
```

---

## Falls JA:

```
✅ WEITER zu CHECK 1
```
