# ARCHIVE — ADR retirées de la liste active

Ce fichier conserve les ADR retirées du `decision-log.md` actif.

Une ADR est archivée quand :
- sa règle est entièrement encodée dans un fichier source de vérité dédié ;
- l'action associée est confirmée terminée ;
- la maintenir dans la liste active n'apporte plus de valeur de gouvernance.

Un pointeur reste visible dans `decision-log.md` (section "ADR archivées").

---

## ADR-006 — Baseline QA officielle centralisée
Date archivage : 2026-05-11
Date origine : 2026-03-21
Raison archivage : règle entièrement couverte par `source-of-truth-map.md`
(ligne "Stack produit, baseline projet, baseline QA → memory/project-context.md").
Action confirmée terminée dans `archive/refonte-summary-2026-03.md` ("baseline QA corrigée").

Décision originale : une seule baseline QA officielle est maintenue dans `project-context.md`
et remplace toute valeur concurrente dans d'autres fichiers.
Raison originale : éviter les contradictions entre sources de vérité QA.
