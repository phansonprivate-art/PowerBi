#!/usr/bin/env python3
"""
PBIP Automation: Visual Field Validator

Validiert dass alle Entity/Property in visual.json in der TMDL-Feldliste existieren.

Anwendung:
  python3 validate-visuals.py --pbip-path "C:\\Projects\\Model" --tmdl-list "TMDL-Feldliste.json"
"""

import json
import glob
import os
import argparse
from pathlib import Path

def validate_visuals(pbip_path, tmdl_fieldlist):
    """Prüft alle visual.json auf gültige Entity/Property"""
    
    errors = []
    
    print(f"Loading TMDL field list: {tmdl_fieldlist}")
    with open(tmdl_fieldlist, 'r', encoding='utf-8') as f:
        valid_fields = json.load(f)
    
    print(f"Valid tables: {list(valid_fields.keys())}\n")
    
    # Find all visual.json files
    visual_files = glob.glob(
        os.path.join(pbip_path, '**', 'visual.json'),
        recursive=True
    )
    
    print(f"Checking {len(visual_files)} visual.json files...\n")
    
    for visual_file in visual_files:
        try:
            with open(visual_file, 'r', encoding='utf-8') as f:
                visual = json.load(f)
            
            # Extract all SourceRef/Property combinations
            def check_bindings(obj, path=""):
                if isinstance(obj, dict):
                    if 'SourceRef' in obj and 'Property' in obj:
                        entity = obj['SourceRef'].get('Entity')
                        prop = obj['Property']
                        
                        if entity and prop:
                            if entity not in valid_fields:
                                errors.append(
                                    f"{visual_file}\n"
                                    f"  Entity '{entity}' NOT FOUND in TMDL"
                                )
                            elif prop not in valid_fields[entity]['all']:
                                errors.append(
                                    f"{visual_file}\n"
                                    f"  Property '{entity}.{prop}' NOT FOUND in TMDL\n"
                                    f"  Valid properties: {valid_fields[entity]['all']}"
                                )
                            else:
                                print(f"  ✅ {entity}.{prop}")
                    
                    for key, value in obj.items():
                        check_bindings(value, f"{path}/{key}")
                
                elif isinstance(obj, list):
                    for item in obj:
                        check_bindings(item, path)
            
            print(f"Checking: {os.path.basename(os.path.dirname(visual_file))}")
            check_bindings(visual)
        
        except Exception as e:
            errors.append(f"{visual_file}: {e}")
    
    # Report
    if errors:
        print(f"\n❌ VALIDATION FAILED - {len(errors)} error(s):\n")
        for e in errors:
            print(f"  {e}\n")
        return False
    else:
        print(f"\n✅ ALL VISUALS VALID")
        return True

def main():
    parser = argparse.ArgumentParser(description='Validate visual.json Entity/Property')
    parser.add_argument('--pbip-path', required=True, help='PBIP project root path')
    parser.add_argument('--tmdl-list', default='TMDL-Feldliste.json',
                        help='Path to TMDL-Feldliste.json')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.tmdl_list):
        print(f"❌ ERROR: TMDL list not found: {args.tmdl_list}")
        return False
    
    return validate_visuals(args.pbip_path, args.tmdl_list)

if __name__ == '__main__':
    success = main()
    exit(0 if success else 1)
