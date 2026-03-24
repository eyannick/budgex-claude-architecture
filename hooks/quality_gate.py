#!/usr/bin/env python3
"""
quality_gate.py — Hook Claude Code (v2)
Contrôle la présence des sections obligatoires et quelques incohérences sémantiques.
Usage : python .claude/hooks/quality_gate.py --event [Stop|SubagentStop]
"""

import argparse
import json
import os
import re
import sys
from pathlib import Path

REQUIRED_SECTIONS = {
    "Stop": [
        "ROUTING_DECISION",
        "PLAN",
        "ACTIONS",
        "RESULT",
        "BLOCKERS",
        "NEXT_STEP",
    ],
    "SubagentStop": [
        "STATUS",
        "SUMMARY",
        "FILES",
        "COMMANDS",
        "VALIDATION",
        "RISKS",
        "HANDOFF",
        "MEMORY_CANDIDATES",
        "CHECKLIST_RESULTS",
        "REFERENCES_USED",
    ],
}

WORKING_MARKERS = [
    "ROUTING_DECISION",
    "SINGLE_STREAM",
    "MULTI_STREAM",
    "NO_DELEGATE",
    "SCOPE_IN",
    "PLAN",
]

ALLOWED_STREAMS = {"backend", "frontend", "seo", "qa", "finance", "database"}


def get_last_response() -> str:
    if not sys.stdin.isatty():
        try:
            content = sys.stdin.read()
            if content.strip():
                return content
        except Exception:
            pass

    env_response = os.environ.get("CLAUDE_RESPONSE", "")
    if env_response:
        return env_response

    tmp_path = os.environ.get("CLAUDE_RESPONSE_FILE", "")
    if tmp_path and os.path.exists(tmp_path):
        try:
            return Path(tmp_path).read_text(encoding="utf-8")
        except Exception:
            pass
    return ""


def is_user_interruption() -> bool:
    return os.environ.get("CLAUDE_STOP_REASON", "") in {"user_interrupt", "stop_sequence", "user_stop"}


def is_working_response(content: str) -> bool:
    # Require markers as actual Markdown section headers (## MARKER), not just
    # mentioned in prose — prevents audit/maintenance responses from being
    # misclassified as orchestrator working responses.
    content_upper = content.upper()
    return sum(1 for marker in WORKING_MARKERS if f"## {marker}" in content_upper) >= 2


def section_present(content: str, name: str) -> bool:
    upper = content.upper()
    # Primary: strict Markdown header. Fallback: name at start of line followed
    # by colon (handles agents that omit ## but still structure by name).
    return f"## {name}" in upper or re.search(rf"^{name}:", upper, re.MULTILINE) is not None


def check_required_sections(content: str, event: str):
    missing = [s for s in REQUIRED_SECTIONS[event] if not section_present(content, s)]
    return missing


def extract_section(content: str, name: str) -> str:
    pattern = rf"(?is)^##\s+{re.escape(name)}\s*(.*?)\s*(?=^##\s+|\Z)"
    match = re.search(pattern, content, flags=re.MULTILINE)
    return match.group(1).strip() if match else ""


def semantic_checks(content: str, event: str):
    errors = []
    warnings = []

    if event == "Stop":
        routing = extract_section(content, "ROUTING_DECISION")
        text = routing.lower()
        if "profil" in text and "deep" in text and "qa" not in content.lower():
            errors.append("Profil deep détecté sans mention explicite de QA dans la réponse orchestrateur.")
        if "multi_stream" in content.lower() and "backend" in content.lower() and "frontend" in content.lower():
            if "backend" in content.lower() and "frontend" in content.lower() and "séquent" not in content.lower():
                warnings.append("Multi-stream backend/frontend sans mention explicite du séquencement.")

    if event == "SubagentStop":
        files = extract_section(content, "FILES")
        scope_in = os.environ.get("CLAUDE_SCOPE_IN", "")
        agent_type = os.environ.get("CLAUDE_AGENT_TYPE", "").lower()
        if scope_in and files:
            allowed = [x.strip() for x in scope_in.split("|") if x.strip()]
            for line in files.splitlines():
                if not line.strip() or line.strip().startswith("-") is False:
                    continue
                candidate = line.lstrip("- ").strip()
                if allowed and not any(candidate.startswith(prefix) or prefix in candidate for prefix in allowed):
                    errors.append(f"Fichier hors scope détecté dans FILES : {candidate}")
        if agent_type in ALLOWED_STREAMS:
            if agent_type == "seo" and re.search(r"src/|config/", files):
                errors.append("Le stream SEO ne doit pas modifier `src/` ou `config/` sans justification explicite.")
            if agent_type == "frontend" and re.search(r"src/Entity|src/Service|src/Repository", files):
                errors.append("Le stream frontend ne doit pas modifier le coeur backend sans handoff explicite.")
        memory = extract_section(content, "MEMORY_CANDIDATES")
        summary = extract_section(content, "SUMMARY").lower()
        if memory and memory.lower() not in {"aucun", "none", "néant"}:
            if any(token in summary for token in ["typo", "cosmétique", "lecture", "explication"]):
                warnings.append("MEMORY_CANDIDATES non vide sur une tâche probablement transitoire.")

    return errors, warnings


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--event", choices=["Stop", "SubagentStop"], required=True)
    args = parser.parse_args()

    if is_user_interruption():
        print("[quality_gate] interruption utilisateur — pass", file=sys.stderr)
        raise SystemExit(0)

    response = get_last_response()
    if not response.strip():
        print("[quality_gate] réponse introuvable — fail-open", file=sys.stderr)
        raise SystemExit(0)

    if args.event == "Stop" and not is_working_response(response):
        print("[quality_gate] réponse conversationnelle — contrôle ignoré", file=sys.stderr)
        raise SystemExit(0)

    missing = check_required_sections(response, args.event)
    semantic_errors, semantic_warnings = semantic_checks(response, args.event)

    if missing or semantic_errors:
        payload = {
            "event": args.event,
            "missing_sections": missing,
            "semantic_errors": semantic_errors,
            "semantic_warnings": semantic_warnings,
            "status": "BLOCKED",
        }
        log_dir = Path(".claude/ops/reports")
        log_dir.mkdir(parents=True, exist_ok=True)
        (log_dir / "quality-gate-last.json").write_text(
            json.dumps(payload, indent=2, ensure_ascii=False),
            encoding="utf-8",
        )
        print(json.dumps(payload, indent=2, ensure_ascii=False), file=sys.stderr)
        raise SystemExit(1)

    if semantic_warnings:
        print("[quality_gate] warnings: " + " | ".join(semantic_warnings), file=sys.stderr)

    print(f"[quality_gate] OK {args.event}", file=sys.stderr)
    raise SystemExit(0)


if __name__ == "__main__":
    main()
