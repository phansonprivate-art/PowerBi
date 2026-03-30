"""
PBIR Enhanced Visual Binding Script v2
Correct format: visual.query.queryState = { RoleName: { projections: [...] } }
Schema: visualContainer/2.7.0, semanticQuery/1.3.0
"""
import json, os, glob

BASE = r"C:\Users\phant\OneDrive\Desktop\Power BI\Lucanet_Finance\Lucanet_Finance.Report\definition\pages"

# --- Helper functions ---
def measure_field(table, prop):
    return {
        "Measure": {
            "Expression": {"SourceRef": {"Entity": table}},
            "Property": prop
        }
    }

def column_field(table, prop):
    return {
        "Column": {
            "Expression": {"SourceRef": {"Entity": table}},
            "Property": prop
        }
    }

def proj(field_def, query_ref, native_ref):
    return {
        "field": field_def,
        "queryRef": query_ref,
        "nativeQueryRef": native_ref
    }

def m(name):
    """Measure projection from Measure table"""
    return proj(measure_field("Measure", name), f"Measure.{name}", name)

def col(table, prop):
    """Column projection"""
    return proj(column_field(table, prop), f"{table}.{prop}", prop)

def bind(visual_data, roles_dict):
    """Add queryState binding inside visual object"""
    qs = {}
    for role_name, projections in roles_dict.items():
        if not isinstance(projections, list):
            projections = [projections]
        qs[role_name] = {"projections": projections}
    visual_data["visual"]["query"] = {"queryState": qs}

def bind_card(visual_data, measure_name):
    """Bind a cardVisual with Data + Fields + sortDefinition (verified PBI Desktop format).
    cardVisual needs BOTH 'Data' and 'Fields' roles with identical measure projection,
    plus a sortDefinition. Using only 'Values' or 'Fields' alone will NOT work."""
    measure_proj = m(measure_name)
    field_def = measure_field("Measure", measure_name)
    visual_data["visual"]["query"] = {
        "queryState": {
            "Data": {"projections": [measure_proj]},
            "Fields": {"projections": [measure_proj]},
        },
        "sortDefinition": {
            "sort": [{"field": field_def, "direction": "Descending"}],
            "isDefaultSort": True
        }
    }

# ============================================================
# BILANZ PAGE (229ddded65ba36c359e6)
# ============================================================
BILANZ = "229ddded65ba36c359e6"
bilanz_cards = {
    "e08628bf944cfaa394aa": "Bilanz Ist",
    "d93a0fe333574e926bf1": "Bilanz Plan",
    "2ca0b3beb589aaa2b08f": "GuV Ist",
    "2944e88e9e19749cc43c": "CF Ist",
}
bilanz_bindings = {

    # --- 2 Gauges ---
    "68dcee2eaa62c08eeed4": {
        "Y":           m("Bilanz Ist"),
        "TargetValue": m("Bilanz Plan"),
    },
    "1bd6318a220328291dc7": {
        "Y":           m("GuV Ist"),
        "TargetValue": m("GuV Plan"),
    },

    # --- Line Chart: Monthly trend ---
    "eb41d0ead52d830e5a5c": {
        "Category": col("Datum", "Monatsname"),
        "Y":        [m("Bilanz Ist"), m("Bilanz Plan")],
    },

    # --- Donut Chart: by AccountLevel2 ---
    "63d36d9765455fe7ad89": {
        "Category": col("AccountStructure", "AccountLevel2"),
        "Y":        m("Bilanz Ist"),
    },

    # --- Clustered Bar Chart: by AccountLevel3 ---
    "c71eef900b3d4510139b": {
        "Category": col("AccountStructure", "AccountLevel3"),
        "Y":        [m("Bilanz Ist"), m("Bilanz Plan")],
    },

    # --- 100% Stacked Column: Quarterly ---
    "a82eb6d4e9afa712dc6a": {
        "Category": col("Datum", "Quartal"),
        "Y":        [m("Bilanz Ist"), m("Bilanz Plan")],
    },

    # --- 7 Slicers ---
    "931b4c92c97d6039e8cc": {"Values": col("Datum", "Jahr")},
    "8cc6e4db50533063f6fc": {"Values": col("Datum", "Quartal")},
    "518806cf32a0093060e1": {"Values": col("DataLevel", "DataLevelName")},
    "a0dd37d5b71d498ad32f": {"Values": col("PartnerStructure", "PartnerName")},
    "0622d919c6179c53593f": {"Values": col("AccountStructure", "AccountLevel1")},
    "c2f60dee8b9024afd427": {"Values": col("AccountStructure", "AccountLevel2")},
    "aeafdbbfac1040fd94f3": {"Values": col("Datum", "Monatsname")},
}

# ============================================================
# GuV PAGE (ca650288acf4f449ebac)
# ============================================================
GUV = "ca650288acf4f449ebac"
guv_cards = {
    "f563e92dd75ffd96a26d": "GuV Ist YTD Total",
    "059feeeae13dc8b22f56": "GuV Plan YTD Total",
}
guv_bindings = {

    # --- Donut Chart: by AccountLevel2 ---
    "8027f3d8": {
        "Category": col("AccountStructure", "AccountLevel2"),
        "Y":        m("GuV Ist"),
    },

    # --- Clustered Bar: by AccountLevel3 ---
    "b39b0c86": {
        "Category": col("AccountStructure", "AccountLevel3"),
        "Y":        [m("GuV Ist"), m("GuV Plan")],
    },

    # --- Table: Detail ---
    "f98c0af6": {
        "Values": [
            col("AccountStructure", "AccountLevel2"),
            col("AccountStructure", "AccountLevel3"),
            m("GuV Ist"),
            m("GuV Plan"),
        ],
    },

    # --- Pivot Table ---
    "91418a36": {
        "Rows":   [col("AccountStructure", "AccountLevel2"), col("Datum", "Monatsname")],
        "Values": [m("GuV Ist"), m("GuV Plan")],
    },

    # --- 7 Slicers ---
    "7911a50b": {"Values": col("Datum", "Jahr")},
    "0464fdc8": {"Values": col("Datum", "Quartal")},
    "fa7e47c6": {"Values": col("DataLevel", "DataLevelName")},
    "255d73fc": {"Values": col("PartnerStructure", "PartnerName")},
    "82c9e6a7": {"Values": col("AccountStructure", "AccountLevel1")},
    "37ce51d5": {"Values": col("AccountStructure", "AccountLevel2")},
    "241f2d52": {"Values": col("Datum", "Monatsname")},
}

# ============================================================
# CASHFLOW PAGE (a1b2c3d4e5f6789012ab)
# ============================================================
CASHFLOW = "a1b2c3d4e5f6789012ab"
cashflow_cards = {
    "f563e92dd75ffd96a26d": "CF Ist",
    "059feeeae13dc8b22f56": "CF Plan",
}
cashflow_bindings = {

    # --- Donut Chart: by AccountLevel2 ---
    "8027f3d8": {
        "Category": col("AccountStructure", "AccountLevel2"),
        "Y":        m("CF Ist"),
    },

    # --- Clustered Bar: by AccountLevel3 ---
    "b39b0c86": {
        "Category": col("AccountStructure", "AccountLevel3"),
        "Y":        [m("CF Ist"), m("CF Plan")],
    },

    # --- Table: Detail ---
    "f98c0af6": {
        "Values": [
            col("AccountStructure", "AccountLevel2"),
            col("AccountStructure", "AccountLevel3"),
            m("CF Ist"),
            m("CF Plan"),
        ],
    },

    # --- Pivot Table ---
    "91418a36": {
        "Rows":   [col("AccountStructure", "AccountLevel2"), col("Datum", "Monatsname")],
        "Values": [m("CF Ist"), m("CF Plan")],
    },

    # --- 7 Slicers ---
    "7911a50b": {"Values": col("Datum", "Jahr")},
    "0464fdc8": {"Values": col("Datum", "Quartal")},
    "fa7e47c6": {"Values": col("DataLevel", "DataLevelName")},
    "255d73fc": {"Values": col("PartnerStructure", "PartnerName")},
    "82c9e6a7": {"Values": col("AccountStructure", "AccountLevel1")},
    "37ce51d5": {"Values": col("AccountStructure", "AccountLevel2")},
    "241f2d52": {"Values": col("Datum", "Monatsname")},
}

# ============================================================
# APPLY BINDINGS
# ============================================================
pages = [
    (BILANZ, bilanz_bindings, bilanz_cards, "Bilanz"),
    (GUV, guv_bindings, guv_cards, "GuV"),
    (CASHFLOW, cashflow_bindings, cashflow_cards, "Cashflow"),
]

def find_visual(page_dir, vid_prefix):
    matches = glob.glob(os.path.join(page_dir, vid_prefix + "*", "visual.json"))
    return matches[0] if matches else None

def load_visual(path):
    with open(path, "r", encoding="utf-8-sig") as f:
        return json.load(f)

def save_visual(path, data):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

total = 0
for page_id, bindings, cards, page_name in pages:
    page_dir = os.path.join(BASE, page_id, "visuals")
    bound = 0

    # Bind cardVisuals with Data+Fields+sortDefinition
    for vid_prefix, measure_name in cards.items():
        vj = find_visual(page_dir, vid_prefix)
        if not vj:
            print(f"  WARNING: {page_name} - card visual {vid_prefix} not found!")
            continue
        data = load_visual(vj)
        bind_card(data, measure_name)
        save_visual(vj, data)
        bound += 1

    # Bind other visuals with standard roles
    for vid_prefix, roles in bindings.items():
        vj = find_visual(page_dir, vid_prefix)
        if not vj:
            print(f"  WARNING: {page_name} - visual {vid_prefix} not found!")
            continue
        data = load_visual(vj)
        bind(data, roles)
        save_visual(vj, data)
        bound += 1

    print(f"{page_name}: {bound} visuals bound")
    total += bound

print(f"\nTotal: {total} visuals bound across 3 pages")
