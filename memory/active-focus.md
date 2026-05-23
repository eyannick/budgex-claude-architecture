# active-focus.md
updated: 2026-05-23
max_lines: 30
status: active

## Sprint actif

**Aucun sprint en cours.**

Derniers lots terminés :
- Roadmap V3 complète — Phases A–E terminées (Sprint 10 ✅ 2026-03-25)
- **Lot Stripe Billing V1 ✅ 2026-04-27** — Checkout, webhooks, Premium, résiliation, renouvellement, expires_at, sécurité clés
- **Lot Transactions / À traiter / Suggestions V1 ✅ 2026-05-01** — /app/a-traiter centre de résolution, TransactionSuggestionService, actions Valider/Catégoriser/Réviser, UX polish (sticky aside, lien hover)
- **Lot Arrière-train complet ✅ 2026-05-01** — 7 commits : pricing page, Stripe billing (checkout/webhooks/lifecycle), Action Center Premium, category icon picker, budget insights panel, admin UI preview, dashboard tests debt soldée
- **Lot Légal Dynamique P-UI-Legal-4L ✅ 2026-05-18** — LegalConfig entity + migration, /admin/legal-settings, Twig global `legal_config`, pages légales dynamiques (dates/éditeur/hébergeur/email/durées), prix Premium via LegalConfig, navbar publique refactorisée, placeholders badgeés, aucun Price ID Stripe exposé
- **Sprint CSS V1 ✅ 2026-05-19** — 9 lots (ad7c9ef→62c4701) : components.css clos (primitives `.bx-*` complètes, !important redondants retirés, token gaps comblés) · app.css sécurisé sur les familles safe-to-replace (couleurs, bordures alpha/base/contrast/hover, surfaces, inline styles sûrs) · inline styles JS-dépendants conservés · CSS-6F documenté (ADR-021)
- **Chantier Auth CSS/UX ✅ 2026-05-20** — _auth.css standalone (L5), app.css retiré du layout auth, styles.css dépendance assumée, Vite pipeline auth, 2FA OTP 6 cases, /2fa-recovery canonique, toasts branded, helpers legacy remplacés, accessibilité corrigée (WCAG AA), noindex/canonical, trusted device Scheb aligné · audit final PASS (0 P0, 0 P1) · ADR-024
- **Série ADMIN-CSS-2D-4 ✅ 2026-05-21** — 6 lots (6bb87da→a98a572) : app.css −~280 lignes admin · admin.css officiel L4-admin (ADR-025) · 0 classe partagée déplacée
- **P24-2A — Appareils de confiance 2FA · infra JWT Scheb ✅ 2026-05-22** — commit 028677a · scheb/2fa-trusted-device + lcobucci/jwt · TrustedDeviceInterface (getTrustedTokenVersion / invalidateTrustedDevices) · colonne trusted_token_version · révocation globale /app/profile/security · disable 2FA invalide appareils · section profil + modale · migration propre (1 SQL) · 84 tests / 707 assertions
- **P24-2B — Appareils de confiance 2FA · listing et révocation unitaire ✅ 2026-05-22** — commit 054f6a7 · TrustedDevice entity/listing · révocation par appareil · conservation du comportement Scheb
- **P24-3 — Impersonation ROLE_SUPER_ADMIN ✅ 2026-05-22** — commit c06f7c0 · SwitchUserVoter (CAN_SWITCH_USER) · bloque impersonation super admin → super admin · SwitchUserSubscriber impersonation_start/end · bandeau app layout · bouton Endosser admin/user/show · 7 tests fonctionnels / 55 tests filtrés OK
- **P24-4A — Historique mots de passe · infrastructure ✅ 2026-05-23** — commit af72075 · PasswordHistory entity/repository/manager · migration manuelle · purge test DB · 7 tests ciblés OK
- **P24-4B — Historique mots de passe · intégration controllers ✅ 2026-05-23** — commit 78c0327 · ProfileController + ForgotPasswordController · interdiction réutilisation 5 derniers mots de passe · baseline 919 tests / 3374 assertions · 0 failure · 0 error
- **Phase 24 — Sécurité avancée techniquement clôturée ✅ 2026-05-23** — 5 commits · aucune dette technique Phase 24 identifiée

## Avant mise en production (dettes P-UI-Legal-4L)

- **LegalConfig** : renseigner les vraies valeurs dans `/admin/legal-settings` (éditeur, hébergeur, email, prix Premium, dates).
- **Placeholders** : remplacer tous les `[À COMPLÉTER]` dans les pages légales et la politique de confidentialité.
- **Sync LegalConfig / Stripe** : vérifier que `LegalConfig.premiumPrice` correspond au montant `STRIPE_PREMIUM_PRICE_ID` réel (sync manuelle V1 — ADR-019).

## Priorités actives

Backlog disponible :
1. **Dettes Auth assumées** *(ADR-024 — ne pas traiter en lot CSS standard)* :
   - `styles.css` (L1) conservé dans le layout auth — délibéré, non remboursable avant lot migration Bootstrap auth
2. **Dettes CSS V1 différées** *(à traiter lot par lot — ADR-021)* :
   - `#fff` foreground en dur → `var(--bx-app-fg)`
   - `#111827` admin en dur → token dédié
   - Valeurs unitaires (rem/px) → `var(--bx-sp-N)` / `var(--bx-radius-*)`
   - Inline styles JS-dépendants (conservés intentionnellement — refactoring JS requis)
   - Inline styles admin/home/email (hors périmètre V1)
   - `app.css` legacy/doublons (déduplication progressive — ADR-014)
   - Sélecteurs `bx-tx-*` transversaux (migration transverse à planifier)
2. Items Phase 24 (sécurité avancée) — clôturée techniquement : P24-2A ✅ · P24-2B ✅ · P24-3 ✅ · P24-4A ✅ · P24-4B ✅
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
