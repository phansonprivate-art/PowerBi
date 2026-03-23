#!/usr/bin/env python3
"""
PBIP Automation: JSON Syntax Validator

Validiert dass alle JSON Dateien im PBIP Projekt syntaktisch korrekt sind.

Anwendung:
  python3 validate-json-syntax.py --pbip-path "C:\\Projects\\Model"
"""

import json
import glob
import os
import argparse
from pathlib import Path

def validate_json_syntax(pbip_path):
    """Prüft alle JSON-Dateien auf Syntax-Fehler"""
    
    errors = []
    valid_count = 0
    
    # Find all JSON files
    json_files = glob.glob(
        os.path.join(pbip_path, '**', '*.json'),
        recursive=True
    )
    
    print(f"Checking {len(json_files)} JSON files...\n")
    
    for json_file in json_files:
        try:
            with open(json_file, 'r', encoding='utf-8') as f:
                json.load(f)
            print(f"✅ {json_file}")
            valid_count += 1
        except json.JSONDecodeError as e:
            errors.append(f"{json_file}:\n  Line {e.lineno}: {e.msg}")
            print(f"❌ {json_file}")
        except Exception as e:
            errors.append(f"{json_file}: {e}")
            print(f"❌ {json_file}")
    
    # Report
    print(f"\n{'─' * 60}")
    if errors:
        print(f"❌ VALIDATION FAILED - {len(errors)} error(s)\n")
        for e in errors:
            print(f"  {e}\n")
        return False
    else:
        print(f"✅ ALL JSON VALID ({valid_count} files)")
        return True

def main():
    parser = argparse.ArgumentParser(description='Validate JSON syntax')
    parser.add_argument('--pbip-path', required=True, help='PBIP project root')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.pbip_path):
        print(f"❌ ERROR: Path not found: {args.pbip_path}")
        return False
    
    return validate_json_syntax(args.pbip_path)

if __name__ == '__main__':
    success = main()
    exit(0 if success else 1)
