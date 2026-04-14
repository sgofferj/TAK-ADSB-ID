import json
import os
import csv
import io
import argparse
import sys

try:
    import iso3166
except ImportError:
    print("Error: The 'iso3166' module is required. Install it using 'pip install iso3166'.")
    sys.exit(1)

def get_country_name(iso_3_code):
    """Maps ISO 3166-1 alpha-3 code to country name using the iso3166 library."""
    try:
        # Standardize to uppercase for lookup
        return iso3166.countries_by_alpha3[iso_3_code.upper()].name
    except KeyError:
        return None

def update_affiliations(countries_file, src_dir, execute=False):
    """
    Reads countries.json, maps ISO-3 directories to country names,
    and previews/applies affiliation updates to CoT types in .txt files.
    """
    # 1. Load countries.json and map country name to affiliation
    if not os.path.exists(countries_file):
        print(f"Error: {countries_file} not found.")
        return

    with open(countries_file, 'r') as f:
        countries_data = json.load(f)
    
    # Map country name (case-insensitive) to affiliation
    country_affil_map = {c['country'].lower(): c['affil'] for c in countries_data}

    # 2. Iterate over directories in src/
    if not os.path.exists(src_dir):
        print(f"Error: {src_dir} not found.")
        return

    for iso_code in sorted(os.listdir(src_dir)):
        iso_dir = os.path.join(src_dir, iso_code)
        if not os.path.isdir(iso_dir):
            continue
            
        country_name = get_country_name(iso_code)
        if not country_name:
            print(f"Skipping {iso_code}: ISO code not recognized by iso3166.")
            continue
            
        affil = country_affil_map.get(country_name.lower())
        if not affil:
            # Some manual overrides for common mismatches if needed
            overrides = {
                "United Kingdom of Great Britain and Northern Ireland": "United Kingdom",
                "Russian Federation": "Russian Federation",
                "United States of America": "United States",
                "Viet Nam": "Viet Nam",
                "Korea, Republic of": "Republic of Korea",
                "Iran, Islamic Republic of": "Iran",
                "Syrian Arab Republic": "Syrian Arab Republic",
                "Venezuela, Bolivarian Republic of": "Venezuela",
                "Taiwan, Province of China": "Taiwan",
                "Tanzania, United Republic of": "United Republic of Tanzania",
                "Congo, Democratic Republic of the": "Dem Rep of the Congo"
            }
            if country_name in overrides:
                affil = country_affil_map.get(overrides[country_name].lower())

        if not affil:
            print(f"Skipping {iso_code} ({country_name}): No matching country name found in countries.json.")
            continue
            
        # 3. Process .txt files in the country directory
        for filename in sorted(os.listdir(iso_dir)):
            if filename.endswith(".txt"):
                file_path = os.path.join(iso_dir, filename)
                
                with open(file_path, 'r') as f:
                    lines = f.readlines()
                
                new_lines = []
                file_modified = False
                
                for line in lines:
                    if line.startswith('#') or not line.strip():
                        new_lines.append(line)
                        continue
                    
                    # Parse CSV line correctly handling quotes
                    try:
                        reader = csv.reader([line.strip()], quotechar='"')
                        parts = next(reader)
                    except Exception:
                        new_lines.append(line)
                        continue
                        
                    if len(parts) >= 2:
                        cot_type = parts[1]
                        if cot_type.startswith('a-'):
                            type_parts = cot_type.split('-')
                            if len(type_parts) > 1:
                                old_affil = type_parts[1]
                                if old_affil != affil:
                                    type_parts[1] = affil
                                    parts[1] = '-'.join(type_parts)
                                    file_modified = True
                                    print(f"[{iso_code}] {parts[0]}: {old_affil} -> {affil}")
                        
                        # Rebuild CSV string
                        output = io.StringIO()
                        writer = csv.writer(output, quotechar='"', quoting=csv.QUOTE_ALL)
                        writer.writerow(parts)
                        new_lines.append(output.getvalue().strip() + '\n')
                    else:
                        new_lines.append(line)
                
                if file_modified:
                    if execute:
                        with open(file_path, 'w') as f:
                            f.writelines(new_lines)
                        print(f"  --> UPDATED: {file_path}")
                    else:
                        print(f"  --> [DRY RUN] Would update: {file_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Update affiliations in ADSB source files based on countries.json.")
    parser.add_argument('--execute', action='store_true', help="Actually apply the changes to the files.")
    args = parser.parse_args()
    
    if not args.execute:
        print("Running in PREVIEW mode. No changes will be made to disk.")
        print("To apply changes, run with the --execute flag.")
        print("-" * 50)
    
    # Adjust paths based on where the script is located (tools/)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    countries_path = os.path.join(script_dir, '../countries.json')
    src_path = os.path.join(script_dir, '../src')
    
    update_affiliations(countries_path, src_path, execute=args.execute)
