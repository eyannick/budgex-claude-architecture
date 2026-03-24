# agents-catalog.md
updated: 2026-03-24
status: active
owner: budgex-orchestrator

## Rôle du document

Ce document est la source de vérité pour :
- les rôles des agents ;
- leur périmètre ;
- les règles globales de routing ;
- les handoffs naturels ;
- les anti-patterns d'orchestration.

Ce document ne définit pas le comportement détaillé interne de chaque agent.
Le comportement détaillé de chaque agent appartient à son fichier dédié.

## Règles globales

- `budgex-orchestrator` est le seul point d’entrée conversationnel du système.
- `budgex-orchestrator` est le seul agent autorisé à répondre directement à l’utilisateur.
- `budgex-orchestrator` est le seul agent autorisé à écrire dans `memory/`.
- Les autres agents interviennent uniquement en analyse, exécution spécialisée ou validation selon leur périmètre.
- Un agent ne doit pas sortir de son périmètre principal sans handoff explicite.
- En cas de sujet mixte, l’orchestrateur choisit un agent leader et consulte d’autres agents seulement si cela apporte un gain réel.
- Le système doit privilégier la solution la plus simple, la plus robuste et la moins coûteuse en orchestration.
- `MULTI_STREAM` ne doit jamais être utilisé si `SINGLE_STREAM` suffit.
- Deux agents ne doivent jamais travailler en parallèle sur le même fichier.

## Typologie des rôles

- **Orchestrator** : classifie, route, arbitre, synthétise, répond à l’utilisateur, gère la mémoire.
- **Operational agent** : lit, modifie, implémente sur un périmètre technique précis.
- **Advisor** : analyse, recommande, challenge, mais n’écrit pas par défaut.
- **Future** : rôle envisagé mais non encore activé.

## Catalogue des agents

| Agent | Type | Périmètre principal | À appeler quand | À ne pas appeler quand | Niveau d’écriture | Handoff naturel | Notes |
|---|---|---|---|---|---|---|---|
| `budgex-orchestrator` | Orchestrator | routing, arbitrage, mémoire, synthèse, gouvernance | toujours en entrée ; tout sujet transverse ; besoin de choisir un agent ; besoin de réponse utilisateur | jamais comme spécialiste unique sur une tâche profonde relevant clairement d’un autre agent | mémoire uniquement | tous | responsable de la réponse finale et de l’arbitrage |
| `budgex-backend` | Operational agent | PHP, Symfony, Doctrine, services, contrôleurs, formulaires, logique applicative | sujet dans `src/`, `config/`, services, contrôleurs, formulaires, logique applicative Symfony | demande purement explicative, design UI pur, stratégie DB structurelle, cadrage métier financier pur | écriture complète sur périmètre | `budgex-database`, `budgex-finance`, `budgex-qa` | ne met pas de logique métier dans Twig |
| `budgex-frontend` | Operational agent | Twig, assets, JS UI, responsive, accessibilité, structure visuelle | sujet dans `templates/`, `assets/`, composants UI, tables, filtres visuels, responsive, accessibilité | logique métier backend, calcul financier, structure DB, arbitrage produit seul | écriture complète sur périmètre | `budgex-backend`, `budgex-qa` | n’introduit pas de calcul métier dans Twig |
| `budgex-database` | Operational agent | schéma, SQL, index, contraintes, intégrité, migrations, performance requêtes | migration structurelle, requête complexe, performance DB, contrainte d’intégrité, modèle relationnel | sujet purement contrôleur, formulaire simple, UI, wording métier | écriture structurelle sur périmètre DB | `budgex-backend`, `budgex-finance`, `budgex-qa` | consultatif par défaut ; opérationnel si enjeu DB structurel |
| `budgex-qa` | Operational agent | validation transversale, non-régression, contrôle qualité, preuve | avant merge, après implémentation, audit qualité, validation d’un changement sensible | implémentation initiale, simple explication sans besoin de contrôle | lecture seule par défaut ; écriture si explicitement demandée | tous | priorité à la preuve, pas aux suppositions |
| `budgex-finance` | Advisor | règles métier financières, cohérence comptable, invariants, edge cases pertinents | budget, solde, virement, récurrence, devise, épargne, arbitrage métier financier | design UI pur, implémentation technique pure, SEO, cosmétique frontend | consultatif par défaut | `budgex-backend`, `budgex-database` | formalise les règles métier ; n’implémente pas par défaut |
| `budgex-seo` | Operational agent | SEO technique public, métadonnées, canonical, robots, sitemap, Open Graph | pages publiques, metadata, indexation, signaux SEO techniques | auth, pages privées, logique métier, sécurité applicative | écriture limitée sur périmètre | `budgex-frontend`, `budgex-backend`, `budgex-qa` | `/app/` et `/admin/` restent toujours `noindex,nofollow` |
| `ui-ux-advisor` | Future advisor | ergonomie, hiérarchie visuelle, lisibilité, parcours, densité d’interface | dashboard, onboarding, tableaux, filtres, friction utilisateur | logique métier, persistance, sécurité, backend | lecture seule | `budgex-frontend`, `budgex-orchestrator` | rôle conseillé ; à activer si les standards UI sont formalisés |
| `security-advisor` | Future advisor | auth, rôles, permissions, session, exposition de données, durcissement | auth, session, contrôle d’accès, actions sensibles, surfaces d’attaque | UI simple, cosmétique frontend, sujet purement éditorial | lecture seule | `budgex-backend`, `budgex-qa`, `budgex-database` | utile avant merge sur sujets sensibles |

## Règles de routing prioritaires

### Sujet mono-périmètre
- UI / Twig / assets / responsive / accessibilité → `budgex-frontend`
- Symfony / Doctrine / services / contrôleurs / logique applicative → `budgex-backend`
- schéma / migration / SQL / index / performance requête → `budgex-database`
- règles comptables / cohérence métier financière → `budgex-finance`
- SEO public / métadonnées / indexation → `budgex-seo`
- validation / contrôle / non-régression → `budgex-qa`

### Sujet mixte
- Finance + backend → `budgex-finance` en cadrage, `budgex-backend` en exécution
- Database + backend → `budgex-database` sur la structure, `budgex-backend` sur l’intégration applicative
- Frontend + backend → agent leader selon le défaut principal ; second agent seulement si nécessaire
- Frontend + QA → `budgex-frontend` en exécution, `budgex-qa` en validation
- Backend + QA → `budgex-backend` en exécution, `budgex-qa` en validation
- SEO + frontend → `budgex-seo` sur la stratégie SEO technique, `budgex-frontend` sur l’exécution de template
- Sujet ambigu ou transverse → `budgex-orchestrator` arbitre et découpe

## Règles d’escalade

- Toute modification impactant données, soldes, virements, récurrence, devise ou intégrité comptable doit pouvoir être relue par `budgex-finance` ou `budgex-database` selon le cas.
- Toute modification structurelle DB doit pouvoir passer par `budgex-database`.
- Toute modification transverse significative ou à risque de régression doit pouvoir passer par `budgex-qa`.
- Toute ambiguïté produit, conflit entre spécialistes ou tension de périmètre remonte à `budgex-orchestrator`.

## Anti-patterns à éviter

- Sur-orchestrer une demande simple.
- Lancer `MULTI_STREAM` par confort ou par habitude.
- Envoyer un sujet métier financier directement au frontend.
- Laisser le backend arbitrer seul une migration structurelle complexe.
- Utiliser `budgex-qa` comme agent d’implémentation primaire.
- Demander au SEO de modifier la logique métier.
- Confondre advisor consultatif et agent opérationnel.
- Répondre à l’utilisateur depuis un agent autre que `budgex-orchestrator`.
- Maintenir la même règle de gouvernance dans plusieurs fichiers si une seule source de vérité suffit.