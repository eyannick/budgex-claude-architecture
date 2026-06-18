# patrimoine-module.md — Campagne Patrimoine

## Métadonnées

```
version : 1
date    : 2026-06-13
auteur  : audit Claude Code claude-sonnet-4-6
HEAD    : 803977b (master = origin/master)
statut  : CLOSED — campagne exécutée avec succès
```

---

## Clôture d'exécution

| Lot | Statut | Commit |
|-----|--------|--------|
| LOT-PAT-0 | CLOSED | `c6270b9` |
| LOT-PAT-1 | CLOSED | `70c5ad5` |
| LOT-PAT-2 | CLOSED | `fbea71f` |

- Cause du blocage initial : faux positif `onclick` provenant du layout global dans la réponse HTML rendue.
- Correction : contrôle source récursif limité aux fichiers `*.html.twig` sous `templates/patrimoine`, partials inclus.
- Résultat : campagne Patrimoine exécutée avec succès.

---

## Audit final indépendant — 2026-06-13

**Auditeur :** Claude Code claude-sonnet-4-6 (session AUDIT-CLOTURE-PATRIMOINE)  
**HEAD audité :** `fbea71f` = `origin/master` ✅  
**Working tree :** propre en entrée et en sortie ✅

### Résultats Git

| Paramètre | Valeur |
|-----------|--------|
| HEAD | `fbea71fb338f2ab044193bb5bbd4bf1ca2a19597` |
| origin/master | `fbea71fb338f2ab044193bb5bbd4bf1ca2a19597` |
| config/reference.php | neutralisé (restore --staged + restore) |

### Réconciliation des commits

| Lot | Commit | Fichier unique | Delta | Conforme |
|-----|--------|---------------|-------|---------|
| PAT-0 | `c6270b9` | `public/css/app.css` | -209 L | ✅ |
| PAT-1 | `70c5ad5` | `public/css/patrimoine.css` | +7/-7 L | ✅ |
| PAT-2 | `fbea71f` | `tests/Domain/Patrimoine/PatrimoineInlineCodeTest.php` | +140 L | ✅ |

### Legacy app.css

- 5 409 lignes ✅ · accolades 988/988 ✅ · 60 media queries ✅
- Sections "Page Patrimoine" et "Pages détail par classe" : zéro résidu ✅
- Section `bx-breadcrumb-dark` intacte à L1617 ✅
- Zéro consommateur résiduel des classes supprimées dans templates/ et public/js/ ✅

### F12 — patrimoine.css

- Zéro hex brut, rgba, rgb, hsl, hsla dans patrimoine.css ✅
- 7/7 substitutions `color-mix(in srgb, var(--bx-app-fg) X%, transparent)` confirmées :
  - L191 `.bx-badge-soon` 7 % ✅ · L377 `.bx-pill.pill-muted` 5 % ✅ · L386 `.bx-cls-stat-box` 3 % ✅
  - L596 `.bx-pat-loan-card` 2 % ✅ · L675 accordéon-item mobile 2,5 % ✅
  - L774 amount-col mobile 3,5 % ✅ · L786 row-arrow mobile 3,5 % ✅
- Source `--bx-app-fg` : token canonique blanc dark-first ✅
- Qualif AUTO-DELTA : aucune revendication de parité stricte ✅

### F13 — patrimoine.css

Valeurs raw relevées et justifiées :

| Valeur | Sélecteur | Justification |
|--------|-----------|--------------|
| `font-size: 0.8125rem` | `.bx-cls-account-rate` | Pas de token exact (delta < 1 px) — CONSERVER |
| `font-size: 42%` | `.bx-patrimoine-currency` | Ratio superscript devise — pas de token |
| `font-size: 1.2rem`, `1.1rem`, `1.25rem` | icônes/chevrons | Tailles icônes, pas de token équivalent |
| `line-height: 1`, `1.2`, `1.25`, `1.35`, `1.45` | divers | Ratios unitless — pas de token |
| `letter-spacing: 0.04em`, `0.08em`, `0.1em` | kickers/badges | Ratios typographiques — pas de token |
| `clamp(2.4rem, 5.5vw, 3.6rem)` | `.bx-patrimoine-amount` | Fluid type — pas de token clamp |

Toutes justifiées. Zéro dette non documentée.

### Styles inline dynamiques

3 occurrences en `index.html.twig` (L275, L307, L330) — source `ASSET_CLASS_COLORS` (PHP constant), auto-escapé par Twig, aucune alternative CSS statique possible. ✅

### Graphiques et donuts

- `centerTextPlugin` (`id: "centerText"`) déclaré et enregistré une fois par IIFE ✅
- `Chart.register()` idempotent — pas de double-enregistrement effectif ✅
- Label central `"Total"` dans tous les fichiers JS ✅
- `legend: { display: false }` dans tous les donuts ✅
- Blocs JSON `type="application/json"` dans les 7 templates Chart.js ✅
- Zéro script exécutable inline ✅

### Accordéons et périodes

- Accordéons : `data-bs-toggle="collapse"` / `data-bs-parent` — zéro onclick ✅
- Période : `data-period` + `data-period-mobile` + `aria-pressed` — addEventListener en IIFE ✅
- Dropdown mobile : `data-bs-toggle="dropdown"` ✅

### Tests structurels

- `testPatrimoineIndexAndDetailLoadPatrimoineCss` : 4 assertions, substringCount `patrimoine.css` = 1 ✅
- `testPatrimoineHasNoOnclickInline` : scan récursif filesystem (11 templates + partials), regex `\bonclick\s*=/i`, layout exclu ✅ — faux positif évité ✅
- `testPatrimoineHasJsonDataBlocks` : 4 assertions, blocs `bxPatData` + `bxClsData` ✅
- `testCreditsPageLoadsPatrimoineCss` : 2 assertions ✅
- **Total : 4 tests · 22 assertions**

### Templates et JavaScript

- Zéro `onclick=`, `onsubmit=`, ni autre event handler inline dans les 11 templates ✅
- Zéro `innerHTML`, `insertAdjacentHTML`, `document.write`, `eval` dans les 8 JS ✅
- `window.confirm()` dans `immobilier_show.js` : dialogue natif de confirmation, message depuis `data-confirm-delete`, non-injectable ✅
- `bar.style.width` dans `immobilier_show.js` : valeur numérique clampée 0–100, NaN guard ✅

### Responsive

Contrôle statique CSS — 3 breakpoints (991.98 px / 767.98 px / 575.98 px) présents et cohérents. Period controls : boutons desktop + dropdown mobile synchronisés. Accordéons et colonnes adaptatives vérifiés dans les templates. **Note : aucune validation visuelle navigateur n'a été exécutée.**

### Résultats tests

```
lint:twig templates/patrimoine    → OK (11 fichiers) ✅
lint:container                    → OK ✅
PatrimoineInlineCodeTest          → 4 tests · 22 assertions · 0 failures ✅
--filter Patrimoine               → 59 tests · 243 assertions · 0 failures ✅
Suite globale                     → 1 049 tests · 4 000 assertions · 0 failures · 13 notices pré-existantes ✅
git diff --check                  → NO_WHITESPACE_ERRORS ✅
```

### Verdicts obligatoires

| Verdict | Résultat |
|---------|---------|
| PATRIMOINE.CSS F12 STRICTEMENT CLÔTURÉ | **OUI** |
| PATRIMOINE.CSS F13 STRICTEMENT CLÔTURÉ | **OUI** |
| LEGACY PATRIMOINE APP.CSS SUPPRIMÉ | **OUI** |
| TEMPLATES PATRIMOINE STRICTEMENT CLÔTURÉS | **OUI** |
| JAVASCRIPT PATRIMOINE STRICTEMENT CLÔTURÉ | **OUI** |
| STYLES DYNAMIQUES RESTANTS JUSTIFIÉS | **OUI** |
| CONTRATS JSON SÛRS | **OUI** |
| GRAPHIQUES ET DONUTS STABILISÉS | **OUI** |
| ACCORDÉONS ET PÉRIODES STABILISÉS | **OUI** |
| MODULE PATRIMOINE FONCTIONNELLEMENT STABILISÉ | **OUI** |
| MODULE PATRIMOINE FIGEABLE | **OUI** |
| CAMPAGNE AUTONOME PATRIMOINE VALIDÉE | **OUI** |

**Déclaration finale :** Le module Patrimoine est strictement clôturé. `patrimoine.css`, les 11 templates et les 8 scripts JS sont figés. Ne pas ouvrir de nettoyage opportuniste sans bug démontré ou évolution produit explicite.

---

## Périmètre d'intervention

### Fichiers cibles

| Fichier | Opération |
|---------|-----------|
| `public/css/app.css` | Purge bloc L1616-L1824 (LOT-PAT-0) |
| `public/css/patrimoine.css` | 7 substitutions rgba→color-mix (LOT-PAT-1) |
| `tests/Domain/Patrimoine/PatrimoineInlineCodeTest.php` | Création (LOT-PAT-2) |

### Fichiers interdits (ne jamais modifier)

- `public/css/bank.css`
- `public/css/transactions.css`
- `public/css/accounts.css`
- Tous les fichiers PHP et Twig (lecture seule)

### Référentiel de lecture seule

- `templates/patrimoine/*.html.twig` (11 templates)
- `public/js/patrimoine.js`, `comptes_bancaires.js`, `livrets.js`, `actions_fonds.js`, `fonds_euros.js`, `immobilier.js`, `immobilier_show.js`, `credits.js`
- `src/Controller/PatrimoineController.php`
- `tests/Domain/Patrimoine/PatrimoineControllerTest.php`

---

## Compte rendu d'audit — 23 points

### §1 Architecture CSS

`patrimoine.css` est un fichier standalone dark-first (790 L). Il couvre l'intégralité des routes `/app/patrimoine/*` via le layout `base_app.html.twig`.  
`app.css` contient un bloc legacy patrimonial résiduel de 209 lignes (L1616-L1824, 2 sections commentées) avec des classes redéfinies/dépassées. → **LOT-PAT-0**.

### §2 Architecture JS

8 fichiers JS dans `public/js/` — chacun isolé dans une IIFE `(function(){}())`. Pattern IIFE respecté partout. Aucun global leak détecté. ✅

### §3 F12 — Hex/rgba bruts dans CSS

7 violations ADR-029 dans `patrimoine.css` : `rgba(255, 255, 255, X)` utilisées comme overlays de surface (X ∈ {0.02, 0.025, 0.03, 0.035, 0.05, 0.07}). → **LOT-PAT-1**.  
1 occurrence dans `app.css` L1824 (dans le bloc legacy) → sera supprimée par LOT-PAT-0.  
Aucun hex brut dans `patrimoine.css`. ✅

### §4 F13 — Font-size brut dans CSS

`.bx-cls-account-rate` à `patrimoine.css` L356 : `font-size: 0.8125rem` (13 px).  
Aucun token disponible exact : `--bx-fs-xs` = 0.78rem (12.5 px), `--bx-fs-sm` = 0.875rem (14 px).  
Delta < 1 px. Décision : **CONSERVER** — pas d'arbitrage justifié, pas de token intermédiaire.

### §5 Accordéons Bootstrap

3 accordéons présents :  
- `bx-assets-accordion` (index.html.twig) — multi-open, `data-bs-*` standard  
- `bx-cls-accounts-accordion` (pages détail) — un seul ouvert via `data-bs-parent`  
- `bx-pat-loan-card` (immobilier_show.html.twig) — toggle simple  

Tous utilisent `data-bs-*` sans onclick. ✅

### §6 Sélecteur de période

Pattern 7 boutons (1J/7J/1M/3M/YTD/1A/TOUT) implémenté dans `patrimoine.js`, `comptes_bancaires.js`, `livrets.js`, `actions_fonds.js`, `fonds_euros.js`. Desktop + dropdown mobile synchronisés.  
Aucun `onclick=` inline dans les templates. Événements via `addEventListener` dans les IIFE JS. ✅

### §7 Charts — Area chart

Area chart (`Line` type + gradient + `fill: 'origin'`) dans `index.html.twig` (canvas `bxPatBalance`) et dans chaque page détail avec historique.  
Gradient RGBA construit dans le JS (`ctx.createLinearGradient`) → hors scope CSS (ADR-029 ne couvre pas le JS). ✅

### §8 Charts — Donut

Plugin `centerTextPlugin` (`id: "centerText"`) enregistré via `Chart.register()` dans chaque IIFE JS. Chart.register() est idempotent — pas de double-enregistrement effectif. Décision : **CONSERVER** (refactor inter-fichiers hors scope).  
Label central "Total" : présent dans tous les fichiers JS. ✅  
Légende externe : aucune balise de légende Chart.js dans aucun template. ✅

### §9 Templates — onclick/style= inline

11 templates audités :

| Template | onclick | style= |
|----------|---------|--------|
| `index.html.twig` | 0 ✅ | 3 justifiés (couleurs PHP dynamiques) |
| `comptes_bancaires.html.twig` | 0 ✅ | 0 ✅ |
| `livrets.html.twig` | 0 ✅ | 0 ✅ |
| `actions_fonds.html.twig` | 0 ✅ | 0 ✅ |
| `fonds_euros.html.twig` | 0 ✅ | 0 ✅ |
| `immobilier.html.twig` | 0 ✅ | 0 ✅ |
| `credits.html.twig` | 0 ✅ | 0 ✅ |
| `immobilier_show.html.twig` | 0 ✅ | 0 ✅ |
| `immobilier_new.html.twig` | 0 ✅ | 0 ✅ |
| `immobilier_edit.html.twig` | 0 ✅ | 0 ✅ |
| `_property_form.html.twig` | 0 ✅ | 0 ✅ |

Les 3 `style=` dans `index.html.twig` (L275, L307, L330) sont des couleurs injectées depuis `Account::ASSET_CLASS_COLORS` (PHP constant). Ils ne peuvent pas être déportés en CSS statique. Voir §CONSERVATIONS.

### §10 XSS

Aucune utilisation de `| raw` avec des données utilisateur. Les valeurs injectées en JSON via `<script type="application/json">` sont sérialisées par `json_encode`. ✅

### §11 Templates — JSON injection

Pattern `<script type="application/json" id="bx*Data">` utilisé dans tous les templates avec Chart.js :

| Template | ID bloc | Données |
|----------|---------|---------|
| `index.html.twig` | `bxPatData` | chartBalance, chartBalanceDaily, chartAssetBreakdown, balanceCurrency, currencySymbols |
| `comptes_bancaires.html.twig` | `bxClsData` | chartBalance, chartBalanceDaily, chartAccountBreakdown, assetColor |
| `livrets.html.twig` | `bxLivData` | idem + weightedRate, annualInterests |
| `actions_fonds.html.twig` | `bxAfData` | idem comptes_bancaires |
| `fonds_euros.html.twig` | `bxFeData` | idem livrets |
| `immobilier.html.twig` | `bxReData` | chartAccountBreakdown seul (pas d'area chart) |
| `credits.html.twig` | `bxDebtData` | chartAccountBreakdown seul |

`immobilier_show.html.twig` : pas de Chart.js, pas de JSON. ✅

### §12 Template immobilier.html.twig

271 lignes. Section synthèse portefeuille (valeur brute / dette restante / valeur nette) conditionnelle. Lignes `.bx-cls-account-row` sans accordéon. ✅

### §13 Template immobilier_show.html.twig

450 lignes. Hero KPI 4 cards. Pattern `data-confirm-delete` et `data-progress-value` — JS non-inline (`immobilier_show.js`). Barre de progression via `data-progress-value` appliqué en JS. Benchmark DVF (data.gouv.fr). ✅

### §14 Templates formulaires

`_property_form.html.twig` (310 L), `immobilier_new.html.twig`, `immobilier_edit.html.twig` : 0 onclick, 0 style= inline. Autocomplétion d'adresse via `data-address-autocomplete` (JS). ✅

### §15 Responsive

3 breakpoints dans `patrimoine.css` : 991.98 px, 767.98 px, 575.98 px. Colonnes cachées adaptatives. Contrôles période : desktop (boutons) + dropdown mobile synchronisés via JS. ✅

### §16 Tests existants

`PatrimoineControllerTest.php` (220 L, 9 tests) :
- 4 tests livrets (taux moyen pondéré, intérêts, accès, vide)
- 2 tests fonds_euros
- 3 tests index/credits_conso

### §17 Couverture manquante

0 test structurel CSS/inline sur le module. Pas de test sur comptes_bancaires, actions_fonds, credits (routes). → **LOT-PAT-2** couvre le gap structurel.

### §18 app.css legacy patrimoine

Section L1616-L1824 (209 lignes, 2 blocs commentés) :

**Bloc 1 "Page Patrimoine" (L1616-L1800)** : `.bx-patrimoine-*`, `.bx-allocation-bar`, `.bx-asset-card`, `.bx-asset-icon`, `.bx-badge-soon`, `.bx-assets-accordion` et sous-classes, `.bx-account-item`, `.bx-alloc-col`, `.bx-amount-col`, `.bx-row-arrow`, `.bx-cls-account-row`. Avec `html[data-theme="dark"]` anti-pattern.

**Bloc 2 "Pages détail par classe" (L1801-L1824)** : `.bx-cls-stat-box`, `.bx-cls-accounts-accordion`, `.bx-cls-account-toggle`, `.bx-cls-account-detail-row`. Avec `html[data-theme="dark"]` anti-pattern.

Toutes ces classes sont redéfinies dark-first dans `patrimoine.css`. Purge sans régression. ✅  
**Ne pas toucher :** L1604-L1614 (`.bx-hero-label/.bx-hero-value/.bx-hero-currency/.bx-hero-sublabel` — bloc séparé "Hero patrimoine Polish 2") ni ce qui suit L1824 (`.bx-breadcrumb-dark` L1826+).

### §19 Sélecteurs morts

Dans le bloc legacy app.css (en cours de purge) : `.bx-allocation-bar`, `.bx-asset-card`, `.bx-asset-total`, `.bx-asset-currency`, `.bx-asset-link` — non utilisés dans les templates actuels. Seront supprimés par LOT-PAT-0.  
Dans `patrimoine.css` : aucun sélecteur mort détecté.

### §20 Dark mode — compliance tokens

`patrimoine.css` : 100 % dark-first, `var(--bx-app-*)` partout. Aucun `html[data-theme="dark"]`. ✅  
7 violations `rgba(255,255,255,X)` → traitées par LOT-PAT-1.

### §21 Doctrine produit — préservation

| Règle | Statut |
|-------|--------|
| Premium/sobre/lisible | ✅ Aucun changement visuel dans ces lots |
| comptes_bancaires = modèle référence | ✅ Confirmé (JSON, accordéon, JS) |
| Donut label central "Total" | ✅ centerTextPlugin → `"Total"` dans tous les JS |
| Pas de légende sous le donut | ✅ Aucune balise légende Chart.js dans les templates |

### §22 Lots de campagne

3 lots actifs :

| Lot | Classification | Fichiers | Delta |
|-----|---------------|----------|-------|
| LOT-PAT-0 | AUTO | `app.css` | -209 L |
| LOT-PAT-1 | AUTO-DELTA | `patrimoine.css` | 7 substitutions |
| LOT-PAT-2 | AUTO | `PatrimoineInlineCodeTest.php` (nouveau) | +~85 L |

### §23 HEAD audit

`803977b refactor(accounts): remove onclick inline, migrate style.display to classList, add 4 structural tests`  
master = origin/master. Clean tree. ✅

---

## Lots de campagne — Spécifications complètes

### LOT-PAT-0 — Purge CSS legacy app.css

**Classification :** AUTO  
**Fichier :** `public/css/app.css`

Supprimer les deux blocs consecutifs (209 lignes au total) :

**Bornes de suppression :**
- Début inclus : ligne commençant par `/* ── Page Patrimoine` (numéro courant : L1616)
- Fin incluse : `html[data-theme="dark"] .bx-cls-stat-box { background: rgba(255, 255, 255, .05); }` (numéro courant : L1824)

**Garde-fous :**
- La ligne immédiatement avant le début contient `.bx-hero-sublabel` — ne pas la supprimer
- La ligne immédiatement après la fin est vide, suivie de `.bx-breadcrumb-dark` — ne pas les supprimer

**Vérification post-purge :**
```bash
grep -n "bx-allocation-bar\|bx-asset-card\|bx-cls-stat-box\|bx-assets-accordion" public/css/app.css
# Attendu : 0 résultat
```

**Risque :** nul — toutes les classes couvertes sont redéfinies dans `patrimoine.css` chargé sur toutes les routes `/app/patrimoine/*`.

---

### LOT-PAT-1 — ADR-029 rgba → color-mix dans patrimoine.css

**Classification :** AUTO-DELTA  
**Fichier :** `public/css/patrimoine.css`

7 substitutions mécaniques `rgba(255, 255, 255, X)` → `color-mix(in srgb, var(--bx-app-fg) X%, transparent)` :

| L# | Sélecteur | AVANT | APRÈS |
|----|-----------|-------|-------|
| ~191 | `.bx-badge-soon` background | `rgba(255, 255, 255, 0.07)` | `color-mix(in srgb, var(--bx-app-fg) 7%, transparent)` |
| ~377 | `.bx-pat-page .bx-pill.pill-muted` background | `rgba(255, 255, 255, 0.05)` | `color-mix(in srgb, var(--bx-app-fg) 5%, transparent)` |
| ~386 | `.bx-cls-stat-box` background | `rgba(255, 255, 255, 0.03)` | `color-mix(in srgb, var(--bx-app-fg) 3%, transparent)` |
| ~596 | `.bx-pat-loan-card` background | `rgba(255, 255, 255, 0.02)` | `color-mix(in srgb, var(--bx-app-fg) 2%, transparent)` |
| ~675 | `.bx-cls-accounts-accordion .accordion-item` bg (mobile @767px) | `rgba(255, 255, 255, 0.025)` | `color-mix(in srgb, var(--bx-app-fg) 2.5%, transparent)` |
| ~774 | `.bx-cls-account-toggle > .bx-amount-col` bg (mobile @575px) | `rgba(255, 255, 255, 0.035)` | `color-mix(in srgb, var(--bx-app-fg) 3.5%, transparent)` |
| ~786 | `.bx-cls-account-detail-row > a.bx-row-arrow` bg (mobile @575px) | `rgba(255, 255, 255, 0.035)` | `color-mix(in srgb, var(--bx-app-fg) 3.5%, transparent)` |

Note : les occurrences ~774 et ~786 ont la même valeur mais des sélecteurs distincts — traiter indépendamment.

**Vérification post-substitution :**
```bash
grep -n "rgba" public/css/patrimoine.css
# Attendu : 0 résultat
```

---

### LOT-PAT-2 — Tests structurels PatrimoineInlineCodeTest.php

**Classification :** AUTO  
**Fichier :** `tests/Domain/Patrimoine/PatrimoineInlineCodeTest.php` (créer)  
**Tests :** 4 méthodes, 7 assertions  
**Baseline attendue :** 9 tests existants + 7 nouveaux = 16 tests sur le module · 0 failures

```php
<?php

declare(strict_types=1);

namespace App\Tests\Domain\Patrimoine;

use App\Entity\Account;
use App\Entity\User;
use App\Tests\AppTestCase;

/**
 * Contrats structurels : patrimoine.css chargé, absence d'onclick inline, blocs JSON présents.
 */
final class PatrimoineInlineCodeTest extends AppTestCase
{
    /**
     * Contrat 1 : index et comptes-bancaires chargent patrimoine.css exactement une fois.
     * 2 assertions.
     */
    public function testPatrimoineIndexAndDetailLoadPatrimoineCss(): void
    {
        $user = $this->createUser();
        $this->createBankAccount($user);
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'patrimoine.css'),
            'La page index doit charger patrimoine.css exactement une fois.'
        );

        $this->client->request('GET', '/app/patrimoine/comptes-bancaires');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'patrimoine.css'),
            'La page comptes-bancaires doit charger patrimoine.css exactement une fois.'
        );
    }

    /**
     * Contrat 2 : index et comptes-bancaires ne contiennent aucun onclick inline.
     * 2 assertions.
     */
    public function testPatrimoineHasNoOnclickInline(): void
    {
        $user = $this->createUser();
        $this->createBankAccount($user);
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine');
        $this->assertResponseIsSuccessful();
        $this->assertStringNotContainsString(
            'onclick=',
            (string) $this->client->getResponse()->getContent(),
            'index.html.twig ne doit contenir aucun onclick inline.'
        );

        $this->client->request('GET', '/app/patrimoine/comptes-bancaires');
        $this->assertResponseIsSuccessful();
        $this->assertStringNotContainsString(
            'onclick=',
            (string) $this->client->getResponse()->getContent(),
            'comptes_bancaires.html.twig ne doit contenir aucun onclick inline.'
        );
    }

    /**
     * Contrat 3 : les blocs JSON de données Chart.js sont présents.
     * 2 assertions.
     */
    public function testPatrimoineHasJsonDataBlocks(): void
    {
        $user = $this->createUser();
        $this->createBankAccount($user);
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine');
        $this->assertResponseIsSuccessful();
        $this->assertStringContainsString(
            'id="bxPatData"',
            (string) $this->client->getResponse()->getContent(),
            'index.html.twig doit contenir le bloc JSON bxPatData.'
        );

        $this->client->request('GET', '/app/patrimoine/comptes-bancaires');
        $this->assertResponseIsSuccessful();
        $this->assertStringContainsString(
            'id="bxClsData"',
            (string) $this->client->getResponse()->getContent(),
            'comptes_bancaires.html.twig doit contenir le bloc JSON bxClsData.'
        );
    }

    /**
     * Contrat 4 : la page credits charge patrimoine.css exactement une fois.
     * 1 assertion.
     */
    public function testCreditsPageLoadsPatrimoineCss(): void
    {
        $user = $this->createUser();
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine/credits');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'patrimoine.css'),
            'La page credits doit charger patrimoine.css exactement une fois.'
        );
    }

    private function createBankAccount(User $user): Account
    {
        $account = new Account();
        $account->setUser($user)
            ->setName('Compte test CB')
            ->setAssetClass('comptes_bancaires')
            ->setInitialBalance('1000.00')
            ->setCurrentBalance('1000.00')
            ->setCurrency('EUR');

        $this->em->persist($account);
        $this->em->flush();

        return $account;
    }
}
```

---

## Conservations justifiées (non-lots)

| Élément | Localisation | Motif |
|---------|-------------|-------|
| `style="background-color: {{ cls.color }}1a; color: {{ cls.color }};"` | `index.html.twig` L275, L307 | Couleur dynamique PHP (`ASSET_CLASS_COLORS`), impossible à tokeniser statiquement |
| `style="color: {{ cls.color }};"` | `index.html.twig` L330 | Idem |
| `font-size: 0.8125rem` | `patrimoine.css` L356 `.bx-cls-account-rate` | Pas de token exact (`--bx-fs-xs`=0.78 ≠ 0.8125, `--bx-fs-sm`=0.875 ≠ 0.8125) — delta < 1 px, pas d'arbitrage justifié |
| `centerTextPlugin` re-enregistré localement | `patrimoine.js` et 4 autres IIFE | `Chart.register()` est idempotent — comportement correct, refactor inter-fichiers hors scope |

---

## Prompt Codex autonome

```
CAMPAGNE-PATRIMOINE — Exécution autonome

Branche de travail : créer `campagne/patrimoine-module` depuis master (803977b).
Commit final en un seul commit sur la branche. Ne pas pusher.

RÈGLES ABSOLUES :
- Ne jamais modifier public/css/bank.css, public/css/transactions.css, public/css/accounts.css.
- Ne jamais modifier de fichier PHP ou Twig.
- Ne jamais modifier d'autres fichiers que ceux listés ci-dessous.

FICHIERS CIBLES (3) :
1. public/css/app.css
2. public/css/patrimoine.css
3. tests/Domain/Patrimoine/PatrimoineInlineCodeTest.php (à créer)

---

LOT-PAT-0 — Purge CSS legacy app.css (AUTO)

Lire public/css/app.css. Supprimer le bloc de code délimité par :
- Début inclus : ligne contenant "/* ── Page Patrimoine" (numéro attendu : ~L1616)
- Fin incluse : ligne "html[data-theme="dark"] .bx-cls-stat-box { background: rgba(255, 255, 255, .05); }" (~L1824)

Ce bloc fait ~209 lignes. Ne pas toucher ce qui est avant (bloc .bx-hero-label ~L1611) ni après (.bx-breadcrumb-dark ~L1826).

Vérification : après la suppression, ces sélecteurs ne doivent plus apparaître dans app.css :
  bx-allocation-bar, bx-asset-card, bx-cls-stat-box, bx-assets-accordion

---

LOT-PAT-1 — ADR-029 rgba → color-mix dans patrimoine.css (AUTO-DELTA)

Lire public/css/patrimoine.css. Appliquer les 7 substitutions suivantes :

  rgba(255, 255, 255, 0.07)   →  color-mix(in srgb, var(--bx-app-fg) 7%, transparent)
  rgba(255, 255, 255, 0.05)   →  color-mix(in srgb, var(--bx-app-fg) 5%, transparent)
  rgba(255, 255, 255, 0.03)   →  color-mix(in srgb, var(--bx-app-fg) 3%, transparent)
  rgba(255, 255, 255, 0.02)   →  color-mix(in srgb, var(--bx-app-fg) 2%, transparent)
  rgba(255, 255, 255, 0.025)  →  color-mix(in srgb, var(--bx-app-fg) 2.5%, transparent)
  rgba(255, 255, 255, 0.035)  →  color-mix(in srgb, var(--bx-app-fg) 3.5%, transparent)  [1ère occurrence]
  rgba(255, 255, 255, 0.035)  →  color-mix(in srgb, var(--bx-app-fg) 3.5%, transparent)  [2ème occurrence]

Les deux occurrences de 0.035 sont dans des sélecteurs distincts (vers L774 et L786 dans un @media 575px).
Traiter chacune individuellement avec Edit (une par call).

Vérification : grep -n "rgba" public/css/patrimoine.css → 0 résultat attendu.

---

LOT-PAT-2 — Créer tests/Domain/Patrimoine/PatrimoineInlineCodeTest.php (AUTO)

Créer le fichier avec ce contenu exact :

<?php

declare(strict_types=1);

namespace App\Tests\Domain\Patrimoine;

use App\Entity\Account;
use App\Entity\User;
use App\Tests\AppTestCase;

/**
 * Contrats structurels : patrimoine.css chargé, absence d'onclick inline, blocs JSON présents.
 */
final class PatrimoineInlineCodeTest extends AppTestCase
{
    /**
     * Contrat 1 : index et comptes-bancaires chargent patrimoine.css exactement une fois.
     * 2 assertions.
     */
    public function testPatrimoineIndexAndDetailLoadPatrimoineCss(): void
    {
        $user = $this->createUser();
        $this->createBankAccount($user);
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'patrimoine.css'),
            'La page index doit charger patrimoine.css exactement une fois.'
        );

        $this->client->request('GET', '/app/patrimoine/comptes-bancaires');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'patrimoine.css'),
            'La page comptes-bancaires doit charger patrimoine.css exactement une fois.'
        );
    }

    /**
     * Contrat 2 : index et comptes-bancaires ne contiennent aucun onclick inline.
     * 2 assertions.
     */
    public function testPatrimoineHasNoOnclickInline(): void
    {
        $user = $this->createUser();
        $this->createBankAccount($user);
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine');
        $this->assertResponseIsSuccessful();
        $this->assertStringNotContainsString(
            'onclick=',
            (string) $this->client->getResponse()->getContent(),
            'index.html.twig ne doit contenir aucun onclick inline.'
        );

        $this->client->request('GET', '/app/patrimoine/comptes-bancaires');
        $this->assertResponseIsSuccessful();
        $this->assertStringNotContainsString(
            'onclick=',
            (string) $this->client->getResponse()->getContent(),
            'comptes_bancaires.html.twig ne doit contenir aucun onclick inline.'
        );
    }

    /**
     * Contrat 3 : les blocs JSON de données Chart.js sont présents.
     * 2 assertions.
     */
    public function testPatrimoineHasJsonDataBlocks(): void
    {
        $user = $this->createUser();
        $this->createBankAccount($user);
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine');
        $this->assertResponseIsSuccessful();
        $this->assertStringContainsString(
            'id="bxPatData"',
            (string) $this->client->getResponse()->getContent(),
            'index.html.twig doit contenir le bloc JSON bxPatData.'
        );

        $this->client->request('GET', '/app/patrimoine/comptes-bancaires');
        $this->assertResponseIsSuccessful();
        $this->assertStringContainsString(
            'id="bxClsData"',
            (string) $this->client->getResponse()->getContent(),
            'comptes_bancaires.html.twig doit contenir le bloc JSON bxClsData.'
        );
    }

    /**
     * Contrat 4 : la page credits charge patrimoine.css exactement une fois.
     * 1 assertion.
     */
    public function testCreditsPageLoadsPatrimoineCss(): void
    {
        $user = $this->createUser();
        $this->client->loginUser($user);

        $this->client->request('GET', '/app/patrimoine/credits');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $this->client->getResponse()->getContent(), 'patrimoine.css'),
            'La page credits doit charger patrimoine.css exactement une fois.'
        );
    }

    private function createBankAccount(User $user): Account
    {
        $account = new Account();
        $account->setUser($user)
            ->setName('Compte test CB')
            ->setAssetClass('comptes_bancaires')
            ->setInitialBalance('1000.00')
            ->setCurrentBalance('1000.00')
            ->setCurrency('EUR');

        $this->em->persist($account);
        $this->em->flush();

        return $account;
    }
}

---

SÉQUENCE D'EXÉCUTION

1. Appliquer LOT-PAT-0 (Edit dans app.css — suppression de ~209 lignes)
2. Appliquer LOT-PAT-1 (7 Edit dans patrimoine.css — substitutions)
3. Appliquer LOT-PAT-2 (Write — création du fichier de tests)
4. Lancer les tests :
   php -d memory_limit=1G bin/phpunit tests/Domain/Patrimoine/ --no-coverage
   Attendu : 9 tests existants + 7 nouveaux = 16 tests · 0 failures
5. Si tous verts → commit unique :

   git commit -m "$(cat <<'EOF'
   refactor(patrimoine): ADR-029 color-mix, purge app.css legacy, 4 structural tests

   LOT-PAT-0: remove 209-line legacy block from app.css (L1616-L1824)
   LOT-PAT-1: tokenize 7 rgba(255,255,255,X) in patrimoine.css via color-mix
   LOT-PAT-2: add PatrimoineInlineCodeTest (4 tests, 7 assertions)
   EOF
   )"

ARRÊT IMMÉDIAT si :
- Un test passe en FAILURE après LOT-PAT-0 → isoler (les autres lots sont indépendants)
- Grep LOT-PAT-1 révèle plus de 7 occurrences rgba(255,255,255 dans patrimoine.css → signaler
- Grep LOT-PAT-0 révèle que le marqueur de début est introuvable → lire les lignes 1610-1620 et corriger l'ancre
```
