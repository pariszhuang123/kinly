#!/usr/bin/env python3
import argparse
import fnmatch
import os
import sys


def matches_any(path, patterns):
    norm = path.replace("\\", "/")
    return any(fnmatch.fnmatch(norm, pat) for pat in patterns)


def parse_lcov(lcov_path):
    if not os.path.exists(lcov_path):
        print(f"Coverage file not found: {lcov_path}")
        return {}
    files = {}
    current = None
    with open(lcov_path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if line.startswith("SF:"):
                current = line[3:]
                files[current] = {"found": 0, "hit": 0}
            elif line.startswith("DA:") and current:
                try:
                    _, data = line.split(":", 1)
                    _lineno, hits = data.split(",")
                    hits = int(hits)
                    files[current]["found"] += 1
                    if hits > 0:
                        files[current]["hit"] += 1
                except Exception:
                    # ignore malformed lines
                    pass
            elif line == "end_of_record":
                current = None
    return files


def main():
    parser = argparse.ArgumentParser(description="Verify Flutter coverage gates")
    parser.add_argument("--lcov", default="coverage/lcov.info")
    parser.add_argument("--overall-min", type=float, default=95.0)
    args = parser.parse_args()

    exclude_globs = [
        "**/*.g.dart",
        "**/*.freezed.dart",
        "lib/l10n/**",
        "**/generated_plugin_registrant.dart",
        "lib/core/design_system/**",
    ]
    strict_globs = [
        "lib/features/*/bloc/**.dart",
        "lib/features/*/repositories/**.dart",
    ]

    files = parse_lcov(args.lcov)
    if not files:
        print("No coverage data parsed.")
        return 1

    total_found = 0
    total_hit = 0
    strict_failures = []

    for path, stats in files.items():
        if matches_any(path, exclude_globs):
            continue
        found = stats["found"]
        hit = stats["hit"]
        # overall aggregation
        total_found += found
        total_hit += hit
        # strict per-layer gate: require 100% for bloc/repositories
        if found > 0 and matches_any(path, strict_globs):
            if hit < found:
                pct = (hit / found) * 100.0
                strict_failures.append((path, found, hit, pct))

    overall_pct = (total_hit / total_found) * 100.0 if total_found else 0.0
    ok = True

    if strict_failures:
        ok = False
        print("Per-layer coverage failures (require 100% for bloc/repositories):")
        for path, found, hit, pct in strict_failures:
            print(f" - {path}: {hit}/{found} lines ({pct:.2f}%)")

    if overall_pct + 1e-9 < args.overall_min:
        ok = False
        print(
            f"Overall coverage {overall_pct:.2f}% is below minimum {args.overall_min:.2f}%"
        )
    else:
        print(f"Overall coverage OK: {overall_pct:.2f}% >= {args.overall_min:.2f}%")

    return 0 if ok else 2


if __name__ == "__main__":
    sys.exit(main())

