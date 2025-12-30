import requests
import re
import time
import os
from packaging import version

# Configuration
INPUT_FILE = "current_versions.yaml"
REPORT_FILE = "dependency_report.txt"
UPDATED_YAML = "updated_versions.yaml"

def fetch_latest_pub(pkg):
    """Fetch the latest version from pub.dev API"""
    try:
        url = f"https://pub.dev/api/packages/{pkg}"
        r = requests.get(url, timeout=5)
        if r.status_code == 200:
            return r.json()['latest']['version']
        return None
    except:
        return None

def extract_highest_version(v_str):
    """Extracts the highest version number from a string (handles ^, +, and multiple versions)"""
    matches = re.findall(r'(\d+\.\d+\.\d+[\S]*)', v_str)
    if not matches:
        return version.parse("0.0.0")
    
    versions = []
    for m in matches:
        clean_v = m.replace('^', '').split('+')[0]
        try:
            versions.append(version.parse(clean_v))
        except:
            continue
    return max(versions) if versions else version.parse("0.0.0")

def run_update():
    # 1. Check if the input file exists
    if not os.path.exists(INPUT_FILE):
        print(f"❌ Error: '{INPUT_FILE}' not found in this folder!")
        return

    # 2. Read the file
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        lines = f.readlines()

    results = []
    new_yaml_content = []

    print(f"📖 Reading {INPUT_FILE}...")
    print(f"🚀 Checking pub.dev for updates...\n")

    for line in lines:
        stripped = line.strip()
        
        # Skip empty lines or comments
        if not stripped or stripped.startswith("#"):
            new_yaml_content.append(line.rstrip())
            continue

        # Parse "package_name: version"
        if ":" in stripped:
            parts = stripped.split(":", 1)
            pkg_name = parts[0].strip()
            current_v_str = parts[1].strip()

            # Clean version for comparison
            current_v_max = extract_highest_version(current_v_str)
            
            # Fetch from Web
            latest_pub = fetch_latest_pub(pkg_name)
            
            is_newer = False
            final_v_for_yaml = current_v_str # Default

            if latest_pub:
                try:
                    pub_v_parsed = version.parse(latest_pub.split('+')[0])
                    if pub_v_parsed > current_v_max:
                        is_newer = True
                        final_v_for_yaml = f"^{latest_pub}"
                except:
                    pass

            # Store result for table
            results.append({
                "icon": "🚀" if is_newer else "✅",
                "name": pkg_name,
                "current": current_v_str,
                "latest": latest_pub if is_newer else "-",
                "status": "UPDATE FOUND" if is_newer else "UP TO DATE"
            })

            # Prepare YAML line
            new_yaml_content.append(f"{pkg_name}: {final_v_for_yaml}")
            print(f"{'Updating' if is_newer else 'Checked'}: {pkg_name}")
            time.sleep(0.05)
        else:
            new_yaml_content.append(line.rstrip())

    # 3. Save the updated YAML file
    with open(UPDATED_YAML, "w", encoding="utf-8") as f_yaml:
        for l in new_yaml_content:
            f_yaml.write(l + "\n")

    # 4. Save and Display the Report Table
    col_fmt = "{:<5} | {:<30} | {:<20} | {:<15} | {:<15}"
    header = col_fmt.format("ICON", "DEPENDENCY", "YAML VERSION", "PUB.DEV LATEST", "STATUS")
    sep = "=" * 95

    with open(REPORT_FILE, "w", encoding="utf-8") as f_rep:
        def output(t):
            print(t)
            f_rep.write(t + "\n")

        output("\n" + sep)
        output(header)
        output(sep)
        
        # Sort so Updates are at the top
        for r in sorted(results, key=lambda x: x['status']):
            output(col_fmt.format(r['icon'], r['name'], r['current'][:20], r['latest'], r['status']))
        
        output(sep)

    print(f"\n✅ Process Finished!")
    print(f"📁 Generated: {UPDATED_YAML} (The new version file)")
    print(f"📁 Generated: {REPORT_FILE} (The comparison table)")

if __name__ == "__main__":
    try:
        run_update()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    
    print("\n" + "="*45)
    input("Press Enter to close this window...")