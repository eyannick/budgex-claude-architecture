---
updated: 2026-03-24
---
# reference-pack-core.md

## Rôle du document

Ce pack définit l’ordre de consultation des références cœur de stack et les règles minimales d’usage des sources locales et externes.

## Hiérarchie de consultation

1. code du projet ;
2. dépendances et versions locales ;
3. mémoire du projet ;
4. documentation officielle ;
5. release notes des dépendances concernées ;
6. blogs/articles en dernier recours.

## Sources locales prioritaires

### Compréhension du projet
- `README.md`
- `memory/project-context.md`
- `memory/decision-log.md`

### Versions et dépendances
- `composer.json`
- `package.json`

### Standards projet
- `memory/engineering-standards.md`

## Références officielles cœur de stack

- PHP manual
- Symfony docs
- Doctrine ORM
- Doctrine Migrations
- PHPUnit
- PHPStan

## Règles d'usage

- ne pas ouvrir les références externes si le code local, les dépendances locales ou la mémoire projet suffisent ;
- citer uniquement les sources réellement utilisées ;
- en cas de doute de version, vérifier d’abord les dépendances locales avant toute doc externe ;
- en cas de contradiction, le code du projet et les versions effectivement installées priment sur une documentation générique ;
- utiliser les blogs et articles seulement en dernier recours, jamais comme source primaire.