# active-focus.md
updated: 2026-05-11
max_lines: 30
status: active

## Sprint actif

**Aucun sprint en cours.**

Derniers lots terminés :
- Roadmap V3 complète — Phases A–E terminées (Sprint 10 ✅ 2026-03-25)
- **Lot Stripe Billing V1 ✅ 2026-04-27** — Checkout, webhooks, Premium, résiliation, renouvellement, expires_at, sécurité clés
- **Lot Transactions / À traiter / Suggestions V1 ✅ 2026-05-01** — /app/a-traiter centre de résolution, TransactionSuggestionService, actions Valider/Catégoriser/Réviser, UX polish (sticky aside, lien hover)
- **Lot Arrière-train complet ✅ 2026-05-01** — 7 commits : pricing page, Stripe billing (checkout/webhooks/lifecycle), Action Center Premium, category icon picker, budget insights panel, admin UI preview, dashboard tests debt soldée

## Priorités actives

Backlog disponible :
1. **Sprint CSS — Mise en conformité visuelle et gouvernance design**
   - Lot 0A ✅ COMPLÉTÉ 2026-05-11 (arbitrages bloquants : user-directives, light theme, app.css strategy)
   - Lot 0 — Cadrage et sources de vérité · à démarrer en premier
2. Items Phase 24 (sécurité avancée) — impersonation, 2FA codes secours, appareils de confiance, historique mdp
3. Post-socle Crypto & Métaux précieux — conditions de déclenchement dans roadmap
4. Backlog non planifié — voir haut du fichier roadmap

## Règles de prudence permanentes

- Toute migration : vérifier l'impact sur la base de test.
- Toute modification auth / `security.yaml` / Voter : profil `deep` + QA.
- Isolation stricte par utilisateur sur toutes les requêtes.
- Ne pas toucher `config/security.yaml` sans demande explicite.

## Décisions produit actives

- Powens reste prioritaire tant que la boucle comptes / transactions n'est pas stabilisée.
- Pas de ML / NLP pour la catégorisation : règles explicites uniquement.
- Pas de prix live crypto / or à ce stade.
- Priorité à la fiabilité du flux avant enrichissement patrimonial avancé.
