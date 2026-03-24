#!/usr/bin/env python3
"""
session_close_trigger.py
Détecte une macro de fin de session dans le prompt utilisateur
et injecte un rappel de procédure de clôture.
Ce hook n'exécute aucune action et ne remplace pas la source de vérité documentaire.
"""

import json
import sys


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        raise SystemExit(0)

    prompt = str(data.get("user_prompt") or "").lower().strip()

    if "fin de session, bonne nuit" in prompt or prompt == "fin de session" or "fin de session" in prompt:
        instructions = (
            "SESSION_CLOSE_TRIGGERED — Macro de fin de session reconnue. "
            "Appliquer la procédure officielle de clôture définie dans `memory/user-directives.md` "
            "et respecter les règles de l’orchestrateur. "
            "Ne jamais prétendre qu’un commit, un push ou une mise à jour mémoire a réussi si ce n’est pas vrai."
        )
        print(json.dumps({
            "hookSpecificOutput": {
                "hookEventName": "UserPromptSubmit",
                "additionalContext": instructions
            }
        }))

    raise SystemExit(0)


if __name__ == "__main__":
    main()