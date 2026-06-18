# Source of Truth Map — Budgex
updated: 2026-06-18 (LOT-DOC-UIUX-001 · archivage campagnes closes + confirmation doctrine UI/UX)
owner: budgex-orchestrator
status: active

## Rôle du document

Ce document définit où vit la vérité primaire pour chaque type d'information structurante du système Claude Budgex.

Objectif :
- éviter les doublons ;
- éviter les contradictions ;
- réduire les coûts d'orchestration ;
- empêcher qu'une même règle vive entièrement dans plusieurs fichiers.

## Définitions

- **Source primaire** : fichier de référence unique où la règle, la structure ou la vérité complète doit être maintenue.
- **Source secondaire autorisée** : fichier pouvant résumer, référencer ou appliquer la source primaire sans la redéfinir complètement.
- **Interdiction de duplication** : un fichier listé dans cette colonne ne doit pas contenir une seconde version complète ou concurrente de la même vérité.

## Carte des sources de vérité

| Sujet | Source primaire | Source secondaire autorisée | À ne pas dupliquer dans |
|---|---|---|---|
| Packaging / Pricing (arbitrages produit Free–Premium–Premium+) | `memory/product-pricing-spec.md` | `memory/decision-log.md` (ADR-008), `memory/project-context.md` (pointeur court) | `memory/roadmap.md`, agents, prompts |
| Entitlements / Capabilities (architecture technique) | `memory/entitlements-spec.md` | `memory/product-pricing-spec.md` (source des arbitrages produit) | agents, prompts, controllers |
| Rôles, périmètres et positionnement des agents | `agents/agents-catalog.md` | `playbooks/agent-team-playbook.md` | prompts spécialistes |
| Comportement détaillé de l’orchestrateur | `agents/budgex-orchestrator.md` | `agents/agents-catalog.md` | `playbooks/agent-team-playbook.md` |
| Comportement détaillé d’un agent spécialisé | `agents/<agent>.md` | `agents/agents-catalog.md` | `playbooks/agent-team-playbook.md`, autres prompts agents |
| Routing global entre agents | `agents/agents-catalog.md` | `agents/budgex-orchestrator.md` | prompts spécialistes, `memory/active-focus.md` |
| Sélection opérationnelle du mode `NO_DELEGATE / SINGLE_STREAM / MULTI_STREAM` | `agents/budgex-orchestrator.md` | aucune | `agents/agents-catalog.md`, prompts spécialistes |
| Profils `fast/safe/deep` | `memory/execution-profiles.md` | `playbooks/agent-team-playbook.md` | prompts spécialistes |
| Standards de code / conventions projet (PHP, Git, structure, règles frontend non-design) | `memory/engineering-standards.md` | checklists | `memory/project-context.md`, prompts — ⚠ pour la doctrine design system, voir `references/budgex-visual-bible.md` |
| Guardrails d'erreurs | `memory/error-guardrails.md` | checklists, hooks | `memory/decision-log.md`, prompts |
| Stack produit, baseline projet, baseline QA | `memory/project-context.md` | checklists QA, `references/reference-pack-core.md` | `memory/active-focus.md`, prompts |
| Priorités actives court terme | `memory/active-focus.md` | `memory/open-risks.md` | `memory/project-context.md`, `memory/decision-log.md` |
| Décisions d'architecture et arbitrages durables | `memory/decision-log.md` | `memory/project-context.md` si impact global stabilisé | `memory/user-directives.md`, prompts |
| Directives utilisateur persistantes | `memory/user-directives.md` | aucune | `memory/decision-log.md`, prompts — ⚠ recréé 2026-05-11 (Lot 0A), ancien contenu archivé |
| Risques ouverts et points de vigilance | `memory/open-risks.md` | `memory/active-focus.md`, rapports ops | `memory/project-context.md` |
| Références techniques core | `references/reference-pack-core.md` | packs spécialisés | prompts |
| Références techniques base de données | `references/reference-pack-database.md` | `references/reference-pack-core.md` | prompts |
| Références techniques frontend | `references/reference-pack-frontend.md` | `references/reference-pack-core.md` | prompts |
| Références techniques SEO | `references/reference-pack-seo.md` | `references/reference-pack-core.md` | prompts |
| Doctrine visuelle & design system (tokens, layout, composants, règles UI) | `references/budgex-visual-bible.md` | `memory/engineering-standards.md` (règles intégration code uniquement) · `checklists/frontend-checklist.md` (application uniquement) | prompts agents, feuilles CSS métier, templates Twig — jamais redéfinir en local |
| Architecture CSS zone auth (layout, _auth.css, dépendance styles.css assumée) | `memory/decision-log.md` ADR-024 | `memory/engineering-standards.md` §Architecture CSS (tableau chargement + règles d'ajout) | `app.css`, `components.css` — ne pas importer dans le layout auth |
| Doctrine flash/toast (implémentation Symfony, aria, noscript, API JS, tests) | `references/budgex-flash-toast-doctrine.md` | `references/budgex-visual-bible.md` §9 (règles visuelles uniquement) · `memory/engineering-standards.md` | prompts agents, templates, contrôleurs — règle d'unicité app.flashes stricte |
| Références techniques billing Stripe | `references/reference-pack-billing.md` | `references/reference-pack-core.md` | prompts, `.env`, agents |
| Secrets Stripe (noms de variables) | `references/reference-pack-billing.md` §Variables | aucune | `.env`, templates, prompts, commits |
| Source documentaire Stripe | `references/reference-pack-billing.md` §Source | aucune | partout — https://docs.stripe.com/ uniquement |
| Configuration légale et marketing affichée (mentions légales, prix affiché, éditeur, hébergeur, email, durées) | `LegalConfig` entity + `/admin/legal-settings` | `memory/decision-log.md` (ADR-019) | templates Twig — lire via `legal_config` global uniquement · ne jamais exposer les Price IDs Stripe |
| Procédures d’équipe et workflow opératoire | `playbooks/agent-team-playbook.md` | aucune | prompts agents, `agents/agents-catalog.md` |
| Répartition des tâches Claude ↔ Codex | `docs/codex/codex-claude-handoff.md` | `AGENTS.md` (résumé des rôles) | `.claude/memory/`, prompts agents |
| Contrôles détaillés par spécialité | `checklists/<specialty>-checklist.md` | `memory/engineering-standards.md`, `memory/error-guardrails.md` | prompts agents, `memory/project-context.md` |
| Rôle et responsabilité des hooks | `CLAUDE.md` | scripts hooks eux-mêmes | prompts agents, `memory/decision-log.md` |
| Protocole d’évaluation | `evals/README.md` | `ops/reports/` | prompts agents, `memory/project-context.md` |
| Cas d’évaluation | `evals/eval-cases.json` | `ops/reports/` | prompts agents, `memory/project-context.md` |

## Doctrine UI/UX — sources actives vs historiques (LOT-DOC-UIUX-001 · 2026-06-18)

Suite à l'audit `AUDIT-DOCTRINE-UI-UX-BUDGEX`, confirmation explicite du périmètre de la doctrine UI/UX.

**Sources doctrinales actives (UI/UX) :**
- `memory/decision-log.md` (ADR)
- `references/budgex-visual-bible.md`
- `references/budgex-flash-toast-doctrine.md`
- `memory/engineering-standards.md`
- `memory/user-directives.md`
- `checklists/frontend-checklist.md`
- `checklists/qa-checklist.md`
- `memory/roadmap.md`
- `memory/open-risks.md`

**Sources historiques archivées (2026-06-18) :**
- `archive/campaigns/2026-06-18/visual-campaigns/`
- `archive/campaigns/2026-06-18/code-campaigns/`
- `archive/campaigns/2026-06-18/css-campaigns/`

Voir `archive/campaigns/2026-06-18/README.md` pour le détail (raison, HEAD de clôture, mapping vers les sources vivantes).

**Règle explicite :** les campagnes archivées peuvent servir à l'historique et à la traçabilité (comprendre une décision passée, retrouver le détail d'une anomalie corrigée), mais ne doivent plus être utilisées comme source primaire ou secondaire de doctrine UI/UX active dans les futurs prompts Claude/Codex.

## Règles d'application

- Une information stable ne doit jamais exister comme vérité complète dans deux fichiers différents.
- Une source secondaire peut résumer, référencer ou appliquer une source primaire, mais ne doit pas la redéfinir.
- Un prompt agent ne doit jamais devenir la source primaire d’une règle transverse.
- Les fichiers `memory/` servent au contexte vivant, aux décisions, aux risques et aux directives ; ils ne doivent pas absorber la gouvernance entière du système.
- Les `playbooks/` décrivent la méthode et les workflows ; ils ne doivent pas remplacer le catalogue des rôles.
- Les `checklists/` contrôlent l’exécution ; elles ne doivent pas redéfinir les missions des agents.
- En cas de conflit entre deux fichiers, la source primaire listée ici l’emporte.

## Règle absolue

Une information stable ne doit jamais exister comme vérité complète dans deux fichiers différents.