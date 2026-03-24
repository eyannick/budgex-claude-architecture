# engineering-standards.md
updated: 2026-03-24
status: active

## Rôle du document

Ce document définit les standards techniques et conventions transverses du projet Budgex.

Il couvre :
- les conventions PHP / Symfony ;
- les conventions de structure ;
- les standards frontend ;
- les patterns UI établis ;
- les conventions Git.

Il ne remplace pas :
- les décisions d’architecture durables (`decision-log.md`) ;
- les règles de routing (`routing-matrix.md`, `agents-catalog.md`) ;
- les checklists de validation.

## Standards PHP / Symfony

- PSR-12 ;
- attributs PHP 8 ;
- pas de logique métier dans les contrôleurs ;
- services injectés par constructeur ;
- Voters pour l'autorisation par ressource ;
- `make:migration`, jamais `doctrine:schema:update --force` ;
- validation serveur obligatoire sur les entrées utilisateur.

## Standards de structure

- méthodes suffisamment courtes pour rester lisibles et testables ;
- une responsabilité par service autant que possible ;
- pas de SQL brut hors cas justifié ;
- requêtes via QueryBuilder, DQL ou repository dédié.

## Standards frontend

- Twig sans logique métier ;
- données et états préparés côté backend avant rendu ;
- WCAG 2.2 AA minimum comme cible ;
- `aria-label` sur tout bouton icon-only ;
- un seul `<h1>` principal par page ;
- pas de CSS inline sauf justification ;
- pas de `!important` sans justification.

## Patterns UI établis

- `card-header-icons`
- `page-header-row`
- `responsive-tables`
- `mobile-period-selector`

Toute régression de pattern doit être signalée dans `RISKS`.

## Standards Git

Format :

```text
type(scope): description courte