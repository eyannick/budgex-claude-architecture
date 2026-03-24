# execution-profiles.md
updated: 2026-03-24
status: active

## Rôle du document

Ce document définit les profils d’exécution utilisés par l’orchestrateur pour calibrer le niveau d’intervention, de validation et de risque acceptable.

Il complète :
- `playbooks/agent-team-playbook.md`
- `agents/budgex-orchestrator.md`

Il ne remplace pas :
- les checklists ;
- les règles propres à chaque agent.

## Tableau canonique

| Profil | Usage | Lecture | Écriture | Validations | QA | Risque max |
|---|---|---|---|---|---|---|
| `fast` | lecture, doc, typo, cosmétique faible risque | oui | limitée | lint ciblé si applicable | non | faible |
| `safe` | feature, bugfix, refactor courant | oui | oui | validations standard adaptées au périmètre | conditionnelle | moyen |
| `deep` | sécurité, auth, migration, incident, modification structurelle à fort risque | oui | oui | validations complètes + QA | obligatoire | élevé |

## Règles d'usage

### `fast`
Autorisé pour :
- explication ;
- documentation ;
- correction mineure ;
- renommage sans effet métier.

Interdit pour :
- sécurité ;
- migration ;
- logique comptable ;
- structure d'entités ;
- règles d'autorisation.

### `safe`
Profil par défaut.

Validations de base recommandées :
- `php bin/phpunit`
- `php bin/console doctrine:schema:validate` si impact Doctrine
- `php bin/console lint:twig templates/` si impact Twig
- `php bin/console lint:yaml config/ --parse-tags` si impact config

### `deep`
Obligatoire pour :
- auth / security / voters ;
- migrations Doctrine ;
- changement de contrat de données ;
- incident production ;
- opération multi-fichiers à fort risque.

Validations additionnelles :
- `php bin/console lint:container`
- `php bin/console debug:router`
- PHPStan si disponible
- passage par `budgex-qa`
- plan de rollback mentionné dans `RISKS`