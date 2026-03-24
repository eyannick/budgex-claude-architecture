# active-focus.md
updated: 2026-03-24
max_lines: 30
status: active

## Sprint actif

**Sprint 4 — Workflow révision transactions · P0**

Référence complète :
- `.claude/memory/roadmap.md`

## Priorités actives

1. Finaliser le workflow de révision transactions :
   - compteur nav ;
   - vue filtrée ;
   - action inline AJAX ;
   - sélection multiple.
2. Préserver la qualité de la boucle Powens → staging → transactions.
3. Ne pas ouvrir de chantier hors Sprint 4 sans nécessité explicite.

## Règles de prudence permanentes

- Toute migration : vérifier l'impact sur la base de test.
- Toute modification auth / `security.yaml` / Voter : profil `deep` + QA.
- Isolation stricte par utilisateur sur toutes les requêtes.
- Ne pas toucher `config/security.yaml` sans demande explicite.

## Décisions produit actives

- Powens reste prioritaire tant que la boucle comptes / transactions n’est pas stabilisée.
- Pas de ML / NLP pour la catégorisation : règles explicites uniquement.
- Pas de prix live crypto / or à ce stade.
- Priorité à la fiabilité du flux avant enrichissement patrimonial avancé.