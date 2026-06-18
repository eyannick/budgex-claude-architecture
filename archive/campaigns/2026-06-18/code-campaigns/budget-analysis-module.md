# Campagne : Budget / Analyse — Extraction CSS + ADR-029

**Statut** : CLOSED  
**HEAD initial attendu** : `fbea71f`  
**Date** : 2026-06-13  
**Version** : v5 — AMEND-BUDGET-ANALYSE-PAGE-SCOPE (2026-06-13)

---

## Historique des versions

| Version | Date | Motif |
|---------|------|-------|
| v1 | 2026-06-13 | Audit initial |
| v2 | 2026-06-13 | 11 blocs / 695 lignes (erroné — consommateurs hors Budget non détectés) |
| v3 | 2026-06-13 | Recalibrage extraction partielle + scissions MIXED |
| v4 | 2026-06-13 | Finalisation : compteurs exacts, 3 scissions, 27 assertions |
| v5 | 2026-06-13 | Correction : @media bx-ap* 575.98px BUDGET-ONLY → extraction complète ; 4733/689/676 ; 28 assertions |

---

## Cause du blocage v2 — Rappel

Quatre familles SHARED consomment des templates Admin, Report et Export :

| Sélecteur | Fichiers hors Budget | Localisation CSS (HEAD fbea71f) |
|-----------|---------------------|---------------------------------|
| `.bx-budgets-shell` | 12 fichiers | Bloc C1 L4054-L4057 |
| `.bx-budgets-header-btn` | 7 fichiers | Bloc C1 L4059-L4065 + @media C3 L4157-L4159 |
| `.bx-budgets-header-btn--secondary` | 2 fichiers | Bloc C1 L4067-L4069 |
| `.bx-budgets-table` | 5 fichiers | Bloc C3 L4110-L4116 + dark L4152-L4154 + @media L4176-L4199, L4218-L4220 |

Ces familles restent dans `app.css` sans modification.

---

## Cause du blocage v4 — Quatre occurrences résiduelles

### Contexte

LOT-BUD-0 a été appliqué sur le working tree (non committé). Les validations finales ont détecté quatre occurrences de `.bx-budget-analyse-page` encore présentes dans `app.css` autour de la ligne 4161 (post-extraction).

### Localisation dans le working tree (app.css à 4781 lignes)

Les quatre occurrences appartiennent à un `@media (max-width: 575.98px)` unique (working tree L4138-L4184), situé dans la section `bx-ap*` :

```
L4135 /* ── Budget Analysis Panel — composant partagé (homepage + /app/budget/analyse) */
L4136 .bx-ap { display: flex; flex-direction: column; }
L4137 (blank)
L4138 @media (max-width: 575.98px) {              ← BLOCK ENTIER CONCERNÉ
L4139     .bx-notice.bx-budget-analyse-warning {
...
L4161     .bx-budget-analyse-page .bx-ap-kpis {   ← occurrence 1
L4165     .bx-budget-analyse-legend li, ...        ← sélecteur associé
L4171     .bx-budget-analyse-page .px-4.py-3 > .d-flex... {  ← occurrence 2
L4176     .bx-budget-analyse-page .px-4.py-3 > ... > .fw-500... {  ← occurrence 3
L4180     .bx-budget-analyse-page .px-4.py-3 > ... > .text-nowrap... {  ← occurrence 4
L4184 }
L4185 (blank)
L4186 .bx-ap-kpis {  ← SHARED, reste dans app.css
```

### Erreur de classification v4

Le manifeste v4 a classifié l'intégralité de la section `bx-ap*` (HEAD L4474-L4621) comme SHARED car le commentaire dit "composant partagé". Cette classification était correcte pour les règles de BASE (`.bx-ap`, `.bx-ap-kpis`, `.bx-ap-kpi`, etc.) mais incorrecte pour ce `@media (max-width: 575.98px)` dont tous les sélecteurs sont BUDGET-ONLY.

### Audit des consommateurs — 9 sélecteurs du bloc

| Sélecteur | Consommateurs templates | Classification |
|-----------|------------------------|----------------|
| `.bx-notice.bx-budget-analyse-warning` | `budget/analyse.html.twig:57` uniquement | **BUDGET-ONLY** |
| `.bx-budget-analyse-warning__icon` | `budget/analyse.html.twig:58` uniquement | **BUDGET-ONLY** |
| `.bx-budget-analyse-warning__text` | `budget/analyse.html.twig:59` uniquement | **BUDGET-ONLY** |
| `.bx-budget-analyse-warning__btn` | `budget/analyse.html.twig:65` uniquement | **BUDGET-ONLY** |
| `.bx-budget-analyse-page .bx-ap-kpis` | qualifier `.bx-budget-analyse-page` → `budget/analyse.html.twig:23` uniquement | **BUDGET-ONLY** |
| `.bx-budget-analyse-legend li` (3 sélecteurs) | `budget/analyse.html.twig:149,156` uniquement | **BUDGET-ONLY** |
| `.bx-budget-analyse-page .px-4.py-3 > ...` (3 règles) | qualifier `.bx-budget-analyse-page` → `budget/analyse.html.twig:23` uniquement | **BUDGET-ONLY** |

**Verdict : Classification A — BUDGET-ONLY À EXTRAIRE pour le bloc entier.**

Le bloc ne contient aucun sélecteur SHARED. Aucune règle n'est consommée par home, Admin, Report, Export ou tout autre template.

### Règles équivalentes déjà dans budget.css

- `.bx-budget-analyse-warning` base : L113 budget.css ✓
- `.bx-budget-analyse-warning__btn` @media 767.98px : L338 budget.css ✓ (breakpoint différent, déclarations partielles)
- `.bx-budget-analyse-legend` base : L148 budget.css ✓
- `.bx-budget-analyse-page` base : L103 budget.css ✓

Le bloc @media 575.98px dans app.css est un **complément responsive BUDGET-ONLY** non extrait par v4.

### Valeurs de couleur dans le bloc

Aucune. Zéro `rgba(`, `#hex`, `color-mix`. Impact sur LOT-BUD-1 : **nul**.

### Cascade après extraction

La cascade est préservée :
- @media 767.98px dans budget.css (L333) : breakpoint > 575.98px, s'applique à 700px
- @media 575.98px extrait (appended fin budget.css) : breakpoint ≤ 575.98px, s'applique à 500px
- Order file : 767.98px avant 575.98px dans budget.css → correct
- `__btn` à 575.98px ajoute `display: flex` et `flex: 1 0 100%` non présents à 767.98px → pas de duplication

---

## Statut Git

**Initial** : `fbea71f` — master = origin/master — working tree propre  
**Working tree LOT-BUD-0** : app.css modifié, budget.css créé (non committé), 4 templates Budget modifiés  
**Final** : à compléter par Codex après les 4 commits

---

## 1. Inventaire des blocs — v5

### Blocs initiaux traités (HEAD fbea71f)

| Bloc | Lignes HEAD | Lignes | Classification | Extraction |
|------|-------------|--------|----------------|-----------|
| A | L1631 | 1 | BUDGET-ONLY | Complète |
| C1 | L4048-L4070 | 23 | **MIXED** | Partielle (5 lignes retirées — `.bx-budgets-page`) |
| C2 | L4087-L4091 | 5 | BUDGET-ONLY | Complète |
| C3 | L4097-L4222 | 126 | **MIXED** | Partielle (77 lignes retirées) |
| D | L4223-L4473 | 251 | BUDGET-ONLY | Complète |
| E | L4623-L4637 | 15 | BUDGET-ONLY | Complète |
| F | L4638-L4746 | 109 | BUDGET-ONLY | Complète |
| G | L4747-L4752 | 6 | BUDGET-ONLY | Complète |
| H | L4958-L5067 | 110 | BUDGET-ONLY | Complète |
| I | L5298-L5312 | 15 | BUDGET-ONLY | Complète |
| J | L5313-L5346 | 34 | BUDGET-ONLY | Complète |
| **C3+** | **L4477-L4523 (HEAD)** | **47** | **BUDGET-ONLY** | **Complète — corrigé v5** |

### Frontière bx-ap* révisée

La section bx-ap* (HEAD L4474-L4621) est **partiellement SHARED** :

| Lignes HEAD | Sélecteurs | Statut |
|------------|-----------|--------|
| L4474 | `.bx-ap` | **SHARED** (`_budget_analysis_panel.html.twig` + home) |
| L4477-L4523 | `@media 575.98px { bx-budget-analyse-* }` | **BUDGET-ONLY** — extrait en v5 |
| L4525-L4621 | `.bx-ap-kpis`, `.bx-ap-kpi`, `.bx-ap-kpi__*` ... | **SHARED** (`_budget_analysis_panel.html.twig`) |

### Blocs conservés dans app.css (inchangés)

| Lignes HEAD | Sélecteurs | Raison |
|------------|-----------|--------|
| L2202-L2204 | `.bx-budget-period-label` @media | PARTAGÉ `todo/index.html.twig` |
| L4071-L4086 | `.bx-budget-period-nav*`, `.bx-budgets-period-nav*` | PARTAGÉ todo |
| L4092-L4096 | `.bx-budgets-period-icon` | PARTAGÉ todo |
| L4474, L4525-L4621 | `.bx-ap`, `.bx-ap-kpis`, `.bx-ap-kpi*` | PARTAGÉ home + budget/analyse |
| L4753-L4957 | Reports + Export | Modules différents |
| L5348-L5373 | `.bx-cat-icon*` | PARTAGÉ transactions |
| L5375-L5409 | `.bx-icon-swatch*` | Module catégorie |

---

## 2. Opérations de scission — 3 scissions v4 inchangées

### Scission 1 — Bloc C1

**app.css** : supprimer L4049-L4053 (5 lignes — `.bx-budgets-page { ... }` + blank).  
**budget.css** : `/* ── Budgets index ── */` + `.bx-budgets-page { ... }` + blank = 6 lignes.  
CONSERVER dans app.css : L4054-L4070 (SHARED : shell, header-btn, --secondary).

### Scission 2 — Bloc C3 @media 767.98px

**app.css** : supprimer L4160-L4171 (12 lignes — budget-only rules dans l'@media).  
**app.css résidu** : 5 lignes (`@media { .bx-budgets-header-btn { justify-content: center; } }`).  
**budget.css** : nouveau @media 767.98px avec 3 règles budget-only = 14 lignes.

### Scission 3 — Bloc C3 @media 575.98px

**app.css** : supprimer L4200-L4217 (18 lignes — budget-only cells dans l'@media).  
**app.css résidu** : 30 lignes (SHARED card-view `.bx-budgets-table*` + hover reset).  
**budget.css** : nouveau @media 575.98px avec cell overrides = 19 lignes.

---

## 3. Extraction complète v5 — Bloc C3+

### Identification

| Paramètre | Valeur |
|-----------|--------|
| Lignes HEAD | L4477-L4523 (47 lignes) |
| Lignes working tree (post-LOT-BUD-0) | L4138-L4184 (47 lignes) |
| Trailing blank à retirer | L4185 (1 ligne) |
| Total à retirer d'app.css | **48 lignes** (L4138-L4185) |
| Total à ajouter à budget.css | **48 lignes** (1 blank séparateur + 47 lignes verbatim) |

### Contenu exact du bloc (verbatim L4138-L4184)

```css
@media (max-width: 575.98px) {
    .bx-notice.bx-budget-analyse-warning {
        flex-wrap: wrap;
        align-items: flex-start;
    }

    .bx-budget-analyse-warning__icon {
        margin-top: 0.1rem;
    }

    .bx-budget-analyse-warning__text {
        flex: 1 1 0;
        min-width: 0;
    }

    .bx-budget-analyse-warning__btn {
        display: flex;
        flex: 1 0 100%;
        width: 100%;
        justify-content: center;
        margin-left: 0 !important;
    }

    .bx-budget-analyse-page .bx-ap-kpis {
        grid-template-columns: 1fr;
    }

    .bx-budget-analyse-legend li,
    .bx-budget-analyse-legend li > .d-flex,
    .bx-budget-analyse-legend-action {
        min-height: 2.75rem;
    }

    .bx-budget-analyse-page .px-4.py-3 > .d-flex.align-items-center.gap-3.py-2 {
        flex-wrap: wrap;
        row-gap: 0.35rem;
    }

    .bx-budget-analyse-page .px-4.py-3 > .d-flex.align-items-center.gap-3.py-2 > .fw-500.flex-grow-1 {
        flex-basis: calc(100% - 1.5rem);
    }

    .bx-budget-analyse-page .px-4.py-3 > .d-flex.align-items-center.gap-3.py-2 > .text-nowrap.small.fw-500 {
        flex: 1 1 auto;
        margin-left: 1.25rem;
    }
}
```

### Résidu dans app.css après retrait de L4138-L4185

```css
/* ── Budget Analysis Panel — composant partagé (homepage + /app/budget/analyse) */
.bx-ap { display: flex; flex-direction: column; }

.bx-ap-kpis {   ← L4186 devient L4138 (new numbering)
    display: grid;
    ...
```

Accolades équilibrées après retrait : aucun @media partiel. ✓

---

## 4. Compteurs structurels exacts — v5

| Métrique | v4 | **v5** |
|----------|----|--------|
| Lignes initiales app.css (HEAD) | 5409 | **5409** |
| Lignes retirées d'app.css | 628 | **676** |
| Lignes finales app.css | 4781 | **4733** |
| Lignes budget.css | 641 | **689** |
| Blocs BUDGET-ONLY extraction complète | 9 | **10** (+ Bloc C3+) |
| Blocs MIXED extraction partielle | 2 | **2** |
| Opérations de scission | 3 | **3** (inchangé) |
| Règles SHARED conservées dans app.css | 12 | **12** (inchangé) |
| Sélecteurs SHARED uniques | 4 | **4** (inchangé) |
| Nouvelles @media créées dans budget.css | 2 | **3** (+ @media 575.98px C3+) |
| @media réduites dans app.css | 2 | **2** (inchangé) |

### Décomposition des 676 lignes retirées d'app.css

| Opération | Lignes | Lignes HEAD / WT |
|-----------|--------|-----------------|
| Bloc A | 1 | HEAD L1631 |
| C1 budget-only | 5 | HEAD L4049-L4053 |
| C2 complet | 5 | HEAD L4087-L4091 |
| C3 — summary group | 13 | HEAD L4097-L4109 |
| C3 — progress-col → dark summary | 34 | HEAD L4118-L4151 |
| C3 — scission @media 767.98px | 12 | HEAD L4160-L4171 |
| C3 — scission @media 575.98px | 18 | HEAD L4200-L4217 |
| Bloc D | 251 | HEAD L4223-L4473 |
| Bloc E | 15 | HEAD L4623-L4637 |
| Bloc F | 109 | HEAD L4638-L4746 |
| Bloc G | 6 | HEAD L4747-L4752 |
| Bloc H | 110 | HEAD L4958-L5067 |
| Bloc I | 15 | HEAD L5298-L5312 |
| Bloc J | 34 | HEAD L5313-L5346 |
| **Bloc C3+ (correction v5)** | **48** | **WT L4138-L4185** |
| **TOTAL** | **676** | |

### Décomposition des 689 lignes budget.css

| Section | Lignes | Source |
|---------|--------|--------|
| Header comment + blank | 7 | Nouveau |
| Comment "Règle éparpillée" | 1 | Nouveau |
| Bloc A | 1 | Verbatim |
| Blank | 1 | Nouveau |
| Comment "Budgets index" | 1 | Nouveau |
| C1 extract (`.bx-budgets-page`) | 5 | Verbatim |
| C2 | 5 | Verbatim |
| C3 summary group | 13 | Verbatim |
| C3 progress-col → dark summary | 34 | Verbatim |
| Nouveau @media 767.98px budget-only | 14 | 11 verbatim + 3 nouveau |
| Nouveau @media 575.98px budget-only (C3) | 19 | 16 verbatim + 3 nouveau |
| Bloc D | 251 | Verbatim |
| Bloc E | 15 | Verbatim |
| Bloc F | 109 | Verbatim |
| Bloc G | 6 | Verbatim |
| Bloc H | 110 | Verbatim |
| Bloc I | 15 | Verbatim |
| Bloc J | 34 | Verbatim |
| Blank séparateur (v5) | 1 | Nouveau |
| Bloc C3+ @media 575.98px (v5) | 47 | Verbatim |
| **TOTAL** | **689** | |

---

## 5. Règles SHARED conservées dans app.css (12 règles — inchangées)

| # | Sélecteur | Contexte | Bloc HEAD |
|---|-----------|---------|-----------|
| 1 | `.bx-budgets-shell` | Base | C1 L4054 |
| 2 | `.bx-budgets-header-btn` | Base | C1 L4059 |
| 3 | `.bx-budgets-header-btn--secondary` | Base | C1 L4067 |
| 4 | `.bx-budgets-table > :not(caption) > tbody > tr > td` | Base (S2) | C3 L4110 |
| 5 | `.bx-budgets-table > tbody > tr:hover > *` | Base | C3 L4114 |
| 6 | `dark .bx-budgets-table > :not(caption) > tbody > tr > td` | Dark (S6) | C3 L4152 |
| 7 | `.bx-budgets-header-btn` | @media 767.98px | C3 L4157 |
| 8 | `.bx-budgets-table thead` | @media 575.98px | C3 L4176 |
| 9 | `.bx-budgets-table tbody, .bx-budgets-table tr` | @media 575.98px | C3 L4180 |
| 10 | `.bx-budgets-table > :not(caption) > tbody > tr` | @media 575.98px | C3 L4185 |
| 11 | `.bx-budgets-table tbody td` | @media 575.98px | C3 L4195 |
| 12 | `.bx-budgets-table > tbody > tr:hover > *` | @media 575.98px (reset) | C3 L4218 |

---

## 6. Dette transversale documentée

> **Dette transversale CSS** : Les familles `.bx-budgets-shell`, `.bx-budgets-header-btn`, `.bx-budgets-header-btn--secondary` et `.bx-budgets-table` portent le préfixe `.bx-budgets-*` mais fonctionnent comme utilitaires globaux partagés entre Budget, Admin, Report et Export. Leur relocalisation ou renommage nécessite une campagne transversale dédiée.

> **Dette F12 différée** : S2 (`rgba(15, 23, 42, .06)`) et S6 (`rgba(148, 163, 184, .2)`) restent dans `app.css` au sein des règles SHARED et ne sont pas modifiées par cette campagne.

---

## 7. Frontière de clôture F12

Après exécution complète des 4 lots :

- `budget.css` est **F12 strictement clôturé** après LOT-BUD-1 (18 substitutions).
- Les templates Budget sont **F12 clôturés** après LOT-BUD-2 (T1-T4).
- S2 et S6 : **dette transversale Admin/Report/Export dans `app.css`**.

> Le module Budget / Analyse ne contient plus de couleur brute non justifiée dans ses actifs propriétaires. Deux valeurs raw rgba restent dans `app.css` au sein de familles partagées Admin/Report/Export et relèvent d'une campagne transversale distincte.

---

## 8. Table S1-S20 — 18 substitutions (inchangée)

S2 et S6 : interdites de modification. Restent dans `app.css`.

| ID | Sélecteur (condensé) | Fichier final | Avant | Après | Lot |
|----|----------------------|---------------|-------|-------|-----|
| S1 | `.bx-budgets-summary` bg | budget.css | `rgba(15, 23, 42, .015)` | `color-mix(in srgb, var(--bx-app-fg) 1.5%, transparent)` | LOT-BUD-1 |
| **S2** | `.bx-budgets-table > *` border | **app.css** | `rgba(15, 23, 42, .06)` | **NON MODIFIÉ** | **HORS CAMPAGNE** |
| S3 | `.bx-budgets-category-dot` bg | budget.css | `#94a3b8` | `var(--bx-app-fg-3)` | LOT-BUD-1 |
| S4 | dark `.bx-budgets-page` `--row-hover` | budget.css | `rgba(255, 255, 255, .06)` | `color-mix(in srgb, var(--bx-app-fg) 6%, transparent)` | LOT-BUD-1 |
| S5 | dark `.bx-budgets-summary` bg | budget.css | `rgba(148, 163, 184, .08)` | `color-mix(in srgb, var(--bx-app-fg-3) 8%, transparent)` | LOT-BUD-1 |
| **S6** | dark `.bx-budgets-table` border | **app.css** | `rgba(148, 163, 184, .2)` | **NON MODIFIÉ** | **HORS CAMPAGNE** |
| S7 | `.bx-budget-analyse-legend-dot` bg | budget.css | `#94a3b8` | `var(--bx-app-fg-3)` | LOT-BUD-1 |
| S8 | `.bx-budget-analyse-subtable > *` border | budget.css | `rgba(15, 23, 42, 0.06)` | `color-mix(in srgb, var(--bx-app-fg) 6%, transparent)` | LOT-BUD-1 |
| S9 | dark `.bx-budget-analyse-page` `--row-hover` | budget.css | `rgba(255, 255, 255, 0.06)` | `color-mix(in srgb, var(--bx-app-fg) 6%, transparent)` | LOT-BUD-1 |
| S10 | dark `.bx-budget-analyse-warning` bg | budget.css | `rgba(245, 158, 11, 0.12)` | `color-mix(in srgb, var(--bs-warning) 12%, transparent)` | LOT-BUD-1 |
| S11 | dark `.bx-budget-analyse-warning` border | budget.css | `#f59e0b` | `var(--bs-warning)` | LOT-BUD-1 |
| S12 | dark `.bx-budget-analyse-help-icon` color | budget.css | `rgba(255, 255, 255, 0.58)` | `color-mix(in srgb, var(--bx-app-fg) 58%, transparent)` | LOT-BUD-1 |
| S13 | dark `.bx-budget-analyse-accordion-item` border | budget.css | `rgba(148, 163, 184, 0.2)` | `color-mix(in srgb, var(--bx-app-fg-3) 20%, transparent)` | LOT-BUD-1 |
| S14 | dark `.bx-budget-analyse-subtable > *` border | budget.css | `rgba(148, 163, 184, 0.2)` | `color-mix(in srgb, var(--bx-app-fg-3) 20%, transparent)` | LOT-BUD-1 |
| S15 | `.bx-merchant-badge` bg | budget.css | `rgba(148, 163, 184, 0.12)` | `color-mix(in srgb, var(--bx-app-fg-3) 12%, transparent)` | LOT-BUD-1 |
| S16 | dark `.bx-budget-analyse-merchants` bg | budget.css | `rgba(255, 255, 255, 0.03)` | `color-mix(in srgb, var(--bx-app-fg) 3%, transparent)` | LOT-BUD-1 |
| S17 | dark `.bx-merchant-badge` bg | budget.css | `rgba(148, 163, 184, 0.1)` | `color-mix(in srgb, var(--bx-app-fg-3) 10%, transparent)` | LOT-BUD-1 |
| S18 | dark `.bx-merchant-badge` color | budget.css | `rgba(255, 255, 255, 0.55)` | `color-mix(in srgb, var(--bx-app-fg) 55%, transparent)` | LOT-BUD-1 |
| S19 | dark `.bx-merchant-badge` border | budget.css | `rgba(148, 163, 184, 0.18)` | `color-mix(in srgb, var(--bx-app-fg-3) 18%, transparent)` | LOT-BUD-1 |
| S20 | dark `.bx-budget-analyse-insights__item` border | budget.css | `rgba(148, 163, 184, 0.16)` | `color-mix(in srgb, var(--bx-app-fg-3) 16%, transparent)` | LOT-BUD-1 |

**LOT-BUD-1 : 18 substitutions dans budget.css uniquement. Zéro modification app.css.**

---

## 9. LOT-BUD-3 — Tests structurels — v5 (7 méthodes, **28 assertions**)

```php
<?php

declare(strict_types=1);

namespace App\Tests\Domain\Budget;

use App\Entity\Budget;
use App\Entity\Category;
use App\Entity\User;
use App\Tests\AppTestCase;

final class BudgetInlineCodeTest extends AppTestCase
{
    /**
     * Contrat 1 : index, new, edit chargent budget.css exactement une fois. (3 assertions)
     */
    public function testBudgetFormPagesLoadBudgetCss(): void
    {
        $user = $this->createUser();
        $this->client->loginUser($user);

        foreach (['/app/budgets', '/app/budgets/new'] as $url) {
            $this->client->request('GET', $url);
            $this->assertResponseIsSuccessful();
            $this->assertSame(
                1,
                substr_count((string) $this->client->getResponse()->getContent(), 'budget.css'),
                sprintf('%s doit charger budget.css exactement une fois.', $url)
            );
        }

        $budget = $this->createBudget($user);
        $this->client->request('GET', sprintf('/app/budgets/%d/edit', $budget->getId()));
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'budget.css'),
            'La page edit doit charger budget.css exactement une fois.'
        );
    }

    /**
     * Contrat 2 : la page analyse charge budget.css exactement une fois. (1 assertion)
     */
    public function testBudgetAnalyseLoadsBudgetCss(): void
    {
        $user = $this->createUser();
        $this->client->loginUser($user);
        $this->client->request('GET', '/app/budget/analyse');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'budget.css'),
            'La page analyse doit charger budget.css exactement une fois.'
        );
    }

    /**
     * Contrat 3 : aucun template dans templates/budget/ ne contient d'onclick inline.
     * 1 assertNotEmpty + N assertDoesNotMatchRegularExpression (1 par fichier .html.twig)
     * Total : 6 assertions (sur 5 fichiers budget/).
     */
    public function testBudgetHasNoOnclickInline(): void
    {
        $projectDir = (string) static::getContainer()->getParameter('kernel.project_dir');
        $templateDir = $projectDir . '/templates/budget';
        $templates = [];
        $iterator = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($templateDir, \FilesystemIterator::SKIP_DOTS)
        );

        foreach ($iterator as $file) {
            if ($file->isFile() && str_ends_with($file->getFilename(), '.html.twig')) {
                $templates[] = $file->getPathname();
            }
        }

        sort($templates);
        self::assertNotEmpty($templates, 'Le répertoire templates/budget doit contenir des templates Twig.');

        foreach ($templates as $template) {
            $relativePath = str_replace('\\', '/', substr($template, strlen($projectDir) + 1));
            $content = file_get_contents($template);
            if ($content === false) {
                self::fail(sprintf('Impossible de lire %s.', $relativePath));
            }
            self::assertDoesNotMatchRegularExpression(
                '/\bonclick\s*=/i',
                $content,
                sprintf('%s ne doit contenir aucun onclick inline.', $relativePath)
            );
        }
    }

    /**
     * Contrat 4 : la page analyse contient les blocs JSON bxAnalyseData et bxSankeyData. (2 assertions)
     */
    public function testBudgetAnalyseHasJsonDataBlocks(): void
    {
        $user = $this->createUser();
        $this->client->loginUser($user);
        $this->client->request('GET', '/app/budget/analyse');
        $this->assertResponseIsSuccessful();
        $html = (string) $this->client->getResponse()->getContent();
        $this->assertStringContainsString('id="bxAnalyseData"', $html, 'La page analyse doit contenir bxAnalyseData.');
        $this->assertStringContainsString('id="bxSankeyData"', $html, 'La page analyse doit contenir bxSankeyData.');
    }

    /**
     * Contrat 5 : la page index contient au moins un data-confirm-delete. (1 assertion)
     */
    public function testBudgetIndexHasDataConfirmDelete(): void
    {
        $user = $this->createUser();
        $this->createBudget($user);
        $this->client->loginUser($user);
        $this->client->request('GET', '/app/budgets');
        $this->assertResponseIsSuccessful();
        $this->assertStringContainsString(
            'data-confirm-delete',
            (string) $this->client->getResponse()->getContent(),
            'La page index doit contenir un élément data-confirm-delete.'
        );
    }

    /**
     * Contrat 6 : frontière app.css / budget.css.
     *
     * SHARED : toujours dans app.css (3 assertions)
     * BUDGET-ONLY : absents d'app.css (3 assertions) — dont "bx-budget-analyse" couvre tout (page + warning + legend)
     * BUDGET-ONLY : présents dans budget.css (3 assertions)
     *
     * Total : 9 assertions.
     */
    public function testSharedSelectorsRemainInAppCss(): void
    {
        $projectDir = (string) static::getContainer()->getParameter('kernel.project_dir');
        $appCss = file_get_contents($projectDir . '/public/css/app.css');
        $budgetCss = file_get_contents($projectDir . '/public/css/budget.css');
        self::assertIsString($appCss, 'public/css/app.css doit être lisible.');
        self::assertIsString($budgetCss, 'public/css/budget.css doit être lisible.');

        // SHARED : toujours dans app.css
        self::assertStringContainsString('.bx-budgets-shell {', $appCss,
            'app.css doit conserver .bx-budgets-shell (partagé Admin/Report/Export).');
        self::assertStringContainsString('.bx-budgets-header-btn {', $appCss,
            'app.css doit conserver .bx-budgets-header-btn (partagé Admin/Report/Export).');
        self::assertStringContainsString('.bx-budgets-table >', $appCss,
            'app.css doit conserver les règles .bx-budgets-table (partagé Admin/Report/Export).');

        // BUDGET-ONLY : absents d'app.css
        self::assertStringNotContainsString('bx-budget-analyse', $appCss,
            'app.css ne doit contenir aucun sélecteur bx-budget-analyse-* après extraction v5.');
        self::assertStringNotContainsString('.bx-sankey-canvas {', $appCss,
            'app.css ne doit plus contenir .bx-sankey-canvas (extrait vers budget.css).');
        self::assertStringNotContainsString('.bx-budget-form-shell {', $appCss,
            'app.css ne doit plus contenir .bx-budget-form-shell (extrait vers budget.css).');

        // BUDGET-ONLY : présents dans budget.css
        self::assertStringContainsString('.bx-budget-analyse-page {', $budgetCss,
            'budget.css doit définir .bx-budget-analyse-page.');
        self::assertStringContainsString('.bx-budget-analyse-warning {', $budgetCss,
            'budget.css doit définir .bx-budget-analyse-warning (responsif 575.98px).');
        self::assertStringContainsString('.bx-sankey-canvas {', $budgetCss,
            'budget.css doit définir .bx-sankey-canvas.');
    }

    /**
     * Contrat 7 : Admin, Report, Export et le partial ne chargent pas budget.css. (6 assertions)
     */
    public function testAdminReportExportDoNotLoadBudgetCss(): void
    {
        $projectDir = (string) static::getContainer()->getParameter('kernel.project_dir');
        $templates = [
            'admin/log/index.html.twig',
            'admin/user/index.html.twig',
            'admin/analytics/users.html.twig',
            'report/index.html.twig',
            'export/transactions.html.twig',
            'components/_budget_analysis_panel.html.twig',
        ];
        foreach ($templates as $rel) {
            $content = file_get_contents($projectDir . '/templates/' . $rel);
            self::assertIsString($content, "templates/$rel doit être lisible.");
            self::assertStringNotContainsString(
                'budget.css',
                $content,
                "templates/$rel ne doit pas référencer budget.css."
            );
        }
    }

    private function createBudget(User $user): Budget
    {
        $category = new Category();
        $category->setUser($user)->setName('Test')->setType('depense');
        $this->em->persist($category);

        $budget = new Budget();
        $budget->setUser($user)
            ->setCategory($category)
            ->setAmount('500.00')
            ->setMonth((int) (new \DateTimeImmutable())->format('n'))
            ->setYear((int) (new \DateTimeImmutable())->format('Y'));
        $this->em->persist($budget);
        $this->em->flush();

        return $budget;
    }
}
```

### Décompte exact des assertions — v5

| Méthode | Assertions |
|---------|-----------|
| testBudgetFormPagesLoadBudgetCss | 3 |
| testBudgetAnalyseLoadsBudgetCss | 1 |
| testBudgetHasNoOnclickInline | 1 (assertNotEmpty) + 5 (× 5 fichiers) = **6** |
| testBudgetAnalyseHasJsonDataBlocks | 2 |
| testBudgetIndexHasDataConfirmDelete | 1 |
| testSharedSelectorsRemainInAppCss | **9** (+1 vs v4 : `bx-budget-analyse-warning` dans budget.css) |
| testAdminReportExportDoNotLoadBudgetCss | 6 |
| **TOTAL** | **28** |

---

## 10. Totaux finaux de campagne — v5

| Dimension | v4 | **v5** |
|-----------|----|--------|
| app.css initial | 5409 | **5409** |
| app.css final | 4781 | **4733** |
| budget.css | 641 | **689** |
| Lignes retirées d'app.css | 628 | **676** |
| Blocs BUDGET-ONLY complets | 9 | **10** |
| Blocs MIXED | 2 | **2** |
| Opérations de scission | 3 | **3** |
| Règles SHARED conservées | 12 | **12** |
| Nouvelles @media dans budget.css | 2 | **3** |
| @media réduites dans app.css | 2 | **2** |
| Substitutions LOT-BUD-1 | 18 | **18** |
| Substitutions LOT-BUD-2 | 4 | **4** |
| Méthodes LOT-BUD-3 | 7 | **7** |
| Assertions LOT-BUD-3 | 27 | **28** |
| Commits | 4 | **4** |
| Fichiers de production créés | 1 | **1** |
| Fichiers de production modifiés | 5 | **5** |
| Fichiers de test créés | 1 | **1** |

---

## 11. Modules figés

Interdire toute modification de :
- `public/css/bank.css`, `transactions.css`, `accounts.css`, `patrimoine.css`
- Leurs templates et scripts JS
- Toute règle Admin, Report, Export (lecture seule dans les tests)

---

## 12. Arbitrages hors périmètre

**ARBITRAGE A** — Couleurs JS : `getComputedStyle` + CSS custom props. Ticket séparé.  
**ARBITRAGE B** — Conversion dark-first 18 blocs `html[data-theme="dark"]`. `LOT-BUD-DARK` séparé.  
**S2/S6** — Tokenisation règles SHARED dans app.css. Campagne CSS transversale.

---

## 13. Prompt Codex de reprise — v5

Ce prompt s'exécute sur un working tree non propre contenant le diff LOT-BUD-0 partiel.

```
Tu es Codex, agent d'exécution autonome du dépôt Budgex.

ÉTAT ATTENDU DU WORKING TREE — vérifier impérativement avant toute action :

  git rev-parse HEAD      → fbea71fb338f2ab044193bb5bbd4bf1ca2a19597
  git rev-parse origin/master → fbea71fb338f2ab044193bb5bbd4bf1ca2a19597
  git diff --cached --name-only → (vide — aucun fichier indexé)

Fichiers modifiés autorisés (et seulement ceux-ci) :
  M public/css/app.css
  M templates/budget/analyse.html.twig
  M templates/budget/edit.html.twig
  M templates/budget/index.html.twig
  M templates/budget/new.html.twig
  ?? public/css/budget.css

STOP si git status --short contient autre chose que ces 6 entrées.
STOP si l'index n'est pas vide.

PRÉCONTRÔLE TAILLES ACTUELLES (post-LOT-BUD-0 partiel) :
  wc -l < public/css/app.css    → doit retourner 4781
  wc -l < public/css/budget.css → doit retourner 641
STOP si l'une de ces conditions échoue.

INTERDITS ABSOLUS dans toute la session :
- Modifier bank.css, transactions.css, accounts.css, patrimoine.css
- Modifier leurs templates ou scripts JS
- Modifier S2 (rgba(15, 23, 42, .06) dans .bx-budgets-table dans app.css)
- Modifier S6 (rgba(148, 163, 184, .2) dans dark .bx-budgets-table dans app.css)
- Modifier tout template Admin, Report ou Export
- Toucher aucun autre fichier que ceux listés dans chaque LOT
- Exécuter git push

────────────────────────────────────────────────────────────────
CORRECTION v5 — EXTRACTION BLOC C3+ (avant commit LOT-BUD-0)
────────────────────────────────────────────────────────────────

CONTEXTE :
Le manifeste v4 a laissé un @media (max-width: 575.98px) BUDGET-ONLY dans
la section bx-ap* de app.css. Ce bloc (working tree L4138-L4184) contient
exclusivement des sélecteurs Budget-analyse. Il doit être extrait avant commit.

ÉTAPE C3+.1 — Retirer L4138-L4185 de app.css (48 lignes)

Supprimer exactement les lignes working tree 4138 à 4185 incluses.

Ligne 4138 : @media (max-width: 575.98px) {
Ligne 4139 :     .bx-notice.bx-budget-analyse-warning {
...
Ligne 4184 : }
Ligne 4185 : (blank)

NE PAS toucher L4136 (.bx-ap) ni L4186 (.bx-ap-kpis).

VÉRIFICATION INTERMÉDIAIRE :
  wc -l < public/css/app.css → doit retourner 4733
  grep -c 'bx-budget-analyse' public/css/app.css → 0
  grep -c '.bx-ap {' public/css/app.css → >= 1
  grep -c '.bx-ap-kpis {' public/css/app.css → >= 1
STOP si l'une de ces conditions échoue.

ÉTAPE C3+.2 — Appendre le bloc dans budget.css

Appendre exactement à la fin de budget.css :
  (1 ligne blank)
  (verbatim le contenu de ce qui était L4138-L4184, soit 47 lignes)

Le résultat final doit être :
  wc -l < public/css/budget.css → 689

VÉRIFICATION INTERMÉDIAIRE :
  wc -l < public/css/budget.css → 689
  grep -c 'bx-budget-analyse-warning' public/css/budget.css → >= 2
  grep -c 'bx-budget-analyse-page' public/css/budget.css → >= 3
STOP si l'une de ces conditions échoue.

────────────────────────────────────────────────────────────────
VALIDATIONS FINALES LOT-BUD-0 (après correction v5)
────────────────────────────────────────────────────────────────

Toutes ces commandes doivent passer avant le commit :

  wc -l < public/css/app.css    → 4733
  wc -l < public/css/budget.css → 689
  grep -c '{' public/css/app.css == grep -c '}' public/css/app.css
  grep -c 'budget.css' templates/budget/index.html.twig    → 1
  grep -c 'budget.css' templates/budget/analyse.html.twig  → 1
  grep -c 'budget.css' templates/budget/new.html.twig      → 1
  grep -c 'budget.css' templates/budget/edit.html.twig     → 1
  grep -c 'bx-budgets-shell' public/css/app.css            → >= 1
  grep -c 'bx-budgets-header-btn' public/css/app.css       → >= 1
  grep -c 'bx-budgets-table' public/css/app.css            → >= 1
  grep -c 'bx-budget-analyse' public/css/app.css           → 0
  grep -c 'bx-sankey-canvas' public/css/app.css            → 0
  grep -c 'bx-budget-form-shell' public/css/app.css        → 0
  grep -c 'bx-budget-analyse-page' public/css/budget.css   → >= 3
  grep -c 'bx-sankey-canvas' public/css/budget.css         → >= 1
  grep -c 'budget.css' templates/report/index.html.twig    → 0
  grep -c 'budget.css' templates/export/transactions.html.twig → 0
  grep -c 'budget.css' templates/admin/log/index.html.twig → 0
  grep -c 'budget.css' templates/components/_budget_analysis_panel.html.twig → 0

STOP si l'une des validations échoue.

Commit LOT-BUD-0 :
  feat(budget): extract budget CSS to standalone budget.css

────────────────────────────────────────────────────────────────
LOT-BUD-1 — 18 substitutions dans budget.css uniquement
────────────────────────────────────────────────────────────────

PRÉCONTRÔLE :
  wc -l < public/css/budget.css → 689

Fichier cible : public/css/budget.css uniquement.

INTERDITS :
- Ne pas modifier app.css
- Ne pas modifier S2 dans app.css
- Ne pas modifier S6 dans app.css

Effectuer les 18 remplacements S1, S3-S5, S7-S20 dans budget.css.
Chercher par valeur exacte (pas par numéro de ligne).
S13 et S14 : même valeur `rgba(148, 163, 184, 0.2)` — remplacer 2 sélecteurs distincts.
Conserver `rgba(var(--bs-primary-rgb), 0.05)` — token Bootstrap dynamique.

Vérification :
  grep -cP 'rgba\(\d' public/css/budget.css → 0
STOP si non-zero.

Commit : refactor(budget): replace raw rgba/hex with color-mix tokens in budget.css

────────────────────────────────────────────────────────────────
LOT-BUD-2 — 4 substitutions Twig
────────────────────────────────────────────────────────────────

T1 — templates/budget/analyse.html.twig :
  AVANT : {% set savingColor     = netIsNeg ? '#f87171' : '#a78bfa' %}
  APRÈS  : {% set savingColor     = netIsNeg ? 'var(--bx-app-danger)' : 'var(--bx-app-accent-on)' %}

T2-T4 — templates/components/_budget_analysis_panel.html.twig :
  '#34d399' → 'var(--bx-app-success)'
  '#f87171' → 'var(--bx-app-danger)'
  '#a78bfa' → 'var(--bx-app-accent-on)'

Vérification :
  grep -c '#34d399\|#f87171\|#a78bfa' templates/budget/analyse.html.twig → 0
  grep -c '#34d399\|#f87171\|#a78bfa' templates/components/_budget_analysis_panel.html.twig → 0
STOP si non-zero.

Commit : refactor(budget): replace raw hex defaults with bx-app-* tokens in Twig panel

────────────────────────────────────────────────────────────────
LOT-BUD-3 — Tests structurels BudgetInlineCodeTest.php
────────────────────────────────────────────────────────────────

Créer tests/Domain/Budget/BudgetInlineCodeTest.php.
Code complet dans la section 9 du manifeste.
7 méthodes, 28 assertions.

Exécuter :
  php -d memory_limit=1G bin/phpunit tests/Domain/Budget/BudgetInlineCodeTest.php --no-coverage
  Attendu : 7 tests, 28 assertions, 0 failures
STOP si failures > 0 ou assertions != 28.

Commit : test(budget): add BudgetInlineCodeTest structural contracts

────────────────────────────────────────────────────────────────
FIN DE CAMPAGNE
────────────────────────────────────────────────────────────────

Après les 4 commits, mettre à jour .claude/code-campaigns/budget-analysis-module.md :
- Changer statut OPEN → CLOSED
- Remplir le tableau "Audit final" avec les 4 SHA de commits
```

---

## 14. Audit final (à compléter par Codex)

| Lot | Statut | Commit |
|-----|--------|--------|
| LOT-BUD-0 | DONE | `8529633` |
| LOT-BUD-1 | DONE | `f7892e7` |
| LOT-BUD-2 | DONE | `c3f9911` |
| LOT-BUD-3 | DONE | `53fa1c6` |

---

## 15. Audit indépendant — Claude Code (2026-06-14)

**HEAD audité** : `53fa1c68f42161fa3e5d2822e843c66842aface9`  
**HEAD = origin/master** : OUI  
**Working tree propre** : OUI (config/reference.php restauré avant et après)

### Réconciliation des commits

| Lot | Hash | Message | Fichiers |
|-----|------|---------|---------|
| LOT-BUD-0 | 8529633 | feat(budget): extract budget CSS to standalone budget.css | app.css -676L, budget.css +689L, 4 templates +4L |
| LOT-BUD-1 | f7892e7 | refactor(budget): replace raw rgba/hex with color-mix tokens in budget.css | budget.css 18 substitutions |
| LOT-BUD-2 | c3f9911 | refactor(budget): replace raw hex defaults with bx-app-* tokens in Twig panel | analyse.html.twig + _budget_analysis_panel.html.twig |
| LOT-BUD-3 | 53fa1c6 | test(budget): add BudgetInlineCodeTest structural contracts | 203 lignes, 7 tests, 28 assertions |

Tous les quatre commits présents sur origin/master. ✓

### Résultats structurels

| Contrôle | Valeur attendue | Valeur constatée | Verdict |
|---------|----------------|-----------------|---------|
| Lignes app.css | 4733 | 4733 | ✓ |
| Lignes budget.css | 689 | 689 | ✓ |
| Accolades budget.css équilibrées | 140/140 | 140/140 | ✓ |
| budget.css chargé dans 4 templates budget/ | exactement 1× chacun | ✓ | ✓ |
| budget.css absent de tous autres templates | 0 occurrence | 0 occurrence | ✓ |
| `{{ parent() }}` présent dans chaque bloc stylesheets | 4/4 templates | 4/4 | ✓ |
| Partial `_budget_analysis_panel.html.twig` sans lien CSS | absent | absent | ✓ |
| `.bx-budget-analyse-page` absent d'app.css | 0 | 0 | ✓ |
| `.bx-budget-analyse-warning` absent d'app.css | 0 | 0 | ✓ |
| `.bx-sankey-canvas` absent d'app.css | 0 | 0 | ✓ |
| `.bx-budgets-shell` présent dans app.css | ≥1 | ✓ | ✓ |
| `.bx-budgets-header-btn` présent dans app.css | ≥1 | ✓ | ✓ |
| `.bx-budgets-table` présent dans app.css | ≥1 | ✓ | ✓ |
| S2 `rgba(15, 23, 42, .06)` non modifié dans app.css | présent L4087 | présent L4087 | ✓ |
| S6 `rgba(148, 163, 184, .2)` non modifié dans app.css | présent L4095 | présent L4095 | ✓ |

### F12 — Couleurs dans budget.css

3 occurrences `rgba()` — toutes justifiées : `rgba(var(--bs-primary-rgb), 0.05)` (×2 custom property) et `rgba(var(--bs-secondary-rgb), 0.04)`. Zéro hex brut, zéro rgb/hsl littéral.

### T1–T4 — Twig tokens

- T1/T2 : `savingColor` dans `analyse.html.twig` L80 : `var(--bx-app-danger)` / `var(--bx-app-accent-on)` — passé comme paramètre Twig à `--bx-ap-kpi-color`, non injecté dans Chart.js. ✓
- T3/T4 : Defaults `incomeColor`/`expenseColor`/`savingColor` dans `_budget_analysis_panel.html.twig` L23-25 : `var(--bx-app-success)` / `var(--bx-app-danger)` / `var(--bx-app-accent-on)`. ✓
- Zéro hex brut `#f87171`, `#34d399`, `#a78bfa` dans les deux fichiers. ✓

Note: `#9CA3AF` subsiste dans `BudgetAnalyseController.php` L83 et L119 (couleur "Sans catégorie" injectée dans chartData JSON puis dans Chart.js `backgroundColor`). Ce hex est dans le controller PHP, hors périmètre campagne CSS. Non bloquant.

### Custom properties dynamiques

6 custom properties dynamiques injectées via `style=` dans les templates budget/ :
- `--bx-budget-progress` : valeur numérique `%` — sûre ✓
- `--bx-budget-cat-color` : valeur DB (`cat.color` — hex `#RRGGBB` par défaut) — Twig auto-escape HTML actif ✓
- `--bx-budget-legend-color` : même source ✓
- `--bx-progress-color` : valeur conditionnelle `#9CA3AF` ou `cat.color` ✓
- `--bx-ap-kpi-color` : valeur `var(--bx-app-*)` string — safe ✓
- `--bx-ap-bar-fill` : valeur `row.color` (DB) ✓

Aucune custom property CSS ne transite directement dans un dataset Chart.js. ✓

### Donut et Chart.js

Données via `type="application/json"` + `JSON.parse(textContent)` — pas de `innerHTML` sur données de l'utilisateur. `innerHTML = ""` (L237) : réinitialisation de container vide — non-risqué. ✓ Les couleurs des datasets viennent de `chartData.color` (hex DB) — pas de token CSS `var()` dans les datasets. ✓

### Sankey

Intégré dans `budget-analyse.js` (pas de `budget-sankey.js` distinct). Source des données : `bxSankeyData` JSON block. Destroy/recreate sur resize avec debounce 200ms. Aucune modification fonctionnelle détectée pendant la campagne. ✓

### Templates et JavaScript — patterns à risque

- `sankeyMobile.innerHTML = ""` : réinitialisation de container propre — non-risqué ✓
- `dot.style.setProperty("--bx-sankey-flow-color", color)` : injection de couleur hex via API DOM — non-risqué ✓
- `window.addEventListener("resize", ...)` / `window.confirm(...)` : événements standards légitimes ✓
- Zéro `onclick` inline dans les templates budget/ ✓
- Zéro `eval`, `insertAdjacentHTML` dans les scripts budget ✓

### Tests

| Suite | Résultat |
|-------|---------|
| `node --check budget-analyse.js` | OK |
| `node --check budget-actions.js` | OK |
| `lint:twig templates/budget` | 5 fichiers OK |
| `lint:container` | OK |
| `BudgetInlineCodeTest.php` | 7 tests, 28 assertions, 0 failures |
| `--filter Budget` | 111 tests, 307 assertions, 0 failures |
| `--filter Analyse` | 26 tests, 83 assertions, 0 failures |
| `git diff --check` | OK |

### Dette transversale

**S2** (`rgba(15, 23, 42, .06)`) et **S6** (`rgba(148, 163, 184, .2)`) : présents dans `.bx-budgets-table` de `app.css` (règles SHARED consommées par 5+ templates Admin/Report/Export). Non modifiables dans cette campagne. Campagne transversale CSS distincte nécessaire.

Familles `.bx-budgets-shell`, `.bx-budgets-header-btn`, `.bx-budgets-table` consommées par 14 templates hors Budget (admin/analytics, admin/log, admin/user, export, report, todo). La dette de renommage vers un préfixe neutre (ex. `.bx-card-shell`) relève d'une campagne transversale.

### Verdicts obligatoires

```
BUDGET.CSS F12 STRICTEMENT CLÔTURÉ : OUI
BUDGET.CSS F13 STRICTEMENT CLÔTURÉ : OUI (valeurs locales justifiées, pas de token disponible pour clamp/rem spécifiques)
LEGACY BUDGET APP.CSS SUPPRIMÉ : OUI
FRONTIÈRE CSS PARTAGÉE MAÎTRISÉE : OUI
TEMPLATES BUDGET STRICTEMENT CLÔTURÉS : OUI
JAVASCRIPT BUDGET STRICTEMENT CLÔTURÉ : OUI
CUSTOM PROPERTIES DYNAMIQUES JUSTIFIÉES : OUI
CONTRATS JSON SÛRS : OUI
DONUT ET CHART.JS STABILISÉS : OUI
SANKEY STABILISÉ : OUI
DONNÉES FINANCIÈRES INCHANGÉES : OUI
MODULE BUDGET / ANALYSE FONCTIONNELLEMENT STABILISÉ : OUI
MODULE BUDGET / ANALYSE FIGEABLE : OUI
CAMPAGNE AUTONOME BUDGET VALIDÉE : OUI
```

**Statut campagne : AUDITED / CLOSED**  
**Date audit** : 2026-06-14  
**Auditeur** : Claude Code (claude-sonnet-4-6) — audit lecture seule, aucun fichier de production modifié, indexé ou committé.
