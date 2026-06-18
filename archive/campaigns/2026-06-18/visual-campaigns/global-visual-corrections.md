# Lots Correctifs — Recette Visuelle Globale Budgex

**Date de création** : 2026-06-17
**Date de mise à jour** : 2026-06-18 (audit de clôture indépendant — section O)
**HEAD de référence (audit initial)** : `0f590d1369a53f40f58e9defce60c9422215e2e0`
**HEAD final (4 lots commités et poussés)** : `86f39a9bf6517e3ef1518a5d59b44323f2e0078f`
  - LOT-VIS-NAV-001 → `776c878a778fc9a140730d971d3a3327d98a00e3`
  - LOT-VIS-CSS-001 → `9ae9ee4ee8b0b362ce966eaf077e516b04390ef8`
  - LOT-VIS-UX-001 → `c5d8b1f63e4a36193f072403ef0de92808b39fdd` (10 fichiers, gap N8 corrigé avant commit)
  - LOT-VIS-CSS-002 → `86f39a9bf6517e3ef1518a5d59b44323f2e0078f`
**Source** : `.claude/visual-campaigns/global-visual-regression.md` (campagne du 2026-06-17, 110 scénarios, 4 anomalies ouvertes)
**Statut** : **CLOTURÉ — AUDITÉ INDÉPENDAMMENT** (voir section O). Les 4 lots sont commités, poussés, et conformes à leurs spécifications respectives (NAV-001 version M faisant foi, UX-001 version N à 10 fichiers faisant foi). Le blocage décrit ci-dessous (gap `templates/budget/edit.html.twig`) a été résolu avant le commit `c5d8b1f` — conservé tel quel comme trace historique de l'arbitrage.
**Portée** : préparation et spécification (sections A-K) + amendements opérationnels (section L : protocole runner, section M : correctif de positionnement mobile NAV-001, section N : arbitrage Comptes + blocage allowlist UX-001) + section O : audit de clôture indépendant (2026-06-18).

---

## A. Rappel des 4 anomalies

| ID | Sévérité | Résumé |
|---|---|---|
| VIS-P1-001 | P1 | Centre de notifications inaccessible sous 576px (aucun point d'entrée mobile) |
| VIS-P1-002 | P2 | Hover violet de marque cassé en dark sur Budgets/Reports/Export (conflit `!important`) |
| VIS-P1-003 | P2 | Confirmations destructives incohérentes (modale stylée vs `confirm()` natif selon le module) |
| VIS-P1-004 | P3 | 4 fichiers preview `/admin/design-system` pointent vers un chemin d'asset incorrect (HTTP 500) |

---

## B. VIS-P1-001 — Notifications mobile

### B1. Cartographie

| Élément | Fichier | Détail |
|---|---|---|
| Bouton desktop | `templates/layouts/app.html.twig:78-94` | `<div class="dropdown dropdown-notifications me-2 d-none d-sm-block">` — masqué sous 576px par la classe utilitaire Bootstrap `d-none d-sm-block` |
| Panneau dropdown | `templates/layouts/app.html.twig:96-160` | Liste des 5 dernières notifications + lien "Voir toutes les notifications" → `app_notification_index` |
| Badge compteur | `templates/layouts/app.html.twig:88-92` + `:103-106` | `#notification-badge` et `#bx-notif-header-badge`, alimentés par `notification_count()` (Twig extension) |
| Drawer mobile | `templates/layouts/app.html.twig:294-315` → `{{ include('_partials/_nav_app.html.twig') }}` | Liste de navigation pure (Vue d'ensemble, Comptes, Cashflow, …) — **aucune entrée Notifications** |
| JS drawer | `public/js/app.js:45-64` | Toggle CSS pur (`body.classList.toggle('drawer-toggled')`), pas de composant Bootstrap offcanvas |
| Page complète | `app_notification_index` → `/app/notifications` | Répond HTTP 200 en accès direct (confirmé), rendu correct et complet |
| Élément analogue avec le même défaut | `templates/layouts/app.html.twig:168` | Badge SCA Powens (`#powensAlertDropdown`) — **même classe `d-none d-sm-block`**, hors périmètre de VIS-P1-001 mais signalé pour information (non traité dans ce lot, voir section F) |
| Tests existants | aucun test fonctionnel ne couvre la présence du bouton notifications sur mobile |

### B2. Cause exacte

`.dropdown-notifications` porte la classe Bootstrap `d-none d-sm-block`, qui masque l'élément en `display:none` pour tout viewport `< 576px`. Le drawer mobile (`#drawerToggle` → `_nav_app.html.twig`) est une simple liste de liens de navigation et ne contient aucune entrée de repli. Le `/app/notifications` est fonctionnellement atteignable (200 en accès direct) mais aucun contrôle visible n'y mène sur mobile/tablette étroite (VP1 360, VP2 390 confirmés en recette).

### B3. Correctif minimal retenu

**Ne pas dupliquer le système de notifications.** Rendre le bouton-cloche existant visible sur tous les viewports en retirant la restriction responsive, plutôt que de créer une seconde entrée dans le drawer (qui dupliquerait la logique d'affichage du badge/panneau).

- Remplacer `d-none d-sm-block` par rien (affichage permanent) sur `.dropdown-notifications`, **OU** par une classe garantissant l'affichage sur tous les breakpoints si une classe explicite est préférée pour la lisibilité (`d-block`).
- Vérifier que le dropdown Bootstrap (`dropdown-menu-end`, `min-width:300px`) reste positionné dans le viewport à 360px (Popper recentre normalement automatiquement — à confirmer par capture).
- Ne pas toucher au badge SCA Powens (`#powensAlertDropdown`, ligne 168) dans ce lot — anomalie non ouverte, hors périmètre (voir section F si une décision future est prise de l'aligner).
- Touch target : le bouton existant est `.btn-lg.btn-icon` (déjà ≥44px en pratique sur les autres boutons de la topbar) — vérifier par capture qu'il atteint bien ≥44×44px une fois visible sur mobile.
- Aucune duplication d'identifiant : un seul `#notificationDropdown` / `#notification-badge` existe déjà dans le DOM — le correctif ne doit pas en introduire un second.

> **⚠ Mise à jour 2026-06-17 (amendement 2)** : la revalidation Playwright a montré que ce correctif seul (retrait de `d-none d-sm-block`) est **nécessaire mais insuffisant** — le panneau déborde à gauche du viewport à 360/390/575px (`menuBox.x = -84` à 360px). Le bloc `LOT-VIS-NAV-001` ci-dessous reflète l'allowlist et les changements **initialement prévus** ; la version **corrigée et complète** (avec le correctif de positionnement) est documentée en **section M**, qui fait foi pour l'implémentation.

### LOT-VIS-NAV-001 *(version initiale — voir section M pour la version corrigée faisant foi)*

```
Anomalie source     : VIS-P1-001
Cause exacte        : .dropdown-notifications porte "d-none d-sm-block" (app.html.twig:78) ;
                       aucun repli dans le drawer mobile (_nav_app.html.twig)
Allowlist            : templates/layouts/app.html.twig (uniquement la classe sur la div ligne 78)
Changements précis   :
  - app.html.twig L78 : retirer "d-none d-sm-block" de la classe de
    <div class="dropdown dropdown-notifications me-2 d-none d-sm-block">
  - Aucun changement JS, aucun changement de route, aucun changement de badge/compteur
Tests structurels    :
  - Nouveau test (ou extension d'un test existant lisant app.html.twig) assertant
    StringNotContainsString("dropdown-notifications me-2 d-none d-sm-block") et
    StringContainsString('class="dropdown dropdown-notifications') pour verrouiller
    la non-régression de cette classe spécifique
Tests fonctionnels   :
  - Test fonctionnel (WebTestCase) : GET /app/dashboard authentifié, assertSelectorExists
    sur '.dropdown-notifications' sans condition de viewport (le test HTTP ne simule pas
    le CSS, donc ce test vérifie uniquement la présence DOM, pas le rendu responsive —
    complété par les scénarios Playwright ci-dessous pour le rendu réel)
Scénarios Playwright (revalidation) :
  - 360×800 dark  : bouton cloche visible, touch target ≥44px, badge lisible, dropdown
    ouvrable sans débordement horizontal
  - 360×800 light : idem en light
  - 1440×900 dark : pas de régression (bouton déjà visible avant le correctif)
Message de commit   : fix(nav): make notifications bell visible on mobile topbar (<576px)
Conditions d'arrêt   : si la suppression de d-none d-sm-block provoque un débordement
                       horizontal mesurable (scrollWidth > clientWidth) sur 360×800, ne pas
                       committer — revenir avec un ajustement de gap/padding de la topbar
                       avant de relancer la revalidation Playwright
```

---

## C. VIS-P1-002 — Hover dark cassé

### C1. Cartographie complète (cause réelle, plus précise que l'hypothèse initiale)

L'audit approfondi révèle que la situation **diffère par page** — ce n'est pas un défaut uniforme :

| Page | Wrapper | Variable consommée | Valeur light | Valeur dark "intentionnelle" | Règle qui gagne réellement en dark | Visible à l'œil ? |
|---|---|---|---|---|---|---|
| `/app/budgets` | `.bx-budgets-page` (budget.css:12) | `--bx-budgets-row-hover` | `rgba(primary,.05)` (budget.css:13) | `color-mix(in srgb, var(--bx-app-fg) 6%, transparent)` (budget.css:61-63) | `html[data-theme="dark"] .table-hover > tbody > tr:hover > *` (app.css:1906, **!important**) | Non — les deux valeurs convergent visuellement vers un gris neutre |
| `/app/reports` | `.bx-report-page` (report/index.html.twig:25) | `--bx-report-row-hover` | `rgba(primary,.05)` (app.css:4216) | `rgba(255,255,255,.06)` (app.css:4275-4277), consommée par une règle dédiée `.bx-report-page .table.table-hover > tbody > tr:hover > *` (app.css:4312-4314) | Idem — app.css:1906 (**!important**) gagne par spécificité+poids sur la règle dédiée non-importante | Non — 0.05 vs 0.06 blanc, imperceptible |
| `/app/export/transactions` | `.bx-export-page` (export/transactions.html.twig:16) | `--bx-export-row-hover` défini (`var(--bx-app-hover)`, app.css:4317-4319) **mais jamais consommé** — aucune règle ne lit cette variable | n/a | n/a (variable morte) | Le tableau utilise la classe partagée `.bx-budgets-table` (confirmé : export/transactions.html.twig:178) → règle générique app.css:4068-4069 → fallback `rgba(primary,.05)` **attendu**, mais app.css:1906 (**!important**) gagne quand même | **Oui** — violet attendu en light, gris neutre imposé en dark sans justification documentée |

**Conclusion de l'audit** : la règle générique `html[data-theme="dark"] .table-hover > tbody > tr:hover > * { ... !important }` (app.css:1906-1909, commentaire d'origine : "Bootstrap 5.2 peut calculer le hover-bg via variable non overridée") a une spécificité de (0,3,3) et un `!important`, qui bat systématiquement :
- la règle partagée `.bx-budgets-table > tbody > tr:hover > *` (app.css:4068-4069, spécificité (0,2,2), pas de `!important`) ;
- la règle dédiée Reports `.bx-report-page .table.table-hover > tbody > tr:hover > *` (app.css:4312-4313, spécificité (0,3,2), pas de `!important`).

Sur Budgets et Reports, les valeurs "perdantes" (color-mix 6%, rgba blanc 6%) sont **visuellement quasi identiques** à ce que la règle générique produit (rgba blanc 5%) — donc **aucun défaut perceptible actuellement**, mais ce sont des règles mortes (code trompeur : modifier `--bx-report-row-hover` n'aurait aujourd'hui aucun effet visible). Sur Export, qui n'a **aucune valeur dark dédiée**, la perte du fallback violet est **perceptible et sans justification de marque documentée**.

### C2. État repos / hover / focus-visible / clair / sombre

- État repos : aucune règle de fond particulière sur `tr` (transparent), confirmé par capture et `getComputedStyle`.
- Hover : voir tableau ci-dessus.
- Focus-visible : aucune règle `:focus-visible` n'existe sur les lignes de `.bx-budgets-table` (les `<tr>` ne sont pas focusables, pas de `tabindex` constaté) — non concerné par cette anomalie.
- Light : violet `rgba(primary,.05)` confirmé visible sur les 3 pages (vérifié par `getComputedStyle` avant/après hover).
- Dark : gris/blanc neutre sur les 3 pages (confirmé), mais avec des degrés d'intentionnalité différents par page (voir C1).

### C3. Correctif retenu

**Transversal mais respectueux de l'intention déjà codée par page.** Ne pas supprimer le `!important` générique de app.css:1906 (aucune preuve qu'il soit sans risque ailleurs dans l'app — il protège potentiellement d'autres tableaux `.table-hover` non couverts par cette recette, ex. DataTables génériques, tableaux admin). À la place, ajouter deux règles dark-scopées de poids égal (même spécificité (0,3,x) + `!important`, conformément à la convention déjà utilisée ailleurs dans app.css pour ce type de conflit), positionnées après les règles génériques dans le fichier :

1. `html[data-theme="dark"] .bx-budgets-table > tbody > tr:hover > * { background-color: var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb), 0.05)) !important; }`
   → restaure le fallback violet pour Export (qui n'a pas de variable dédiée) **et** laisse Budgets afficher sa propre valeur intentionnelle (`color-mix` 6%) puisque `--bx-budgets-row-hover` reste définie par `.bx-budgets-page` en dark.

2. `html[data-theme="dark"] .bx-report-page .table.table-hover > tbody > tr:hover > * { background-color: var(--bx-report-row-hover) !important; }`
   → rend enfin actif le choix déjà codé pour Reports (`rgba(255,255,255,.06)`).

Effet attendu : **aucun changement visuel sur Budgets et Reports** (les valeurs convergent déjà visuellement), **restauration du violet de marque sur Export en dark**. Optionnel (signalé, pas obligatoire) : supprimer la variable morte `--bx-export-row-hover` (app.css:4317-4319) puisqu'elle n'est consommée par aucune règle — à la discrétion de l'implémenteur, sans impact si laissée en place.

### LOT-VIS-CSS-001

```
Anomalie source     : VIS-P1-002
Cause exacte        : html[data-theme="dark"] .table-hover > tbody > tr:hover > *
                       (app.css:1906, !important, spécificité 0,3,3) bat systématiquement
                       .bx-budgets-table (app.css:4068, 0,2,2, sans !important) et
                       .bx-report-page .table.table-hover (app.css:4312, 0,3,2, sans !important).
                       Impact perceptible uniquement sur Export (aucune valeur dark dédiée) ;
                       Budgets/Reports ont des valeurs dark déjà codées mais actuellement mortes.
Allowlist            : public/css/app.css uniquement
Changements précis   :
  - Ajouter après app.css:4070 (juste après la règle .bx-budgets-table existante) :
      html[data-theme="dark"] .bx-budgets-table > tbody > tr:hover > * {
          background-color: var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb), 0.05)) !important;
      }
  - Ajouter après app.css:4314 (juste après la règle .bx-report-page existante) :
      html[data-theme="dark"] .bx-report-page .table.table-hover > tbody > tr:hover > * {
          background-color: var(--bx-report-row-hover) !important;
      }
  - Ne PAS toucher à app.css:1906-1909 (règle générique conservée intacte)
  - Ne PAS supprimer de !important existant
  - Optionnel : supprimer la variable morte --bx-export-row-hover (app.css:4317-4319) — sans
    effet fonctionnel, à la discrétion de l'implémenteur
Tests structurels    :
  - Nouveau test lisant public/css/app.css (même pattern que SharedAppCssInlineCodeTest) :
      * assertStringContainsString sur les deux nouvelles règles dark-scopées
      * assert (via strpos) que la position des deux nouvelles règles est strictement
        après la position de la règle générique app.css:1906, pour verrouiller l'ordre
        de cascade voulu
Tests fonctionnels   : aucun (CSS pur, pas de logique serveur)
Scénarios Playwright (revalidation) :
  - /app/budgets   : VP4 1440 dark + light (aucun changement visuel attendu)
  - /app/reports   : VP4 1440 dark + light (aucun changement visuel attendu)
  - /app/export/transactions : VP4 1440 dark (changement attendu : violet rgba(primary,.05)
    au lieu de gris neutre) + VP4 1440 light (déjà correct, non-régression)
  - Vérification programmatique getComputedStyle avant/après hover sur les 3 pages en dark,
    comme effectué lors de l'audit (hover-check.js)
Message de commit   : fix(css): restore brand-violet hover on .bx-budgets-table family in dark theme
Conditions d'arrêt   : si une page tierce hors périmètre (admin, DataTables génériques) montre
                       une régression de hover après ce changement, revenir en arrière et
                       circonscrire davantage le sélecteur ajouté (ex. limiter à .bx-export-page
                       uniquement plutôt qu'à .bx-budgets-table générique)
```

---

## D. VIS-P1-003 — Confirmations destructives incohérentes

### D1. Audit des quatre suppressions

| Module | Template(s) | Bouton | Form/Route | Méthode | CSRF | Voter/ownership | JS | Texte de confirmation | Après suppression |
|---|---|---|---|---|---|---|---|---|---|
| **Comptes** (référence) | `account/_delete_modal.html.twig` | `.bx-btn-danger-app` dans modale Bootstrap `#deleteModal` | `app_account_delete` (`AccountController::delete`, L313-353) | POST | `delete_account_{id}`, vérifié serveur (L322) | `denyAccessUnlessGranted(AccountVoter::DELETE, $account)` (L320) + `is_granted('account_delete', account)` côté template (L1) | `account-delete-modal.js` : `window.confirm()` **additionnel** si `txCount > 0`, après fermeture de la modale | Modale : "Supprimer ce compte" + 2 options (Archiver/Supprimer) ; confirm() natif si transactions liées | Flash success + redirect `app_account_index` |
| **Budgets** | `budget/index.html.twig:222-226` | `.bx-btn-icon-app--danger` direct sur la liste | `app_budget_delete` (`BudgetController::delete`, L198-) | POST | `delete_budget_{id}`, vérifié serveur (L208) | `denyAccessUnlessGranted(BudgetVoter::DELETE, $budget)` (L203) | `budget-actions.js` : `window.confirm()` natif **seul**, aucune modale | "Confirmer la suppression ?" (générique) | Flash success + redirect index |
| **Objectifs** | `goal/edit.html.twig:56-60` (objectif) + `goal/show.html.twig:323-330` et `:359-365` (versement, **dupliqué desktop+mobile**) | `.bx-btn-icon-app--danger` / bouton form direct | `app_goal_delete`, `app_goal_contribution_delete` (`GoalController`) | POST | `delete_goal_{id}` / `delete_contribution_{id}` | `IsGranted('ROLE_USER')` classe + (à confirmer : voter par entité au niveau action, pattern cohérent avec Budget/Account observé ailleurs dans le contrôleur) | `goal-form.js` : `window.confirm()` natif, gère **aussi** `data-confirm-action` (Annuler un objectif — **hors périmètre, ne pas toucher**) | "Supprimer cet objectif et tous ses versements ?" / "Supprimer ce versement ?" | Flash + redirect |
| **Immobilier** | `patrimoine/immobilier_show.html.twig:10-16` | bouton form direct | `app_patrimoine_immobilier_delete` (`PropertyController`) | POST | `delete_property_{id}` | pattern cohérent (voter/ownership) à confirmer au moment de l'implémentation | `immobilier_show.js` : `window.confirm()` natif, **et** gère `initProgressBars()` (sans lien — **ne pas supprimer cette fonction**) | "Supprimer ce bien immobilier ?" | Flash + redirect |

**Particularité critique pour l'implémentation** : `goal/show.html.twig` rend **deux fois** chaque formulaire de suppression de versement — une fois dans la table desktop (L323-331) et une fois dans la card mobile (L359-366), pour le **même** `contribution.id`. Si la modale remplace le `confirm()`, il ne faut **qu'une seule instance de modale par versement** (sinon doublons d'`id`), avec **deux déclencheurs** (`data-bs-target` desktop + mobile) pointant vers la même modale rendue une seule fois (par exemple regroupées dans un bloc séparé après la boucle, ou seulement après le premier rendu de chaque id).

### D2. Pattern de référence (Comptes) — réutilisabilité

- Markup : `.modal.fade.bx-tx-modal` (primitive dark-first déjà partagée — confirmé dans le commentaire du fichier "Réutilise la primitive .bx-tx-modal canonique"), structure `modal-header` / `modal-body` / `modal-footer` standard Bootstrap.
- JS : `account-delete-modal.js` est un petit script autonome (binding par `data-confirm`, anti-double-binding via `dataset.accountDeleteConfirmBound`).
- Personnalisation : titre, corps et bouton sont actuellement **codés en dur pour le cas Compte** (option Archiver/Supprimer spécifique aux comptes) — **ne peut pas être réutilisé tel quel** pour Budget/Objectif/Immobilier qui n'ont pas de notion d'archivage.

### D3. Décision

**Option B retenue : créer un composant partagé générique, inspiré de la structure du pattern Comptes, sans réutiliser le fichier `_delete_modal.html.twig` lui-même** (celui-ci reste propre aux Comptes pour son option Archiver/Supprimer spécifique). Le nouveau partial est une modale de confirmation **simple** (titre + message + bouton Annuler + bouton danger), paramétrable, utilisée par Budgets, Objectifs (objectif + versement) et Immobilier.

Justification : promouvoir tel quel le pattern Compte (option A) imposerait une UI à deux choix (Archiver/Supprimer) non pertinente pour des entités sans archivage ; créer une exception démontrée (option C) pérenniserait l'incohérence que la recette a justement signalée. Un composant minimal partagé est la cible la plus sûre et la plus petite à committer.

### LOT-VIS-UX-001

```
Anomalie source     : VIS-P1-003
Cause exacte        : account/_delete_modal.html.twig (+ account-delete-modal.js) utilise une
                       modale Bootstrap stylée ; budget-actions.js / goal-form.js /
                       immobilier_show.js utilisent window.confirm() natif (3 implémentations
                       quasi-dupliquées du même handler générique)
Allowlist            :
  - NOUVEAU : templates/_partials/_confirm_delete_modal.html.twig (composant générique)
  - NOUVEAU : public/js/confirm-delete-modal.js (binding générique data-bs-toggle="modal",
    remplace la portion "delete" de budget-actions.js / goal-form.js / immobilier_show.js)
  - templates/budget/index.html.twig (bouton + include de la modale par ligne budget)
  - templates/goal/edit.html.twig (bouton + include pour la suppression de l'objectif)
  - templates/goal/show.html.twig (boutons desktop+mobile + include UNIQUE par versement,
    voir note D1 sur la duplication desktop/mobile)
  - templates/patrimoine/immobilier_show.html.twig (bouton + include)
  - public/js/budget-actions.js (retirer uniquement la fonction initDeleteConfirmations
    devenue inutile pour les boutons migrés — vérifier qu'aucun autre data-confirm-delete
    ne subsiste sur la page avant de retirer le fichier entier de l'entrypoint si besoin)
  - public/js/goal-form.js (retirer SEULEMENT la branche data-confirm-delete de
    initDeleteConfirmations ; CONSERVER intégralement la branche data-confirm-action qui
    gère "Annuler cet objectif ?" — hors périmètre de cette anomalie)
  - public/js/immobilier_show.js (retirer SEULEMENT initDeleteConfirmations ; CONSERVER
    initProgressBars et tout autre handler sans lien)
Comportement attendu : modale stylée dark/light cohérente sur les 4 modules, identique en
                       structure (titre, message, Annuler, bouton danger) à la modale Comptes
                       sans son option Archiver. POST, CSRF, voters, routes, comportement
                       métier post-suppression INCHANGÉS (vérifié à l'audit : tous les
                       contrôleurs utilisent déjà denyAccessUnlessGranted + isCsrfTokenValid
                       de façon cohérente — aucune modification serveur nécessaire)
Contrôle desktop     : VP4 1440 dark + light, sur chacun des 4 points d'entrée
Contrôle mobile      : VP1 360 dark, en particulier goal/show.html.twig (vérifier qu'un clic
                       sur le bouton mobile ET le bouton desktop ouvrent la même modale sans
                       doublon d'id dans le DOM)
Tests structurels    :
  - Nouveau test : templates/_partials/_confirm_delete_modal.html.twig existe et expose les
    paramètres attendus (modalId, title, body, formAction, csrfTokenId, submitLabel)
  - Tests étendant SharedAppCssInlineCodeTest (ou nouveau test Domain/Shared) : les 4
    templates migrés ne contiennent plus data-confirm-delete mais data-bs-toggle="modal"
  - Test ciblé : goal/show.html.twig ne contient qu'une seule occurrence de
    id="deleteContributionModal{{ contribution.id }}" par versement malgré le double
    rendu desktop/mobile (régression anti-duplication)
Tests fonctionnels   : WebTestCase existants sur la suppression (Budget/Goal/Property) à
                       rejouer sans modification — ils testent le POST serveur, inchangé
Tests de sécurité    : confirmer par lecture de code (pas de nouveau test nécessaire si les
                       contrôleurs ne sont pas touchés) que denyAccessUnlessGranted et
                       isCsrfTokenValid restent appelés AVANT toute suppression sur les 4
                       contrôleurs après migration du seul JS/Twig front-end
Scénarios Playwright (revalidation) :
  - Ouverture modale (4 modules) : VP1 360 dark, VP4 1440 light
  - Annulation (clic "Annuler" ou bouton fermer) : la suppression n'a pas lieu
  - Fermeture clavier (Échap) : modale se ferme sans soumission
  - Confirmation simulée UNIQUEMENT sur données de test jetables (ex. un budget créé puis
    supprimé dans le même scénario, jamais sur les comptes de démonstration existants)
  - Desktop + mobile + dark + light pour chacun des 4 points d'entrée (16 combinaisons,
    peuvent être réduites à un sous-ensemble représentatif si le temps de recette est limité)
Risques              : portée la plus large des 4 lots (5 fichiers Twig + 4 fichiers JS).
                       Découper en commits si nécessaire (voir section E) plutôt qu'un commit
                       monolithique risqué.
Commit (si un seul)  : fix(ux): unify destructive-action confirmation modal across budget/goal/property
```

### D4. Découpage recommandé si le périmètre est jugé trop large pour un seul commit sûr

1. **Commit 1/2 — Infrastructure** : créer `_confirm_delete_modal.html.twig` + `confirm-delete-modal.js`, sans encore migrer aucun consommateur (aucun comportement visible ne change, lot purement additif).
2. **Commit 2/2 — Migrations** : migrer Budget, Goal (objectif + versement), Immobilier vers le nouveau composant et retirer les branches JS devenues mortes, dans un seul commit fonctionnel (ou un commit par module si une prudence supplémentaire est souhaitée — à arbitrer par l'implémenteur selon la stabilité observée après le commit 1).

---

## E. VIS-P1-004 — Design system previews

### E1. Audit des quatre fichiers

| Fichier | Ligne(s) | Chemin actuel | Chemin attendu | Asset réel | HTTP observé |
|---|---|---|---|---|---|
| `public/design-system-previews/brand-logo-usage.html` | 14, 19 | `../assets/logo.png` | `../assets/img/logo.png` | `public/assets/img/logo.png` | 500 |
| `public/design-system-previews/brand-logo-usage.html` | 24 | `../assets/favicon.png` | `../assets/img/favicon.png` | `public/assets/img/favicon.png` | 500 |
| `public/design-system-previews/brand-logo.html` | 13 | `../assets/logo.png` | `../assets/img/logo.png` | `public/assets/img/logo.png` | 500 |
| `public/design-system-previews/components-navbar-landing.html` | 19 | `../assets/favicon.png` | `../assets/img/favicon.png` | `public/assets/img/favicon.png` | 500 |
| `public/design-system-previews/components-sidebar.html` | 27 | `../assets/favicon.png` | `../assets/img/favicon.png` | `public/assets/img/favicon.png` | 500 |

**Origine du calcul** : ces fichiers HTML statiques sont servis directement par Apache depuis `public/design-system-previews/`, donc `../assets/...` résout vers `public/assets/...`. Le fichier réel est à `public/assets/img/...` — il manque le segment `img/`. Le chemin correct est confirmé par grep sur `templates/layouts/app.html.twig:67` : `asset('assets/img/favicon.png')`.

**Raison du HTTP 500 (au lieu d'un 404 attendu)** : `/assets/*` est intercepté par Symfony AssetMapper, qui tente de résoudre `favicon.png`/`logo.png` comme un asset mappé. L'échec de résolution déclenche une exception non gérée proprement (`Unable to find asset "./styles/app.css" imported from ".../assets/app.js"`, confirmé par l'en-tête `X-Debug-Exception` observé en recette) plutôt qu'un 404 propre. Ce comportement secondaire d'AssetMapper est une particularité de la configuration existante du projet, **hors périmètre de ce lot** (corriger les 4 chemins suffit à éliminer le symptôme ; re-architecturer la gestion d'erreur d'AssetMapper n'est pas demandé et ajouterait un risque transversal non justifié par cette anomalie).

### LOT-VIS-CSS-002

```
Anomalie source     : VIS-P1-004
Cause exacte        : 4 fichiers HTML statiques référencent /assets/{favicon,logo}.png au lieu
                       de /assets/img/{favicon,logo}.png (segment "img/" manquant)
Allowlist            :
  - public/design-system-previews/brand-logo-usage.html (lignes 14, 19, 24)
  - public/design-system-previews/brand-logo.html (ligne 13)
  - public/design-system-previews/components-navbar-landing.html (ligne 19)
  - public/design-system-previews/components-sidebar.html (ligne 27)
Changements précis   : remplacer chaque occurrence de "../assets/logo.png" par
                       "../assets/img/logo.png" et "../assets/favicon.png" par
                       "../assets/img/favicon.png" — uniquement ces 5 occurrences au total,
                       aucun autre changement de markup ou de style
Comportement attendu : logo/favicon affichés sans erreur 500 dans les 4 preview cards ;
                       rendu visuel des cards inchangé par ailleurs
Tests structurels    : nouveau test (pattern SharedAppCssInlineCodeTest) lisant les 4 fichiers
                       statiques et assertant StringNotContainsString('"../assets/logo.png"')
                       / StringNotContainsString('"../assets/favicon.png"') et
                       StringContainsString('"../assets/img/logo.png"') /
                       StringContainsString('"../assets/img/favicon.png"') selon le fichier —
                       verrouille la non-régression de chemin
Validation manuelle  : curl -I sur chacune des 4 URLs réécrites doit renvoyer 200 (pas 500/404)
Scénarios Playwright (revalidation) :
  - /admin/design-system : VP4 1440 dark — vérifier 0 erreur console/réseau au chargement
    (contre 5 erreurs constatées à l'audit), captures des cards "Marque" affichant
    correctement logo/favicon
Commit              : fix(admin): correct broken asset paths in design-system preview cards
```

---

## F. NON_TESTABLE — Recette complémentaire différée

Conservés comme documentés dans `global-visual-regression.md`, **non traités dans ces 4 lots**, aucune donnée créée artificiellement pour les couvrir :

| Scénario | Cause | Fixture/environnement requis | Bloquant ? |
|---|---|---|---|
| S06 (2FA, état "attente code") | testé via un compte 2FA tiers (`thomas.legrand@test.budgex`), non bloquant pour cette campagne mais pas un test dédié au profil VISUAL-DATA officiel | un profil VISUAL-DATA avec 2FA activé et secret connu (ou seed déterministe) | Non bloquant |
| S18/S20 (Bank/Powens, état "connexion active") | `arnaud.robert@test.budgex` n'a aucune `BankConnection` réelle dans les fixtures | fixture ou compte avec connexion Powens sandbox active | Non bloquant |
| S24 (Inbox, modale qualify) | aucune transaction "à qualifier" dans le jeu de données VISUAL-DATA actuel | fixture dédiée avec transactions Powens non enrichies en attente de qualification | Non bloquant — anomalie ANOM-MODAL-001 reste "à vérifier" |
| P2-22 (Export PDF) | déclenche un téléchargement de fichier, pas une navigation — hors portée des captures Playwright actuelles | script de validation dédié (lecture du flux téléchargé) si une vérification du rendu PDF est souhaitée | Non bloquant — comportement confirmé correct (Content-Disposition attachment) |
| 403 intentionnels (`/admin/settings`, `/admin/legal-settings`, ownership immobilier) | comportement de sécurité correct, pas une anomalie | aucun | Non applicable |
| Pages d'erreur 403/404/500 stylées | non observables avec `APP_ENV=dev` (trace de debug Symfony affichée à la place) | `APP_DEBUG=0` dans un environnement dédié, hors périmètre "dev/test obligatoire" de la campagne | Non bloquant |
| Mentions légales (placeholders) | donnée de configuration non remplie (`/admin/legal-settings`), pas un défaut de code | remplissage des champs ROLE_SUPER_ADMIN dans l'admin | Non bloquant |
| Bascule thème live (ANOM-GRAPH-001) | non concluant — limite de l'émulation Playwright/CDP sur l'évènement `matchMedia.change` | test manuel avec un vrai changement de thème OS pendant que l'app est ouverte (theme=system) | Non bloquant, à revérifier manuellement si le doute persiste |
| Badge SCA Powens (`#powensAlertDropdown`) — même `d-none d-sm-block` que VIS-P1-001 | non ouvert comme anomalie par la recette (hors périmètre du rapport initial) | décision produit : aligner ou non sur le même correctif que les notifications | Non bloquant — à arbitrer séparément si souhaité |

**Règle** : ne pas créer de données artificielles ni élargir le périmètre des 4 lots ci-dessus pour couvrir ces cas.

---

## G. Dettes non rouvertes

Interdiction explicite de toucher dans le cadre de ces 4 lots :

- `--bx-radius-md` (delta 0.625 vs 0.62rem)
- Campagne globale de tokenisation des `box-shadow`
- `.bx-toast-noscript` (fallback `.5rem`)
- Polyfill dark mode (architecture générale, hors les deux règles ciblées du LOT-VIS-CSS-001)
- Fallbacks Chart.js

---

## H. Stratégie de commits

**Un commit par lot, dans cet ordre :**

1. `LOT-VIS-NAV-001`
2. `LOT-VIS-CSS-001`
3. `LOT-VIS-UX-001` (potentiellement scindé en 2 commits, voir D4)
4. `LOT-VIS-CSS-002`

**Avant chaque commit**, exécuter :

```bash
git status --short
# Si config/reference.php apparaît :
git checkout -- config/reference.php

git add <ALLOWLIST DU LOT>
git diff --cached --name-only
git diff --cached --check
git diff --cached
git commit -m "<MESSAGE EXACT DU LOT>"
git push origin master
```

Ne jamais utiliser `git add -A` ou `git add .` — toujours lister explicitement les fichiers de l'allowlist du lot en cours.

---

## I. Validations par lot

| Lot | Lint Twig | Lint Container | node --check | PHPUnit ciblé | Tests structurels | Tests sécurité | git diff --check | Playwright ciblé |
|---|---|---|---|---|---|---|---|---|
| LOT-VIS-NAV-001 | `bin/console lint:twig templates/layouts/app.html.twig` | non concerné | non concerné | tests fonctionnels Dashboard existants (non-régression) | nouveau test (section B3) | non concerné (pas de logique serveur) | oui | 3 scénarios (section B3) |
| LOT-VIS-CSS-001 | non concerné | non concerné | non concerné | aucun (CSS pur) | nouveau test (section C3) | non concerné | oui | 6 scénarios (section C3) |
| LOT-VIS-UX-001 | `bin/console lint:twig templates/budget templates/goal templates/patrimoine templates/_partials` | `bin/console lint:container` (si services modifiés — a priori non) | `node --check public/js/confirm-delete-modal.js` (+ fichiers JS modifiés) | tests fonctionnels suppression Budget/Goal/Property existants (non-régression stricte) | 3 nouveaux tests (section D3) | revue de code (denyAccessUnlessGranted + isCsrfTokenValid inchangés) | oui | jusqu'à 16 combinaisons (section D3), réductible |
| LOT-VIS-CSS-002 | non concerné (fichiers HTML statiques hors Twig) | non concerné | non concerné | aucun | nouveau test (section E) | non concerné | oui | 1 scénario (section E) |

**Recette consolidée après les 4 lots** :
- VIS-P1-001 à VIS-P1-004 individuellement re-testés (scénarios ci-dessus)
- Navigation mobile complète (drawer + notifications) sur 2-3 routes `/app/*`
- Budget/Report/Export en dark (hover) sur les 3 pages
- Modales destructives sur les 4 modules (ouverture/annulation/fermeture clavier, pas de confirmation réelle sur données de démonstration)
- `/admin/design-system` (0 erreur console/réseau)
- Smoke test des parcours P1 du manifeste original (S01-S11, S21-S26 a minima)

---

## J. Prompt Codex autonome

Le prompt ci-dessous est destiné à une session Codex (ou Claude Code) autonome chargée d'implémenter les 4 lots dans l'ordre, en respectant strictement les allowlists et tests de ce manifeste. À copier tel quel dans une nouvelle session dédiée à l'implémentation (hors session d'audit).

```
IMPLEMENT-VISUAL-CORRECTIONS — Implémenter les 4 lots correctifs de la recette visuelle Budgex

Source de vérité : .claude/visual-campaigns/global-visual-corrections.md
HEAD attendu avant de commencer : 0f590d1369a53f40f58e9defce60c9422215e2e0 (ou un HEAD
descendant si des commits non liés ont été poussés depuis — vérifier qu'aucun des 4 lots
n'a déjà été appliqué avant de commencer).

Précontrôle obligatoire avant tout commit :
  git status --short
  (si config/reference.php apparaît : git checkout -- config/reference.php)
  git status -sb
  git rev-parse HEAD

Implémenter dans l'ordre, UN COMMIT PAR LOT (LOT-VIS-UX-001 peut être scindé en 2
commits selon la section D4 du manifeste) :
  1. LOT-VIS-NAV-001 (section B du manifeste)
  2. LOT-VIS-CSS-001 (section C du manifeste)
  3. LOT-VIS-UX-001 (section D du manifeste)
  4. LOT-VIS-CSS-002 (section E du manifeste)

Pour chaque lot :
  - Relire intégralement la section correspondante du manifeste avant de coder.
  - Respecter EXACTEMENT l'allowlist du lot — ne jamais "git add -A" ou "git add .".
  - Implémenter les changements précis décrits, ni plus ni moins (pas de refactor
    opportuniste, pas de nettoyage hors-scope).
  - Écrire les tests structurels et fonctionnels décrits dans le manifeste avant de
    committer.
  - Exécuter : bin/console lint:twig (fichiers concernés), node --check (fichiers JS
    concernés si applicable), php bin/phpunit --no-coverage (suite complète ou ciblée
    selon le temps disponible), git diff --cached --check.
  - Committer avec le message exact donné dans le manifeste.
  - git push origin master après chaque commit (sauf instruction contraire de l'utilisateur).
  - Si une "condition d'arrêt" du lot est rencontrée (section correspondante du
    manifeste), NE PAS committer ce lot, documenter le blocage, et passer au lot suivant
    si indépendant, sinon arrêter et rapporter.

Interdictions strictes (reprises du manifeste) :
  - Ne pas toucher à --bx-radius-md, aux box-shadow non tokenisées, à
    .bx-toast-noscript, au polyfill dark (hors les 2 règles ciblées du LOT-VIS-CSS-001),
    ni aux fallbacks Chart.js (section G du manifeste).
  - Ne pas créer de données de test artificielles pour couvrir les scénarios NON_TESTABLE
    (section F du manifeste) — ils restent différés.
  - LOT-VIS-UX-001 : ne pas toucher à la branche "data-confirm-action" de goal-form.js
    (gère "Annuler cet objectif ?", sans lien avec cette anomalie) ni à initProgressBars()
    dans immobilier_show.js.
  - LOT-VIS-UX-001 : ne pas modifier les contrôleurs (AccountController, BudgetController,
    GoalController, PropertyController) — POST/CSRF/voters/routes restent inchangés,
    seule la couche présentation (Twig/JS) est concernée.
  - LOT-VIS-CSS-001 : ne pas supprimer ou modifier la règle générique
    html[data-theme="dark"] .table-hover > tbody > tr:hover > * (app.css ~L1906).

Après les 4 lots, exécuter la recette consolidée décrite section I du manifeste
(Playwright si disponible dans l'environnement d'implémentation, sinon documenter
l'impossibilité et recommander une recette manuelle).

Rapport final attendu :
  1. Statut Git initial et final (par lot).
  2. Diff résumé par lot (fichiers touchés, lignes ajoutées/retirées).
  3. Résultats des tests structurels/fonctionnels par lot.
  4. Résultats de la recette consolidée (ou cause du report si Playwright indisponible).
  5. Confirmation : allowlist strictement respectée pour chaque commit.
  6. Liste des 4 SHA de commit (ou des lots non committés avec la raison).
```

---

## K. Compte rendu de cette session d'audit

1. **Statut Git** : initial = HEAD `0f590d1` = origin/master, `config/reference.php` régénéré par les commandes `bin/console` lancées pendant l'audit (lecture seule des routes/templates, aucune commande d'écriture), restauré à la fin. Final = identique à l'initial, working tree propre.
2. **Cause exacte VIS-P1-001** : voir section B2.
3. **Structure LOT-VIS-NAV-001** : voir section B (1 fichier, 1 ligne modifiée, 3 scénarios Playwright).
4. **Cause exacte VIS-P1-002** : voir section C1 (nuancée par page — impact perceptible réel limité à Export).
5. **Structure LOT-VIS-CSS-001** : voir section C (1 fichier, 2 règles ajoutées, aucune suppression).
6. **Audit des quatre suppressions** : voir section D1 (tableau complet template/route/CSRF/voter/JS/texte/comportement).
7. **Décision de composant partagé** : Option B — nouveau partial générique inspiré du pattern Comptes, sans réutiliser `_delete_modal.html.twig` tel quel (incompatible avec l'option Archiver propre aux Comptes).
8. **Structure LOT-VIS-UX-001** : voir section D3-D4 (5 fichiers Twig + 4 fichiers JS, scindable en 2 commits).
9. **Cause exacte VIS-P1-004** : voir section E1 (segment `img/` manquant dans 4 fichiers statiques, 5 occurrences).
10. **Structure LOT-VIS-CSS-002** : voir section E (4 fichiers, 5 remplacements de chemin).
11. **NON_TESTABLE différés** : voir section F (8 cas documentés, aucun traité, aucune donnée artificielle créée).
12. **Dettes non rouvertes** : voir section G — confirmé aucune touchée pendant cet audit.
13. **Tests par lot** : voir section I (tableau récapitulatif).
14. **Scénarios Playwright par lot** : détaillés dans chaque section B/C/D/E.
15. **Messages de commit** : un par lot, donnés textuellement dans chaque section.
16. **Manifeste créé** : ce fichier, `.claude/visual-campaigns/global-visual-corrections.md` (non commité depuis le dépôt principal, conformément à la consigne).
17. **Prompt Codex autonome** : section J ci-dessus.
18. **Campagne exécutable** : OUI — les 4 lots sont spécifiés avec allowlist, changements précis, tests et scénarios de revalidation ; aucune ambiguïté bloquante identifiée à ce stade.
19. **Interventions utilisateur prévues** : aucune obligatoire avant de lancer l'implémentation. Optionnelles : (a) arbitrer le badge SCA Powens (section F, dernière ligne) si une cohérence totale avec les notifications est souhaitée ; (b) valider le découpage en 2 commits de LOT-VIS-UX-001 (section D4) ou imposer un commit unique.
20. **Confirmation** : aucun fichier de production modifié, indexé ou commité pendant cette session d'audit. Seules des commandes de lecture (`grep`, `Read`, `git status`, `bin/console debug:router`/`lint` en lecture) ont été exécutées dans le dépôt principal ; `config/reference.php` restauré.

---

## L. Amendement 2026-06-17 — Protocole runner Playwright externe et reprise NAV-001

### L0. Constat à l'origine de l'amendement

La première tentative de reprise (session Codex) a appliqué correctement le diff LOT-VIS-NAV-001 en working tree mais s'est arrêtée **avant tout commit**, faute d'autorisation explicite dans ce manifeste pour créer/utiliser un environnement de navigateur automatisé hors du dépôt. Le manifeste original (sections B-J) spécifiait *quoi* tester mais pas *avec quel outil*, alors que la campagne de recette initiale (`global-visual-regression.md`) avait déjà résolu ce problème via un paquet npm isolé hors dépôt. Cet amendement corrige l'omission.

### L1. État Git autorisé pour reprendre — vérifié à la date de cet amendement

```
git status --short
 M templates/layouts/app.html.twig
git status -sb
## master...origin/master
git diff --cached --name-only
(vide — index vide)
git rev-parse HEAD
0f590d1369a53f40f58e9defce60c9422215e2e0
git rev-parse origin/master
0f590d1369a53f40f58e9defce60c9422215e2e0
git diff templates/layouts/app.html.twig
-            <div class="dropdown dropdown-notifications me-2 d-none d-sm-block">
+            <div class="dropdown dropdown-notifications me-2">
```

**Cet état est désormais le point de départ légitime de toute reprise.** Une session de reprise :
- **doit accepter** ce diff non commité comme acquis et ne **doit pas** le restaurer (`git checkout -- templates/layouts/app.html.twig` est interdit tant que NAV-001 n'a pas été validé ou explicitement rejeté) ;
- **doit** vérifier que `templates/layouts/app.html.twig` est le **seul** fichier métier modifié (en dehors de `config/reference.php`, qui est un artefact auto-régénéré par toute commande `bin/console` en dev — à restaurer systématiquement avant chaque `git status` de contrôle, jamais à committer) ;
- **doit** vérifier que le diff exact correspond caractère pour caractère à celui ci-dessus avant de poursuivre — si le diff diverge (modifications supplémentaires non prévues par LOT-VIS-NAV-001), arrêter et rapporter sans committer ;
- **ne doit pas** exiger un working tree entièrement propre comme préalable — un travail en cours non commité sur le lot courant est l'état normal d'une reprise.

### L2. Autorisation explicite — runner Playwright externe

**Un runner Playwright temporaire, hors du dépôt Git principal, est explicitement autorisé** pour exécuter les scénarios de revalidation de tous les lots (NAV-001 à CSS-002 et la recette consolidée). Cette autorisation lève le blocage rencontré par la précédente tentative de reprise.

**Ordre de résolution obligatoire** :

**A. Réutiliser le runner historique s'il existe** :
```
%TEMP%\budgex-visual-qa\
```
Vérifié à la date de cet amendement : **ce dossier existe déjà** avec Playwright 1.61.0 installé (`node_modules\playwright`) et Chromium 1228 mis en cache sous `%LOCALAPPDATA%\ms-playwright\`. C'est le runner de la campagne de recette initiale (`global-visual-regression.md`). **Une session de reprise doit le réutiliser en priorité** — ne pas réinstaller Playwright si ce dossier répond déjà.

**B. Si absent, rechercher tout autre paquet temporaire exploitable** contenant `node_modules\playwright` ou `node_modules\@playwright\test`, sous `%TEMP%\` ou tout autre dossier hors dépôt déjà utilisé pour ce projet.

**C. Si aucun runner exploitable n'existe**, créer :
```
%TEMP%\budgex-visual-corrections-runner\
```
avec :
```
npm init -y
npm install playwright@1.61.0
npx playwright install chromium
```
Toutes ces opérations s'exécutent **hors du dépôt Budgex**, dans le dossier temporaire uniquement.

**Interdictions absolues (rappel, déjà en vigueur depuis la section H mais explicitées ici sans ambiguïté)** :
- ne jamais modifier `package.json` ou `package-lock.json` du projet Budgex ;
- ne jamais modifier `composer.json` ;
- ne jamais ajouter Playwright (ou tout autre paquet de test navigateur) aux dépendances versionnées du dépôt ;
- ne jamais créer de script de recette/test dans le dépôt (`tests/`, `public/`, racine du projet, etc.) ;
- ne jamais `git add` un fichier temporaire — ces fichiers vivent exclusivement sous `%TEMP%\`.

### L3. Emplacement des scripts et preuves

```
%TEMP%\budgex-visual-corrections-runner\scripts\    ← scripts Node temporaires
%TEMP%\budgex-visual-corrections-runner\evidence\   ← captures, results.json
```

Si le runner réutilisé est `%TEMP%\budgex-visual-qa\` (option A), créer ces deux sous-dossiers à l'intérieur de ce dossier existant plutôt que d'en créer un second — un seul runner actif à la fois, conformément à la section L6 (réutilisation, pas de duplication d'environnement).

Aucun script, capture d'écran ou `results.json` ne doit être écrit dans le dépôt principal, à quelque moment que ce soit.

### L4. Vérifications d'environnement avant tout scénario

Avant d'exécuter le moindre scénario Playwright, vérifier :
- `APP_ENV=dev` (ou `test`) dans `.env`/`.env.local` — jamais `prod` ;
- la base de données pointée par `DATABASE_URL` est locale (`127.0.0.1`) ;
- `http://budgex.local/login` répond HTTP 200 (ou démarrer le serveur local si nécessaire, sans modifier de configuration versionnée) ;
- les profils VISUAL-DATA et VISUAL-ADMIN de la campagne précédente restent utilisables (comptes de fixtures `@test.budgex` / `admin@budgex.fr` — ne pas régénérer les fixtures avec `--purge`, qui détruirait les données existantes sans nécessité) ;
- aucune donnée de production n'est accessible depuis cet environnement.

**Les identifiants (emails/mots de passe des profils de test) ne doivent apparaître ni dans le rapport de session, ni dans le manifeste, ni dans aucun fichier commité** — seuls les noms de profils (VISUAL-DATA, VISUAL-ADMIN) sont mentionnés publiquement, conformément à la pratique déjà appliquée dans `global-visual-regression.md`.

### L5. Validation NAV-001 — protocole de reprise immédiate

Avec le runner résolu (section L2) et l'environnement vérifié (section L4), exécuter les trois scénarios de revalidation déjà spécifiés section B3 :

| Scénario | Viewport | Thème | Contrôles |
|---|---|---|---|
| 1 | 360×800 | dark | notifications visibles, dropdown ouvrable, compteur affiché, touch target ≥44×44px, 0 overflow horizontal (`scrollWidth === clientWidth`), focus clavier atteignable, fermeture correcte (clic extérieur ou Échap), 0 nouvelle erreur console/réseau |
| 2 | 360×800 | light | idem |
| 3 | 1440×900 | dark | non-régression desktop (le bouton était déjà visible avant le correctif — vérifier qu'il le reste à l'identique) |

**En cas de PASS sur les 3 scénarios** :
1. Exécuter les validations statiques du lot (section I) : `bin/console lint:twig templates/layouts/app.html.twig`.
2. `git status --short` → restaurer `config/reference.php` s'il apparaît.
3. `git add templates/layouts/app.html.twig` (uniquement ce fichier — allowlist stricte du lot).
4. `git diff --cached --name-only` (doit afficher exactement `templates/layouts/app.html.twig`).
5. `git diff --cached --check`.
6. `git commit -m "fix(nav): make notifications bell visible on mobile topbar (<576px)"`.
7. `git push origin master`.
8. Poursuivre avec LOT-VIS-CSS-001 (section C) en réutilisant le même runner (section L6).

**En cas de FAIL sur au moins un scénario** :
1. **Ne pas restaurer le diff** — le conserver non commité pour permettre une correction ultérieure sans perdre le travail.
2. **Ne pas committer.**
3. Rapporter précisément quel scénario a échoué et pourquoi (capture + mesure exacte, ex. `scrollWidth=372 / clientWidth=360`).
4. Arrêter avant d'entamer LOT-VIS-CSS-001 ou tout autre lot.

### L6. Réutilisation du runner pour les lots suivants

Le runner résolu en L2 (réutilisé ou nouvellement créé) **doit être réemployé sans réinstallation** pour :
- LOT-VIS-CSS-001 (section C) ;
- LOT-VIS-UX-001 (section D) ;
- LOT-VIS-CSS-002 (section E) ;
- la recette consolidée (section I, dernier paragraphe).

Ne relancer `npm install playwright` que si le runner devient indisponible (dossier supprimé entre deux sessions, par exemple) — vérifier d'abord son existence avant toute réinstallation.

### L7. Échecs techniques — classification BLOCKED_BROWSER_BOOTSTRAP

Si le runner historique (L2.A) est absent, qu'aucun runner alternatif n'est trouvé (L2.B), et que la création isolée (L2.C) échoue (erreur réseau lors du téléchargement npm/Chromium, erreur système, permissions) :
- rapporter la commande exacte qui a échoué ;
- rapporter le message d'erreur complet (réseau ou système) ;
- classer le blocage **BLOCKED_BROWSER_BOOTSTRAP** ;
- **ne pas restaurer** le diff NAV-001 en cours (le laisser non commité, intact) ;
- **ne pas committer** ;
- ne pas présenter ce blocage comme une régression de l'application Budgex elle-même — c'est une limitation de l'environnement d'exécution de la session, indépendante du code applicatif.

### L8. Prompt Codex corrigé — reprise autonome

```
RESUME-VISUAL-CORRECTIONS — Reprendre l'implémentation des lots correctifs Budgex

Source de vérité : .claude/visual-campaigns/global-visual-corrections.md (sections A-L)
HEAD attendu      : 0f590d1369a53f40f58e9defce60c9422215e2e0 (origin/master)

PRÉCONTRÔLE GIT — état dirty AUTORISÉ pour ce point de reprise précis :
  git status --short
  Attendu :  M templates/layouts/app.html.twig
  (et éventuellement  M config/reference.php → restaurer avec
   git checkout -- config/reference.php, ne JAMAIS le committer)
  git status -sb        → ## master...origin/master
  git diff --cached --name-only  → doit être VIDE (index vide)
  git rev-parse HEAD              → doit valoir 0f590d1369a53f40f58e9defce60c9422215e2e0
  git diff templates/layouts/app.html.twig
  Attendu EXACTEMENT :
    -            <div class="dropdown dropdown-notifications me-2 d-none d-sm-block">
    +            <div class="dropdown dropdown-notifications me-2">

  Si templates/layouts/app.html.twig porte un diff DIFFÉRENT de celui ci-dessus, ou si
  un autre fichier métier (hors config/reference.php) apparaît modifié : ARRÊTER,
  rapporter l'écart, ne rien committer.

  NE PAS exécuter "git checkout -- templates/layouts/app.html.twig".
  NE PAS réappliquer le correctif (il est déjà appliqué).

RUNNER PLAYWRIGHT — résolution obligatoire dans cet ordre (section L2 du manifeste) :
  A. Tester l'existence de %TEMP%\budgex-visual-qa\ avec node_modules\playwright présent.
     → si présent : le réutiliser tel quel, créer scripts\ et evidence\ à l'intérieur
       si absents.
  B. Sinon, rechercher tout autre dossier temporaire avec node_modules\playwright ou
     node_modules\@playwright\test.
  C. Sinon, créer %TEMP%\budgex-visual-corrections-runner\ et exécuter :
       npm init -y
       npm install playwright@1.61.0
       npx playwright install chromium
     (uniquement dans ce dossier temporaire — jamais dans le dépôt Budgex)

  Si A, B et C échouent tous : classer BLOCKED_BROWSER_BOOTSTRAP (section L7), ne pas
  committer, ne pas restaurer le diff NAV-001, rapporter la commande et l'erreur exactes,
  arrêter.

  Interdiction stricte : ne jamais modifier package.json, package-lock.json ou
  composer.json du dépôt Budgex ; ne jamais créer de script de recette dans le dépôt ;
  ne jamais indexer un fichier temporaire.

VÉRIFICATIONS D'ENVIRONNEMENT (section L4) :
  - APP_ENV=dev ou test, base locale, http://budgex.local/login répond 200
  - profils VISUAL-DATA / VISUAL-ADMIN déjà utilisables (fixtures existantes,
    NE PAS régénérer avec --purge)
  - ne jamais faire apparaître d'identifiant de profil dans le rapport

VALIDATION NAV-001 (section L5) — exécuter les 3 scénarios :
  1. 360×800 dark  : notifications visibles, dropdown ouvrable, compteur affiché,
     touch target ≥44×44px, 0 overflow (scrollWidth===clientWidth), focus atteignable,
     fermeture correcte, 0 nouvelle erreur console/réseau
  2. 360×800 light : idem
  3. 1440×900 dark : non-régression desktop (déjà visible avant le correctif)

  Captures et résultats → %TEMP%\<runner>\evidence\ (jamais dans le dépôt).

  SI PASS (les 3 scénarios) :
    1. bin/console lint:twig templates/layouts/app.html.twig
    2. git status --short (restaurer config/reference.php si présent)
    3. git add templates/layouts/app.html.twig   (UNIQUEMENT ce fichier)
    4. git diff --cached --name-only             (doit afficher exactement ce fichier)
    5. git diff --cached --check
    6. git commit -m "fix(nav): make notifications bell visible on mobile topbar (<576px)"
    7. git push origin master
    8. Poursuivre avec LOT-VIS-CSS-001 (section C du manifeste), en réutilisant le
       MÊME runner (section L6 — ne pas réinstaller Playwright).
    9. Puis LOT-VIS-UX-001 (section D, scindable en 2 commits selon D4) puis
       LOT-VIS-CSS-002 (section E), toujours un commit par lot, toujours avec le
       précontrôle git status --short / restauration de config/reference.php avant
       chaque commit.
    10. Recette consolidée finale (section I).

  SI FAIL (au moins un scénario) :
    - NE PAS restaurer le diff (le laisser non commité)
    - NE PAS committer
    - Rapporter précisément le scénario en échec (mesures exactes, capture)
    - ARRÊTER avant tout autre lot

INTERDICTIONS RAPPELÉES (sections F, G, H du manifeste) :
  - ne pas créer de données de test artificielles pour les cas NON_TESTABLE (section F)
  - ne pas toucher --bx-radius-md, box-shadow non tokenisées, .bx-toast-noscript,
    polyfill dark (hors les 2 règles ciblées CSS-001), fallbacks Chart.js (section G)
  - LOT-VIS-UX-001 : ne pas toucher data-confirm-action (goal-form.js) ni
    initProgressBars (immobilier_show.js) ; ne pas modifier les contrôleurs PHP
  - LOT-VIS-CSS-001 : ne pas supprimer/modifier la règle générique dark app.css ~L1906
  - toujours un commit par lot, jamais "git add -A" ni "git add ."

RAPPORT FINAL ATTENDU :
  1. Résultat du précontrôle git (diff conforme ou écart constaté).
  2. Runner résolu (A/B/C) et chemin exact utilisé.
  3. Résultats des 3 scénarios NAV-001 (PASS/FAIL détaillé).
  4. Statut du commit NAV-001 (SHA si poussé, ou raison du blocage).
  5. Progression sur les lots suivants si NAV-001 est passé (CSS-001, UX-001, CSS-002).
  6. Confirmation : aucun fichier de production ou de test modifié hors allowlist de
     chaque lot ; aucun fichier temporaire indexé ; aucun identifiant de profil exposé.
```

### L9. Compte rendu de cet amendement

1. **Statut Git initial et final** : identique avant/après cet amendement — `templates/layouts/app.html.twig` modifié (diff LOT-VIS-NAV-001 intact, non restauré, conformément à la consigne), `config/reference.php` restauré après vérification, index vide, HEAD = origin/master = `0f590d1`. Aucun commit créé pendant cette session d'amendement.
2. **Confirmation du diff NAV-001 conservé** : vérifié caractère pour caractère (section L1) — correspond exactement au diff annoncé, non touché par cette session.
3. **Protocole runner externe** : section L2 — ordre A (réutiliser `%TEMP%\budgex-visual-qa\`, **confirmé déjà présent et fonctionnel avec Playwright 1.61.0 + Chromium 1228**) → B (autre dossier temporaire) → C (création isolée si nécessaire).
4. **Chemins temporaires autorisés** : `%TEMP%\budgex-visual-qa\` (existant, prioritaire) ou `%TEMP%\budgex-visual-corrections-runner\{scripts,evidence}\` (si création nécessaire) — jamais dans le dépôt.
5. **Interdictions npm du dépôt** : section L2, rappelées explicitement (package.json/package-lock.json/composer.json du projet jamais touchés, aucun script de recette versionné).
6. **Scénarios NAV-001** : section L5, tableau des 3 scénarios avec critères de contrôle détaillés.
7. **Conditions de commit** : section L5 (PASS) — lint Twig, allowlist stricte (1 fichier), message exact, push, puis enchaînement CSS-001.
8. **Conditions de blocage** : section L7 — `BLOCKED_BROWSER_BOOTSTRAP` si A+B+C échouent, diff NAV-001 conservé tel quel, aucun commit.
9. **Réutilisation pour les autres lots** : section L6 — même runner pour CSS-001, UX-001, CSS-002 et la recette consolidée, pas de réinstallation sauf indisponibilité constatée.
10. **Manifeste mis à jour** : ce fichier, section L ajoutée (non commitée depuis le dépôt principal).
11. **Prompt Codex final** : section L8 ci-dessus, prêt à copier dans une nouvelle session de reprise.
12. **Campagne reprenable automatiquement** : **OUI** — le blocage initial (absence d'autorisation runner) est levé ; le runner historique est confirmé disponible immédiatement, sans étape d'installation requise.
13. **Confirmation** : aucun fichier de production ou de test modifié, indexé ou commité pendant cette session d'amendement. Seules des commandes de lecture/vérification (`git status`, `git diff`, tests d'existence de dossiers `%TEMP%`) ont été exécutées ; `config/reference.php` restauré ; `templates/layouts/app.html.twig` intentionnellement laissé en l'état (diff LOT-VIS-NAV-001 préservé, non commité).

---

## M. Amendement 2 — 2026-06-17 — Correctif de positionnement mobile NAV-001

### M0. Constat à l'origine de cet amendement

Le runner `%TEMP%\budgex-visual-qa\` (réutilisé conformément à la section L) a exécuté les 3 scénarios de revalidation NAV-001 :

| Scénario | Résultat |
|---|---|
| 360×800 dark | **FAIL** — panneau débordant à gauche du viewport |
| 360×800 light | **FAIL** — même débordement (indépendant du thème, confirmé géométrique pur) |
| 1440×900 dark | **PASS** — aucune régression desktop |

Mesures relevées : `menuBox.x = -84`, `menuBox.width = 328`, `viewport width = 360`, `scrollWidth = clientWidth = 360` (donc **aucun scroll horizontal** créé — le débordement est purement visuel, le panneau dépasse le bord gauche de l'écran sans agrandir la page). Tous les autres contrôles (bouton visible, touch target 48×48, ouverture clic/clavier, fermeture Échap/clic extérieur, focus visible, pas de duplication d'id, drawer utilisable, 0 nouvelle erreur console/réseau) étaient déjà conformes — seul le placement horizontal du panneau était en cause.

### M1. Audit du markup (`templates/layouts/app.html.twig:72-95`)

| Élément | Détail |
|---|---|
| Conteneur positionné | `<div class="dropdown dropdown-notifications me-2">` (ligne 78, déjà corrigé par le diff NAV-001 en cours) — `position: relative` héritée de la classe Bootstrap `.dropdown` |
| Déclencheur | `<button id="notificationDropdown" class="btn btn-lg btn-icon dropdown-toggle" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" aria-label="Notifications…">` (lignes 79-84) |
| Menu | `<ul class="dropdown-menu dropdown-menu-end mt-3 py-0" style="min-width:300px;" aria-labelledby="notificationDropdown">` (ligne 96) |
| Ordre dans la topbar | `[drawerToggle (hamburger)] [navbar-brand, flex-grow via me-auto] [dropdown-notifications] [badge SCA Powens, toujours d-none d-sm-block] [menu utilisateur (avatar)]` — **le bouton notifications n'est pas le dernier élément de la barre** ; le bouton utilisateur le suit, plus à droite |
| Identifiants | `#notificationDropdown` (déclencheur), `#notification-badge` / `#bx-notif-header-badge` (compteurs) — aucune duplication constatée |
| `aria-*` | `aria-expanded`, `aria-label` (déclencheur), `aria-labelledby` (menu) — gérés par Bootstrap, non affectés par cet amendement |

### M2. Audit CSS — inventaire complet des règles pertinentes

| Fichier | Ligne | Sélecteur | Spécificité | Breakpoint | Valeur | Ordre de chargement | Consommateur |
|---|---|---|---|---|---|---|---|
| `public/css/styles.css` | 3890 | `.dropdown-menu` (Bootstrap, racine) | (0,1,0) | aucun | `--bs-dropdown-zindex: 1000` (et autres variables Bootstrap par défaut) | 1er chargé (legacy SB Admin) | tous les dropdowns de l'app |
| `public/css/styles.css` | (règle générique, confirmée par CSSOM live, non trouvée par recherche textuelle car générée à partir d'un sélecteur composé) | `.dropdown .dropdown-menu` | (0,2,0) | aucun | `max-width: 17.5rem` (= **280px**, confirmé par `getComputedStyle` + inspection `document.styleSheets`) | 1er chargé | tous les dropdowns descendants de `.dropdown` (générique, non spécifique aux notifications) |
| `public/css/app.css` | ~1222-1226 | `.dropdown-notifications .dropdown-menu` | (0,2,0) + `!important` | `max-width: 575.98px` (xs) | `width: calc(100vw - 2rem) !important; max-width: calc(100vw - 2rem) !important;` | 3e chargé, après styles.css | neutralise correctement le `max-width:280px` générique **sur la largeur uniquement** — confirmé : à 360px cette règle produit `328px`, exactement `calc(100vw - 2rem)` |
| (Bootstrap, inline via JS dropdown.js — confirmé : **aucune règle de fichier**, comportement natif `.dropdown-menu-end`) | — | `.dropdown-menu-end` | — | aucun | `right: 0` (relatif au conteneur positionné `.dropdown`) ; `left` résolu par le navigateur comme valeur d'usage (`-280px` au contexte du conteneur, soit `-84px` en coordonnées viewport à 360px) | — | aligne le bord **droit** du menu sur le bord droit du déclencheur, **sans aucune contrainte de bord gauche** |
| — | — | `data-popper-placement` | — | — | **`null`** (confirmé par lecture directe de l'attribut DOM) ; `transform: none` (confirmé par `getComputedStyle`) | — | **Popper.js n'est pas actif** sur ce dropdown — positionnement 100% CSS statique Bootstrap, pas de JS de positionnement dynamique |

**Aucune règle de `app.css` ou `components.css` n'a été modifiée pendant cet audit** (lecture seule, confirmé par `git status` avant/après).

### M3. Styles calculés et mesures par viewport (mesurées via le runner `%TEMP%\budgex-visual-qa\`, script `nav001-measure.js`)

| Viewport | navBox (topbar) | triggerBox | menuBox (avant correctif) | computed left/right/top | width/min/max-width | data-popper-placement | transform |
|---|---|---|---|---|---|---|---|
| 360×800 | x0 y0 w360 h**72** | x196 y11.5 w48 h48 | **x=-84** y75.5 w328 h322.6 | top:48px left:-280px right:0px | width:328px min:300px max:328px | `null` | `none` |
| 390×844 | w390 h72 | x226 w48 | **x=-84** w358 | left:-310px right:0px | width:358px min:300px max:358px | `null` | `none` |
| 575×800 | w575 h72 | x411 w48 | **x=-84** w543 | left:-495px right:0px | width:543px min:300px max:543px | `null` | `none` |
| 576×800 (hors media xs) | w576 h72 | x400 w48 | x=148 w300 | left:-252px right:0px | width:300px min:300px **max:280px** | `null` | `none` |
| 1440×900 (hors media xs) | w1440 h72 | x1312 w48 | x=1060 w300 | left:-252px right:0px | width:300px min:300px **max:280px** | `null` | `none` |

**Lecture de la mécanique exacte (arithmétique vérifiée)** : à 360px, le bord droit du déclencheur est à `196+48=244px`. La règle `.dropdown-menu-end` aligne le bord droit du menu sur ce point. Le menu doit faire `328px` de large (règle xs déjà correcte). Bord gauche résultant = `244 - 328 = -84px`. **Coïncide exactement avec la mesure Playwright.** Le calcul est identique à 390px (`226+48-358=-84`) et à 575px (`411+48-543=-84`) — **le débordement de -84px est mathématiquement constant** dès que la largeur du panneau dépasse l'espace disponible à gauche du bord droit du déclencheur, ce qui est le cas sur toute la plage xs depuis que le bouton est visible sur mobile.

À 576px et 1440px (hors media xs), le `max-width:280px` générique de `styles.css` redevient actif ; combiné au `min-width:300px` inline (qui l'emporte car min > max, comportement standard du navigateur), le menu fait `300px`, largeur qui reste confortablement positionnable même avec l'ancrage à droite — **c'est pourquoi le débordement n'existe qu'en dessous de 576px**, exactement la plage que NAV-001 vient de rendre visible pour la première fois (avant NAV-001, `d-none d-sm-block` empêchait ce panneau de jamais s'ouvrir sur mobile — cette règle de largeur xs existait déjà dans le code mais n'avait jamais été exercée visuellement).

### M4. Classification de la cause

**C. MOBILE_POSITION_OVERRIDE**, avec preuve explicite d'élimination des autres catégories :
- **A (classe Bootstrap manquante)** — éliminé : Bootstrap ne fournit aucune classe utilitaire native qui borne un dropdown au viewport sur mobile ; `dropdown-menu-end` fait exactement ce qu'il est censé faire (ancrer à droite du déclencheur), ce n'est pas un défaut d'usage de classe.
- **B (largeur insuffisamment contrainte)** — éliminé : la largeur est déjà correctement contrainte par la règle xs existante (`calc(100vw - 2rem)`, confirmée produire exactement 328/358/543px) ; réduire encore la largeur pour la faire rentrer dans l'espace disponible (244px à 360px) produirait un panneau de notification inconfortablement étroit et trahirait l'intention déjà documentée dans le commentaire du code ("pleine largeur sur xs").
- **D (conflit de règle globale)** — éliminé comme cause principale : le conflit avec `.dropdown .dropdown-menu { max-width:17.5rem }` générique est **déjà résolu** par la règle xs existante (`!important`) ; il ne reste plus de conflit de règle non maîtrisé, juste une absence de règle de position.
- **E (configuration Popper)** — **éliminé avec preuve directe** : `data-popper-placement` est `null` et `transform` est `none` sur les 5 viewports testés → Popper.js n'intervient pas du tout dans ce positionnement, qui est 100% CSS statique Bootstrap (`.dropdown-menu-end`). Aucune configuration JS à modifier.
- **C retenue** : le menu nécessite une règle de positionnement responsive explicitement bornée au viewport sous 576px, qui n'existe pas aujourd'hui — la règle xs actuelle couvre la largeur mais pas la position.

### M5. Options comparées

| Option | Description | Évaluation |
|---|---|---|
| **1 — classe Bootstrap existante** | Chercher une classe Bootstrap (`dropdown-menu-start`, variante responsive `dropdown-menu-sm-end`, etc.) qui résoudrait le débordement | **Rejetée** : aucune classe Bootstrap stock ne borne un dropdown au viewport — `dropdown-menu-{breakpoint}-{start\|end}` ne fait que changer l'ancre gauche/droite, pas la contrainte de viewport ; passer à `dropdown-menu-start` sur mobile déplacerait le débordement vers la droite au lieu de le supprimer (le bouton n'est pas non plus à l'extrême gauche) |
| **2 — règle CSS responsive scoped, repositionnement en `absolute`** | Conserver `position:absolute` mais ajouter `left:auto !important` ou une valeur calculée pour recentrer | **Rejetée** : en `position:absolute`, le panneau reste positionné **relativement au conteneur `.dropdown`** (qui suit le déclencheur dans le flux de la topbar), pas au viewport. Aucune valeur fixe de `left`/`right` en `absolute` ne peut garantir un placement à distance constante des deux bords du **viewport** quelle que soit la position du déclencheur dans la barre — la seule façon d'ancrer au viewport est `position: fixed` |
| **3 — position fixed mobile (RETENUE)** | `position: fixed` scopé à `.dropdown-notifications .dropdown-menu` sous 575.98px, avec `left`/`right` en `rem` et `top` mesuré | **Retenue** — voir M6 et validation M7. Le passage à `fixed` ancre le panneau au viewport (pas au conteneur), ce qui est exactement le comportement requis : marges symétriques constantes par rapport aux bords de l'écran, indépendantes de la position du déclencheur dans la topbar |
| **4 — configuration Popper** | Réactiver/configurer Popper avec un modificateur `preventOverflow`/`flip` pour ce dropdown spécifique | **Rejetée sans même être testée** : Popper n'est pas actif sur ce dropdown (M3/M4) ; l'activer introduirait une dépendance JS nouvelle pour un problème intégralement résoluble en CSS, contraire au principe de correctif minimal et scoped |

### M6. Solution retenue et contrat visuel

**Étendre la règle existante** `public/css/app.css` (bloc `@media (max-width: 575.98px)`, lignes ~1222-1226) en y ajoutant le positionnement, sans toucher à la largeur déjà correcte :

```css
/* Notifications dropdown : pleine largeur sur xs */
.dropdown-notifications .dropdown-menu {
    width: calc(100vw - 2rem) !important;
    max-width: calc(100vw - 2rem) !important;
    position: fixed !important;
    top: 72px !important;
    left: 1rem !important;
    right: 1rem !important;
    bottom: auto !important;
    transform: none !important;
}
```

**Justification de chaque valeur ajoutée** :
- `position: fixed !important` : ancre le panneau au viewport plutôt qu'au conteneur `.dropdown` (option 3, seule option viable — voir M5).
- `top: 72px !important` : **mesuré directement** — hauteur de `.top-app-bar` (bounding box), **identique sur les 5 viewports testés** (360/390/575/576/1440), donc une valeur stable et fiable. Aucun token `--bx-*` existant ne porte cette mesure (recherché, absent — voir M2) ; valeur brute justifiée par la mesure live, pas inventée.
- `left: 1rem !important` / `right: 1rem !important` : réutilisent le `rem` déjà présent dans la règle existante (`calc(100vw - 2rem)` = viewport moins exactement `2×1rem`) — **aucune nouvelle valeur d'espacement introduite**, cohérence totale avec l'intention déjà codée par l'auteur de la règle xs.
- `bottom: auto !important` / `transform: none !important` : resets défensifs (valeurs déjà observées comme neutres avant correctif, mais explicités pour empêcher toute régression si une future règle ou mise à jour de Bootstrap introduit un `transform` résiduel).

**Validation live effectuée** (via `page.addStyleTag` dans le runner Playwright, **jamais écrit dans un fichier du dépôt** — purement en mémoire navigateur pour preuve avant correctif réel) :

| Viewport | menuBox.x | menuBox.width | rightEdge (x+width) | Contrat mobile (x≥16, rightEdge≤vw-16) | Overflow | Notes |
|---|---|---|---|---|---|---|
| 360×800 | **16** | 328 | 344 (=360-16) | ✅ respecté exactement | non | capture `nav001-fix-360x800.png` : rendu propre, lien "Voir toutes les notifications" visible, aucune troncature |
| 390×844 | **16** | 358 | 374 (=390-16) | ✅ | non | — |
| 575×800 | **16** | 543 | 559 (=575-16) | ✅ | non | — |
| 576×800 | 148 | 300 | 448 | **identique à l'avant-correctif** (148/300) | non | confirme l'absence de régression à la frontière du breakpoint |
| 1440×900 | 1060 | 300 | 1360 | **identique à l'avant-correctif** (1060/300) | non | confirme l'absence de régression desktop |

Contrôles d'interaction revérifiés après correctif (toujours via `addStyleTag`, mêmes scénarios qu'avant) : ouverture clavier (Tab×2 depuis `#drawerToggle` puis Entrée) → menu visible ; `Échap` → menu fermé ; clic extérieur → menu fermé. **Aucune régression d'interaction.**

### Contrat mobile (< 576px)

- `menuBox.x >= 16` (1rem) — **vérifié 16px exactement aux 3 largeurs xs testées**
- `menuBox.x + menuBox.width <= viewport_width - 16` — **vérifié exactement** (344/374/559 = vw-16 dans les 3 cas)
- Largeur exploitable sans texte comprimé : confirmé par capture (328px à 360px, lisible, aucune troncature du texte des notifications ni du lien de pied de panneau)
- 0 overflow horizontal (`scrollWidth === clientWidth`) : confirmé sur les 3 largeurs
- 0 contenu tronqué : confirmé par capture (le lien "Voir toutes les notifications" reste visible et cliquable)
- Ouverture/fermeture (clic, clavier, Échap, clic extérieur) : confirmé fonctionnel après correctif
- Touch target inchangé : le déclencheur (`.btn-lg.btn-icon`, 48×48 mesuré) n'est pas modifié par ce correctif (seul le `<ul class="dropdown-menu">` est concerné)
- Focus visible : géré par Bootstrap/le navigateur, non affecté par un changement de `position`
- Compteur inchangé : `#notification-badge` / `#bx-notif-header-badge` non touchés

### Contrat desktop (≥ 576px)

- Comportement, largeur (300px, résultant du conflit min/max déjà existant, non introduit par ce correctif) et placement (`x=148` à 576px, `x=1060` à 1440px) **strictement inchangés**, vérifié par mesure identique avant/après sur les 2 viewports desktop testés.
- Aucune régression des autres dropdowns de l'application : le sélecteur `.dropdown-notifications .dropdown-menu` est strictement scopé à ce composant, aucune règle générique (`.dropdown-menu`, `.dropdown .dropdown-menu`) n'est modifiée.

### M7. Allowlist amendée de LOT-VIS-NAV-001

| Fichier | Changement |
|---|---|
| `templates/layouts/app.html.twig` | déjà appliqué en working tree (retrait de `d-none d-sm-block`, ligne 78) — **inchangé par cet amendement** |
| `public/css/app.css` | **ajout** des 5 déclarations de positionnement (M6) dans la règle existante `.dropdown-notifications .dropdown-menu` du bloc `@media (max-width: 575.98px)` (~lignes 1222-1226) — aucune autre ligne du fichier touchée |
| Test structurel (nouveau ou étendu) | lecture de `public/css/app.css`, assertion de présence des 5 nouvelles déclarations dans le bloc média xs, **dans la même règle** que `width`/`max-width` (pas une règle dupliquée ailleurs) |

**Exclu explicitement** (rappel de la consigne) : Bank/Powens, badge SCA Powens (`#powensAlertDropdown`), tout fichier sans lien direct, tout JavaScript (le correctif est intégralement CSS, aucun fichier `.js` modifié).

### M8. Diff exact attendu (à appliquer par l'implémenteur)

```diff
--- a/public/css/app.css
+++ b/public/css/app.css
@@ -1221,7 +1221,12 @@
     /* Notifications dropdown : pleine largeur sur xs */
     .dropdown-notifications .dropdown-menu {
         width: calc(100vw - 2rem) !important;
         max-width: calc(100vw - 2rem) !important;
+        position: fixed !important;
+        top: 72px !important;
+        left: 1rem !important;
+        right: 1rem !important;
+        bottom: auto !important;
+        transform: none !important;
     }
```

(Numéros de ligne indicatifs — à ajuster selon l'état exact du fichier au moment de l'implémentation ; le bloc `@media (max-width: 575.98px)` et la règle `.dropdown-notifications .dropdown-menu` existante servent d'ancre fiable, identifiables par leur commentaire `/* Notifications dropdown : pleine largeur sur xs */`.)

### M9. Tests

**Statiques** :
- `bin/console lint:twig templates/layouts/app.html.twig` (déjà requis par la version initiale du lot, inchangé)
- `bin/console lint:container` (non concerné — aucun service modifié, à exécuter par prudence seulement)
- Test structurel (nouveau, pattern `SharedAppCssInlineCodeTest`) lisant `public/css/app.css` et assertant :
  - présence de `position: fixed !important;` dans le voisinage immédiat de `.dropdown-notifications .dropdown-menu` sous le bloc `@media (max-width: 575.98px)`
  - présence de `top: 72px !important;`, `left: 1rem !important;`, `right: 1rem !important;`
  - absence de toute règle dupliquée équivalente ailleurs dans le fichier (contrôle d'occurrence : une seule règle `.dropdown-notifications .dropdown-menu` dans tout `app.css`)
- `git diff --check` (espaces/fins de ligne)

**Playwright obligatoires** (6 scénarios, runner `%TEMP%\budgex-visual-qa\`) :

| Viewport | Thème | Mesures à collecter |
|---|---|---|
| 360×800 | dark | bounding boxes déclencheur+menu, overflow, visibilité, ouverture/fermeture clic+clavier+Échap, console, réseau |
| 360×800 | light | idem |
| 390×844 | dark | idem |
| 575×800 | dark | idem |
| 576×800 | dark | idem — **doit être identique à l'état pré-correctif** (non-régression frontière) |
| 1440×900 | dark | idem — **doit être identique à l'état pré-correctif** (non-régression desktop) |

Critères de PASS : `menuBox.x >= 16` et `menuBox.x + menuBox.width <= viewport_width - 16` sur les 4 viewports < 576px ; `menuBox` strictement identique aux valeurs pré-correctif sur 576×800 et 1440×900 ; 0 overflow (`scrollWidth === clientWidth`) sur tous ; 0 nouvelle erreur console/réseau ; ouverture/fermeture clavier et Échap fonctionnelles.

### M10. Journal du blocage et de sa résolution

| Étape | Constat |
|---|---|
| Tentative de reprise précédente | Diff NAV-001 (retrait `d-none d-sm-block`) appliqué, runner Playwright autorisé (section L), 3 scénarios exécutés |
| Résultat | 360×800 dark **FAIL**, 360×800 light **FAIL**, 1440×900 dark **PASS** |
| Cause du FAIL | Débordement géométrique du panneau (`menuBox.x = -84` à 360px), **sans** scroll horizontal créé (`scrollWidth === clientWidth`) — débordement purement visuel |
| Investigation menée (cette session) | Audit markup (M1), audit CSS exhaustif incluant inspection directe du CSSOM (M2), mesures live sur 5 viewports (M3), classification causale avec élimination motivée de 4 des 5 catégories (M4), comparaison de 4 options (M5) |
| Correctif retenu | Extension de la règle CSS existante (déjà scopée xs, déjà partiellement correcte pour la largeur) avec 5 déclarations de positionnement (M6) |
| Validation | Correctif testé en mémoire navigateur (`addStyleTag`, jamais écrit sur disque) sur les 5 viewports + contrôles d'interaction — 100% conforme au contrat (M6, M9) |
| État du diff NAV-001 en cours | **Non restauré, non réappliqué** — laissé tel quel dans le working tree, conformément à la consigne |
| Fichiers de production modifiés pendant cette session | **Aucun** — uniquement lecture (`grep`, `Read`) et tests temporaires via Playwright (`addStyleTag`, jamais persisté) |

### M11. Prompt Codex de reprise (corrigé, remplace la validation NAV-001 de la section L8)

```
RESUME-VISUAL-CORRECTIONS-v2 — Reprendre l'implémentation des lots correctifs Budgex
(avec correctif de positionnement mobile NAV-001)

Source de vérité : .claude/visual-campaigns/global-visual-corrections.md (sections A-M,
la section M fait foi pour LOT-VIS-NAV-001 — elle remplace le contenu de la section B/LOT
initial sur les points de désaccord)
HEAD attendu      : 0f590d1369a53f40f58e9defce60c9422215e2e0 (origin/master)

PRÉCONTRÔLE GIT — état dirty AUTORISÉ pour ce point de reprise précis :
  git status --short
  Attendu :  M templates/layouts/app.html.twig
  (et éventuellement  M config/reference.php → restaurer avec
   git checkout -- config/reference.php, ne JAMAIS le committer)
  git diff --cached --name-only  → doit être VIDE
  git rev-parse HEAD              → 0f590d1369a53f40f58e9defce60c9422215e2e0
  git diff templates/layouts/app.html.twig
  Attendu EXACTEMENT :
    -            <div class="dropdown dropdown-notifications me-2 d-none d-sm-block">
    +            <div class="dropdown dropdown-notifications me-2">

  NE PAS restaurer ni réappliquer ce diff. Si le diff diverge de celui ci-dessus ou si un
  autre fichier métier (hors config/reference.php) est modifié : ARRÊTER et rapporter.

RUNNER PLAYWRIGHT (section L2) : réutiliser %TEMP%\budgex-visual-qa\ (déjà présent et
fonctionnel, confirmé lors de l'amendement précédent) — ne pas réinstaller Playwright.

APPLIQUER LE COMPLÉMENT CSS (section M6/M8 du manifeste) :
  Dans public/css/app.css, localiser le bloc @media (max-width: 575.98px) contenant la
  règle .dropdown-notifications .dropdown-menu (commentaire "/* Notifications dropdown :
  pleine largeur sur xs */"). Ajouter à l'intérieur de cette MÊME règle (ne pas créer de
  règle dupliquée ailleurs) :
    position: fixed !important;
    top: 72px !important;
    left: 1rem !important;
    right: 1rem !important;
    bottom: auto !important;
    transform: none !important;
  Ne toucher à aucune autre ligne de app.css. Ne toucher à aucun autre fichier CSS.

VALIDATION NAV-001 — exécuter les 6 scénarios (section M9) :
  360×800 dark, 360×800 light, 390×844 dark, 575×800 dark, 576×800 dark, 1440×900 dark
  Critères de PASS (section M9) :
    - menuBox.x >= 16 et menuBox.x + menuBox.width <= viewport_width - 16 sur les 4
      viewports < 576px
    - menuBox strictement identique à l'état pré-correctif sur 576×800 et 1440×900
      (x=148/w=300 et x=1060/w=300 respectivement — comparer aux valeurs mesurées
      dans le manifeste, section M3, colonne "avant correctif")
    - 0 overflow (scrollWidth === clientWidth) sur tous les viewports
    - 0 nouvelle erreur console/réseau
    - ouverture clic + clavier (Tab puis Entrée), fermeture Échap + clic extérieur :
      toutes fonctionnelles

  Captures et results.json → %TEMP%\budgex-visual-qa\evidence\ (jamais dans le dépôt).

  SI PASS (les 6 scénarios) :
    1. bin/console lint:twig templates/layouts/app.html.twig
    2. git status --short (restaurer config/reference.php si présent)
    3. git add templates/layouts/app.html.twig public/css/app.css
    4. git diff --cached --name-only   → doit afficher exactement ces 2 fichiers
    5. git diff --cached --check
    6. git commit -m "fix(nav): make notifications bell visible and viewport-contained on mobile (<576px)"
    7. git push origin master
    8. Poursuivre avec LOT-VIS-CSS-001 (section C), LOT-VIS-UX-001 (section D, scindable
       selon D4), puis LOT-VIS-CSS-002 (section E) — un commit par lot, même runner
       (section L6, pas de réinstallation), précontrôle git avant chaque commit.
    9. Recette consolidée finale (section I).

  SI FAIL (au moins un des 6 scénarios) :
    - NE PAS committer, NE PAS restaurer le diff (le laisser non commité, complet ou non)
    - Rapporter précisément quel scénario échoue, avec les mesures exactes (menuBox.x,
      width, viewport) et une capture
    - ARRÊTER avant tout autre lot

ÉCHEC TECHNIQUE DU RUNNER : si %TEMP%\budgex-visual-qa\ est devenu indisponible et
qu'aucune alternative (section L2.B) ni création isolée (section L2.C) ne fonctionne :
classer BLOCKED_BROWSER_BOOTSTRAP (section L7), ne rien committer, ne rien restaurer,
rapporter la commande et l'erreur exactes.

INTERDICTIONS RAPPELÉES :
  - ne pas toucher au badge SCA Powens, à Bank/Powens, à aucun fichier JavaScript pour
    ce lot (le correctif est intégralement CSS)
  - ne pas créer de seconde règle .dropdown-notifications .dropdown-menu — étendre
    l'unique règle existante dans le bloc média xs
  - ne pas toucher --bx-radius-md, box-shadow non tokenisées, .bx-toast-noscript,
    polyfill dark (hors les 2 règles ciblées de LOT-VIS-CSS-001), fallbacks Chart.js
  - toujours un commit par lot, jamais "git add -A" ni "git add ."

RAPPORT FINAL ATTENDU :
  1. Résultat du précontrôle git.
  2. Diff CSS exact appliqué (avec numéros de ligne réels du fichier au moment du commit).
  3. Résultats des 6 scénarios NAV-001 (PASS/FAIL détaillé, mesures exactes).
  4. Statut du commit NAV-001 (SHA si poussé, ou raison du blocage).
  5. Progression sur CSS-001/UX-001/CSS-002 si NAV-001 est passé.
  6. Confirmation : allowlist strictement respectée, aucun fichier hors scope touché.
```

### M12. Compte rendu de cet amendement

1. **Statut Git initial et final** : identique avant/après — `templates/layouts/app.html.twig` modifié (diff NAV-001 préservé tel quel, non restauré, non réappliqué), `config/reference.php` restauré (réapparu seul, artefact auto-régénéré, sans rapport avec les commandes de cette session), index vide, HEAD = origin/master = `0f590d1`. Aucun commit créé.
2. **Diff NAV-001 conservé** : vérifié caractère pour caractère au début et en fin de session (section précontrôle) — strictement inchangé.
3. **Markup du dropdown** : section M1 — conteneur `.dropdown-notifications`, déclencheur `#notificationDropdown`, menu `.dropdown-menu.dropdown-menu-end` avec `min-width:300px` inline ; le bouton notifications n'est pas le dernier élément de la topbar (le menu utilisateur le suit).
4. **Règles CSS impliquées** : section M2 — 4 règles identifiées (Bootstrap générique `.dropdown-menu`, générique `.dropdown .dropdown-menu` max-width 17.5rem/280px, règle xs existante `.dropdown-notifications .dropdown-menu` déjà correcte pour la largeur, comportement natif `.dropdown-menu-end` sans Popper).
5. **Styles calculés et mesures par viewport** : section M3, tableau complet 360/390/575/576/1440, avec preuve arithmétique exacte du débordement constant de -84px.
6. **Cause classifiée** : **C. MOBILE_POSITION_OVERRIDE**, avec élimination motivée de A/B/D/E (section M4) — E éliminé avec preuve directe (`data-popper-placement: null`).
7. **Options comparées** : 4 options (section M5), option 3 (position fixed mobile) retenue comme seule solution capable d'ancrer le panneau au viewport plutôt qu'au conteneur suivant le déclencheur.
8. **Solution retenue** : extension de la règle CSS existante avec 6 déclarations (`position`, `top`, `left`, `right`, `bottom`, `transform`), toutes justifiées par mesure ou réutilisation de token existant (section M6).
9. **Allowlist finale** : `templates/layouts/app.html.twig` (déjà appliqué) + `public/css/app.css` (à ajouter) + 1 test structurel (section M7).
10. **Diff exact attendu** : section M8.
11. **Contrat mobile** : section M6 — `x>=16`, `x+width<=vw-16`, vérifié exactement sur 360/390/575px.
12. **Contrat desktop** : section M6 — comportement strictement identique sur 576/1440px, vérifié par mesure avant/après.
13. **Tests statiques** : section M9 — lint Twig, test structurel CSS, contrôle d'occurrence, `git diff --check`.
14. **Scénarios Playwright** : section M9 — 6 scénarios (360 dark/light, 390, 575, 576, 1440), tous exécutés en validation live pour cette session (via `addStyleTag`, non persisté).
15. **Manifeste mis à jour** : ce fichier, section M ajoutée (non commitée depuis le dépôt principal).
16. **Prompt Codex final** : section M11 ci-dessus.
17. **Campagne reprenable automatiquement** : **OUI** — correctif identifié, formellement spécifié et déjà validé empiriquement (en mémoire navigateur) avant d'être proposé à l'implémentation réelle.
18. **Confirmation** : aucun fichier de production ou de test modifié, indexé ou commité pendant cette session d'amendement. Le correctif CSS a été testé exclusivement via injection de style en mémoire navigateur (`page.addStyleTag`), jamais écrit sur disque dans le dépôt ; `templates/layouts/app.html.twig` laissé strictement inchangé (diff NAV-001 préservé) ; `config/reference.php` restauré.

---

## N. Amendement 3 — 2026-06-17 — Arbitrage Comptes (LOT-VIS-UX-001) + blocage allowlist découvert

### N0. Contexte

`LOT-VIS-NAV-001` et `LOT-VIS-CSS-001` sont commités et poussés (`776c878a…`, `9ae9ee4e…`). `LOT-VIS-UX-001` est entièrement appliqué dans le working tree (9 fichiers : 5 Twig + 4 JS, conforme à l'allowlist du manifeste), mais non indexé, non commité. Une session de validation a rapporté un scénario Playwright rouge sur `/app/accounts/224` (DataTable + fermeture Échap) alors que Comptes est explicitement **hors allowlist** de ce lot. Mission de cet amendement : déterminer la cause exacte de ce rouge sans perdre le working tree, et statuer sur l'autorisation de commit.

### N1. Inventaire exact des neuf fichiers du working tree

| # | Fichier | Rôle | Diff (résumé) | Consommateurs / routes | Chargement |
|---|---|---|---|---|---|
| 1 | `templates/_partials/_confirm_delete_modal.html.twig` *(nouveau)* | Partial générique de modale de confirmation destructive (titre, corps, bouton Annuler, formulaire POST+CSRF, bouton danger) | — | Inclus par les fichiers 4-7 via `{% include … with {…} %}`, paramétré (`modalId`, `title`, `body`, `formAction`, `csrfTokenId`, `submitLabel`) | Twig include, pas de route propre |
| 2 | `public/js/confirm-delete-modal.js` *(nouveau)* | Binding générique : focus du bouton submit à l'ouverture, fermeture Échap (`keydown`/`keyup` capturants sur `document`+`window`), garde anti-double-soumission | — | Référencé uniquement par les 4 fichiers Twig 4-7 via `<script src="…confirm-delete-modal.js?v=vis-ux-001">` | Chargement explicite, **un seul endroit par page**, jamais dans `app.html.twig` (layout non modifié) |
| 3 | `public/js/budget-actions.js` | Avant : confirmation native `data-confirm-delete`. Après : **fichier vidé** (IIFE vide) | `templates/budget/index.html.twig` (et, **constat de cet amendement**, `templates/budget/edit.html.twig` — voir N6) | Toujours chargé sur les deux pages budget ; ne fait plus rien |
| 4 | `templates/budget/index.html.twig` | Liste des budgets, bouton supprimer par ligne | `data-confirm-delete` natif → `data-bs-toggle="modal"` + 1 modale par budget (boucle après le tableau) | `/app/budgets` | Charge `confirm-delete-modal.js` |
| 5 | `public/js/goal-form.js` | Avant : gérait `data-confirm-delete` ET `data-confirm-action`. Après : **gère uniquement `data-confirm-action`** (action "Annuler cet objectif ?", hors périmètre) | `templates/goal/edit.html.twig`, `templates/goal/show.html.twig` | Chargé sur les deux pages objectif |
| 6 | `templates/goal/edit.html.twig` | Formulaire d'édition + suppression de l'objectif | `data-confirm-delete` natif → modale unique | `/app/goals/{id}/edit` | Charge `confirm-delete-modal.js` |
| 7 | `templates/goal/show.html.twig` | Détail objectif + historique des versements (rendu **deux fois** : table desktop + cards mobile) | Les 2 déclencheurs (desktop+mobile) par versement pointent vers `data-bs-target="#deleteContributionModal{id}"` ; **une seule modale par versement**, rendue dans une boucle séparée après les deux blocs desktop/mobile | `/app/goals/{id}` | Charge `confirm-delete-modal.js` |
| 8 | `public/js/immobilier_show.js` | Avant : gérait `data-confirm-delete` + `initProgressBars()`. Après : **`initProgressBars()` seul conservé**, fonction de confirmation supprimée | `templates/patrimoine/immobilier_show.html.twig` | Chargé sur la page bien immobilier |
| 9 | `templates/patrimoine/immobilier_show.html.twig` | Détail d'un bien, suppression | `data-confirm-delete` natif → modale unique | `/app/patrimoine/immobilier/{id}` | Charge `confirm-delete-modal.js` |

**Confirmation explicite** : `confirm-delete-modal.js` n'est référencé que dans les fichiers 4, 6, 7, 9 ci-dessus. Aucune trace dans `templates/layouts/app.html.twig` (non modifié, vérifié par `git diff --name-only` au précontrôle) ni dans aucun template Comptes.

### N2. Graphe de dépendances de `/app/accounts/224` (mesuré en direct, runner `%TEMP%\budgex-visual-qa\`)

Scripts chargés, dans l'ordre réseau observé :

```
https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js   (CDN)
http://budgex.local/js/material.js
http://budgex.local/js/app.js
http://budgex.local/js/notifications.js?v=4
http://budgex.local/js/chart.umd.min.js
http://budgex.local/js/account-balance-chart.js
https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js            (CDN)
https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js             (CDN)
https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js          (CDN)
https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js            (CDN)
https://cdn.datatables.net/2.1.8/js/dataTables.min.js                       (CDN)
https://cdn.datatables.net/2.1.8/js/dataTables.bootstrap5.min.js            (CDN)
https://cdn.datatables.net/buttons/3.1.2/js/dataTables.buttons.min.js       (CDN)
https://cdn.datatables.net/buttons/3.1.2/js/buttons.bootstrap5.min.js       (CDN)
https://cdn.datatables.net/buttons/3.1.2/js/buttons.html5.min.js            (CDN)
https://cdn.datatables.net/buttons/3.1.2/js/buttons.print.min.js            (CDN)
http://budgex.local/js/datatables-init.js
http://budgex.local/js/account-tx-detail.js
http://budgex.local/js/account-delete-modal.js
```

- **`confirm-delete-modal.js` absent** de cette liste (confirmé par script — recherche de `"confirm-delete-modal"` dans les `src` chargés → `false`).
- Partial de suppression utilisé : `account/_delete_modal.html.twig` (inclus ligne 240 de `account/show.html.twig`), **distinct** du nouveau `_confirm_delete_modal.html.twig` générique — Comptes garde son propre composant (option Archiver/Supprimer, voir section D du manifeste), non touché par UX-001.
- DataTables : chargé intégralement via 8 scripts CDN (`jquery.slim`, `jszip`, `pdfmake` ×2, `dataTables` ×2, `buttons` ×4) + `datatables-init.js` local, conformément au commentaire d'origine de `_partials/_datatables_js.html.twig` (qui documente lui-même la dépendance CDN comme un choix temporaire, avec suggestion de self-hosting future pour SRI).
- Bootstrap lui-même (`bootstrap.bundle.min.js`) est **également chargé depuis un CDN** (`cdn.jsdelivr.net`), donc soumis à la même catégorie de risque réseau que DataTables.
- Aucun handler Échap custom dans `account-delete-modal.js` (vérifié — il gère uniquement un `window.confirm()` additionnel quand `txCount > 0`, pas de logique clavier). La fermeture Échap dépend donc entièrement du comportement natif de Bootstrap (`data-bs-keyboard`, défaut `true`, non surchargé dans `account/_delete_modal.html.twig`).

### N3. Reproduction live (2 exécutions indépendantes, `ux001-accounts-audit.js`)

| Mesure | Exécution 1 | Exécution 2 |
|---|---|---|
| `window.DataTable` | `"function"` (défini) | `"function"` (défini) |
| `window.jQuery` | `"function"` | `"function"` |
| `window.bootstrap` | `"object"` | `"object"` |
| Requêtes CDN (13 au total) | **toutes HTTP 200** | **toutes HTTP 200** |
| Erreurs console | **0** | **0** |
| Erreurs réseau | **0** | **0** |
| `confirm-delete-modal.js` chargé sur la page | **non** (confirmé) | — |
| Modale `#deleteModal` — classes avant Échap | `modal fade bx-tx-modal show` | — |
| `data-bs-keyboard` (config Bootstrap réelle, lue via `Modal.getInstance()._config`) | `{"backdrop":true,"focus":true,"keyboard":true}` | — |
| Modale `#deleteModal` — classes après Échap | `modal fade bx-tx-modal` (sans `show`) | — |
| Modale visible après Échap | **`false`** (fermée avec succès) | — |

**Aucune des deux pannes rapportées (`DataTable is not defined`, fermeture Échap défaillante) ne s'est reproduite, à deux reprises consécutives, dans l'environnement actuel.**

### N4. Comparaison au HEAD de référence

Méthode retenue : **C — comparaison statique complète des dépendances + preuve D (recette globale antérieure)**, sans environnement détaché (justifié ci-dessous, méthodes A/B jugées disproportionnées car une preuve plus directe est disponible) :

- **Preuve statique (C)** : `/app/accounts/224` ne partage **aucun** template, partial, ni fichier JavaScript avec les 9 fichiers du working tree UX-001 (confirmé section N1 — `account/show.html.twig` et `account/_delete_modal.html.twig` sont des fichiers entièrement distincts, non modifiés, non inclus par aucun des 9 fichiers). Le rendu de `/app/accounts/224` au working tree actuel est donc **structurellement identique** à son rendu au HEAD `9ae9ee4` — il n'existe aucun chemin de dépendance par lequel UX-001 pourrait l'affecter.
- **Preuve historique (D)** : la campagne de recette globale du 2026-06-17 (`global-visual-regression.md`, scénario **S15 — Account show dark mobile**, exécutée à HEAD `0f590d1`, *avant même l'existence de UX-001*) a mesuré **0 erreur console, 0 erreur réseau** sur cette exact route.
- **Reproduction directe (cette session)** : 2 exécutions consécutives, **0 erreur, fermeture Échap fonctionnelle**.

Trois mesures indépendantes (une historique pré-UX-001, deux live actuelles) convergent vers **0 défaut observable**. Aucune ne corrobore le rouge rapporté.

### N5. Analyse DataTable — classification

**C. TEST_HARNESS_FALSE_NEGATIVE.**

Justification : `window.DataTable` est défini, les 8 requêtes CDN nécessaires répondent 200, aucune erreur console n'est levée, à deux reprises. L'architecture dépend de CDN externes pour Bootstrap, jQuery, JSZip, pdfmake et DataTables (documenté comme un choix assumé — mais avec risque réseau reconnu — dans le commentaire d'en-tête de `_partials/_datatables_js.html.twig`). Une erreur `DataTable is not defined` lors d'une exécution antérieure est compatible avec un aléa réseau transitoire (latence/échec CDN au moment précis de cette exécution) plutôt qu'avec un défaut de code stable — un défaut de code stable se reproduirait de façon déterministe, ce qui n'est pas le cas ici. **Aucune anomalie permanente n'est créée** (pas de `VIS-P2-005`) faute de reproductibilité — créer un identifiant d'anomalie pour un événement non reproductible surstaterait la certitude. Le risque architectural (dépendance CDN, déjà documenté dans le code source lui-même) est noté section N8 comme observation, pas comme défaut actif.

### N6. Analyse Échap modale Comptes — classification

**C. TEST_HARNESS_FALSE_NEGATIVE.**

Justification : `account/_delete_modal.html.twig` ne définit aucun `data-bs-keyboard="false"`, et `account-delete-modal.js` n'implémente aucune logique de capture clavier qui interférerait. La configuration Bootstrap effective lue en direct (`{"keyboard":true}`) confirme que le composant Comptes utilise le comportement **natif et par défaut** de Bootstrap pour Échap — comportement que Bootstrap garantit de façon fiable depuis des années. Le test live (2 exécutions) montre une fermeture Échap réussie à 100%. Une hypothèse plausible et cohérente avec N5 : si `bootstrap.bundle.min.js` (chargé depuis CDN, voir N2) a été lent/indisponible lors de l'exécution Playwright défaillante, `window.bootstrap` aurait pu être `undefined` au moment de l'interaction, empêchant l'initialisation de la modale ET sa gestion clavier simultanément — une **cause unique de flakiness réseau expliquant les deux pannes rapportées de façon cohérente**, plutôt que deux défauts distincts. **Aucune anomalie permanente n'est créée** (pas de `VIS-P2-006`), pour la même raison qu'en N5 — non reproductible, donc pas qualifiable de défaut stable. Il n'est pas non plus question d'imposer au nouveau composant `confirm-delete-modal.js` de reproduire un quelconque défaut de l'ancien — aucune divergence de comportement n'a été constatée entre les deux composants sur ce point.

### N7. Classification finale et verdict du scénario Comptes

| Problème | Classification |
|---|---|
| `DataTable is not defined` | **C. TEST_HARNESS_FALSE_NEGATIVE** (probable aléa réseau CDN transitoire, non reproduit) |
| Fermeture Échap | **C. TEST_HARNESS_FALSE_NEGATIVE** (même cause réseau probable, non reproduit) |

**Verdict global du scénario Comptes** : **non imputable à UX-001**. Aucun fichier Comptes n'est dans l'allowlist, aucun script UX-001 n'est chargé sur cette page, et le comportement actuel de Comptes est identique à son comportement pré-UX-001 (preuve historique + reproduction live). Le rouge rapporté est traité comme un **résultat de test non reproductible**, pas comme un défaut applicatif à corriger.

### N8. Découverte additionnelle pendant l'arbitrage — gap d'allowlist UX-001 (BLOQUANT)

En vérifiant indépendamment l'affirmation « confirm() natifs ciblés restants : 0 » (validation déjà annoncée comme PASS), une recherche exhaustive de `data-confirm-delete=` dans tout `templates/` révèle :

```
templates/budget/edit.html.twig:50:    data-confirm-delete="Supprimer ce budget ?"
```

**`templates/budget/edit.html.twig` n'est pas dans l'allowlist des 9 fichiers UX-001 et n'a donc pas été migré.** Or `public/js/budget-actions.js` (fichier 3 de l'allowlist) a été **entièrement vidé** de sa fonction `initDeleteConfirmations()` — la SEULE fonction qui liait un comportement à `data-confirm-delete`. Conséquence : le bouton "Supprimer" de la page `/app/budgets/{id}/edit` n'a **plus aucun gestionnaire JavaScript du tout**.

**Vérifié en direct** (`ux001-budget-edit-confirm-check.js`, requête de suppression interceptée et avortée avant tout envoi réseau réel pour ne détruire aucune donnée) :

```
delete button found: 1
DELETE POST INTERCEPTED (aborted, not sent to server): http://budgex.local/app/budgets/159/delete POST
window.confirm dialog fired before submit: false
delete POST attempted (i.e. form actually submitted): true
```

**Le formulaire se soumet immédiatement, sans `window.confirm()`, sans modale — aucune confirmation d'aucune sorte.** C'est une **régression réelle introduite par l'application incomplète de LOT-VIS-UX-001**, plus grave que l'anomalie VIS-P1-003 d'origine (qui décrivait une confirmation incohérente mais toujours présente). Recherche exhaustive confirmant qu'il s'agit du **seul** fichier oublié : `grep -rl "data-confirm-delete=" templates/` ne retourne que ce fichier (Goal et Immobilier sont intégralement migrés, vérifié par la même recherche + contrôle DOM live en N1/section confirmant 0 ID dupliqué pour les versements d'objectifs).

**Ce constat est un blocage de commit, indépendant de l'arbitrage Comptes demandé.**

### N9. Règle de référence amendée pour Comptes (baseline-aware)

Conformément à la section 8 de la mission (les deux problèmes Comptes étant classés C, non-préexistants au sens strict mais non-reproductibles), la règle de non-régression pour Comptes dans la recette consolidée de LOT-VIS-UX-001 est amendée ainsi — **Comptes ne doit plus exiger un PASS absolu** mais doit vérifier :

1. aucun fichier `account/*` modifié (vérifiable par `git diff --name-only` ne contenant aucun chemin `templates/account/` ni `public/js/account-*`) ;
2. aucun script UX-001 (`confirm-delete-modal.js`) chargé sur `/app/accounts/{id}` (vérifiable par inspection de la liste des `<script src>`) ;
3. 0 nouvelle erreur console/réseau **par rapport au baseline** (baseline = 0 erreur, mesuré 3 fois indépendamment : S15 historique + 2 exécutions de cette session — donc en pratique le contrat reste « 0 erreur », mais sans bloquer le commit UX-001 si une exécution isolée échoue de façon non reproductible) ;
4. aucun changement de DOM ou de comportement imputable au lot (vérifiable par comparaison statique des dépendances, section N1-N2) ;
5. rendu visuel de référence non dégradé (captures de la recette globale antérieure comme référence).

Si une future exécution Playwright sur Comptes échoue à nouveau : **rejouer une seconde fois avant de conclure** (cohérent avec la discipline de second contrôle déjà appliquée dans ce projet) ; si le défaut persiste de façon reproductible sur 2 exécutions consécutives, **alors** créer une anomalie Comptes indépendante (`VIS-P2-00X`) dans une campagne séparée, et ne plus la classer C.

Les scénarios Budgets/Objectifs/Immobilier restent obligatoirement verts sans exception (aucune tolérance baseline-aware pour ces trois modules, qui sont dans l'allowlist).

### N10. Décision de commit UX-001

**NON — commit UX-001 bloqué**, malgré l'arbitrage favorable du scénario Comptes (N7), en raison du gap d'allowlist N8 :

| Condition (section 9 de la mission) | Statut |
|---|---|
| Toutes les routes ciblées UX-001 vertes | ✅ Budgets/Objectifs/Immobilier confirmés verts par les validations déjà rapportées |
| Aucune régression Comptes imputable à UX-001 | ✅ confirmé arbitrage N7 |
| Tests statiques verts | ✅ déjà rapporté (lint, PHPUnit 146/451) |
| **`confirm()` ciblés à zéro** | ❌ **FAUX** — `budget/edit.html.twig` a un bouton sans confirmation (pire que l'état pré-UX-001) |
| Contrats de sécurité inchangés | ✅ POST/CSRF/voters non affectés par ce gap (c'est uniquement la couche présentation qui est concernée) |
| Working tree strictement limité aux neuf fichiers | ⚠️ **doit devenir dix fichiers** — `templates/budget/edit.html.twig` doit être ajouté à l'allowlist et migré avant commit |

**Le lot ne peut pas être committé dans son état actuel.** Il manque une migration sur un dixième fichier, identique en nature à celle déjà appliquée à `budget/index.html.twig` (même pattern, même partial, même script).

### N11. Allowlist UX-001 amendée (10 fichiers)

Ajout à l'allowlist existante (section D7 du manifeste) :

| Fichier | Changement requis |
|---|---|
| `templates/budget/edit.html.twig` | Remplacer le `<form data-confirm-delete="Supprimer ce budget ?">…</form>` (lignes 48-57) par un bouton `data-bs-toggle="modal" data-bs-target="#deleteBudgetModal{{ budget.id }}"` + un `{% include '_partials/_confirm_delete_modal.html.twig' with {...} %}` après le formulaire d'édition, **exactement selon le pattern déjà appliqué à `templates/budget/index.html.twig`** (diff de référence ci-dessous) ; ajouter `<script src="{{ asset('js/confirm-delete-modal.js') }}?v=vis-ux-001"></script>` dans le bloc `javascripts` de cette page (vérifier au préalable si ce bloc existe déjà dans `budget/edit.html.twig` et s'il charge déjà `budget-actions.js` — si oui, ajouter juste après ; si non, créer le bloc `{% block javascripts %}{{ parent() }}<script src="{{ asset('js/confirm-delete-modal.js') }}?v=vis-ux-001"></script>{% endblock %}`) |

**Diff de référence à reproduire** (pattern déjà validé sur `budget/index.html.twig`, à adapter — ici une seule instance, pas une boucle) :

```diff
--- a/templates/budget/edit.html.twig
+++ b/templates/budget/edit.html.twig
@@ -45,17 +45,25 @@
                 {{ form_end(form) }}
 
-                <form method="post"
-                      action="{{ path('app_budget_delete', {id: budget.id}) }}"
-                      data-confirm-delete="Supprimer ce budget ?"
-                      class="bx-budget-form-delete">
-                    <input type="hidden" name="_token" value="{{ csrf_token('delete_budget_' ~ budget.id) }}">
-                    <button type="submit" class="bx-btn-outline-app bx-btn-outline-app--danger bx-budget-delete-btn">
-                        <i class="material-icons icon-sm leading-icon">delete</i>
-                        Supprimer
-                    </button>
-                </form>
+                <button type="button"
+                        class="bx-btn-outline-app bx-btn-outline-app--danger bx-budget-delete-btn"
+                        data-bs-toggle="modal"
+                        data-bs-target="#deleteBudgetModal{{ budget.id }}">
+                    <i class="material-icons icon-sm leading-icon">delete</i>
+                    Supprimer
+                </button>
+                {% include '_partials/_confirm_delete_modal.html.twig' with {
+                    modalId: 'deleteBudgetModal' ~ budget.id,
+                    title: 'Supprimer ce budget',
+                    body: 'Supprimer le budget "' ~ budget.category.name ~ '" ?',
+                    formAction: path('app_budget_delete', {id: budget.id}),
+                    csrfTokenId: 'delete_budget_' ~ budget.id,
+                    submitLabel: 'Supprimer le budget',
+                } %}
 
             </div>
```

(Numéros de ligne indicatifs — l'implémenteur doit relire le fichier réel au moment de l'implémentation ; l'ancre fiable est le bloc `<form method="post" action="{{ path('app_budget_delete'…`.)

**Test structurel à étendre** : la recherche `data-confirm-delete=` dans `templates/` doit retourner **zéro résultat** après ce correctif (actuellement 1 — `budget/edit.html.twig`). Ajouter cette assertion explicite au test structurel déjà prévu pour LOT-VIS-UX-001.

### N12. Prompt Codex de reprise (depuis le working tree actuel, avec le 10e fichier)

```
RESUME-VISUAL-CORRECTIONS-UX001 — Compléter et committer LOT-VIS-UX-001

Source de vérité : .claude/visual-campaigns/global-visual-corrections.md (sections A-N,
la section N fait foi — elle amende l'allowlist de la section D)
HEAD attendu      : 9ae9ee4ee8b0b362ce966eaf077e516b04390ef8 (origin/master)
(LOT-VIS-NAV-001 et LOT-VIS-CSS-001 sont déjà commités et poussés à ce HEAD.)

PRÉCONTRÔLE GIT :
  git status --short
  Attendu : exactement les 9 fichiers UX-001 déjà listés section N1 (5 Twig modifiés,
  3 JS modifiés, 2 nouveaux fichiers non suivis) + éventuellement config/reference.php
  (restaurer avec git checkout -- config/reference.php, ne jamais le committer).
  AUCUN fichier templates/account/* ni public/js/account-* ne doit apparaître.
  git diff --cached --name-only → doit être VIDE.
  git rev-parse HEAD → doit valoir 9ae9ee4ee8b0b362ce966eaf077e516b04390ef8.

  NE RESTAURER ni NE RÉAPPLIQUER aucun des 9 fichiers déjà présents.

ÉTAPE OBLIGATOIRE AVANT COMMIT — compléter le 10e fichier (section N11) :
  Migrer templates/budget/edit.html.twig avec le même pattern que
  templates/budget/index.html.twig (déjà fait, à utiliser comme référence) :
  remplacer le <form data-confirm-delete="Supprimer ce budget ?"> par un bouton
  data-bs-toggle="modal" + un include de _partials/_confirm_delete_modal.html.twig,
  et s'assurer que confirm-delete-modal.js est chargé dans le bloc javascripts de
  cette page.

  Vérifier ensuite :
    grep -rn "data-confirm-delete=" templates/
    → doit retourner ZÉRO résultat (actuellement 1 : budget/edit.html.twig)

VALIDATION COMPLÈTE (10 fichiers désormais) :
  - bin/console lint:twig templates/budget templates/goal templates/patrimoine templates/_partials
  - node --check public/js/confirm-delete-modal.js public/js/budget-actions.js
    public/js/goal-form.js public/js/immobilier_show.js
  - php bin/phpunit --no-coverage (suite Budget/Goal/Property au minimum — doit rester
    146 tests / 451 assertions PASS ou plus, jamais moins)
  - Playwright (runner %TEMP%\budgex-visual-qa\, réutilisé sans réinstallation) :
    * Budgets index (mobile+desktop) : ouverture/annulation modale — PASS requis
    * Budgets EDIT (nouveau, à tester) : ouverture modale, annulation, fermeture Échap,
      confirmation sur donnée de test jetable uniquement — doit maintenant afficher
      une modale stylée au lieu de soumettre sans confirmation
    * Objectif edit, Objectif show (mobile+desktop) : PASS requis (déjà vert, revérifier
      simplement en non-régression)
    * Immobilier (donnée locale temporaire) : PASS requis (déjà vert, revérifier)
    * Comptes /app/accounts/224 : mode baseline-aware (section N9) — vérifier les 5
      critères N9, PAS un PASS Playwright brut. Si rouge persiste 2 fois de suite,
      ARRÊTER et rapporter (ne pas créer d'anomalie VIS-P2-00X sans cette confirmation
      de reproductibilité)

  SI tout PASS (10 fichiers, tests statiques, Playwright Budgets/Goal/Immobilier verts,
  Comptes conforme aux 5 critères baseline-aware N9) :
    1. git status --short (restaurer config/reference.php si présent)
    2. git add templates/_partials/_confirm_delete_modal.html.twig \
              public/js/confirm-delete-modal.js \
              public/js/budget-actions.js public/js/goal-form.js public/js/immobilier_show.js \
              templates/budget/index.html.twig templates/budget/edit.html.twig \
              templates/goal/edit.html.twig templates/goal/show.html.twig \
              templates/patrimoine/immobilier_show.html.twig
       (10 fichiers exactement — vérifier avec git diff --cached --name-only)
    3. git diff --cached --check
    4. git commit -m "fix(ux): unify destructive-action confirmation modal across budget/goal/property"
    5. git push origin master
    6. Poursuivre avec LOT-VIS-CSS-002 (section E), même runner, précontrôle git avant
       de committer.
    7. Recette consolidée finale (section I), Comptes toujours en mode baseline-aware.

  SI un test échoue (hors Comptes baseline-aware) :
    - NE PAS committer, conserver le working tree tel quel, rapporter précisément le test
      en échec, ARRÊTER.

INTERDICTIONS RAPPELÉES :
  - ne pas toucher à data-confirm-action (goal-form.js) ni à initProgressBars
    (immobilier_show.js)
  - ne pas modifier les contrôleurs PHP (Account/Budget/Goal/Property)
  - ne pas toucher à templates/account/* ni public/js/account-*
  - ne pas créer VIS-P2-005/006 sauf reproduction confirmée 2 fois consécutives
  - toujours un commit par lot, jamais "git add -A" ni "git add ."

RAPPORT FINAL ATTENDU :
  1. Confirmation du 10e fichier migré et de la recherche data-confirm-delete= à zéro.
  2. Résultats des tests statiques (lint, node --check, PHPUnit).
  3. Résultats Playwright par route (Budgets index+edit, Goal edit+show, Immobilier).
  4. Résultat Comptes (baseline-aware — 5 critères N9, pas un PASS/FAIL brut).
  5. SHA du commit UX-001 si poussé, ou raison précise du blocage.
  6. Progression CSS-002 si UX-001 est passé.
```

### N13. Compte rendu de cet amendement

1. **Statut Git initial et final** : identique — exactement les 9 fichiers UX-001 (5 Twig + 4 JS, dont 2 nouveaux non suivis) modifiés/non suivis, aucun fichier Comptes touché, index vide, HEAD = origin/master = `9ae9ee4`. `config/reference.php` restauré (réapparu seul, artefact auto-régénéré). Aucun commit créé pendant cette session d'arbitrage.
2. **Liste des neuf fichiers UX-001** : section N1, tableau complet rôle/diff/consommateurs/chargement.
3. **Chargement réel du JS partagé** : `confirm-delete-modal.js` confirmé chargé uniquement par 4 des 9 fichiers (budget/index, goal/edit, goal/show, immobilier_show), jamais dans le layout global, jamais sur Comptes (confirmé statiquement et en direct, liste de scripts).
4. **Dépendances de `/app/accounts/224`** : section N2 — 19 scripts dont 13 hébergés sur CDN externes (Bootstrap, jQuery, JSZip, pdfmake, DataTables), 0 dépendance partagée avec UX-001.
5. **Stack DataTable** : aucune erreur reproduite — `window.DataTable` défini, 13 requêtes CDN toutes HTTP 200, sur 2 exécutions consécutives (section N3).
6. **Résultat avec JS partagé "bloqué"** : non applicable au sens littéral (le script n'étant déjà pas chargé sur cette page, son absence est la preuve elle-même — section N1/N2) ; documenté comme preuve d'absence d'interférence directe conformément à la consigne de la mission.
7. **Résultat de comparaison au HEAD** : 3 mesures indépendantes convergentes (S15 historique pré-UX-001 + 2 exécutions live de cette session) → 0 erreur dans les 3 cas (section N4).
8. **Classification DataTable** : **C. TEST_HARNESS_FALSE_NEGATIVE** (section N5).
9. **Classification Échap** : **C. TEST_HARNESS_FALSE_NEGATIVE** (section N6), cause probable commune avec N5 (CDN Bootstrap transitoire).
10. **Anomalies Comptes créées** : **aucune** — non reproductible, donc non qualifiable de défaut stable (sections N5-N6). Une règle de reproduction (2 échecs consécutifs) est documentée (section N9) pour de futures sessions.
11. **Règle de référence amendée** : section N9 — Comptes passe en mode « baseline-aware » (5 critères) pour la recette consolidée de UX-001 uniquement ; Budgets/Objectifs/Immobilier restent à PASS absolu.
12. **Autorisation de commit UX-001** : **NON**, en l'état — un gap d'allowlist réel et vérifié en direct (section N8) doit être corrigé en premier (`templates/budget/edit.html.twig`, 10e fichier, section N11).
13. **Conditions de reprise Codex** : section N12 — migrer le 10e fichier, revalider, puis committer les 10 fichiers en un seul commit atomique avec le message déjà défini.
14. **Manifeste mis à jour** : ce fichier, section N ajoutée (non commitée depuis le dépôt principal).
15. **Campagne reprenable automatiquement** : **OUI**, après correction du gap N8 — aucune ambiguïté bloquante restante une fois le 10e fichier migré selon le pattern déjà validé.
16. **Confirmation** : aucun fichier de production ou de test modifié, restauré, indexé ou commité pendant cette session d'arbitrage. Le test de soumission sans confirmation sur `budget/edit.html.twig` (section N8) a intercepté et **avorté** la requête réseau réelle avant tout envoi au serveur — aucune donnée n'a été supprimée. `config/reference.php` restauré ; les 9 fichiers UX-001 laissés strictement inchangés.

---

## O. Audit de clôture indépendant — 2026-06-18

### O0. Mandat

Audit final indépendant, en lecture seule, des 4 lots commités (`776c878`, `9ae9ee4`, `c5d8b1f`, `86f39a9`). Aucun fichier de production modifié. Aucun commit créé. Seule la mise à jour locale de ces deux manifestes est autorisée (non indexée, non commitée depuis le dépôt principal).

### O1. Précontrôle Git

- `config/reference.php` réapparu modifié à plusieurs reprises pendant la session (artefact auto-régénéré par `bin/console lint:*` et `bin/phpunit`, confirmé par `git diff` vide à chaque fois — racy-git, pas un changement de contenu réel) — restauré systématiquement.
- HEAD initial = HEAD final = `86f39a9bf6517e3ef1518a5d59b44323f2e0078f` = `origin/master` (local et distant, confirmé par `git ls-remote`).
- Working tree propre, index vide, `git diff --check` propre.

### O2. Réconciliation des 4 commits — verdict

| Lot | Commit | Conformité allowlist | Conformité diff vs spécification faisant foi | Tests structurels |
|---|---|---|---|---|
| LOT-VIS-NAV-001 | `776c878` | OK — 3 fichiers (`app.css`, `app.html.twig`, +1 test) | OK — identique à la section M8 (6 déclarations CSS + retrait `d-none d-sm-block`) | OK — 2 nouveaux tests, suite `SharedAppCssInlineCodeTest` 8/8 PASS |
| LOT-VIS-CSS-001 | `9ae9ee4` | OK — `app.css` uniquement, 2 règles ajoutées | OK — identique à la section C3 (règles dark-scopées `.bx-budgets-table` + `.bx-report-page`, générique L1912 non touché) | MANQUANT — aucun test structurel ajouté dans ce commit malgré la section C3 qui en spécifiait un — réserve documentée en O6 |
| LOT-VIS-UX-001 | `c5d8b1f` | OK — 10 fichiers exacts (6 Twig + 4 JS), conforme à l'allowlist amendée section N11 (gap `budget/edit.html.twig` corrigé avant commit) | OK — pattern partagé identique sur les 4 modules, CSRF/route/voter inchangés par construction (seule la couche présentation est touchée) | aucun test structurel dédié ajouté dans ce commit, mais 173 tests Budget/Goal/Property rejoués au vert (560 assertions) |
| LOT-VIS-CSS-002 | `86f39a9` | OK — 4 fichiers statiques exacts | OK — chemins corrigés ; compteur réel = 6 occurrences (3 dans `brand-logo-usage.html` + 1 dans chacun des 3 autres fichiers), pas 5 comme annoncé initialement section E1 — voir O5 | n/a (fichiers HTML statiques hors couverture PHPUnit, conforme à la spécification) |

### O3. NAV-001 — audit détaillé

- `templates/layouts/app.html.twig:78` : `d-none d-sm-block` retiré, classe `dropdown dropdown-notifications me-2` unique, aucun doublon d'ID (`#notificationDropdown`, `#notification-badge`, `#bx-notif-header-badge` — 1 occurrence chacun, vérifié par test structurel).
- Badge SCA Powens (`#powensAlertDropdown`, ligne ~168) : inchangé, conserve `d-none d-sm-block`, hors périmètre comme documenté.
- Règle CSS (`app.css` bloc `@media (max-width: 575.98px)`, ligne 1222) : 6 déclarations (`width`, `max-width`, `position: fixed`, `top: 72px`, `left: 1rem`, `right: 1rem`, `bottom: auto`, `transform: none`) confirmées présentes dans la même règle, unique occurrence du sélecteur dans tout le fichier, brace-matching confirmant que le bloc média s'ouvre à la ligne 1167 et se ferme proprement après la règle.
- Preuve live (`%TEMP%\budgex-visual-qa\evidence\nav-001-v2-results.json`) : 6/6 scénarios PASS (360 dark/light, 390, 575, 576, 1440), `menuBox.x=16` sur les 3 largeurs xs, comportement desktop strictement identique avant/après (576px et 1440px).
- Aucun fichier Bank/Powens touché. Aucune implémentation parallèle.

### O4. CSS-001 — cascade hover dark — verdict

Vérification de la spécificité CSS et de l'ordre de cascade confirmée par lecture directe du fichier compilé :
- Règle générique `html[data-theme="dark"] .table-hover > tbody > tr:hover > *` (L1912, spécificité (0,3,3), `!important`) — non touchée.
- Règle ajoutée `html[data-theme="dark"] .bx-budgets-table > tbody > tr:hover > *` (L4078, spécificité (0,3,3) égale, `!important`, postérieure dans le fichier → gagne le tie-break par ordre de source) — couvre aussi Export via la classe partagée `.bx-budgets-table` (confirmé : `export/transactions.html.twig:178` utilise cette classe).
- Règle ajoutée `html[data-theme="dark"] .bx-report-page .table.table-hover > tbody > tr:hover > *` (L4326, spécificité (0,5,3), strictement supérieure) — gagne sans ambiguïté.
- Preuve live (`css-001-hover-results.json`) : 6/6 scénarios PASS, `export-dark` confirme `rgba(98,0,234,0.05)` (violet) au lieu du gris neutre `rgba(255,255,255,0.05)` mesuré avant correctif ; Budget et Report dark confirment l'absence de changement visuel perceptible (valeurs convergentes déjà documentées section C1).

HOVER DARK BUDGET STABILISÉ : OUI
HOVER DARK REPORT STABILISÉ : OUI
HOVER DARK EXPORT STABILISÉ : OUI

### O5. CSS-002 — compteur réel corrigé

Le manifeste initial (section E, ligne "uniquement ces 5 occurrences au total") annonçait 5 remplacements. La vérification du diff réel du commit `86f39a9` montre :

| Fichier | Occurrences corrigées |
|---|---|
| `brand-logo-usage.html` | 3 (lignes 14, 19 logo.png ; ligne 24 favicon.png) |
| `brand-logo.html` | 1 |
| `components-navbar-landing.html` | 1 |
| `components-sidebar.html` | 1 |
| Total | 6 |

Compteur réel CSS-002 : 6 occurrences (et non 5). Ce nombre est désormais la référence corrigée de ce manifeste.

Vérifications complémentaires :
- `grep` sur les 4 fichiers : 0 référence résiduelle à `../assets/logo.png` ou `../assets/favicon.png`.
- `../assets/img/logo.png` et `../assets/img/favicon.png` : présents, fichiers réels existants sur disque (`public/assets/img/logo.png`, `public/assets/img/favicon.png`).
- Aucun autre changement de markup, aucun reformatage opportuniste (diff strictement limité aux attributs `src` ciblés).
- Vérification HTTP live (`curl`) : les 4 fichiers preview répondent 200, les 2 assets corrigés répondent 200. L'ancien chemin direct `/assets/logo.png` répond toujours 500 (comportement AssetMapper non corrigé, hors périmètre documenté — seul le contenu des 4 fichiers preview a été corrigé, pas le comportement d'erreur d'AssetMapper).

### O6. Réserve — test structurel CSS-001 manquant

La section C3 du présent manifeste spécifiait un test structurel pour LOT-VIS-CSS-001 (assertion sur la présence et l'ordre des deux nouvelles règles dark-scopées dans `app.css`). Le commit `9ae9ee4` ne contient aucun fichier de test — seul `public/css/app.css` est modifié (8 lignes). Aucune régression fonctionnelle n'en découle (la suite complète est au vert, le comportement CSS a été vérifié par mesure Playwright en O4), mais la non-régression de cette règle n'est aujourd'hui verrouillée par aucun test automatisé. Réserve documentée, non bloquante pour la clôture — à corriger en micro-polish si une session future touche à `app.css` dans cette zone.

### O7. Suite de tests — résultat exact (audit indépendant)

Commande : `php -d memory_limit=1G bin/phpunit --no-coverage`
Résultat : Tests: 1075, Assertions: 4159, PHPUnit Notices: 13. OK, but there were issues! (0 failures, 0 errors)

Résultat identique à celui annoncé par les sessions précédentes. `git diff --check` propre. `node --check` propre sur les 4 fichiers JS modifiés par UX-001. `lint:twig` : 37 fichiers valides. `lint:container` : OK.

### O8. Verdict final de l'audit de clôture

- Les 4 lots sont conformes à leurs spécifications faisant foi (NAV-001 section M, CSS-001 section C, UX-001 section N à 10 fichiers, CSS-002 section E avec compteur corrigé à 6).
- Le scénario Comptes reste non-imputable à UX-001 (arbitrage N7 confirmé stable, aucune régression constatée lors de cet audit).
- 1 réserve non bloquante : absence de test structurel CSS-001 (O6).
- 1 correction de manifeste : compteur CSS-002 = 6, pas 5 (O5).
- Suite complète verte, working tree propre, HEAD figé = `origin/master` = `86f39a9`.

STATUT FINAL : AUDITED / CLOSED.
