#!/usr/bin/env python3
"""
reference_freshness.py — Hook Claude Code
Vérifie l'ancienneté des packs de référence actifs.
Signal informatif uniquement, non bloquant.
"""

import sys
from datetime import date, datetime, timedelta
from pathlib import Path

REFERENCE_FILES = [
    Path(".claude/references/reference-pack-core.md"),
    Path(".claude/references/reference-pack-database.md"),
    Path(".claude/references/reference-pack-frontend.md"),
    Path(".claude/references/reference-pack-seo.md"),
]

FRESHNESS_DAYS = 45
DATE_TAG = "updated:"


def extract_date(path: Path):
    try:
        for line in path.read_text(encoding="utf-8").splitlines():
            if line.strip().lower().startswith(DATE_TAG):
                value = line.split(":", 1)[1].strip()
                return datetime.strptime(value, "%Y-%m-%d").date()
    except Exception:
        return None
    return None


def main():
    today = date.today()
    warnings = []

    for ref in REFERENCE_FILES:
        if not ref.exists():
            warnings.append(f"{ref} introuvable")
            continue

        updated = extract_date(ref)
        if not updated:
            warnings.append(f"date introuvable dans {ref}")
            continue

        age = today - updated
        if age > timedelta(days=FRESHNESS_DAYS):
            warnings.append(f"{ref} âgé de {age.days} jours")

    if warnings:
        print("[reference_freshness] warnings: " + " | ".join(warnings), file=sys.stderr)
    else:
        print("[reference_freshness] OK", file=sys.stderr)

    raise SystemExit(0)


if __name__ == "__main__":
    main()