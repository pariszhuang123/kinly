import pathlib
import re
import sys


def main() -> int:
    base = pathlib.Path(".").resolve()
    roots = ("contracts", "coordination", "db", "docs")
    source_files = []
    for root in roots:
        root_path = base / root
        if not root_path.exists():
            continue
        source_files.extend(root_path.rglob("*.md"))
        source_files.extend(root_path.rglob("*.yml"))
        source_files.extend(root_path.rglob("*.yaml"))

    source_rel = sorted(
        {
            p.relative_to(base).as_posix()
            for p in source_files
            if p.name != "kinly_contracts_migration_map.md"
        }
    )

    map_path = base / "docs" / "engineering" / "kinly_contracts_migration_map.md"
    if not map_path.exists():
        sys.stderr.write("Missing migration map: docs/engineering/kinly_contracts_migration_map.md\n")
        return 1

    text = map_path.read_text(encoding="utf-8")
    arrow_re = re.compile(r"-\s+(\S[^\n]*?)\s+→\s+(\S[^\n]*)")

    mapped_sources = []
    for match in arrow_re.finditer(text):
        src = match.group(1).strip()
        if src.startswith(("docs/", "contracts/", "coordination/", "db/")):
            mapped_sources.append(src)

    mapped_set = set(mapped_sources)
    duplicates = [src for src in mapped_sources if mapped_sources.count(src) > 1]
    unmapped = [f for f in source_rel if f not in mapped_set]

    errors = []
    if duplicates:
        errors.append(f"Duplicate mappings for: {sorted(set(duplicates))}")
    if unmapped:
        errors.append(f"Unmapped files: {unmapped}")

    if errors:
        sys.stderr.write("doc migration map check failed:\n")
        for err in errors:
            sys.stderr.write(f" - {err}\n")
        return 1

    sys.stdout.write("doc migration map check passed\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
