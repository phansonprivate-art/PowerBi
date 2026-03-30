"""
Phase 2 – queryState Bindings für alle 3 Seiten (Bilanz, GuV, Cashflow)
PBIR Enhanced Format: visualConfiguration/2.3.0 + semanticQuery/1.4.0

queryState ist ein OBJECT (nicht Array!) mit Rollenname-Keys.
Jede Rolle hat "projections" Array von {field, queryRef}.
field nutzt Column/Measure-Wrapper mit SourceRef.Source (nicht Entity!).
"""

import json
import os

BASE = r"C:\Users\phant\OneDrive\Desktop\Power BI\Lucanet_Finance\Lucanet_Finance.Report\definition\pages"

# ===========================================================================
# Feld-Helfer (Schema: semanticQuery/1.4.0 QueryExpressionContainer)
# ===========================================================================
def col(table, prop):
    """Column-Referenz"""
    return {
        "field": {
            "Column": {
                "Expression": {"SourceRef": {"Source": table}},
                "Property": prop
            }
        },
        "queryRef": f"{table}.{prop}"
    }

def meas(table, prop):
    """Measure-Referenz"""
    return {
        "field": {
            "Measure": {
                "Expression": {"SourceRef": {"Source": table}},
                "Property": prop
            }
        },
        "queryRef": f"{table}.{prop}"
    }

def m(name):
    """Measure aus 'Measure'-Tabelle"""
    return meas("Measure", name)

# ===========================================================================
# Query-Builder pro Visual-Typ
# ===========================================================================
def slicer_query(column_proj):
    """Slicer: Rolle 'Values'"""
    return {"query": {"queryState": {
        "Values": {"projections": [column_proj]}
    }}}

def card_query(*measure_projs):
    """cardVisual: Rolle 'Values'"""
    return {"query": {"queryState": {
        "Values": {"projections": list(measure_projs)}
    }}}

def gauge_query(value_proj, target_proj=None):
    """gauge: Rolle 'Y' + optional 'TargetValue'"""
    qs = {"Y": {"projections": [value_proj]}}
    if target_proj:
        qs["TargetValue"] = {"projections": [target_proj]}
    return {"query": {"queryState": qs}}

def chart_query(category_proj, *value_projs):
    """lineChart/donutChart/clusteredBarChart/stacked: 'Category' + 'Y'"""
    return {"query": {"queryState": {
        "Category": {"projections": [category_proj]},
        "Y": {"projections": list(value_projs)}
    }}}

def table_query(*all_projs):
    """tableEx: Rolle 'Values'"""
    return {"query": {"queryState": {
        "Values": {"projections": list(all_projs)}
    }}}

def matrix_query(row_projs, col_projs, value_projs):
    """pivotTable/matrix: 'Rows', 'Columns', 'Values'"""
    qs = {}
    if row_projs:
        qs["Rows"] = {"projections": row_projs}
    if col_projs:
        qs["Columns"] = {"projections": col_projs}
    if value_projs:
        qs["Values"] = {"projections": value_projs}
    return {"query": {"queryState": qs}}

# ===========================================================================
# PAGE 1: Bilanz  (229ddded65ba36c359e6)
# ===========================================================================
BILANZ = "229ddded65ba36c359e6"

BILANZ_BINDINGS = {
    # Cards
    "e08628bf944cfaa394aa": card_query(m("Bilanz Ist")),
    "d93a0fe333574e926bf1": card_query(m("Bilanz Plan")),
    "2ca0b3beb589aaa2b08f": card_query(m("GuV Ist Operatives Ergebnis")),
    "2944e88e9e19749cc43c": card_query(m("GuV Ist Umsatzerlöse")),

    # Gauge  (Wert + Zielwert)
    "1bd6318a220328291dc7": gauge_query(m("Bilanz Ist"), m("Bilanz Plan")),

    # Line chart  (Achse + Werte)
    "eb41d0ead52d830e5a5c": chart_query(
        col("Datum", "Monatsname"),
        m("Bilanz Ist"), m("Bilanz Plan")
    ),

    # Donut  (Kategorie + Wert)
    "63d36d9765455fe7ad89": chart_query(
        col("AccountStructure", "AccountLevel2"),
        m("Bilanz Ist")
    ),

    # Clustered Bar  (Kategorie + Werte)
    "c71eef900b3d4510139b": chart_query(
        col("AccountStructure", "AccountLevel3"),
        m("Bilanz Ist"), m("Bilanz Plan")
    ),

    # 100% Stacked Column
    "a82eb6d4e9afa712dc6a": chart_query(
        col("Datum", "Quartal"),
        m("Bilanz Ist"), m("Bilanz Plan")
    ),

    # Slicers – oben
    "931b4c92c97d6039e8cc": slicer_query(col("Datum", "Jahr")),
    "8cc6e4db50533063f6fc": slicer_query(col("DataLevel", "DataLevelName")),
    "518806cf32a0093060e1": slicer_query(col("Datum", "Quartal")),

    # Slicers – links
    "a0dd37d5b71d498ad32f": slicer_query(col("PartnerStructure", "PartnerName")),
    "0622d919c6179c53593f": slicer_query(col("AccountStructure", "AccountLevel2")),
    "c2f60dee8b9024afd427": slicer_query(col("Datum", "Monatsname")),
    "aeafdbbfac1040fd94f3": slicer_query(col("AccountStructure", "AccountLevel1")),
}

# ===========================================================================
# PAGE 2: GuV  (ca650288acf4f449ebac)
# ===========================================================================
GUV = "ca650288acf4f449ebac"

GUV_BINDINGS = {
    # Cards
    "f563e92dd75ffd96a26d": card_query(m("GuV Ist YTD Total")),
    "059feeeae13dc8b22f56": card_query(m("GuV Plan YTD Total")),

    # Donut
    "8027f3d8e4e5f01d538d": chart_query(
        col("AccountStructure", "AccountLevel2"),
        m("GuV Ist")
    ),

    # Clustered Bar
    "b39b0c860e17e4ee094d": chart_query(
        col("AccountStructure", "AccountLevel3"),
        m("GuV Ist"), m("GuV Plan")
    ),

    # Table
    "f98c0af677831b1d2c5e": table_query(
        col("AccountStructure", "AccountLevel3"),
        m("GuV Ist"), m("GuV Plan")
    ),

    # Matrix (rows=AccountLevel2, columns=Monatsname, values=GuV Ist)
    "91418a362eee14190eb7": matrix_query(
        [col("AccountStructure", "AccountLevel2")],
        [col("Datum", "Monatsname")],
        [m("GuV Ist")]
    ),

    # Slicers – oben
    "7911a50b56d8bf47455d": slicer_query(col("Datum", "Jahr")),
    "0464fdc862d0bcdf81ca": slicer_query(col("DataLevel", "DataLevelName")),
    "fa7e47c601622e86f7ab": slicer_query(col("Datum", "Quartal")),

    # Slicers – links
    "255d73fc0186781ab6c5": slicer_query(col("PartnerStructure", "PartnerName")),
    "82c9e6a7e9e0e7e70178": slicer_query(col("AccountStructure", "AccountLevel2")),
    "37ce51d562eb71da26d7": slicer_query(col("Datum", "Monatsname")),
    "241f2d5209bed09b2b77": slicer_query(col("AccountStructure", "AccountLevel1")),
}

# ===========================================================================
# PAGE 3: Cashflow  (a1b2c3d4e5f6789012ab) – Kopie von GuV mit CF-Measures
# ===========================================================================
CF = "a1b2c3d4e5f6789012ab"

CF_BINDINGS = {
    # Cards
    "f563e92dd75ffd96a26d": card_query(m("CF Ist")),
    "059feeeae13dc8b22f56": card_query(m("CF Plan")),

    # Donut
    "8027f3d8e4e5f01d538d": chart_query(
        col("AccountStructure", "AccountLevel2"),
        m("CF Ist")
    ),

    # Clustered Bar
    "b39b0c860e17e4ee094d": chart_query(
        col("AccountStructure", "AccountLevel3"),
        m("CF Ist"), m("CF Plan")
    ),

    # Table
    "f98c0af677831b1d2c5e": table_query(
        col("AccountStructure", "AccountLevel3"),
        m("CF Ist"), m("CF Plan")
    ),

    # Matrix
    "91418a362eee14190eb7": matrix_query(
        [col("AccountStructure", "AccountLevel2")],
        [col("Datum", "Monatsname")],
        [m("CF Ist")]
    ),

    # Slicers – oben
    "7911a50b56d8bf47455d": slicer_query(col("Datum", "Jahr")),
    "0464fdc862d0bcdf81ca": slicer_query(col("DataLevel", "DataLevelName")),
    "fa7e47c601622e86f7ab": slicer_query(col("Datum", "Quartal")),

    # Slicers – links
    "255d73fc0186781ab6c5": slicer_query(col("PartnerStructure", "PartnerName")),
    "82c9e6a7e9e0e7e70178": slicer_query(col("AccountStructure", "AccountLevel2")),
    "37ce51d562eb71da26d7": slicer_query(col("Datum", "Monatsname")),
    "241f2d5209bed09b2b77": slicer_query(col("AccountStructure", "AccountLevel1")),
}

# ===========================================================================
# Anwenden
# ===========================================================================
ALL_PAGES = [
    (BILANZ, BILANZ_BINDINGS),
    (GUV,    GUV_BINDINGS),
    (CF,     CF_BINDINGS),
]

ok = 0
err = 0

for page_id, bindings in ALL_PAGES:
    visuals_dir = os.path.join(BASE, page_id, "visuals")
    for visual_id, qstate in bindings.items():
        path = os.path.join(visuals_dir, visual_id, "visual.json")
        if not os.path.exists(path):
            print(f"  SKIP (nicht gefunden): {page_id}/{visual_id}")
            err += 1
            continue
        with open(path, "r", encoding="utf-8-sig") as f:
            data = json.load(f)

        # Alte query entfernen (egal ob top-level oder in visual)
        data.pop("query", None)
        data["visual"].pop("query", None)

        # Neue query in visual einfügen (Schema: visualConfiguration/2.3.0)
        data["visual"].update(qstate)

        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"  OK: {page_id[:8]}…/{visual_id[:8]}…")
        ok += 1

# Cashflow Titel-Textbox auf "Cashflow" setzen
title_path = os.path.join(BASE, CF, "visuals", "9c5d1feb56e7e1d63d76", "visual.json")
if os.path.exists(title_path):
    with open(title_path, "r", encoding="utf-8-sig") as f:
        d = json.load(f)
    try:
        d["visual"]["objects"]["general"][0]["properties"]["paragraphs"][0]["textRuns"][0]["value"] = "Cashflow"
    except (KeyError, IndexError):
        pass
    with open(title_path, "w", encoding="utf-8") as f:
        json.dump(d, f, indent=2, ensure_ascii=False)
    print(f"  OK: Cashflow-Titel gesetzt")

print(f"\nFertig: {ok} OK, {err} Fehler")
