# ARCHIVE — user-directives.md (migré 2026-05-11)

**Raison de l'archivage :** ce fichier contenait une copie tronquée de l'ancien `decision-log.md`
(ADR-001 à ADR-007, daté 2026-03-24, header `# decision-log.md`). Il ne contenait aucune
vraie directive utilisateur. Il a été remplacé par un `user-directives.md` correct.

**Action :** remplacé par `.claude/memory/user-directives.md` recréé le 2026-05-11.
**Décision :** Lot 0A — Sprint CSS — Mise en conformité visuelle et gouvernance design.

---

## Contenu original archivé (copie exacte)

# decision-log.md
updated: 2026-03-24
managed_by: orchestrator_only
format: ADR
max_active_entries: 15
status: active

### Rôle du document

Ce fichier conserve les décisions d'architecture et de gouvernance durables du système Budgex.

Il ne stocke pas :
- les directives utilisateur persistantes ;
- les priorités temporaires ;
- la roadmap active ;
- les détails transitoires de session.

### ADR-001 — Orchestrateur unique comme point d'entrée
Date : 2026-03-09 / Décision : un orchestrateur unique reçoit les demandes utilisateur et délègue si nécessaire.

### ADR-002 — Écriture mémoire réservée à l'orchestrateur
Date : 2026-03-09 / Décision : les spécialistes ne font que proposer des MEMORY_CANDIDATES.

### ADR-003 — SCOPE_IN nominatif obligatoire
Date : 2026-03-13 / Décision : toute délégation doit lister précisément les fichiers ou dossiers autorisés.

### ADR-004 — safe par défaut, deep pour sécurité et migration
Date : 2026-03-09 / Décision : le profil standard du système est safe.

### ADR-005 — Finance comme stream consultatif officiel
Date : 2026-03-21 / Décision : budgex-finance devient un stream officiel mais consultatif par défaut.

### ADR-006 — Baseline QA officielle centralisée
Date : 2026-03-21 / Décision : une seule baseline QA officielle est maintenue dans project-context.md.

### ADR-007 — Directives utilisateur persistantes séparées des ADR
Date : 2026-03-21 / Décision : toute règle durable demandée par l'utilisateur est stockée dans user-directives.md.
