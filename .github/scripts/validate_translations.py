#!/usr/bin/env python3
"""Validate that all translation files have equivalent keys to the base en.yaml file."""

import os
import sys
from pathlib import Path
import yaml


def get_all_keys(obj, prefix=''):
    """Recursively get all keys from a nested dictionary."""
    keys = set()
    if isinstance(obj, dict):
        for key, value in obj.items():
            current_key = f"{prefix}.{key}" if prefix else key
            keys.add(current_key)
            if isinstance(value, dict):
                keys.update(get_all_keys(value, current_key))
    return keys


def load_yaml_file(file_path):
    """Load and parse a YAML file."""
    try:
        # Check if file is empty first
        if file_path.stat().st_size == 0:
            print(f"⚠️  Empty file: {file_path}")
            return None
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read().strip()
            if not content:
                print(f"⚠️  Empty content: {file_path}")
                return None
            return yaml.safe_load(content)
    except yaml.YAMLError as e:
        print(f"❌ YAML parsing error in {file_path}: {e}")
        return None
    except Exception as e:
        print(f"❌ Error loading {file_path}: {e}")
        return None


def validate_addon_translations(addon_path):
    """Validate translations for a specific addon."""
    translations_dir = addon_path / "translations"
    base_file_path = translations_dir / "en.yaml"
    
    print(f"\n📁 Checking {addon_path.name}...")
    
    if not base_file_path.exists():
        print(f"⚠️  Base en.yaml file not found: {base_file_path}")
        return True  # Skip if no base file
    
    # Load base English file
    base_data = load_yaml_file(base_file_path)
    if base_data is None:
        print(f"❌ Failed to load base file: {base_file_path}")
        return False
    
    base_keys = get_all_keys(base_data)
    print(f"📋 Base en.yaml has {len(base_keys)} keys")
    
    # Check if translations directory exists
    if not translations_dir.exists():
        print(f"ℹ️  No translations directory found at {translations_dir}")
        return True
    
    # Find all translation files (excluding en.yaml)
    translation_files = [f for f in translations_dir.glob("*.yaml") if f.name != "en.yaml"]
    
    if not translation_files:
        print("ℹ️  No translation files found (only base en.yaml exists)")
        return True
    
    print(f"🔍 Found {len(translation_files)} translation file(s)")
    
    all_valid = True
    
    for trans_file in sorted(translation_files):
        lang_code = trans_file.stem
        print(f"\n🌍 Validating {lang_code}.yaml...")
        
        trans_data = load_yaml_file(trans_file)
        if trans_data is None:
            all_valid = False
            continue
        
        trans_keys = get_all_keys(trans_data)
        
        # Check for missing keys
        missing_keys = base_keys - trans_keys
        # Check for extra keys
        extra_keys = trans_keys - base_keys
        
        if not missing_keys and not extra_keys:
            print(f"✅ {lang_code}.yaml is complete and valid")
        else:
            all_valid = False
            
            if missing_keys:
                print(f"❌ {lang_code}.yaml is missing {len(missing_keys)} key(s):")
                for key in sorted(missing_keys):
                    print(f"   - {key}")
            
            if extra_keys:
                print(f"⚠️  {lang_code}.yaml has {len(extra_keys)} extra key(s) not in base:")
                for key in sorted(extra_keys):
                    print(f"   - {key}")
    
    return all_valid


def main():
    """Main validation function."""
    print("🌍 Translation Validation")
    print("=" * 50)
    
    # Define addon paths
    addon_paths = [
        Path("tududi-addon"),
        Path("tududi-addon-dev")
    ]
    
    overall_valid = True
    
    for addon_path in addon_paths:
        if addon_path.exists():
            if not validate_addon_translations(addon_path):
                overall_valid = False
        else:
            print(f"\n⚠️  Addon directory not found: {addon_path}")
    
    print("\n" + "=" * 50)
    
    if overall_valid:
        print("✅ All translation files are valid!")
        sys.exit(0)
    else:
        print("❌ Translation validation failed!")
        print("\nPlease ensure all translation files have the same keys as en.yaml")
        sys.exit(1)


if __name__ == "__main__":
    main()
