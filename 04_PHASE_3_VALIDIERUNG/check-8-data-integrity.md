# PHASE 3: CHECK 8 – Daten-Integrität (via MCP)

## Optional: Validierung über MCP

**Falls gewünscht, um Runtime-Fehler zu checken:**

### Measure-Referenzen validieren

**via MCP → measure_operations**

```
Operation: List
→ Output: Alle Measures
```

**Vergleiche mit visual.json:**
```
Alle "Property": "Measure_XYZ" in visual.json existieren in Measure List?
```

- [ ] Jede Measure-Referenz existiert?

---

### Relationships validieren

**via MCP → relationship_operations**

```
Operation: List
→ Output: Alle Relationships
```

**Prüfen:**
- [ ] Alle Relationships sind Active (falls für Visuals nötig)?
- [ ] Kardinalität korrekt (1:1, 1:*, etc.)?

---

## Status

- [ ] Measure-Referenzen valide?
- [ ] Relationship-Struktur OK?

**→ Alle ✅?**
- **JA** → ALLE CHECKS PASSED! 🎉
- **NEIN** → Fehler beheben, CHECK 8 wiederholen

---

## ✅ FREIGABE ERTEILT

```
Wenn ALLE Checks 0-8 = PASS:

1. Phase 3 Zusammenfassung erstellen
2. PBI Desktop öffnen
3. Projekt laden
4. Visual Validation im PBI Desktop
5. Refresh + Publish zu Fabric
```
