#!/usr/bin/env python3
"""
PBIP Automation: TMDL Field List Extractor

Extrahiert Feldnamen aus TMDL-Dateien nach Export.
Output: TMDL-Feldliste.json (single source of truth für visual.json)

Anwendung:
  python3 extract-tmdl-fields.py --tmdl-path "C:\...\definition\tables"
"""

import os
import json
import re
import argparse
from pathlib import Path

def extract_tmdl_fields(tmdl_folder):
    """Extrahiert Spalten + Measures aus TMDL Dateien"""
    
    valid_fields = {}
    
    for tmdl_file in Path(tmdl_folder).glob('*.tmdl'):
        table_name = tmdl_file.stem
        
        try:
            with open(tmdl_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Spalten: Pattern "  column Name"
            columns = re.findall(r'^\s+column\s+(\S+)', content, re.MULTILINE)
            
            # Measures: Pattern "  measure 'Name' ="
            measures = re.findall(r"^\s+measure\s+'?([^'=\n]+)'?", content, re.MULTILINE)
            
            all_fields = set(columns + measures)
            
            valid_fields[table_name] = {
                'columns': columns,
                'measures': measures,
                'all': sorted(list(all_fields))
            }
            
            print(f"✅ {table_name:30} | Cols: {len(columns):3} | Measures: {len(measures):3}")
        
        except Exception as e:
            print(f"❌ {table_name}: {e}")
            return None
    
    return valid_fields

def main():
    parser = argparse.ArgumentParser(
        description='Extract field names from TMDL files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Example:
  python3 extract-tmdl-fields.py --tmdl-path "C:\\Projects\\Model\\definition\\tables"
        '''
    )
    parser.add_argument('--tmdl-path', required=True, help='Path to TMDL tables folder')
    parser.add_argument('--output', default=None, help='Output JSON file (default: TMDL-Feldliste.json)')
    
    args = parser.parse_args()
    
    tmdl_path = Path(args.tmdl_path)
    if not tmdl_path.exists():
        print(f"❌ ERROR: Path does not exist: {tmdl_path}")
        return False
    
    print(f"Extracting fields from: {tmdl_path}\n")
    
    fields = extract_tmdl_fields(tmdl_path)
    if fields is None:
        return False
    
    # Determine output path
    if args.output:
        output_file = Path(args.output)
    else:
        output_file = tmdl_path.parent / 'TMDL-Feldliste.json'
    
    # Save JSON
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(fields, f, indent=2, ensure_ascii=False)
    
    print(f"\n✅ TMDL-Feldliste generated: {output_file}")
    print(f"\nSummary:")
    print(f"  Tables: {len(fields)}")
    print(f"  Total Fields: {sum(len(v['all']) for v in fields.values())}")
    
    return True

if __name__ == '__main__':
    success = main()
    exit(0 if success else 1)
