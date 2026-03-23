# PHASE 1: SCHRITT 1 – MCP Verbindung & Metadaten

## Ablauf (Sequential!)

### 1️⃣ Connection einrichten

**via MCP → connection_operations**

```
Operation: Connect
ConnectionString: "localhost:port" oder "PowerBI Desktop"
```

**Status:** ✅ Verbindung erfolgreich oder ❌ Fehler → **STOPP**

---

### 2️⃣ DatabaseID abrufen

**via MCP → database_operations**

```
Operation: Get
→ Ziel: "DatabaseID" und "ModelName" merken
```

**Ausgabe merken:**
```
{
  "id": "12345-abc-def-ghi",    ← MERKEN für Schritt 5A!
  "name": "SemanticModel",
  "compatibilityLevel": 1700
}
```

---

### 3️⃣ Alle Tabellen auflisten

**via MCP → table_operations**

```
Operation: List
```

**Zu dokumentieren:**
```
[ ] Wie viele Tabellen?
[ ] Tabellennamen (z.B. DIM_Kalender, DIM_Produkt, ...)
[ ] Welche sind Dimensions, welche Fakten?
```

---

### 4️⃣ Alle Measures auflisten

**via MCP → measure_operations**

```
Operation: List
```

**Zu dokumentieren:**
```
[ ] Wie viele Measures?
[ ] Measure-Namen (vor Neuerstellung!)
[ ] Welche Display-Folders?
[ ] Gibt es Time Intelligence Measures?
```

---

### 5️⃣ Beziehungen abrufen

**via MCP → relationship_operations**

```
Operation: List
```

**Zu dokumentieren:**
```
[ ] Alle Relationships dokumentieren:
    - FROM: (Tabelle.Spalte)
    - TO: (Tabelle.Spalte)
    - Active/Inactive?
    - Cardinality?
```

---

## ⚠️ KRITISCHE WARNUNG

```
❌ column_operations NUR zur Orientierung!

Die ECHTEN Spaltennamen kommen aus TMDL files (nach Export).

MCP kann sagen "Category", aber TMDL hat "Kategorie"
→ IMMER TMDL verwenden, nicht MCP!
```

---

## Status-Checkliste

- [ ] PBI Desktop läuft?
- [ ] MCP Verbindung erfolgreich?
- [ ] DatabaseID notiert?
- [ ] Alle Tabellen inventarisiert?
- [ ] Alle Measures inventarisiert?
- [ ] Alle Relationships dokumentiert?
- [ ] Keine Fehler → Weiter zu **SCHRITT 2**

---

## Fehlerbehandlung

| Fehler | Ursache | Lösung |
|--------|--------|--------|
| Keine PBI Instance | Desktop nicht offen | Öffne PBI Desktop + Modell |
| Verbindung timeout | Falsche Konfiguration | Check `connection_operations` |
| Keine Measures | Modell hat nur Implicit Measures | OK – erstelle neue in Phase 2 |
