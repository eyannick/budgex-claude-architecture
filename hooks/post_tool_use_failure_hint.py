#!/usr/bin/env python3
"""
post_tool_use_failure_hint.py — hook d'aide après échec outil.
Non bloquant, purement informatif.
"""

import json
import sys


def choose_bash_hint(payload: dict) -> str:
    error_text = " ".join(
        str(payload.get(k, "")) for k in ("stderr", "error", "message")
    ).lower()

    if "command not found" in error_text:
        return "Échec Bash détecté : commande introuvable. Vérifier la dépendance, le PATH et le répertoire courant avant de réessayer."
    if "no such file or directory" in error_text:
        return "Échec Bash détecté : fichier ou chemin introuvable. Vérifier le répertoire courant, les chemins relatifs et le scope avant de réessayer."
    if "permission denied" in error_text:
        return "Échec Bash détecté : permission refusée. Vérifier les permissions, le scope et si l’action est autorisée avant de réessayer."

    return "Échec Bash détecté : vérifier le scope, le répertoire courant, les dépendances et les permissions avant de réessayer."


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        raise SystemExit(0)

    tool_name = payload.get("tool_name", "")
    if tool_name == "Bash":
        print(choose_bash_hint(payload), file=sys.stderr)

    raise SystemExit(0)


if __name__ == "__main__":
    main()