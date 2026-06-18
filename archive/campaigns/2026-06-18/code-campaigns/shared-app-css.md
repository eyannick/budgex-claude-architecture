# Campagne CSS Transverse — shared-app-css

**Date d'audit** : 2026-06-15  
**Date de finalisation** : 2026-06-16  
**Statut** : PRÊT À EXÉCUTER  
**Périmètre audit** : `public/css/app.css`, `components.css`, `colors_and_type.css`, `templates/report/`, `templates/export/`

---

## 1. Périmètre et fichiers figés

### Fichiers en scope (modifiables par la campagne)
| Fichier | Lignes | Rôle |
|---|---|---|
| `public/css/app.css` | 4708 | CSS cross-cutting app+auth+admin |
| `tests/Domain/Shared/SharedAppCssInlineCodeTest.php` | à créer | Contrats structurels |

### Fichiers figés (lecture seule — hors scope)
- `public/css/components.css` — 1655 lignes, **audit L1–L1655 COMPLET : CLEAN** (0 violation F12/F13)
- `public/css/colors_and_type.css` — 430 lignes, **AUTORITÉ DÉCLARÉE TOKENS** (note : conflit de valeur avec app.css sur --bx-radius-md, voir §2.5)
- `public/css/styles.css` — 27116 lignes, vendor base, hors périmètre
- Tous les CSS module : `budget.css`, `admin.css`, `dashboard.css`, `accounts.css`, `transactions.css`, `patrimoine.css`, `bank.css` — figés depuis clôture campagnes précédentes
- `templates/report/pdf.html.twig` — HORS PÉRIMÈTRE LÉGITIME (voir §4)
- `templates/report/index.html.twig` — lecture seule (module report figé)
- `templates/export/*.html.twig` — lecture seule (module export figé)
- `templates/budget/*.html.twig` — lecture seule (module budget figé)

---

## 2. Décisions stratégiques

### 2.1 Stratégie `.bx-budgets-*` — DÉCISION A : CONSERVER + DOCUMENTER

Les classes `bx-budgets-shell`, `bx-budgets-table`, `bx-budgets-header-btn`, `bx-budgets-header-btn--secondary` sont des **composants partagés de niveau app**, nommés par héritage historique (créés pour le module budget, devenus transverses).

**Carte des consommateurs :**

| Classe | Consommateurs | Occurrences totales |
|---|---|---|
| `bx-budgets-shell` | budget/index, budget/analyse, report/index, export/transactions, export/rgpd, admin/user/index, admin/security_event/index, admin/log/index, admin/analytics/users, admin/analytics/registration, admin/analytics/logins, admin/analytics/errors, admin/powens_category_mapping/* | 100+ |
| `bx-budgets-table` | budget/index, report/index (×2), export/transactions, admin/user/index, admin/log/index, admin/powens_category_mapping/index | 8 |
| `bx-budgets-header-btn` | budget, report, export, admin (analytics/errors JS DataTable), admin/powens_*, admin/powens_debug | 30+ |
| `bx-budgets-header-btn--secondary` | budget/index, budget/analyse, report/index, export/rgpd | 5 |

**Justification stratégie A :** renommer (B) exigerait 100+ éditions templates sans gain fonctionnel. Déplacer vers `components.css` (C) n'est pas nécessaire — app.css est le bon fichier pour ces utilities cross-cutting. Un commentaire de section documente l'intention.

**Note architecture :** `--bx-budgets-row-hover` est défini dans `budget.css` (L13 et L62) mais consommé dans `app.css` L4069 → variable leak (voir LOT-APP-1).

### 2.2 Dark mode polyfill block (L~1285–2100) — CONSERVER EN MASSE

Le bloc `html[data-theme="dark"]` de app.css est un **polyfill Bootstrap → Material Design dark**. Il override les composants Bootstrap (cards, forms, buttons, dropdowns, modals, tables, badges, nav-tabs, pagination) avec des valeurs du système d'élévation Material.

Ces 300+ raw hex/rgba sont **intentionnels et architecturaux** — ils définissent la couche de compatibilité Bootstrap, pas des violations ADR-029. Les tokens `--bx-app-*` sont pour le CSS feature (niveau module), pas pour le layer bootstrap-override.

**Verdict F12 dark mode block : CONSERVER EN MASSE — aucune substitution.**

Valeurs caractéristiques conservées :
- `#0d0d0d`, `#1a1a1a`, `#1e1e1e`, `#2c2c2c`, `#2d2d2d`, `#3d3d3d`, `#4d4d4d` — échelle d'élévation Material
- `rgba(255, 255, 255, 0.87/0.70/0.60/0.54/0.38/0.30)` — hiérarchie texte Material dark
- `#bb86fc`, `#7c4dff`, `#7c3aed` — accent Material deep purple

### 2.3 Tokens supplémentaires app.css (L4386–4399) — ÉTAT

Définis dans un `:root` terminal de app.css :
- `--bx-radius-md: 0.62rem` — alias du radius standard, **26 déclarations border-radius hardcodées restantes** (24 opérations logiques R1–R24)
- `--bx-shadow-sm/md/lg` — système d'élévation, 40+ box-shadow uniques (migration progressive)

**LOT-APP-2** exécute la migration `--bx-radius-md`.  
`--bx-shadow-*` : DIFFÉRÉ à une campagne ultérieure (hors périmètre immédiat).

### 2.4 Cas spécial — `report/pdf.html.twig`

Template autonome pour rendu PDF par Dompdf. Aucune feuille externe n'est chargée dans ce contexte. Le bloc `<style>` inline (L6-29) est **légitime et nécessaire**. Les couleurs raw (`#4f46e5`, `#64748b`, etc.) sont CONSERVER.

Les tests structurels doivent **explicitement valider la présence** du `<style>` dans ce template (contrat positif).

### 2.5 Conflit de définition `--bx-radius-md` — DETTE DOCUMENTÉE

**Inventaire complet :**

| Fichier | Ligne | Scope | Valeur | Ordre chargement |
|---|---|---|---|---|
| `colors_and_type.css` | L157 | `:root` | `0.625rem` (10px exact) | 1er |
| `app.css` | L4395 | `:root` | `0.62rem` (9.92px) | 3e (dernier) |

**Cascade** : app.css est chargé APRÈS colors_and_type.css dans tous les layouts. La valeur effective est donc `0.62rem` (app.css gagne).

**Delta** : `+0.005rem` = `+0.08px` à 16px base — imperceptible.

**Décision** : Le conflit n'est PAS BLOQUANT pour LOT-APP-2 car la migration hardcodé→token est à parité stricte pour tous les consommateurs app.css (0.62rem → var() → 0.62rem). La résolution du conflit (unification vers une valeur canonique unique) est planifiée dans une campagne future.

---

## 3. F12 — Audit chromatique app.css (hors dark mode block)

### Valeurs CONSERVER (hors dark mode)

| ID | Valeur | Selector | Justification |
|---|---|---|---|
| V1 | `rgba(98, 0, 234, 0.1)` | `.icon-circle-primary` L414 | Tint Bootstrap primary, pas de token alpha |
| V2 | `rgba(46, 125, 50, 0.1)` | `.icon-circle-success` L418 | Tint Bootstrap success |
| V3 | `rgba(211, 47, 47, 0.1)` | `.icon-circle-danger` L422 | Tint Bootstrap danger |
| V4 | `rgba(117, 117, 117, 0.1)` + `#757575` | `.icon-circle-neutral` L426-427 | Gris neutre, pas de token |
| V5 | `rgba(255,255,255,0.55/0.72)` | `.bx-page-header__*` | Hero dark gradient — transparences sur blanc |
| V6 | `#fff` | `.bx-page-header__title` | Texte blanc sur gradient sombre |
| V7 | `rgba(0,0,0,0.45)` + `#fff` | `#scrollToTop` | Fixed overlay intentionnel |
| V8 | gradient complex | `.bx-auth-body` L892-897 | Branding auth — gradient unique |
| V9 | `rgba(255,255,255,0.90/0.12/0.20)` | `.bx-auth-reassurance-item` | Sur gradient auth |
| V10 | `#dee2e6` + `#fff` | `.bx-locale-chip` | Composant light-only |
| V11 | `#e2e8f0` | `.bx-completion-bar` | Track gris light |
| V12 | `rgba(0,0,0,0.1)` | `.bx-info-col-left` | Séparateur light-mode |
| V13 | `rgba(15,23,42,.02)` | `.bx-tx-filter-bar--shell` | Alpha ultra-bas, intentionnel |
| V14 | `rgba(15,23,42,.06)` | `.bx-budgets-table > td` | Border light ultra-bas |
| V15 | `#596174` | `.table-light th` | Couleur header table spécifique |
| V16 | `#6366f1` | `.bx-color-preview` | Placeholder remplacé par JS |
| V17 | `rgba(0,0,0,0.35)` | `.bx-color-swatch.is-selected` | Shadow swatch |
| V18 | `#303744` + `var(--bs-light)` | `body` light mode | Couleur base text light |

**Fallback LOT-APP-1 :** `rgba(var(--bs-primary-rgb), 0.05)` — couleur DYNAMIQUE Bootstrap (pas brute statique) — NON classifiée F12, NON comptée dans V1-V18.

**Verdict F12 hors dark mode : 0 AUTO, 0 AUTO-DELTA actionnable — 18 valeurs CONSERVER + 1 fallback Bootstrap dynamique légitime.**

---

## 4. F13 — Audit dimensions app.css

### Tokens disponibles (définis dans app.css L4394-4399)
```css
--bx-radius-md: 0.62rem;   /* valeur effective sur pages app — 26 déclarations border-radius hardcodées */
```

### Catalogue R1–R24 — LOT-APP-2

*24 opérations logiques (R15 et R22 couvrent chacun 2 lignes consécutives)*

| ID | Ligne(s) | Sélecteur | Propriété | Avant | Token | Résolu | Parité |
|---|---|---|---|---|---|---|---|
| R1 | L763 | `.bx-category-form-actions .btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R2 | L1630 | `.bx-transactions-header-btn` | `border-radius` | `.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R3 | L1674 | `.bx-tx-filter-group` | `border-radius` | `.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R4 | L2379 | `.bx-category-rules-form .form-floating > .form-control, .form-select` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R5 | L2636 | `.bx-categories-header-btn` | `border-radius` | `.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R6 | L3275 | `.bx-account-form .form-floating > .form-control, .form-select` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R7 | L3307 | `.bx-account-form-btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R8 | L3349 | `.bx-transaction-form .form-floating > .form-control, .form-select` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R9 | L3397 | `.bx-libelles-header-btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R10 | L3498 | `.bx-libelle-form .form-floating > .form-control, .form-select` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R11 | L3535 | `.bx-libelle-color-help` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R12 | L3546 | `.bx-libelle-option` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R13 | L3583 | `.bx-libelle-form-btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R14 | L3632 | `.bx-goal-form .form-floating > .form-control, .form-select` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R15 | L3652+L3653 | `.bx-goal-amount-group .input-group-text` | `border-top-right-radius` + `border-bottom-right-radius` | `0.62rem` (×2) | `var(--bx-radius-md)` (×2) | `0.62rem` | AUTO |
| R16 | L3676 | `.bx-goal-color-field` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R17 | L3704 | `.bx-goal-form-btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R18 | L3779 | `.bx-goals-header-btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R19 | L3860 | `.bx-goal-show-header-btn` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R20 | L3895 | `.bx-goal-show-progress__kpis` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R21 | L3918 | `.bx-goal-contrib-form .form-floating > .form-control, .form-select` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R22 | L3934+L3935 | `.bx-goal-contrib-form__amount-group .input-group-text` | `border-top-right-radius` + `border-bottom-right-radius` | `0.62rem` (×2) | `var(--bx-radius-md)` (×2) | `0.62rem` | AUTO |
| R23 | L3940 | `.bx-goal-contrib-form__submit` | `border-radius` | `0.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |
| R24 | L4033 | `.bx-budgets-header-btn` | `border-radius` | `.62rem` | `var(--bx-radius-md)` | `0.62rem` | AUTO |

**EXCLURE de la substitution :**
- L2825 : `padding: .62rem .72rem` — valeur padding, pas border-radius
- L3677 : `padding: 0.45rem 0.62rem` — idem
- L4387 : commentaire — CONSERVER
- L4395 : définition du token `--bx-radius-md: 0.62rem` — CONSERVER

**Condition de clôture F13 :**
```bash
grep -cE "border(-top-right|-bottom-right|-top-left|-bottom-left)?-radius: \.?0?62rem" public/css/app.css
# → 0
```

---

## 5. Bug identifié — LOT-APP-1 : variable leak `--bx-budgets-row-hover`

**Bug :** `--bx-budgets-row-hover` est défini dans `budget.css` (L13 et L62) mais consommé dans `app.css` L4069 :

```css
/* app.css L4068-4070 */
.bx-budgets-table > tbody > tr:hover > * {
    background-color: var(--bx-budgets-row-hover);   /* ← bug : undefined sur report/export/admin */
}
```

**Impact :** sur toutes les pages qui ne chargent pas `budget.css` (report, export, admin analytics), la variable est `undefined` → hover transparent → aucun feedback visuel sur les lignes de table.

**Correctif :** ajouter une valeur fallback CSS :

```css
/* app.css L4069 — APRÈS correctif */
    background-color: var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb), 0.05));
```

**Analyse du fallback :**
- Pages Budget (budget.css chargé) : `--bx-budgets-row-hover` résout normalement — fallback inactif — delta zéro
- Pages Report/Export/Admin : avant = undefined/transparent ; après = `rgba(primary, 5%)` — hover subtle
- Thème clair et sombre : couleur dynamique Bootstrap `--bs-primary-rgb` — cohérent dans les deux thèmes
- Classification : couleur DYNAMIQUE Bootstrap légitime — NON classifiée F12

**Condition de clôture LOT-APP-1 :**
```bash
grep "bx-budgets-row-hover" public/css/app.css | grep -c "rgba"
# → 1
```

**Compteur de lignes** : 1 ligne modifiée, 0 ajoutée, 0 supprimée → app.css reste à **4 708 lignes**.

---

## 6. Lots de la campagne

### LOT-APP-1 — Correctif variable leak `--bx-budgets-row-hover`

**Opération :** 1 substitution dans `public/css/app.css`  
**Fichier :** `public/css/app.css` uniquement  
**Git scope :** 1 fichier, 1 ligne modifiée

```
Avant (L4069) :
    background-color: var(--bx-budgets-row-hover);

Après :
    background-color: var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb), 0.05));
```

**Commit :** `fix(css): add fallback for --bx-budgets-row-hover in shared table hover rule`

**Condition d'arrêt :**
```bash
grep "bx-budgets-row-hover" public/css/app.css | grep -c "rgba"
# → 1
```

---

### LOT-APP-2 — F13 : 24 border-radius tokens (R1–R24)

**Opération :** remplacer les 26 déclarations border-radius utilisant `.62rem` ou `0.62rem` (24 opérations logiques, R15 et R22 couvrent chacun 2 lignes) par `var(--bx-radius-md)`.

**Lignes cibles** : L763, L1630, L1674, L2379, L2636, L3275, L3307, L3349, L3397, L3498, L3535, L3546, L3583, L3632, L3652, L3653, L3676, L3704, L3779, L3860, L3895, L3918, L3934, L3935, L3940, L4033

**NE PAS substituer :**
- L2825 : `padding: .62rem .72rem` (padding, pas border-radius)
- L3677 : `padding: 0.45rem 0.62rem` (padding, pas border-radius)
- L4387 : commentaire
- L4395 : `--bx-radius-md: 0.62rem` (définition du token lui-même)

**Fichier :** `public/css/app.css` uniquement  
**Git scope :** 1 fichier, 26 lignes modifiées, 0 lignes ajoutées/supprimées

**Commit :** `refactor(css): tokenize border-radius 0.62rem → var(--bx-radius-md) R1–R24`

**Condition d'arrêt :**
```bash
grep -cE "border(-top-right|-bottom-right|-top-left|-bottom-left)?-radius: \.?0?62rem" public/css/app.css
# → 0
```

**Vérification post-correctif :**
```bash
grep -n "\.62rem" public/css/app.css
# Doit contenir UNIQUEMENT :
#   L2825 : padding: .62rem .72rem
#   L3677 : padding: 0.45rem 0.62rem
#   L4387 : commentaire --bx-radius-md  : alias... 0.62rem
#   L4395 : --bx-radius-md:  0.62rem;
```

---

### LOT-APP-3 — Tests structurels SharedAppCssInlineCodeTest

**Opération :** créer `tests/Domain/Shared/SharedAppCssInlineCodeTest.php`  
**Fichier :** 1 nouveau fichier PHP dans un nouveau répertoire `tests/Domain/Shared/`  
**Git scope :** 1 nouveau fichier

**Contenu — 6 méthodes, 31 assertions :**

```
testBudgetIndexUsesSharedCardComponents()
  → assertFileExists + bx-budgets-shell + bx-budgets-table + bx-budgets-header-btn + bx-budgets-header-btn--secondary
  = 5 assertions

testReportIndexUsesSharedAndModuleComponents()
  → assertFileExists + bx-budgets-shell + bx-budgets-table + bx-budgets-header-btn + bx-report-shell
  + assertNotContains(<style>)
  = 6 assertions

testPdfReportIsStandalonePrintDocument()
  → assertFileExists + assertContains(<style>) + assertNotContains(bx-budgets-)
  = 3 assertions

testExportTransactionsUsesSharedComponents()
  → assertFileExists + bx-budgets-shell + bx-budgets-table + bx-budgets-header-btn + bx-export-shell
  + assertNotContains(<style>)
  = 6 assertions

testExportRgpdUsesSharedComponents()
  → assertFileExists + bx-budgets-shell + bx-budgets-header-btn + bx-budgets-header-btn--secondary + bx-export-shell
  + assertNotContains(<style>)
  = 6 assertions

testExportIndexUsesModuleSpecificClassesOnly()
  → assertFileExists + bx-export-shell + bx-export-page
  + assertNotContains(bx-budgets-) + assertNotContains(<style>)
  = 5 assertions
```

**Vérification template :** toutes les assertions ont été validées sur les templates courants (présences et absences confirmées).

**Commit :** `test(shared-css): add structural contracts for shared app CSS components`

**Condition d'arrêt :**
```bash
php -d memory_limit=1G bin/phpunit tests/Domain/Shared/SharedAppCssInlineCodeTest.php --no-coverage
# → 6 tests, 31 assertions, 0 failures
```

---

## 7. Ordre d'exécution

```
LOT-APP-1  (bugfix)   → commit indépendant
LOT-APP-2  (F13 CSS)  → commit indépendant
LOT-APP-3  (tests)    → commit indépendant
```

Les 3 lots sont indépendants et peuvent être exécutés dans cet ordre. LOT-APP-1 en premier pour fixer le bug.

---

## 8. Prompt Codex autonome

```
CAMPAGNE-TRANSVERSE-APP-CSS — Exécution des lots APP-1, APP-2, APP-3

HEAD attendu : 61ba8585c7874c96c2ff6cdad0f283ecbd678d63
Vérifier : git log --oneline -1

CONTEXTE :
Cette campagne finalise les contrats CSS cross-cutting de l'application Budgex.
Fichier principal : public/css/app.css (4708 lignes — doit rester 4708 après chaque lot).
Fichier test à créer : tests/Domain/Shared/SharedAppCssInlineCodeTest.php
Manifeste de référence : .claude/code-campaigns/shared-app-css.md

RÈGLES CRITIQUES :
- Ne modifier que : public/css/app.css et tests/Domain/Shared/SharedAppCssInlineCodeTest.php (nouveau)
- Ne pas modifier les templates, ni components.css, ni colors_and_type.css
- Exécuter `git restore -- config/reference.php` avant chaque commit
- Ne pas committer ou indexer le dossier .claude (dépôt imbriqué distinct)
- app.css doit rester à exactement 4708 lignes après chaque lot

---

LOT-APP-1 — Correctif variable leak (1 ligne modifiée)

Dans public/css/app.css, trouver la ligne :
    background-color: var(--bx-budgets-row-hover);
(contexte : sélecteur .bx-budgets-table > tbody > tr:hover > *, environ L4069)

Remplacer par :
    background-color: var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb), 0.05));

Vérifier :
  grep "bx-budgets-row-hover" public/css/app.css | grep -c "rgba"  → 1
  wc -l public/css/app.css  → 4708

Commit : fix(css): add fallback for --bx-budgets-row-hover in shared table hover rule
Préalable : git restore -- config/reference.php

---

LOT-APP-2 — F13 : 24 opérations logiques R1–R24 (26 déclarations)

Dans public/css/app.css, remplacer chacune des 26 déclarations border-radius suivantes
par var(--bx-radius-md). Toutes sont à parité stricte AUTO (valeur effective inchangée).

Lignes cibles (vérifier sélecteur avant modification) :
  L763   .bx-category-form-actions .btn          border-radius: 0.62rem
  L1630  .bx-transactions-header-btn             border-radius: .62rem
  L1674  .bx-tx-filter-group                     border-radius: .62rem
  L2379  .bx-category-rules-form .form-floating  border-radius: 0.62rem
  L2636  .bx-categories-header-btn               border-radius: .62rem
  L3275  .bx-account-form .form-floating         border-radius: 0.62rem
  L3307  .bx-account-form-btn                    border-radius: 0.62rem
  L3349  .bx-transaction-form .form-floating     border-radius: 0.62rem
  L3397  .bx-libelles-header-btn                 border-radius: 0.62rem
  L3498  .bx-libelle-form .form-floating         border-radius: 0.62rem
  L3535  .bx-libelle-color-help                  border-radius: 0.62rem
  L3546  .bx-libelle-option                      border-radius: 0.62rem
  L3583  .bx-libelle-form-btn                    border-radius: 0.62rem
  L3632  .bx-goal-form .form-floating            border-radius: 0.62rem
  L3652  .bx-goal-amount-group .input-group-text border-top-right-radius: 0.62rem
  L3653  .bx-goal-amount-group .input-group-text border-bottom-right-radius: 0.62rem
  L3676  .bx-goal-color-field                    border-radius: 0.62rem
  L3704  .bx-goal-form-btn                       border-radius: 0.62rem
  L3779  .bx-goals-header-btn                    border-radius: 0.62rem
  L3860  .bx-goal-show-header-btn                border-radius: 0.62rem
  L3895  .bx-goal-show-progress__kpis            border-radius: 0.62rem
  L3918  .bx-goal-contrib-form .form-floating    border-radius: 0.62rem
  L3934  .bx-goal-contrib-form__amount-group     border-top-right-radius: 0.62rem
  L3935  .bx-goal-contrib-form__amount-group     border-bottom-right-radius: 0.62rem
  L3940  .bx-goal-contrib-form__submit           border-radius: 0.62rem
  L4033  .bx-budgets-header-btn                  border-radius: .62rem

EXCLURE ABSOLUMENT :
  L2825  padding: .62rem .72rem            (valeur padding — NE PAS TOUCHER)
  L3677  padding: 0.45rem 0.62rem          (valeur padding — NE PAS TOUCHER)
  L4387  commentaire                        (NE PAS TOUCHER)
  L4395  --bx-radius-md:  0.62rem;         (définition token — NE PAS TOUCHER)

Vérifier après modifications :
  grep -cE "border(-top-right|-bottom-right|-top-left|-bottom-left)?-radius: \.?0?62rem" public/css/app.css
  → 0

  grep -n "\.62rem" public/css/app.css
  → uniquement L2825, L3677, L4387, L4395

  wc -l public/css/app.css  → 4708

Commit : refactor(css): tokenize border-radius 0.62rem → var(--bx-radius-md) R1–R24
Préalable : git restore -- config/reference.php

---

LOT-APP-3 — Tests structurels (1 nouveau fichier)

Créer le répertoire tests/Domain/Shared/ s'il n'existe pas.
Créer tests/Domain/Shared/SharedAppCssInlineCodeTest.php :

<?php

namespace App\Tests\Domain\Shared;

use PHPUnit\Framework\TestCase;

final class SharedAppCssInlineCodeTest extends TestCase
{
    private function readTemplate(string $relative): string
    {
        $path = dirname(__DIR__, 3) . '/templates/' . $relative;
        self::assertFileExists($path);
        return file_get_contents($path);
    }

    public function testBudgetIndexUsesSharedCardComponents(): void
    {
        $twig = $this->readTemplate('budget/index.html.twig');
        self::assertStringContainsString('bx-budgets-shell', $twig);
        self::assertStringContainsString('bx-budgets-table', $twig);
        self::assertStringContainsString('bx-budgets-header-btn', $twig);
        self::assertStringContainsString('bx-budgets-header-btn--secondary', $twig);
    }

    public function testReportIndexUsesSharedAndModuleComponents(): void
    {
        $twig = $this->readTemplate('report/index.html.twig');
        self::assertStringContainsString('bx-budgets-shell', $twig);
        self::assertStringContainsString('bx-budgets-table', $twig);
        self::assertStringContainsString('bx-budgets-header-btn', $twig);
        self::assertStringContainsString('bx-report-shell', $twig);
        self::assertStringNotContainsString('<style>', $twig, 'No inline <style> expected in report/index');
    }

    public function testPdfReportIsStandalonePrintDocument(): void
    {
        $twig = $this->readTemplate('report/pdf.html.twig');
        self::assertStringContainsString('<style>', $twig, 'PDF template must carry inline styles for renderer');
        self::assertStringNotContainsString('bx-budgets-', $twig, 'PDF is standalone — no shared app classes expected');
    }

    public function testExportTransactionsUsesSharedComponents(): void
    {
        $twig = $this->readTemplate('export/transactions.html.twig');
        self::assertStringContainsString('bx-budgets-shell', $twig);
        self::assertStringContainsString('bx-budgets-table', $twig);
        self::assertStringContainsString('bx-budgets-header-btn', $twig);
        self::assertStringContainsString('bx-export-shell', $twig);
        self::assertStringNotContainsString('<style>', $twig, 'No inline <style> expected in export/transactions');
    }

    public function testExportRgpdUsesSharedComponents(): void
    {
        $twig = $this->readTemplate('export/rgpd.html.twig');
        self::assertStringContainsString('bx-budgets-shell', $twig);
        self::assertStringContainsString('bx-budgets-header-btn', $twig);
        self::assertStringContainsString('bx-budgets-header-btn--secondary', $twig);
        self::assertStringContainsString('bx-export-shell', $twig);
        self::assertStringNotContainsString('<style>', $twig, 'No inline <style> expected in export/rgpd');
    }

    public function testExportIndexUsesModuleSpecificClassesOnly(): void
    {
        $twig = $this->readTemplate('export/index.html.twig');
        self::assertStringContainsString('bx-export-shell', $twig);
        self::assertStringContainsString('bx-export-page', $twig);
        self::assertStringNotContainsString('bx-budgets-', $twig, 'export/index uses bx-export-* only, not bx-budgets-*');
        self::assertStringNotContainsString('<style>', $twig, 'No inline <style> in export/index');
    }
}

Vérifier avant commit :
  php -d memory_limit=1G bin/phpunit tests/Domain/Shared/SharedAppCssInlineCodeTest.php --no-coverage
  → 6 tests, 31 assertions, 0 failures

Commit : test(shared-css): add structural contracts for shared app CSS components
Préalable : git restore -- config/reference.php

---

GARDE-FOU SUITE COMPLÈTE :
php -d memory_limit=1G bin/phpunit --no-coverage
→ 0 failure, 0 error
(nombre exact de tests : N_baseline + 6 — enregistrer N_baseline avant APP-3)

PRÉALABLE TOUS LES COMMITS :
git restore -- config/reference.php
```

---

## 9. Audits de clôture requis

Avant de déclarer la campagne CLOSE, vérifier :

| Vérification | Commande | Attendu |
|---|---|---|
| Variable leak corrigée | `grep "bx-budgets-row-hover" public/css/app.css` | contient `, rgba(` |
| F13 complet | `grep -cE "border(-[a-z-]+)?-radius: \.?0?62rem" public/css/app.css` | 0 |
| Padding non affectés | `grep -n "padding.*\.62rem" public/css/app.css` | L2825 et L3677 présents |
| Token definition inchangé | `grep "bx-radius-md.*0.62rem" public/css/app.css` | L4395 présent |
| Compteur lignes app.css | `wc -l public/css/app.css` | 4708 |
| Tests au vert | `php -d memory_limit=1G bin/phpunit --no-coverage` | 0 failures, 0 errors |
| Tests SharedAppCss | `php -d memory_limit=1G bin/phpunit tests/Domain/Shared/SharedAppCssInlineCodeTest.php --no-coverage` | 6 tests, 31 assertions |

---

## 10. Journal des exécutions

| Date | Lot | Opération | Résultat |
|---|---|---|---|
| 2026-06-15 | — | Campagne créée après audit L1–L800 app.css + components.css (partiel) | PRÊT |
| 2026-06-16 | — | Finalisation : audit components.css L801–1655, inventaire --bx-radius-md, catalogue R1–R24, correction garde-fous | PRÊT À EXÉCUTER |
| 2026-06-16 | APP-1 | fix(css): add fallback for --bx-budgets-row-hover in shared table hover rule — `02ef73f` | CLOSED |
| 2026-06-16 | APP-2 | refactor(css): tokenize border-radius 0.62rem → var(--bx-radius-md) R1–R24 — `99a1039` | CLOSED |
| 2026-06-16 | APP-3 | test(shared-css): add structural contracts for shared app CSS components — `0f590d1` | CLOSED |

## Résultats d'audit de clôture (2026-06-16)

**HEAD final** : `0f590d1369a53f40f58e9defce60c9422215e2e0`  
**Synchronisation** : HEAD = origin/master (local) = master (distant) ✓

**Suite complète** : 1 073 tests · 4 137 assertions · 13 notices PHPUnit préexistantes · 0 failure · 0 error  
**Test ciblé SharedAppCssInlineCodeTest** : 6 tests · 31 assertions · 0 failure

**app.css** : 4 708 lignes · 844 accolades ouvertes = 844 fermées · 54 media queries

**Dettes documentées (non bloquantes, campagnes futures)** :
- Conflit `--bx-radius-md` : `colors_and_type.css` L157 = `0.625rem` vs `app.css` L4395 = `0.62rem` (delta +0.005rem = +0.08px). Valeur effective `0.62rem` (app.css gagne la cascade). Migration APP-2 à parité stricte dans l'état actuel.
- `--bx-shadow-sm/md/lg` : 40+ box-shadow non tokenisées — DIFFÉRÉ
- `.bx-toast-noscript` fallback `.5rem` dans components.css L1172 — DIFFÉRÉ

**STATUT** : **AUDITED / CLOSED** — Socle CSS transversal app.css figé dans le périmètre de cette campagne.

---

## 11. Ce qui N'EST PAS dans cette campagne

- `--bx-shadow-sm/md/lg` : 40+ box-shadow à tokeniser — DIFFÉRÉ (campagne future)
- Conflit `--bx-radius-md` entre colors_and_type.css (0.625rem) et app.css (0.62rem) — DIFFÉRÉ (unification dans campagne future)
- Dark mode polyfill block : CONSERVER EN MASSE — pas de substitution
- CSS modules figés (`budget.css`, `admin.css`, etc.) : hors périmètre
- Templates figés : hors périmètre
- `components.css` : clean, aucun lot nécessaire
- `colors_and_type.css` : aucun lot nécessaire (conflit résolu dans campagne future)
- `report/pdf.html.twig` : standalone PDF, HORS PÉRIMÈTRE LÉGITIME
- `.bx-toast-noscript` fallback `.5rem` dans components.css : dette séparée, hors périmètre
