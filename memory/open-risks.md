# open-risks.md
updated: 2026-03-24
max_active_risks: 10
status: active

## Rôle du document

Ce fichier recense les risques actifs réellement ouverts et encore utiles au pilotage courant.

Il ne contient pas :
- un backlog d’améliorations ;
- des risques déjà traités ;
- de l’historique détaillé.

| ID | Risque | Impact | Probabilité | Mitigation | Statut |
|---|---|---|---|---|---|
| R-001 | Surcharge de contexte si les prompts ou documents re-gonflent | élevé | moyen | garder les prompts courts et déplacer les règles communes dans les fichiers maîtres | ouvert |
| R-002 | Permissions shell encore trop larges selon le stream | élevé | moyen | restreindre davantage par rôle et renforcer uniquement les guardrails réellement justifiés | ouvert |
| R-003 | Connecteurs Powens instables ou incomplets selon la banque | élevé | moyen | rendre l’état de connexion lisible, gérer reconnexion / warning / erreurs sans masquer les limites | ouvert |
| R-004 | Dette UX si la page bank-connections reste incomplète | moyen | moyen | finaliser Sprint 3 avant d’ouvrir des enrichissements secondaires | ouvert |
| R-005 | Macro de fin de session utilisée sur un dépôt mal configuré ou non sain | élevé | faible | vérifier remote, auth et working tree avant commit/push et ne rien prétendre en cas d’échec | ouvert |