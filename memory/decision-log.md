# decision-log.md
updated: 2026-05-29 (ADR-026 Files d'action distinctes)
managed_by: orchestrator_only
format: ADR
max_active_entries: 16
status: active

## Rôle du document

Ce fichier conserve les décisions d'architecture et de gouvernance durables du système Budgex.

Il ne stocke pas :
- les directives utilisateur persistantes ;
- les priorités temporaires ;
- la roadmap active ;
- les détails transitoires de session.

## ADR-001 — Orchestrateur unique comme point d'entrée
Date : 2026-03-09
Statut : Actif
Décision : un orchestrateur unique reçoit les demandes utilisateur et délègue si nécessaire.
Raison : cohérence des réponses, contrôle de la mémoire, limitation du scope drift.

## ADR-002 — Écriture mémoire réservée à l'orchestrateur
Date : 2026-03-09
Statut : Actif
Décision : les spécialistes ne font que proposer des `MEMORY_CANDIDATES`.
Raison : éviter la dérive contextuelle et les doublons.

## ADR-003 — `SCOPE_IN` nominatif obligatoire
Date : 2026-03-13
Statut : Actif
Décision : toute délégation doit lister précisément les fichiers ou dossiers autorisés.
Raison : réduire les effets de bord.

## ADR-004 — `safe` par défaut, `deep` pour sécurité et migration
Date : 2026-03-09
Statut : Actif
Décision : le profil standard du système est `safe`.
Raison : compromis robustesse / vitesse.

## ADR-005 — Finance comme stream consultatif officiel
Date : 2026-03-21
Statut : Actif
Décision : `budgex-finance` devient un stream officiel mais consultatif par défaut.
Raison : clarifier les règles comptables sans le laisser coder directement.

## ADR-007 — Directives utilisateur persistantes séparées des ADR
Date : 2026-03-21
Statut : Actif
Décision : toute règle durable demandée par l'utilisateur est stockée dans `user-directives.md` et non dans le `decision-log`.
Raison : séparer gouvernance technique et habitudes opératoires utilisateur.

## ADR-008 — `memory/product-pricing-spec.md` comme source de vérité unique pour le packaging Budgex
Date : 2026-04-25
Statut : Actif
Décision : le fichier `.claude/memory/product-pricing-spec.md` est la référence canonique et unique pour tout ce qui concerne le packaging Free / Premium / Premium+, les entitlements / capabilities, la logique d'offre, le positionnement des fonctionnalités et l'UX de monétisation.
Raison : centraliser en un seul endroit les arbitrages produit structurants pour éviter les contradictions, faciliter la maintenance et donner une base stable pour la pricing page, les specs d'entitlements et la roadmap de lancement.
Conséquence : aucun autre fichier `.claude` ne doit contenir une version complète ou concurrente de ces arbitrages. Les autres fichiers peuvent pointer vers `product-pricing-spec.md` ou en résumer un élément, pas le redéfinir.

## ADR-009 — Claude comme orchestrateur documentaire du périmètre pricing / packaging
Date : 2026-04-25
Statut : Actif
Décision : à chaque future décision structurante sur le packaging, le pricing, les entitlements, le Centre d'actions, l'automatisation, ou la taxonomie catégories / règles / libellés, Claude doit (1) mettre à jour `memory/product-pricing-spec.md`, (2) aligner les fichiers `.claude` secondaires si nécessaire, (3) maintenir la cohérence de la documentation produit sans créer de doublon concurrent.
Raison : la spec produit est un document vivant. Sans règle de maintenance explicite, elle se désynchronise dès le premier arbitrage non inscrit.
Déclencheurs d'application : décision sur Free / Premium / Premium+, changement de limite quantitative (règles, connexions), introduction d'une nouvelle capability, arbitrage UX sur les locks / badges, décision sur Powens en Free.

## ADR-010 — `memory/entitlements-spec.md` comme source de vérité pour l'architecture technique des droits d'accès
Date : 2026-04-25
Statut : Actif
Décision : le fichier `.claude/memory/entitlements-spec.md` est la référence canonique pour l'architecture technique du système d'entitlements : modèle Subscription, classe Capability, EntitlementService, CapabilityVoter, EntitlementExtension Twig, PlanLimitException, séquence d'implémentation et garde-fous.
Raison : séparer les arbitrages produit (product-pricing-spec.md) de leur traduction technique (entitlements-spec.md), conformément au principe de séparation des responsabilités documentaires.
Relation : entitlements-spec.md dépend de product-pricing-spec.md et doit rester cohérent avec lui. En cas de conflit, product-pricing-spec.md l'emporte sur les arbitrages produit ; entitlements-spec.md l'emporte sur les choix d'implémentation.

## ADR-011 — Stripe docs comme source documentaire officielle exclusive pour le billing
Date : 2026-04-27
Statut : Actif
Décision : https://docs.stripe.com/ est la seule source externe autorisée pour toute implémentation billing Stripe dans Budgex. Aucune documentation tierce (blog, article, tutoriel, exemple GitHub) ne peut servir de référence primaire pour des décisions billing.
Raison : les décisions billing (gestion de webhooks, statuts d'abonnement, sécurité des clés) ont un impact direct sur le chiffre d'affaires et la sécurité. Seule la doc officielle Stripe garantit l'exactitude.
Règles associées :
- Toute clé Stripe (secret, publishable, webhook secret, price ID) doit être lue uniquement via variable d'environnement.
- Jamais commiter une vraie valeur Stripe dans un fichier versionné.
- Toute clé exposée accidentellement doit être rotée immédiatement dans le Stripe Dashboard.
- Variables attendues : `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PREMIUM_PRICE_ID`.
- Référence technique détaillée : `references/reference-pack-billing.md`.

## ADR-012 — `references/budgex-visual-bible.md` comme source de vérité primaire pour la doctrine visuelle
Date : 2026-05-11
Statut : Actif
Décision : le fichier `.claude/references/budgex-visual-bible.md` est la référence canonique et unique pour toute la doctrine visuelle et UX/UI de Budgex : vision, principes, palette officielle, tokens `--bx-app-*`, typographie, layouts, composants, règles graphiques, tableaux, alertes, responsive, do/don't, checklist et archétypes de pages.
Raison : stabiliser la doctrine design dans un document unique, éviter les définitions concurrentes dispersées dans `engineering-standards.md`, les checklists et les prompts agents.
Conséquences :
- Les fichiers CSS (`colors_and_type.css`, `components.css`) restent la source **technique** d'exécution (vérité du code).
- La bible est la source **doctrinale** (vérité de l'intention).
- `memory/engineering-standards.md §Design System` est une source secondaire autorisée : elle peut résumer des règles d'application code, mais ne doit pas redéfinir les tokens ni la doctrine complète.
- `checklists/frontend-checklist.md` F12–F16 est une checklist d'application, pas une source doctrinale.
- Aucun nouveau token ne peut être créé sans décision explicite tracée ici.
- En cas de conflit entre la bible et un autre fichier `.claude`, la bible l'emporte.

## ADR-013 — Statut du thème light pour la V1 Budgex
Date : 2026-05-11
Statut : Actif
Décision :
- Le thème **dark est la V1 officielle** de la zone authentifiée (`/app/*`, `/admin/*`). Toutes les garanties de conformité visuelle et de QA s'appliquent exclusivement au dark.
- Le thème **light est toléré sans garantie V1** : il existe (`html[data-theme="light"]`), il fonctionne, mais il n'est pas audité dans le sprint CSS V1 et n'entre pas dans son périmètre.
- La dette connue `--bx-app-accent: #6200ea` en mode clair (couleur Material vs. brand `#7c3aed`) est documentée dans la bible visuelle §Annexe B.4 et dans ce log. Elle sera traitée si et quand le thème light devient officiellement supporté.
- **Aucune modification CSS** n'est autorisée pour le thème light dans le sprint CSS V1.
Raison : la bible visuelle est dark-first par décision produit. Auditer simultanément dark et light doublerait la charge sans apport utilisateur mesurable en V1.

## ADR-014 — Stratégie de déduplication `app.css` vs CSS métier
Date : 2026-05-11
Statut : Actif
Décision :
- **`components.css` est et reste la source des primitives `.bx-*`**. Aucune primitive ne doit être dupliquée ou redéfinie dans `app.css` ou un CSS métier.
- **`app.css` est en transition active** (9 980 lignes au 2026-05-11). Il contient :
  - des alias legacy (`--bx-space-*` → `--bx-sp-*`, `--bx-font-*` → `--bx-fs-*`) : tolérés en transition, à retirer lot par lot ;
  - des overrides intentionnels de tokens canoniques (`--bx-radius: 12px` vs canonique `8px`, `--bx-radius-sm: 8px` vs canonique `6.4px`) : documentés dans le code comme dette — à retirer per composant uniquement après vérification visuelle que la migration est transparente ;
  - du contenu page-spécifique mélangé au global : à déplacer vers les CSS métier concernés ou supprimer s'il est couvert par une primitive.
- **Les CSS métier** (`cashflow.css`, `patrimoine.css`, `accounts.css`, `transactions.css`, `dashboard.css`, `profile.css`, `legal.css`) portent les variantes spécifiques justifiées à leur domaine. Ils ne doivent pas absorber du global.
- **Règle de déduplication** : un style dans `app.css` est éligible à suppression uniquement si (1) il est couvert à l'identique par une primitive `components.css` ET (2) la suppression a été vérifiée visuellement sans régression.
- **Interdiction absolue de suppressions massives** : lot par lot, domaine par domaine, tests visuels entre chaque passe.
- **Ordre de priorité** : (a) raw hex / rem en dur → remplacer par tokens, (b) doublons exacts avec une primitive → supprimer, (c) aliases legacy → retirer une fois les consumers migrés, (d) overrides de radius → retirer per composant.
Raison : `app.css` a 9k sélecteurs actifs. Une suppression massive sans audit visuel risque des régressions silencieuses sur des pages non testées. La déduplication progressive est la seule approche sûre.

## ADR-015 — Convention d'usage `chevron_right` / `arrow_forward`
Date : 2026-05-11
Statut : Actif
Décision : deux icônes Material Icons ont des rôles sémantiques distincts et non interchangeables.
- `chevron_right` : ligne de tableau, ligne de liste, item ouvrant une fiche de détail dans la même hiérarchie.
- `arrow_forward` : CTA autonome, lien "Tout voir", lien de section, action qui quitte la vue courante.
Raison : le lot Accounts-Polish v1 a remplacé `arrow_forward` par `chevron_right` dans la liste des comptes. Cette décision a été généralisée en règle transverse pour éviter les incohérences futures.
Conséquences :
- La bible visuelle §6.J est la source doctrinale de cette règle.
- Les templates Patrimoine (× 7) et `admin/user/index.html.twig` constituent une dette connue à migrer en lot dédié.
- La classe `.bx-row-arrow` reste valide (wrapper de colonne) ; seule l'icône intérieure change.
- Le commentaire CSS `patrimoine.css:221` devra être corrigé lors du lot de migration.

## ADR-016 — Doctrine de largeur des pages et cards
Date : 2026-05-11
Statut : Actif
Décision : la largeur d'une card ou section est déterminée par l'usage utilisateur, selon trois archétypes :
- **Opérationnel** (comptes, transactions, admin) → `col-12` / full-width — scanner, comparer, gérer.
- **Analytique** (dashboard, patrimoine, cashflow) → full-width ou grille justifiée (`8/4`, `7/5`) — blocs complémentaires lus simultanément uniquement.
- **Formulaire / paramètres / lecture** (profil, édition, légal) → largeur contrainte (`col-lg-8`, max-width 720–900 px) — préserver la lisibilité à la saisie.
Raison : la page Comptes a posé la question d'une contrainte `col-lg-*` inutile. La décision a été généralisée en doctrine transverse pour éviter les incohérences futures de layout.
Conséquences : la bible visuelle §5 "Largeur des sections par type de page" est la source doctrinale. Aucun audit global immédiat — les corrections sont appliquées page par page lors des futurs lots de polish.

## ADR-017 — Doctrine sémantique des boutons danger
Date : 2026-05-11
Statut : Actif
Décision : deux variants danger coexistent avec des sémantiques strictement distinctes.
- **Danger outline** (`.bx-btn-outline-app--danger`) : déclencheur visible sur page principale, bouton ouvrant une modale de confirmation, action sensible mais annulable.
- **Danger filled** (`.bx-btn-danger-app`) : confirmation finale destructive uniquement, principalement dans des modales. Interdit comme CTA permanent sur une page principale.
- **Annuler** : toujours neutre (`.bx-btn-outline-app`), jamais rouge.
- **Règle d'intensité** : une page principale ne doit pas afficher plusieurs boutons rouge filled simultanément.
Raison : la bible visuelle §6.E interdisait initialement tout rouge filled ("jamais filled rouge plein"). Cette interdiction visait les CTA de page, mais bloquait la création d'un bouton de confirmation destructive dark-first cohérent. La règle a été levée pour les modales de confirmation uniquement.
Conséquences :
- La bible visuelle §6.E est la source doctrinale de cette règle (mise à jour 2026-05-11).
- Les primitives CSS `.bx-btn-danger-app` et `.bx-btn-outline-app--danger` sont autorisées dans `components.css`.
- Aucune primitive danger filled ne doit être utilisée hors contexte de confirmation finale.

## ADR-018 — Modèle de session active dans LoginHistory
Date : 2026-05-14
Statut : Actif
Décision :
- Deux colonnes ajoutées à `LoginHistory` : `isRememberMe` (bool, NOT NULL DEFAULT 0) et `expiresAt` (DateTimeImmutable, nullable).
- `isRememberMe` est détecté dans `LoginSubscriber` via `$request->request->getBoolean('_remember_me')` ; par défaut `false`.
- `expiresAt` est calculé à la connexion : `loggedAt + 30 jours` si remember_me, `loggedAt + 24 heures` sinon.
- Machine à états (calculée, non stockée) via `getDisplayStatus()` : `active` | `expired` | `revoked` | `failed`.
- L'état `active` dans l'UI (card "Sessions actives") = `isSuccessful AND revokedAt IS NULL AND (expiresAt IS NULL OR expiresAt > now())`.
- Les lignes pré-migration (`expiresAt IS NULL`) sont traitées comme `active` en fallback, et purgées par la commande de nettoyage (seuil 90 jours).
- Interdiction d'auto-révocation silencieuse : seule une action explicite de l'utilisateur ou un `logout` peuvent poser `revokedAt`.
Raison : Budgex affichait jusqu'à 28 sessions "actives" car la notion d'expiration n'était pas persistée. La colonne `expiresAt` donne une base factuelle pour filtrer l'affichage sans manipuler les données.
Conséquences :
- Migration `Version20260514000000` (ou date réelle) — non-destructive, 2 ALTER nullable.
- `LoginSubscriber` produit désormais des entrées complètes à chaque connexion.
- `ProfileController::security()` utilise `findActiveByUser()` (sessions) et `findRecentHistoryByUser()` (historique) — deux méthodes distinctes.
- La card "Sessions actives" affiche max 5 entrées + lien "Voir X autres" si dépassement.
- L'historique affiche tous les états (active / expired / revoked / failed) sur 30 entrées.
- Risques associés : voir R-008, R-009, R-010 dans `open-risks.md`.

## ADR-019 — LegalConfig comme source d'affichage légal et marketing
Date : 2026-05-18
Statut : Actif
Décision : `LegalConfig` est la source unique d'affichage pour tout contenu légal et marketing visible dans l'application (dates, éditeur, hébergeur, prestataire email, durées légales, prix Premium affiché). Les valeurs sont gérées via `/admin/legal-settings`.
Stripe reste la **source de vérité du montant réellement débité** — seul `STRIPE_PREMIUM_PRICE_ID` détermine le prélèvement effectif.
La synchronisation `LegalConfig.premiumPrice` ↔ `STRIPE_PREMIUM_PRICE_ID` est **manuelle en V1** : l'administrateur garantit la cohérence entre les deux.
Raison : séparer la couche d'affichage légal de la couche billing évite d'exposer les Price IDs Stripe dans les templates Twig et permet de modifier les mentions légales indépendamment de la configuration Stripe.
Conséquences :
- Avant toute mise en production : renseigner les vraies valeurs dans `/admin/legal-settings`.
- Les placeholders `[À COMPLÉTER]` sont acceptables en développement, interdits en production.
- Tout changement de prix Stripe doit être répercuté manuellement dans `LegalConfig.premiumPrice`.
- ADR-011 reste la règle de sécurité pour les clés Stripe (source https://docs.stripe.com/ uniquement).
- Les ADR-012, ADR-014 et ADR-020 (doctrine CSS, déduplication et vérification d'origine des classes) s'appliquent sans exception aux futurs lots UI légaux.

## ADR-020 — Origine CSS et réutilisation des classes
Date : 2026-05-18
Statut : Actif
Décision : avant d'utiliser ou de réutiliser une classe CSS existante, vérifier (1) son fichier de définition exact, (2) si ce fichier est chargé sur le layout cible (`base.html.twig`, `base_admin.html.twig`, `legal.html.twig`, `home.html.twig`), (3) si la classe est canonique/réutilisable ou module-locale, (4) si elle doit être promue dans `components.css`, (5) qu'aucune classe module-locale n'est copiée sans rendre son style disponible sur la page cible, (6) qu'aucun style inline ni doublon local ne sert de substitution.
Raison : lot P-UI-Legal-4E — un bouton admin réutilisait des classes de `profile.css` (non chargé dans `base_admin.html.twig`), produisant un rendu HTML brut. Correction : promotion du style dans `components.css`. Ce cas illustre le risque systémique d'une réutilisation sans vérification du chargement CSS sur la page cible.
Source primaire des règles d'application détaillées : `memory/engineering-standards.md` §Origine CSS et réutilisation des classes.
Checklist opérationnelle : `checklists/frontend-checklist.md` F17.
Note sur la numérotation : ADR-018 est occupé par le modèle de session LoginHistory (2026-05-14), ADR-019 par la séparation LegalConfig / Stripe (2026-05-18). Ce numéro ADR-020 est correct et ne réutilise pas ADR-018.

## ADR-021 — Clôture du Sprint CSS V1 et gouvernance des dettes différées
Date : 2026-05-19
Statut : Actif
Décision :
- Le Sprint CSS V1 est techniquement clôturé. `components.css` est clos pour V1 : primitives `.bx-*` complètes, flags `!important` redondants retirés, token gaps comblés.
- `app.css` a été sécurisé uniquement sur les familles safe-to-replace validées (couleurs app, bordures alpha/base/contrast/hover, surfaces, inline styles sûrs).
- Les valeurs listées ci-dessous restent volontairement hors V1. Elles constituent la dette CSS différée à traiter en lots futurs.
- ADR-020 (origine CSS et réutilisation des classes) reste obligatoire pour tout futur lot UI/CSS.
- ADR-014 (pas de drainage massif de `app.css`) reste en vigueur : lot par lot, domaine par domaine, vérification visuelle entre chaque passe.
Raison : safe-by-default — inclure dans V1 uniquement les remplacements à risque zéro identifiés et validés. Les valeurs différées nécessitent un audit visuel ou un refactoring JS préalable.
Lots réalisés :
- `ad7c9ef` tokenize safe component values · `cee6c1b` remove redundant form button important flags
- `8a01d8f` tokenize safe app color values · `f38d83c` replace safe inline display styles
- `ae34562` close remaining component token gaps · `77b2224` tokenize app border alpha values
- `6cee199` tokenize app border base values · `eabb08e` tokenize app border contrast values
- `62c4701` tokenize app hover surface values
Dettes CSS différées (hors V1 — traiter lot par lot) :
- Textes foreground `#fff` en dur → `var(--bx-app-fg)`
- `#111827` admin en dur → token admin dédié
- Valeurs unitaires (rem/px) → `var(--bx-sp-N)` / `var(--bx-radius-*)`
- Inline styles JS-dépendants (conservés intentionnellement — toute modification exige un refactoring JS simultané)
- Inline styles admin/home/email (hors périmètre V1)
- `app.css` legacy/doublons (déduplication progressive — ADR-014)
- Sélecteurs `bx-tx-*` transversaux (migration transverse à planifier)

## ADR-022 — Hiérarchie CSS officielle Budgex (L0–L6)
Date : 2026-05-19
Statut : Actif
Décision : la hiérarchie CSS de Budgex est formalisée en six couches L0–L6.
- L0 `colors_and_type.css` : tokens (source de vérité unique — seul fichier autorisé à définir des raw hex).
- L1 `styles.css` : vendor legacy (reset/base — ne jamais enrichir).
- L2 `app.css` : legacy/transition (à drainer — ADR-014, ADR-021 — aucune nouvelle classe sans justification).
- L3 `components.css` : primitives canoniques app/admin (chargé sur `base.html.twig` + `base_admin.html.twig` uniquement).
- L4 modules métier (`profile.css`, `transactions.css`, `accounts.css`, `dashboard.css`, `cashflow.css`, `patrimoine.css`, `goal.css`) : module-local, promotion dans L3 si réutilisation.
- L5 zones publiques (`landing.css`, `legal.css`) : autonomes, hors zone app/admin, indépendantes de L3.
- L6 page-specific (block stylesheets Twig) : exceptionnel, justification obligatoire, aucun token défini.
Raison : l'audit CSS-7A a révélé une architecture partiellement saine mais encore hybride. Formaliser la hiérarchie clarifie où chaque nouvelle classe doit atterrir et empêche l'accrétion silencieuse dans `app.css`.
Conséquences :
- Toute nouvelle primitive réutilisable app/admin va dans `components.css` (L3).
- `components.css` (L3) n'est pas chargé sur home / legal / auth — ADR-020 s'applique strictement.
- Les modules L4 sont module-local : interdiction de réutiliser sans promotion dans L3.
- `styles.css` (L1) est figé — ne jamais enrichir.
- `app.css` (L2) ne doit plus recevoir de nouvelle classe sans justification explicite validée.
- Dettes identifiées : doublon `.bx-form-btn` (profile.css / components.css), `bx-tx-*` transversal, patterns dashboard à auditer, admin/auth trop dépendants de L2, futur `admin.css` à planifier.
Source primaire des règles d'application : `memory/engineering-standards.md` §Architecture CSS officielle.
Source doctrinale : `references/budgex-visual-bible.md` §13.

## ADR-023 — Introduction de Vite en pipeline CSS parallèle
Date : 2026-05-19
Statut : Actif
Décision :
- Vite est confirmé comme prérequis technique pour accueillir la future structure CSS sémantique `assets/styles/`.
- La Phase 1 doit installer et configurer Vite comme pipeline parallèle uniquement : aucun layout Twig ne doit être modifié, aucun asset Vite ne doit être branché dans les pages, et la cascade active ne doit pas changer.
- `public/css/` reste la source CSS active pendant toute la transition initiale.
- `assets/styles/` devient la future source CSS de travail seulement après validation de la Phase 1 ; sa nomenclature officielle est sans préfixes numériques : `entries/`, `tokens/`, `themes/`, `base/`, `layouts/`, `components/`, `utilities/`, `modules/`, `public/`, `legacy/`.
- Le package Symfony/Vite n'est pas figé par cette ADR. Le lot d'implémentation doit vérifier au moment de l'exécution le bundle maintenu et compatible avec Symfony 7. Le candidat prioritaire à vérifier est `pentatrion/vite-bundle`, sans exclure une alternative mieux maintenue si l'audit package le justifie.
- AssetMapper/Importmap existant est documenté comme scaffold Symfony présent mais non utilisé par les layouts CSS/JS audités. Il n'est ni à brancher ni à nettoyer pendant la Phase 1 ; tout nettoyage éventuel devra faire l'objet d'un lot ultérieur séparé.
Raison : CSS-9B a montré que Budgex sert actuellement CSS et JS directement depuis `public/` via `asset()`, que Bootstrap CSS est compilé dans `public/css/styles.css`, que Bootstrap JS vient du CDN, et qu'AssetMapper/Importmap existe sans être raccordé aux layouts audités. Introduire Vite en parallèle permet de préparer la future architecture `assets/styles/` sans risque immédiat sur la cascade, les layouts ou les pages existantes.
Conséquences :
- La Phase 1 doit être limitée à l'installation/configuration Vite, à la création de la structure `assets/styles/` et à un entry CSS vide ou quasi vide.
- Interdictions Phase 1 : pas de modification Twig, pas de migration de `public/css`, pas de suppression de fichiers CSS existants, pas de `@layer`, pas de branchement `vite_entry_*` dans les layouts.
- L'ordre CSS actif ADR-022 reste inchangé tant que Vite n'est pas branché explicitement dans un lot ultérieur.
- `assets/app.js` et l'import existant vers `./styles/app.css` ne doivent pas servir de base implicite à la migration CSS sans audit dédié ; la Phase 1 peut créer des entries CSS explicites sous `assets/styles/entries/`.
- Toute Phase 2 de branchement Vite devra commencer par un audit de cascade et un plan de rollback.

## ADR-024 — Clôture du chantier Auth CSS/UX
Date : 2026-05-20
Statut : Actif
Décision :
- Le chantier Auth CSS/UX est **techniquement clôturé**. Audit final PASS — aucun point P0 ni P1 non résolu.
- `_auth.css` est désormais le fichier CSS dédié à la zone auth (login, register, 2FA, 2fa-recovery, trusted device). Il appartient à la couche **L5** (zone publique autonome).
- `app.css` (L2) a été **retiré** du layout auth. La zone auth ne dépend plus de la couche de transition L2.
- `styles.css` (L1) est conservé volontairement dans le layout auth comme dépendance Bootstrap/vendor assumée. Ce n'est pas une dette — c'est un choix délibéré documenté (voir §Dettes assumées).
- La pipeline Vite est en place pour la zone auth.
- Le formulaire 2FA OTP est en 6 cases natives.
- La route `/2fa-recovery` est canonique.
- Les toasts auth sont branded (doctrine `references/budgex-flash-toast-doctrine.md`).
- Les helpers CSS legacy ont été remplacés par des primitives auth-native.
- L'accessibilité des formulaires auth est corrigée (WCAG 2.2 AA — `aria-label`, `autocomplete`, focus ring).
- Les balises `noindex` / `canonical` auth sont correctes (pattern `base.html.twig` SEO — ADR-012).
- Le trusted device Scheb est aligné sur la doctrine 2FA Budgex.
Raison : la zone auth était la seule zone encore dépendante de `app.css` (L2) après la clôture du Sprint CSS V1 (ADR-021). Créer une couche autonome `L0 → L1 → L5` pour auth complète la séparation des zones CSS formalisée dans ADR-022.
Conséquences :
- Le layout auth charge désormais : **L0** (`colors_and_type.css`) → **L1** (`styles.css`) → **L5** (`_auth.css`).
- `_auth.css` est module-local à la zone auth. Toute primitive réutilisable app/admin doit être promue dans `components.css` (L3) — jamais copiée.
- Interdiction d'importer `app.css` ou `components.css` dans le layout auth sans décision explicite de lot dédié.
- `styles.css` (L1) reste figé — ne jamais enrichir (ADR-022).
- Le tableau "Chargement par layout" dans ADR-022 et `engineering-standards.md` est mis à jour en conséquence.
- Dette assumée : dépendance `styles.css` sur la zone auth — délibérée, non remboursable avant un éventuel lot de migration Bootstrap auth. Documentée ici, ne pas traiter en lot CSS standard.

## ADR-025 — admin.css comme couche CSS officielle de la zone admin (L4-admin)
Date : 2026-05-21
Statut : Actif
Décision : `public/css/admin.css` est la couche CSS officielle de la zone admin (`/admin/*`). Elle s'insère dans la hiérarchie ADR-022 comme couche L4-admin — zone-wide pour `/admin/*`, parallèle aux modules L4 page-spécifiques de la zone app.
Raison : la série ADMIN-CSS-2D-4 (6 lots, 6bb87da→a98a572) a extrait ~280 lignes de styles admin depuis `app.css` (L2) vers `admin.css`. La dette "futur admin.css à planifier" inscrite dans ADR-022 est résolue. `admin.css` existait depuis 8279255 mais n'avait pas été formalisé dans la hiérarchie.
Conséquences :
- `admin.css` est chargé dans `base_admin.html.twig` uniquement. Zone-local à `/admin/*`.
- Tout nouveau style spécifique à la zone admin va dans `admin.css`, pas dans `app.css`.
- `app.css` n'accepte plus de style purement admin — interdiction formelle.
- Aucune classe `admin.css` ne peut être réutilisée hors admin sans promotion dans `components.css` (L3).
- Résidus partagés volontairement conservés dans `app.css` : `.bx-export-*`, `.bx-icon-hero`, `.bx-chart-wrap`, `.bx-budget-form-*` — restent en L2 jusqu'à éventuelle promotion en L3.
- La dette "admin/auth trop dépendants de L2" (ADR-022) est résolue : admin par ADR-025, auth par ADR-024.

## ADR-026 — Files d'action distinctes plutôt que totaux techniques ambigus
Date : 2026-05-29
Statut : Actif
Contexte : la page /app/transactions affichait "200 transactions à traiter, dont 199 sans catégorie et 24 non révisées." — formulation techniquement correcte (union dédupliquée des motifs), mais cognitivement confuse pour l'utilisateur (199 + 24 ≠ 200). Le chantier Transactions (2026-05-29, 10 commits) a résolu ce problème.
Décision : quand plusieurs motifs d'action peuvent se chevaucher (union dédupliquée), ne pas exposer à l'utilisateur un total global abstrait. Afficher à la place des **files d'action séparées**, chacune nommée par un verbe d'action clair.
Vocabulaire utilisateur validé :
- "À catégoriser" / "Catégoriser" — opérations sans catégorie.
- "À valider" / "Valider" / "Validée" — opérations catégorisées non confirmées.
- "Annuler la validation" — retour arrière sur une validation.
- "Suggestions" — automatisation disponible (propositions fiables).
- "Opérations en attente" — compteur neutre acceptable dans les contextes courts (nav, lien rapide).
Termes techniques internes à conserver (ne jamais renommer côté code) : `reviewed`, `isReviewed`, `review`, `mark_reviewed`, `pending_review`, `data-is-reviewed`, `data-review-filter`.
Raison : l'utilisateur final ne doit pas avoir à comprendre qu'un total peut être inférieur à la somme de ses composantes. Les files d'action indépendantes éliminent l'ambiguité arithmétique et orientent directement vers une action.
Conséquences :
- Cette doctrine s'applique à tout futur module Budgex exposant des compteurs de tâches potentiellement chevauchants (ex. : notifications multi-motifs, alertes budget).
- Le bandeau /app/transactions et la page /app/a-traiter sont les implémentations de référence.
- Dashboard, Budget analyse et Cashflow ont été harmonisés en conséquence.
- Périmètre technique stable : routes, méthodes et attributs `reviewed`-préfixés restent inchangés — seuls les libellés visibles ont changé.

---

## ADR archivées

| ADR | Sujet | Archivée le | Raison |
|---|---|---|---|
| ADR-006 | Baseline QA officielle centralisée | 2026-05-11 | Règle entièrement encodée dans `source-of-truth-map.md` + action confirmée close dans `archive/refonte-summary-2026-03.md` |

Contenu complet → `.claude/archive/adr-archive.md`.
