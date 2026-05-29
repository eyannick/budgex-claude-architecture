# active-focus.md
updated: 2026-05-29
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
- **P25-0 — Immobilier V1 hardening & tests ✅ 2026-05-23** — commit 391043c · PropertyController tests · PropertyValuationService tests · PropertyLoanSummaryService tests · correction audit logs property.created/updated/deleted · working tree propre
- **P25-1 — Indicateur plus-value latente ✅ 2026-05-23** — commit 603fda9 · purchasePrice + latentGain + latentGainPercent dans PropertyValuationService::getPropertySnapshot() · pill +/−% dans immobilier_show.html.twig · tests adaptés · 3 fichiers · 0 migration
- **P25-2 — Timeline prêt immobilier ✅ 2026-05-23** — commit 3c50bc3 · loanEndDate + loanRemainingMonths snapshot · date de fin + mensualités restantes + progress bar dans immobilier_show.html.twig · fix netValue color · 3 fichiers · 0 migration
- **P25-3 — Indicateur performance liste ✅ 2026-05-23** — commit 4d2e808 · gain%/perte% coloré dans sous-titre liste · testListShowsLatentGainIndicator · 2 fichiers · 0 migration
- **P25-4 — Bilan visuel brut/dette/net ✅ 2026-05-23** — commit a1f98dd · strip `.bx-bilan-strip` conditionnel `snapshot.hasLoan` · 3 KPI (Valeur brute / Dette restante / Valeur nette) · 2 tests · 949 tests / 3491 assertions / 0 failure
- **P25-5 — KPI bilan liste immobilier ✅ 2026-05-24** — commit 60cc602 · strip brut/dette/net sur `immobilier.html.twig` · conditionnel `includedPropertiesCount > 0 and totalOwnedGrossValue > 0` · 0 migration · 0 service
- **P25-DVF-1 — Données Property localisation + surface ✅ 2026-05-23** — commit d4701fd · surfaceM2 · dwellingType · addressLine · city · postalCode · inseeCode · latitude · longitude · geocodingScore · geocodedAt · migration propre · form + show enrichis · 953 tests / 3525 assertions / 0 failure · aucun appel API
- **P25-DVF-2 — Service DVF + cache marché ✅ 2026-05-23** — commit b030faf · PropertyMarketReference entity/repository/migration · DvfBenchmarkService (HTTP + CSV + médiane + TTL 30j) · RefreshDvfBenchmarkCommand · pricePerM2Purchase/Estimated dans snapshot · getCachedBenchmark() dans PropertyController::show() · 0 appel HTTP en rendu · 0 template modifié
- **P25-DVF-3 — Affichage benchmark DVF sur la fiche ✅ 2026-05-23** — commit 045c040 · dvfVariationPercent dans PropertyController::show() · carte "Benchmark prix au m²" · prix achat/m², estimé/m², médiane DVF/m², écart, disclaimer DVF · tests 4 cas (avec/sans surface, avec/sans marketRef) · 0 migration · 0 appel HTTP
- **P25-GEO-1 — Géocodage automatique via Géoplateforme ✅ 2026-05-23** — commit 2fd576b · GeocodingService (data.geopf.fr/geocodage/search) · app:property:geocode (--property-id / --force / --dry-run / --with-dvf) · findWithAddressButNoInseeCode() · 0 migration · 0 template · 0 appel HTTP en rendu
- **P25-GEO-FORM-1 — Autocomplete adresse formulaire immobilier ✅ 2026-05-24** — commit 3bf7519 · address-autocomplete.js (composant générique, Géoplateforme) · _property_form.html.twig instrumenté · champs remplis : addressLine, postalCode, city, inseeCode · profil non modifié · 0 migration · 0 service · 0 controller
- **P25-GEO-FORM-2A — Autocomplete adresse admin/user/edit ✅ 2026-05-24** — commit 304f219 · address-autocomplete.js réutilisé · champs addressLine/postalCode/city/inseeCode sur admin user edit · 0 service · 0 migration
- **P25-GEO-FORM-2B — Harmonisation UI suggestions adresse profil ✅ 2026-05-24** — commit c24dbb4 · style des suggestions profil aligné sur design Budgex · profile.js non modifié · Série autocomplete adresse clôturée côté application
- **P-S8-PROJ-1 — Liaison SavingProductReference ↔ Account ✅ 2026-05-24** — commit c486ba3 · savingProduct ManyToOne nullable sur Account (existait déjà) · AccountFormType · show_info.html.twig · AccountShowInfoTest · 0 migration · 0 service créé
- **DÉCOUVERTE : P-S8-PROJ-2 déjà livré** — InterestProjectionService (src/Service/) + AccountController::show()+showInfo() + section "Projection d'intérêts" show_info.html.twig + tests InterestProjectionTest + AccountProjectionOnShowTest — complet, wired, testé
- **P-S8-PAT-1 — Intérêts agrégés patrimoine/livrets et fonds-euros ✅ 2026-05-24** — commit 011a4f5 · PatrimoineController::livrets()+fondsEuros() inject InterestProjectionService · totalEstimatedInterest + weightedAvgRate · KPI strip additif avant ligne graphique · PatrimoineControllerTest · 0 migration
- **P-S8-LINK-1 — Auto-liaison SavingProductReference pour nouveaux comptes Powens ✅ 2026-05-24** — commit d093c0e · PowensAccountMapper constructor nullable repo · tryAutoLinkSavingProduct() · types liés : livret_a → livret_a · ldds → ldds · PEL/CEL/CSL/savings exclus · 5 tests mock-based · 0 migration
- **P-S8-PAT-2 — Taux et intérêts estimés par compte dans les listes patrimoine ✅ 2026-05-24** — commit e1affc3 · PatrimoineController projectionsByAccountId · livrets.html.twig + fonds_euros.html.twig · PatrimoineControllerTest +2 tests · patrimoine.css .bx-cls-account-rate · 0 migration · **Sprint 8 — Épargne réglementée CLÔTURÉ** (courbe Chart.js différée explicitement)
- **P25-UX-IMM-1 — Ville dans les lignes + placeholder compact ✅ 2026-05-24** — commit d3f1ab0 · ville visible en sous-titre liste · placeholder contexte enrichi · 0 migration · 0 service
- **P25-UX-IMM-2 — Section Synthèse premium page globale ✅ 2026-05-24** — commit 4cf5d2b · .bx-realestate-summary (brut/dette/net) conditionnel sur includedPropertiesCount · 0 migration · 0 service
- **P25-UX-IMM-3 — Hero KPIs sur fiche détail ✅ 2026-05-24** — commit c057849 · 4 cards (valeur estimée / valeur nette / plus-value latente / dette restante) · .bx-realestate-detail-hero · 0 migration · 0 service
- **P25-UX-IMM-4 — DVF visible en colonne droite fiche détail ✅ 2026-05-25** — commit d98c61c · layout 2 colonnes (col-lg-8 Synthèse+Prêt / col-lg-4 Benchmark m²) · fallback "Comparaison de marché indisponible" · 0 CSS · 0 migration · 0 service
- **P25-UX-IMM-5 — Surface m² en liste + lien source DVF ✅ 2026-05-25** — commit 453c88c · surface visible dans sous-titre lignes immobilier.html.twig · lien data.gouv.fr sur mention DVF fiche détail · test PropertyControllerTest · 0 CSS · 0 migration · 0 service · **Série P25-UX-IMM CLÔTURÉE — Phase 25 Immobilier CLOSE**
- **P26-PAT-GLOBAL-1 — Non requis ✅ 2026-05-25** — audit lecture seule · netTotal déjà calculé dans PatrimoineController::index() · index.html.twig affiche déjà Dettes + Patrimoine net · 0 fichier modifié
- **P26-CREDITS-CONSO-1 — Crédits à la consommation dans le patrimoine ✅ 2026-05-25** — commit 3ed6baa · Account::ASSET_CLASSES +credits_conso · instruments (pret_auto/pret_perso/revolving/autre_credit) · migration CHECK constraint uniquement · PatrimoineController isLiability + soustraction netTotal · index.html.twig passif en rouge · donut actifs exclu · 0 entité · 0 service · 0 page
- **P26-CREDITS-CONSO-2 — Clarification UX formulaire Account pour credits_conso ✅ 2026-05-25** — "Solde initial" → "Capital restant dû" · hint dette · section Rémunération masquée JS · label taux adapté · 0 PHP · 0 migration
- **P26-CREDITS-CONSO-3 — Affichage dette dans liste et fiche Account ✅ 2026-05-25** — commit c9ec9be · _kpi_cards.html.twig : "Capital restant dû" + − + text-danger + hint · index.html.twig : − et text-danger · 0 migration · 0 CSS
- **P26-CREDITS-CONSO-4 — Projection d'intérêts masquée pour credits_conso ✅ 2026-05-25** — commit 3f1cf4a · show_info.html.twig wrappé {% if account.assetClass != 'credits_conso' %} · 0 PHP · 0 migration
- **P26-PAT-SEPARATOR-1 — Séparateur visuel Actifs / Passifs dans /app/patrimoine ✅ 2026-05-25** — commit 014e036 · PatrimoineController usort isLiability en fin de liste · index.html.twig flag _seenLiability + séparateur "Passifs" · 3 tests · 0 migration · **Phase 26 CLOSE**
- **Chantier Transactions UX ✅ 2026-05-29** — 10 commits (1eab416→0e013ef) · desktop readability (inline styles, icônes flux, couleurs montants) · mobile cards dédiées `bx-tx-mobile-card` + kebab `data-bs-display="static"` · files d'action distinctes (bandeau signal, /app/a-traiter KPIs restructurés) · wording harmonisé Valider/Validée/À valider sur toutes surfaces · Dashboard, Budget analyse, Cashflow alignés · ADR-026 · **chantier CLÔTURÉ — audit final PASS (0 P1)**

## Avant mise en production (dettes P-UI-Legal-4L)

- **LegalConfig** : renseigner les vraies valeurs dans `/admin/legal-settings` (éditeur, hébergeur, email, prix Premium, dates).
- **Placeholders** : remplacer tous les `[À COMPLÉTER]` dans les pages légales et la politique de confidentialité.
- **Sync LegalConfig / Stripe** : vérifier que `LegalConfig.premiumPrice` correspond au montant `STRIPE_PREMIUM_PRICE_ID` réel (sync manuelle V1 — ADR-019).

## P26-PAT-GLOBAL-1 — Non requis (2026-05-25)

Audit lecture seule : PatrimoineController::index() calcule déjà grossAssetsTotal, propertyDebtIncludedTotal et netTotal. index.html.twig affiche déjà Dettes et Patrimoine net. Aucune modification effectuée.

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
2. **Phase 25 — Immobilier CLOSE ✅** : P25-0 · P25-1 · P25-2 · P25-3 · P25-4 · P25-5 · DVF-1 · DVF-2 · DVF-3 · GEO-1 · GEO-FORM-1 · GEO-FORM-2A · GEO-FORM-2B · UX-IMM-1 · UX-IMM-2 · UX-IMM-3 · UX-IMM-4 · UX-IMM-5 — ADR-026 DVF/GEO différé · historique valorisation différé
3. **Phase 26 — Passifs/crédits non immobiliers CLOSE ✅** : GLOBAL-1 (non requis) · CONSO-1 · CONSO-2 · CONSO-3 · CONSO-4 · PAT-SEPARATOR-1 — 1 migration CHECK-only · 0 entité · 0 page dédiée · 6 lots · 14 fichiers
3. Phase 24 — clôturée : P24-2A ✅ · P24-2B ✅ · P24-3 ✅ · P24-4A ✅ · P24-4B ✅
4. Post-socle Crypto & Métaux précieux — conditions de déclenchement dans roadmap
5. Backlog non planifié — voir haut du fichier roadmap

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
