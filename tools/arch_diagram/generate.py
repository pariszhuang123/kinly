import os
import re
import argparse
import sys
# import yaml (Removed to avoid dependency)
from pathlib import Path
from collections import defaultdict

# --- Configuration ---
ROOT_DIR = Path.cwd()
LIB_DIR = ROOT_DIR / "lib"
DOCS_DIR = ROOT_DIR / "docs" / "architecture"
CONTRACTS_DIR = ROOT_DIR / "contracts" / "architecture"
CONFIG_MODULES = ["features", "foundation", "core", "contracts", "app", "data"]
LAYER_ORDER = ["main", "app", "foundation", "features", "core", "contracts", "generated", "renderer", "other"]

# --- Regex Patterns ---
IMPORT_PATTERN = re.compile(r"import\s+['\"]package:kinly/(.*?)['\"]")
DI_REGISTER_PATTERN = re.compile(r"(registerLazySingleton|registerSingleton|registerFactory)\s*<([^>]+)>")

# --- Data Structures ---
modules = set()
dependencies = defaultdict(set)
di_registrations = defaultdict(list)
capabilities_map = {}  # Module -> Bucket


def get_module_name(file_path: Path):
    try:
        relative_path = file_path.relative_to(LIB_DIR)
        parts = relative_path.parts
        if not parts:
            return "main.dart"

        top_level = parts[0]
        if top_level == "main.dart":
            return "main.dart"

        if top_level in CONFIG_MODULES:
            if len(parts) > 1:
                return f"{top_level}.{parts[1]}"
            return top_level

        if top_level == "generated":
            return "generated"

        if "renderer" in top_level:
            return "renderer"

        return top_level
    except ValueError:
        return None


def get_module_name_from_import(import_path: str):
    parts = import_path.split("/")
    if not parts:
        return None

    top_level = parts[0]
    if top_level in CONFIG_MODULES:
        if len(parts) > 1:
            return f"{top_level}.{parts[1]}"
        return top_level

    if top_level == "generated":
        return "generated"

    return top_level


def parse_simple_yaml(content: str):
    """
    Very basic YAML parser for our specific structure:
    buckets:
      NAME:
        - item
    """
    data = {"buckets": {}}
    current_bucket = None

    lines = content.split("\n")
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#"):
            continue

        if line == "buckets:":
            continue

        if line.endswith(":"):
            # It's a key, likely a bucket name
            key = line[:-1]
            if key != "buckets":
                current_bucket = key
                data["buckets"][current_bucket] = []
        elif line.startswith("- ") and current_bucket:
            # List item
            val = line[2:].strip()
            data["buckets"][current_bucket].append(val)

    return data


def load_capabilities_map():
    yaml_path = CONTRACTS_DIR / "business_capabilities_map.yml"
    if not yaml_path.exists():
        print(f"Warning: {yaml_path} not found. Skipping Business Map.")
        return False

    try:
        with open(yaml_path, "r", encoding="utf-8") as f:
            content = f.read()
            data = parse_simple_yaml(content)

        buckets = data.get("buckets", {})
        for bucket, mods in buckets.items():
            for m in mods:
                capabilities_map[m] = bucket
        return True
    except Exception as e:
        print(f"Error loading YAML: {e}")
        return False


def scan_files():
    print(f"Scanning {LIB_DIR}...")
    for root, dirs, files in os.walk(LIB_DIR):
        # deterministic walk order
        dirs.sort()
        files.sort()

        for file in files:
            if not file.endswith(".dart"):
                continue

            file_path = Path(root) / file
            current_module = get_module_name(file_path)
            if not current_module:
                continue

            modules.add(current_module)

            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            imports = IMPORT_PATTERN.findall(content)
            for imp in imports:
                target_module = get_module_name_from_import(imp)
                if target_module and target_module != current_module:
                    dependencies[current_module].add(target_module)

            di_matches = DI_REGISTER_PATTERN.findall(content)
            for _, registered_type in di_matches:
                di_registrations[current_module].append(registered_type.strip())


def sanitize_id(raw_label: str):
    safe = raw_label.replace(".", "_").replace("-", "_")
    safe = re.sub(r"[^A-Za-z0-9_]", "", safe)
    if safe and safe[0].isdigit():
        safe = "m_" + safe
    return safe


def classify_layer(module_name: str):
    if module_name == "main.dart":
        return "main"
    if module_name == "generated":
        return "generated"

    parts = module_name.split(".")
    top = parts[0]
    if top in LAYER_ORDER:
        return top
    if "renderer" in top:
        return "renderer"
    return "other"


def handle_output(path: Path, content: str, check_mode: bool):
    path.parent.mkdir(parents=True, exist_ok=True)
    content = content.replace("\r\n", "\n")

    if check_mode:
        if not path.exists():
            print(f"FAIL: {path} is missing.")
            return False
        with open(path, "r", encoding="utf-8") as f:
            existing = f.read().replace("\r\n", "\n")
        if existing != content:
            print(f"FAIL: {path} is out of date.")
            return False
        print(f"PASS: {path} is up to date.")
        return True

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Generated {path}")
    return True


def generate_di_graph_md(check_mode: bool = False):
    layer_map = defaultdict(list)
    for m in modules:
        layer = classify_layer(m)
        layer_map[layer].append(m)

    lines = ["```mermaid", "graph LR"]
    for layer in LAYER_ORDER:
        mods = sorted(layer_map.get(layer, []))
        if not mods:
            continue
        grp_id = f"{layer}_grp"
        lines.append(f"  subgraph {grp_id} [{layer}]")
        for m in mods:
            node_id = sanitize_id(m)
            lines.append(f"    {node_id}[\"{m}\"]")
        lines.append("  end")

    all_edges = []
    for source, targets in dependencies.items():
        src_id = sanitize_id(source)
        for target in targets:
            tgt_id = sanitize_id(target)
            all_edges.append((src_id, tgt_id))
    all_edges.sort()

    for src, tgt in all_edges:
        lines.append(f"  {src} --> {tgt}")

    lines.append("```")
    return handle_output(DOCS_DIR / "di_graph.md", "\n".join(lines), check_mode)


def generate_business_map(check_mode: bool = False):
    if not capabilities_map:
        return True  # Fail gracefully if loading failed

    unmapped = []
    bucket_map = defaultdict(list)

    for m in sorted(modules):
        if m not in capabilities_map:
            unmapped.append(m)
        else:
            bucket = capabilities_map[m]
            bucket_map[bucket].append(m)

    if unmapped:
        print("\nERROR: The following modules are not mapped in business_capabilities_map.yml:")
        for m in unmapped:
            print(f" - {m}")
        # Always return false on drift
        return False

    lines = []
    lines.append("```mermaid")
    lines.append("%% Auto-generated from di_graph.md")
    lines.append("%% Do not edit manually")
    lines.append("%% Edit business_capabilities_map.yml instead")
    lines.append("graph LR")

    for bucket in sorted(bucket_map.keys()):
        mods = sorted(bucket_map[bucket])
        grp_id = f"{sanitize_id(bucket)}_grp"
        lines.append(f"  subgraph {grp_id} [{bucket}]")
        for m in mods:
            node_id = sanitize_id(m)
            lines.append(f"    {node_id}[\"{m}\"]")
        lines.append("  end")

    all_edges = []
    for source, targets in dependencies.items():
        if source in capabilities_map and all(t in capabilities_map for t in targets):
            src_id = sanitize_id(source)
            for target in targets:
                tgt_id = sanitize_id(target)
                all_edges.append((src_id, tgt_id))
    all_edges.sort()

    for src, tgt in all_edges:
        lines.append(f"  {src} --> {tgt}")

    lines.append("```")
    output_path = CONTRACTS_DIR / "business_map.md"
    return handle_output(output_path, "\n".join(lines), check_mode)


def generate_report_md(check_mode: bool = False):
    report = ["# Architecture Report"]
    report.append(f"\n- **Modules**: {len(modules)}")
    report.append(f"- **DI Registrations**: {sum(len(v) for v in di_registrations.values())}")

    report.append("\n## Modules List")
    for m in sorted(modules):
        report.append(f"- {m}")

    return handle_output(DOCS_DIR / "report.md", "\n".join(report), check_mode)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate architecture diagrams.")
    parser.add_argument("--check", action="store_true", help="Fail if diagrams are outdated")
    args = parser.parse_args()

    map_loaded = load_capabilities_map()
    scan_files()

    results = [
        generate_di_graph_md(args.check),
        generate_report_md(args.check),
        generate_business_map(args.check) if map_loaded else False,
    ]

    if not all(results):
        sys.exit(1)
