# evals/ — Système d'évaluation du routage et de la discipline orchestrateur

Permet de vérifier que `budgex-orchestrator` :
- route correctement les requêtes ;
- respecte les règles du playbook ;
- applique correctement les formats et garde-fous attendus.

---

## Workflow

```text
1. Soumettre la requête de `eval-cases.json` à Claude Code (orchestrateur)
2. Copier la réponse brute dans `evals/responses/[id].txt`
3. Lancer `run-evals.ps1` pour scorer automatiquement
4. Consulter le rapport dans `evals/results/`