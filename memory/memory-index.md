# memory-index.md — Guide d’usage de la mémoire
updated: 2026-03-24
managed_by: orchestrator_only
status: active

Référence d’entrée pour toute écriture dans `memory/`.

## Rôle du document

Ce document sert à :
- repérer rapidement le rôle de chaque fichier du dossier `memory/` ;
- savoir qui lit quoi ;
- décider où écrire une information durable ;
- éviter les doublons et la pollution de la mémoire.

## Registre des fichiers

| Fichier | Rôle | Lu par | Mise à jour |
|---|---|---|---|
| `active-focus.md` | priorités en cours et interdits temporaires | orchestrateur | fréquente |
| `project-context.md` | état stable du projet, stack, baseline QA | orchestrateur | rare |
| `execution-profiles.md` | profils d'exécution | orchestrateur | rare |
| `engineering-standards.md` | standards de code et UI | tous les spécialistes | rare |
| `error-guardrails.md` | erreurs connues à ne plus répéter | tous les spécialistes | après incident confirmé |
| `decision-log.md` | ADR techniques | orchestrateur | ponctuelle |
| `open-risks.md` | risques actifs | orchestrateur | régulière |
| `user-directives.md` | directives utilisateur persistantes et macros | orchestrateur | ponctuelle |
| `archive/` | historiques archivés | référence si besoin | selon besoin |
| `roadmap.md` | roadmap active produit et technique | orchestrateur | régulière |
| `routing-matrix.md` | matrice opérationnelle de routage | orchestrateur | ponctuelle |

## Règles d’écriture

Avant toute écriture :
1. vérifier la source primaire dans `../source-of-truth-map.md` ;
2. confirmer que l'information a une valeur au-delà de la session ;
3. vérifier qu'elle n'existe pas déjà ailleurs ;
4. choisir une seule destination ;
5. ne pas écrire si une mise à jour simple d’un fichier existant suffit.

## Ce qu’on écrit

- décision d'architecture stable ;
- règle validée à l'échelle du projet ;
- priorité active ;
- risque actif ;
- directive utilisateur durable ;
- baseline QA officielle après validation.

## Ce qu’on n’écrit pas

- résumé de code déjà présent dans Git ;
- contenu de fichiers source ;
- notes transitoires sans valeur future ;
- doublons ;
- décisions personnelles de session non demandées par l'utilisateur.

## Politique d’archivage

Cibles de maintenance :
- `active-focus.md` : court et lisible ;
- `decision-log.md` : garder seulement les décisions actives ou encore utiles ;
- `open-risks.md` : ne conserver que les risques réellement ouverts ;
- `archive/` : utiliser dès qu’un historique grossit ou n’est plus opératoire.

## Règles spécifiques au dossier `memory/`

- `decision-log.md` ne stocke pas les directives utilisateur ;
- `user-directives.md` ne stocke pas les ADR techniques ;
- `active-focus.md` ne stocke pas la baseline QA ;
- toute divergence entre deux fichiers de `memory/` doit être corrigée rapidement ;
- en cas de doute sur l’emplacement d’une information, l’orchestrateur tranche selon `source-of-truth-map.md`.