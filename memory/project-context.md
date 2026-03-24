# project-context.md
updated: 2026-03-24
managed_by: orchestrator_only
status: active

## Rôle du document

Contexte stable du projet Budgex :
- stack technique ;
- périmètre produit ;
- architecture applicative ;
- baseline QA officielle ;
- repères structurants du code.

Ce document ne porte pas la roadmap active détaillée, qui vit dans `memory/roadmap.md`.

## Stack technique stable

| Composant | Version cible |
|---|---|
| PHP | 8.3.x |
| Symfony | 7.4 |
| Doctrine ORM | 3.x |
| MySQL | 8.x |
| PHPUnit | 12.x |
| Bootstrap | 5.3 |
| Webpack Encore | version stable du projet |
| DataTables | version stable du projet |
| Chart.js | CDN (SRI hash fixé) |

## Domaine produit

Budgex est une application de gestion financière personnelle et patrimoniale avec :
- suivi des revenus, dépenses et virements ;
- catégories hiérarchiques, libellés, budgets, objectifs d'épargne ;
- intégration Powens : connexions bancaires, sync incrémentale, staging, connecteurs ;
- vision patrimoine consolidée : comptes bancaires, épargne, crypto, métaux précieux ;
- tableaux de bord orientés pilotage financier ;
- isolation stricte des données par utilisateur ;
- admin panel complet : audit, analytics, logs erreurs, GeoIP.

## Architecture applicative

- pattern principal : MVC Symfony ;
- couche métier : `Controller → Service → Repository → Entity` ;
- auth : Symfony Security + Voters ;
- formulaires : Symfony Forms + validation serveur ;
- assets : Webpack Encore ;
- templates : Twig + Bootstrap 5 ;
- tests : PHPUnit avec base de test isolée (InnoDB forcé via PDO option 1002).

## Conventions durables

- attributs PHP 8 pour routes, entités et contraintes ;
- FormTypes suffixés `FormType` ;
- injection par constructeur ;
- `#[IsGranted]` ou Voter sur toute action sensible ;
- migrations via `make:migration` ;
- format de commit : `type(scope): description` ;
- commentaires développeur utiles sur logique non évidente.

## Baseline QA officielle

| Métrique | Valeur | Date |
|---|---|---|
| Tests PHPUnit | 328 tests | 2026-03-24 |
| Assertions | 903 assertions | 2026-03-24 |
| Failures | 0 | 2026-03-24 |

Cette baseline est la seule valeur de référence officielle tant qu'un run QA validé ne l'a pas remplacée.

## Entités principales

Account, User, BankConnection, Transaction, Category, Libelle, Budget, Goal, GoalContribution,
PowensConnector, PowensAccountStaging, CryptoHolding, PreciousMetalHolding, SavingProductReference,
Currency, Notification, AdminLog, LoginHistory, AppErrorLog, RegistrationAttempt,
RegistrationErrorLog, SiteConfig.

## Services Powens (`src/Service/Powens/`)

PowensClient, PowensSyncService, PowensAccountMapper, PowensTransactionMapper,
PowensConnectorSyncService, PowensStagingService, LogoService, SyncResult.

## Structure projet

```text
assets/
bin/
config/
migrations/
public/
  uploads/bank-logos/
src/
  Command/
  Controller/
  Entity/
  EventListener/
  Repository/
  Service/
  Service/Powens/
templates/
tests/
.claude/
  memory/
    roadmap.md
    active-focus.md
    project-context.md