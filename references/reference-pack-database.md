# Reference Pack — Database
updated: 2026-03-24

Charger uniquement pour une tâche base de données, SQL, schéma ou migration.

## Rôle du document

Ce pack fournit le contexte technique DB du projet et les références externes prioritaires à consulter pour toute tâche liée au schéma, aux migrations, aux requêtes SQL ou à la performance base de données.

## Stack DB du projet

| Composant | Version / règle |
|---|---|
| MySQL | 8.x |
| Doctrine ORM | 3.x |
| Doctrine Migrations | version pilotée par le projet via `composer.json` |
| Storage engine | InnoDB obligatoire (dev, test, prod) |

## Points d’attention projet

- vérifier les versions effectives dans `composer.json` avant toute consultation externe ;
- privilégier les migrations générées via `php bin/console make:migration` ;
- ne jamais utiliser `doctrine:schema:update --force` comme mécanisme de mise à jour de schéma projet ;
- vérifier explicitement les index utiles sur colonnes de jointure et de filtrage ; ne pas supposer qu’un mapping ou une FK couvre automatiquement tous les besoins de requête ;
- analyser le plan d’exécution (`EXPLAIN`) avant et après toute modification sensible de requête ou d’index ;
- privilégier la lisibilité et la maintenabilité du modèle avant l’optimisation spéculative.

## Références officielles prioritaires

- Doctrine ORM
- Doctrine Migrations
- MySQL 8 Reference Manual

## Règles d’usage

- commencer par le code du projet, les migrations existantes et les versions déclarées localement ;
- consulter ce pack uniquement si la tâche a une portée DB réelle ;
- utiliser les références officielles avant toute source secondaire ;
- ne citer que les sources réellement utilisées ;
- en cas de contradiction, les versions installées et le comportement observé dans le projet priment sur une documentation générique.

## Hors périmètre de ce pack

Ce document n’est pas la source primaire pour :
- les invariants métier Budgex ;
- les décisions d’architecture durable ;
- les règles d’orchestration inter-agents.