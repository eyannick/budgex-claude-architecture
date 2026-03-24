# routing-matrix.md
updated: 2026-03-24
status: active
owner: budgex-orchestrator

## Rôle du document

Cette matrice fournit une aide opérationnelle au routage des demandes Budgex.

Elle complète :
- `agents/agents-catalog.md` pour les rôles et règles globales ;
- `agents/budgex-orchestrator.md` pour la décision de délégation.

En cas de conflit, `agents/agents-catalog.md` et `agents/budgex-orchestrator.md` priment.

## Mots-clés → stream

| Signal principal | Stream | Delegate | Profil par défaut | Notes |
|---|---|---|---|---|
| entité, migration, repository, service, controller, voter, doctrine | backend | oui | safe / deep | `deep` si sécurité ou migration sensible |
| template, twig, css, js, bootstrap, responsive, layout, datatable | frontend | oui | fast / safe | front seulement |
| title, meta, canonical, robots, sitemap, indexation, og: | seo | oui | fast / safe | ne pas modifier la logique métier |
| tester, valider, QA, avant merge, couverture, lint | qa | oui | safe / deep | souvent post-spécialiste |
| virement, solde, budget, récurrence, modèle comptable, devise | finance | oui | fast / safe | consultatif par défaut |
| schéma, index, contrainte, SQL, EXPLAIN, cardinalité, normalisation, intégrité référentielle, locking, transaction DB, migration structurelle, requête complexe, performance requête | database | oui | safe / deep | `deep` si migration destructive ou risque structurel |
| expliquer, comparer, arbitrer, documenter, planifier | NO_DELEGATE | non | fast | réponse orchestrateur |

## Fichiers / zones → stream

| Zone | Stream principal | Stream secondaire possible |
|---|---|---|
| `src/Entity/` | backend | database (si enjeu structurel), qa |
| `src/Service/` | backend | qa |
| `src/Controller/` | backend | qa |
| `src/Form/` | backend | qa |
| `src/Repository/` | backend (logique) / database (requêtes complexes) | qa |
| `config/` | backend | qa |
| `migrations/` | backend (migration applicative courante) / database (migration structurelle, rollback, performance) | qa |
| `templates/` | frontend | seo |
| `assets/` | frontend | aucun |
| `public/robots.txt` | seo | aucun |
| `public/sitemap.xml` | seo | aucun |
| `.claude/memory/` | orchestrateur | aucun |

## Séquences multi-stream autorisées

| Situation | Décision |
|---|---|
| Feature touchant `src/` et `templates/` | `backend → frontend` |
| Ajustement UI avec impact SEO public | `frontend → seo` |
| Sécurité / auth / migration sensible | `backend (deep) → qa` |
| Nouvelle règle comptable | `finance → backend` |
| Nouvelle règle comptable avec impact UI | `finance → backend → frontend` |
| Question purement métier finance | `finance` ou `NO_DELEGATE` |
| Schéma / migration structurelle suivi d'implémentation app | `database → backend` |
| Migration destructive avant déploiement | `database (deep) → qa` |
| Feature applicative révélant un enjeu DB complexe | `backend → database` |
| Invariant comptable nécessitant modélisation DB | `finance → database → backend` |

## Note — chevauchement `migration` entre backend et database

- `migration` seul dans une feature Symfony courante → **backend**
- `migration` avec enjeux de schéma, performance, rollback ou volumétrie → **database**
- en cas de doute, l'orchestrateur arbitre selon la nature applicative ou structurelle du besoin

## Conditions de non-délégation

Ne pas déléguer si la demande est principalement :
- une explication ;
- un arbitrage ;
- une synthèse ;
- une décision de gouvernance agentique ;
- une création ou modification de directives utilisateur.