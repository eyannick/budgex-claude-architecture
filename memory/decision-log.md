# decision-log.md
updated: 2026-03-24
managed_by: orchestrator_only
format: ADR
max_active_entries: 15
status: active

## Rôle du document

Ce fichier conserve les décisions d’architecture et de gouvernance durables du système Budgex.

Il ne stocke pas :
- les directives utilisateur persistantes ;
- les priorités temporaires ;
- la roadmap active ;
- les détails transitoires de session.

## ADR-001 — Orchestrateur unique comme point d'entrée
Date : 2026-03-09
Statut : Actif
Décision : un orchestrateur unique reçoit les demandes utilisateur et délègue si nécessaire.
Raison : cohérence des réponses, contrôle de la mémoire, limitation du scope drift.

## ADR-002 — Écriture mémoire réservée à l'orchestrateur
Date : 2026-03-09
Statut : Actif
Décision : les spécialistes ne font que proposer des `MEMORY_CANDIDATES`.
Raison : éviter la dérive contextuelle et les doublons.

## ADR-003 — `SCOPE_IN` nominatif obligatoire
Date : 2026-03-13
Statut : Actif
Décision : toute délégation doit lister précisément les fichiers ou dossiers autorisés.
Raison : réduire les effets de bord.

## ADR-004 — `safe` par défaut, `deep` pour sécurité et migration
Date : 2026-03-09
Statut : Actif
Décision : le profil standard du système est `safe`.
Raison : compromis robustesse / vitesse.

## ADR-005 — Finance comme stream consultatif officiel
Date : 2026-03-21
Statut : Actif
Décision : `budgex-finance` devient un stream officiel mais consultatif par défaut.
Raison : clarifier les règles comptables sans le laisser coder directement.

## ADR-006 — Baseline QA officielle centralisée
Date : 2026-03-21
Statut : Actif
Décision : une seule baseline QA officielle est maintenue dans `project-context.md` et remplace toute valeur concurrente dans d'autres fichiers.
Raison : éviter les contradictions entre sources de vérité.

## ADR-007 — Directives utilisateur persistantes séparées des ADR
Date : 2026-03-21
Statut : Actif
Décision : toute règle durable demandée par l'utilisateur est stockée dans `user-directives.md` et non dans le `decision-log`.
Raison : séparer gouvernance technique et habitudes opératoires utilisateur.