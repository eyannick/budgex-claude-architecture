# Manifeste — Campagne Templates & JS Transactions
<!-- .claude/ est gitignored — fichier local uniquement -->
<!-- AMEND 2026-06-11 : fusion LOT-2+3, compteurs exacts, readJsonArray, tests sécurité -->
<!-- AMEND-XSS-TEST 2026-06-11 : contrat P3 corrigé — suppression assertion incorrecte, ajout vérification script exécutable + validité JSON + restauration nom -->
<!-- AMEND-TXJS-CODE-COUNTERS 2026-06-12 : LOT-1 CLOSED 48088b0 · inventaire CODE/COMMENTAIRE · compteurs sémantiques · réécritures commentaires obsolètes · G2 ajouté LOT-4 (txReviewContext suggest.js) · validation reprise obligatoire -->

## Statut

**CLÔTURÉE — 2026-06-12**

| Lot | Statut | Commit | Push |
|-----|--------|--------|------|
| LOT-TXJS-1-CSS | CLOSED | `48088b0` | confirmé |
| LOT-TXJS-2-MODAL-INBOX | CLOSED | `d07a7ea` | confirmé |
| LOT-TXJS-3-REVIEW | CLOSED | `3e94321` | confirmé |
| LOT-TXJS-4-SUGGEST | CLOSED | `0d50f41` | confirmé |
| LOT-TXJS-5-CONTEXT | CLOSED | `d973d4d` | confirmé |

---

## Contexte

Campagne de clôture de la dette hors-CSS du module Transactions / À traiter.
Prérequis : campagne CSS Transactions clôturée au commit `23d9058`.

HEAD initial : `23d90584b428d6d781f4745beb96884afd48451f`
HEAD de reprise (après LOT-1 CLOSED) : `48088b0`
Branch : `master` = `origin/master`

---

## Périmètre

### Fichiers modifiables (allowlist stricte)

| Fichier | Rôle | Lot |
|---------|------|-----|
| `public/css/transactions.css` | Ajout class `.bx-tx-nav-badge` uniquement | LOT-1 |
| `templates/transaction/_qualify_modal.html.twig` | JSON blocks + d-none | LOT-2 |
| `public/js/inbox-qualify.js` | JSON read + classList + styles | LOT-2 |
| `tests/Domain/Todo/TodoPageTest.php` | Assertions contrat JSON + sécurité | LOT-2 |
| `public/js/transaction-review.js` | feedEl + nav-badge | LOT-3 |
| `public/js/transaction-suggest.js` | Retrait font-size:14px inline | LOT-4 |
| `templates/todo/index.html.twig` | Retrait script txReviewContext | LOT-5 |

### Fichiers FIGÉS (lecture seule, zéro modification)

- `public/css/bank.css` — figé définitivement
- `public/css/components.css`, `public/css/app.css`, `public/css/colors_and_type.css`
- `src/Controller/TodoController.php`, `src/Controller/TransactionController.php`
- `templates/transaction/_todo_feed.html.twig`
- `templates/transaction/index.html.twig`
- `public/js/transaction-index.js`
- `public/js/todo-feed.js`
- Tous fichiers hors allowlist

---

## Inventaire des occurrences window.*

Résultat de l'audit effectué sur HEAD 48088b0.

| Fichier | Ligne | Contenu (résumé) | Nature | Lot |
|---------|-------|------------------|--------|-----|
| `templates/transaction/_qualify_modal.html.twig` | 4 | `categoriesJson  — JSON string pour window.txCategories` | COMMENTAIRE | LOT-2 (réécriture) |
| `templates/transaction/_qualify_modal.html.twig` | 5 | `libellesJson    — JSON string pour window.txLibelles` | COMMENTAIRE | LOT-2 (réécriture) |
| `templates/transaction/_qualify_modal.html.twig` | 9 | `<script>window.txCategories = {{ categoriesJson|raw }};` | CODE | LOT-2 (remplacement) |
| `templates/transaction/_qualify_modal.html.twig` | 10 | `<script>window.txLibelles   = {{ libellesJson|raw }};` | CODE | LOT-2 (remplacement) |
| `public/js/inbox-qualify.js` | 13 | `* - Cascade catégorie → sous-catégorie (window.txCategories)` | COMMENTAIRE | LOT-2 (réécriture) |
| `public/js/inbox-qualify.js` | 14 | `* - Filtrage libellés par catégorie effective (window.txLibelles)` | COMMENTAIRE | LOT-2 (réécriture) |
| `public/js/inbox-qualify.js` | 51 | `: (window.txReviewContext \|\| 'all');` | CODE | LOT-2 (suppression) |
| `public/js/inbox-qualify.js` | 188 | `return (window.txCategories \|\| []).filter(...)` | CODE | LOT-2 (remplacement) |
| `public/js/inbox-qualify.js` | 193 | `return (window.txCategories \|\| []).filter(...)` | CODE | LOT-2 (remplacement) |
| `public/js/inbox-qualify.js` | 200 | `return (window.txLibelles \|\| []).filter(...)` | CODE | LOT-2 (remplacement) |
| `public/js/transaction-review.js` | 22 | `: (window.txReviewContext \|\| 'all');` | CODE | LOT-3 (suppression) |
| `public/js/transaction-suggest.js` | 16 | `var reviewFilter = ... \|\| (window.txReviewContext \|\| 'all');` | CODE | LOT-4 (suppression) |
| `templates/todo/index.html.twig` | 124 | `<script>window.txReviewContext = 'pending';</script>` | CODE | LOT-5 (suppression) |

**Remarque** : `grep -c 'window\.txCategories'` retourne **2** dans le template (1 code + 1 commentaire) et **3** dans `inbox-qualify.js` (2 code + 1 commentaire JSDoc), au lieu des valeurs attendues 1 et 2. C'est pourquoi Codex s'est arrêté avant LOT-2 — les préconditions utilisaient des compteurs bruts.

Les contrôles AVANT/APRÈS utilisent désormais des **motifs sémantiques** ciblant uniquement le code exécutable (voir section "Contrôles sémantiques" ci-dessous).

---

## Contrôles sémantiques

### Motifs CODE exécutable (préconditions bloquantes)

| Contexte | Motif sémantique | Description |
|----------|-----------------|-------------|
| Template AVANT | `<script>window\.txCategories` | Cible `<script>window.txCategories =` — n'existe que dans le script exécutable, pas dans le commentaire Twig |
| Template AVANT | `<script>window\.txLibelles` | Idem pour libelles |
| JS AVANT | `window\.txCategories \|\| \[\]` | Cible `(window.txCategories \|\| []).filter(...)` — absent du commentaire JSDoc |
| JS AVANT | `window\.txLibelles \|\| \[\]` | Cible `(window.txLibelles \|\| []).filter(...)` — absent du commentaire JSDoc |
| JS AVANT | `window\.txReviewContext \|\| ` | Cible les fallbacks exécutables — absent des commentaires |

### Motifs COMMENTAIRE (non bloquants, utilisés pour vérification de cohérence)

| Contexte | Motif | Attendu AVANT | Attendu APRÈS |
|----------|-------|---------------|---------------|
| Template | `JSON string pour window\.txCategories` | 1 | 0 (après T1C) |
| Template | `JSON string pour window\.txLibelles` | 1 | 0 (après T2C) |
| JS | `window\.txCategories\)` en JSDoc | 1 | 0 (après J0C) |
| JS | `window\.txLibelles\)` en JSDoc | 1 | 0 (après J0C) |

---

## Compteurs exacts par catégorie

**CODE de production**

| Catégorie | Lot | Fichier | Nombre |
|-----------|-----|---------|--------|
| Règle CSS `.bx-tx-nav-badge` ajoutée | LOT-1 ✅ CLOSED | `transactions.css` | **1** |
| Blocs `<script type="application/json">` ajoutés | LOT-2 | `_qualify_modal.html.twig` | **2** |
| Scripts exécutables `window.*` supprimés (template) | LOT-2 | `_qualify_modal.html.twig` | **2** |
| `style="display:none;"` supprimés (template) | LOT-2 | `_qualify_modal.html.twig` | **3** |
| Classes `d-none` ajoutées (template) | LOT-2 | `_qualify_modal.html.twig` | **3** |
| Fonction `readJsonArray` ajoutée | LOT-2 | `inbox-qualify.js` | **1** |
| Initialisations `_txCats`/`_txLibs` ajoutées | LOT-2 | `inbox-qualify.js` | **2** |
| Références `window.txCategories` supprimées (code) | LOT-2 | `inbox-qualify.js` | **2** |
| Références `window.txLibelles` supprimées (code) | LOT-2 | `inbox-qualify.js` | **1** |
| Référence `window.txReviewContext` supprimée fallback inbox | LOT-2 | `inbox-qualify.js` | **1** |
| Mutations `style.display` remplacées par classList | LOT-2 | `inbox-qualify.js` | **7** |
| Styles `font-size:14px` supprimés dans innerHTML | LOT-2 | `inbox-qualify.js` | **1** |
| Mutations `style.fontSize` supprimées | LOT-2 | `inbox-qualify.js` | **1** |
| Classes `.bx-tx-nav-badge` ajoutées via `classList.add` | LOT-2 | `inbox-qualify.js` | **1** |
| Référence `window.txReviewContext` supprimée fallback review | LOT-3 | `transaction-review.js` | **1** |
| Mutations `style.fontSize` supprimées | LOT-3 | `transaction-review.js` | **1** |
| Classes `.bx-tx-nav-badge` ajoutées via `classList.add` | LOT-3 | `transaction-review.js` | **1** |
| Fallback `feedEl` ajouté | LOT-3 | `transaction-review.js` | **1** |
| Styles `font-size:14px` supprimés dans innerHTML | LOT-4 | `transaction-suggest.js` | **1** |
| Référence `window.txReviewContext` supprimée fallback suggest | LOT-4 | `transaction-suggest.js` | **1** |
| Script `window.txReviewContext` supprimé (template todo) | LOT-5 | `todo/index.html.twig` | **1** |

**COMMENTAIRES à réécrire** (documenter l'ancien contrat window.* — obsolètes après migration)

| Élément | Lot | Fichier | Ligne | Nombre |
|---------|-----|---------|-------|--------|
| Commentaire Twig `categoriesJson — JSON string pour window.txCategories` | LOT-2 | `_qualify_modal.html.twig` | 4 | **1** |
| Commentaire Twig `libellesJson    — JSON string pour window.txLibelles` | LOT-2 | `_qualify_modal.html.twig` | 5 | **1** |
| JSDoc `* - Cascade catégorie … (window.txCategories)` | LOT-2 | `inbox-qualify.js` | 13 | **1** |
| JSDoc `* - Filtrage libellés … (window.txLibelles)` | LOT-2 | `inbox-qualify.js` | 14 | **1** |

### Total par lot

| Lot | Fichiers | Code prod | Commentaires | Méthodes test |
|-----|----------|-----------|--------------|---------------|
| LOT-TXJS-1-CSS ✅ CLOSED | 1 | **1** | 0 | 0 |
| LOT-TXJS-2-MODAL-INBOX | 3 (template + js + test) | **19** (5T + 14JS) | **4** (2T + 2JS) | **3** |
| LOT-TXJS-3-REVIEW | 1 | **2** | 0 | 0 |
| LOT-TXJS-4-SUGGEST | 1 | **2** (G1 + G2) | 0 | 0 |
| LOT-TXJS-5-CONTEXT | 1 | **1** | 0 | 0 |
| **TOTAL CAMPAGNE** | **7 fichiers** | **25 code prod** | **4 commentaires** | **3 méthodes test** |
| **RESTANT (LOT 2→5)** | **7 fichiers** | **24 code prod** | **4 commentaires** | **3 méthodes test** |

---

## Contrats de données

### categoriesJson / libellesJson

Structure (produite par `TodoController` et `TransactionController`) :
```json
// categoriesJson
[{"id": 1, "name": "Alimentation", "parentId": null}, {"id": 12, "name": "Restaurants", "parentId": 1}]

// libellesJson
[{"id": 5, "name": "Leclerc", "categoryId": 1}]
```

Encodage : `json_encode($data, JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE)` — sans `JSON_HEX_TAG`.
Risque XSS actuel : un nom contenant `</script>` fermerait prématurément le tag.
Mitigation Twig (sans toucher les contrôleurs) : `replace({'</': '<\/'})`.

**Explication de la sécurité :**
- `</script>` dans les données → `<\/script>` après replace
- Le parseur HTML cherche `</` suivi de `script>` : `<\/` commence par `<\`, pas `</` → le tag n'est PAS fermé
- `JSON.parse` décode `<\/` en `</` correctement (forward-slash peut être échappé en JSON selon RFC 8259)
- Le bloc `<script type="application/json">` n'est pas exécuté par le navigateur

**Transport cible :**
```twig
<script type="application/json" id="bx-tx-categories-data">{{ categoriesJson|replace({'</': '<\/'}) |raw }}</script>
<script type="application/json" id="bx-tx-libelles-data">{{ libellesJson|replace({'</': '<\/'}) |raw }}</script>
```

Note sur `|raw` : `categoriesJson` est une string JSON déjà encodée. L'auto-escape Twig transformerait `"` en `&quot;` et casserait le JSON. `|raw` est requis, le replace assure la sécurité avant.

### window.txReviewContext

`#todoFeed` porte `data-review-filter="pending"` (ligne 10 de `_todo_feed.html.twig`).
Après migration `feedEl` dans `transaction-review.js`, `window.txReviewContext` devient mort dans tous les JS.
Suppression de `todo/index.html.twig:124` en LOT-5, après validation de LOT-3.

---

## Fonction readJsonArray

Ajoutée dans `inbox-qualify.js` avant les initialisations `_txCats`/`_txLibs`.
Emplacement : après le bloc `var currentHasRule = false;` (actuel L41), dans un nouveau commentaire de section.

```js
// ── Données JSON — lues depuis les blocs <script type="application/json"> ────

function readJsonArray(elementId, label) {
    var el = document.getElementById(elementId);
    if (!el) { return []; }
    try {
        var parsed = JSON.parse(el.textContent);
        if (!Array.isArray(parsed)) {
            console.error('[inbox-qualify] ' + label + ': not an array');
            return [];
        }
        return parsed;
    } catch (e) {
        console.error('[inbox-qualify] ' + label + ' parse error:', e);
        return [];
    }
}

var _txCats = readJsonArray('bx-tx-categories-data', 'categories');
var _txLibs = readJsonArray('bx-tx-libelles-data', 'libelles');
```

Propriétés :
- Retourne `[]` si l'élément est absent
- Retourne `[]` si `JSON.parse` lance une exception
- Retourne `[]` si la valeur parsée n'est pas un tableau
- Journalise sans planter
- Aucune variable `window.*`
- Aucune syntaxe Twig

---

## Éléments CONSERVER

| Élément | Fichier | Justification |
|---------|---------|---------------|
| `style="--bx-budget-cat-color: {{ _catColor }}"` | `_todo_feed.html.twig` | CSS custom property dynamique — hors périmètre, légitime |
| `row.style.transition`, `row.style.opacity` | `transaction-review.js:53-54` | Animation de retrait de ligne — pas de token équivalent |
| `btnReviewAll.style.display = 'none'` | `transaction-review.js:417` | Masquage bouton legacy — hors scope modal qualify |
| `pendingBadge.style.display = 'none'` | `transaction-review.js:419` | Idem |
| `row.style.transition`, `row.style.opacity` | `inbox-qualify.js:71-72` | Animation de retrait de ligne |
| `escapeHtml()` | `transaction-suggest.js:136` | Garde XSS explicite — ne pas retirer |
| Tous les `data-*` attributs existants | Templates | Contrats CSRF/données — figés |

---

## LOT-TXJS-1-CSS

**Classification** : AUTO
**Dépendances** : aucune
**Fichier** : `public/css/transactions.css`
**Modifications** : 1

### Modification

Ajouter à la fin du fichier, après la dernière `}` (L2267) :

```css

/* ── Nav badge "À traiter" — override Bootstrap .badge font-size (0.75em) ── */
.bx-tx-nav-badge { font-size: .65rem; }
```

Justification F13 locale : `.65rem` = reprise exacte du comportement existant `badge.style.fontSize = '.65rem'`. Aucun token strictement équivalent. Classe partagée par `inbox-qualify.js` et `transaction-review.js`. Ajout autorisé à `transactions.css` figé (section "uniquement si classes locales nécessaires"). Aucune réouverture de la campagne CSS générale.

### Contrôle AVANT

```bash
grep -c "bx-tx-nav-badge" public/css/transactions.css   # → 0 attendu
```

### Contrôle APRÈS

```bash
grep -c "bx-tx-nav-badge" public/css/transactions.css   # → 1 attendu
git diff --check public/css/transactions.css
```

### Message de commit

```
refactor(transactions): extract nav badge font-size to CSS class bx-tx-nav-badge
```

### Règle d'arrêt

Arrêt si `grep -c "bx-tx-nav-badge"` ≠ 0 avant modification.

---

## LOT-TXJS-2-MODAL-INBOX

**Classification** : AUTO-DELTA
**Dépendances** : LOT-1 (classe `bx-tx-nav-badge` doit exister)
**Fichiers** : `templates/transaction/_qualify_modal.html.twig`, `public/js/inbox-qualify.js`, `tests/Domain/Todo/TodoPageTest.php`
**Modifications** : 5 template + 14 JS + tests = **19**

Rationalité de la fusion : le producteur JSON (template) et le consommateur (inbox-qualify.js) doivent être dans le même commit. Un état intermédiaire avec uniquement le template modifié briserait la page (JSON blocks présents mais JS lit encore `window.txCategories = undefined`). Un état intermédiaire avec uniquement le JS modifié serait silencieusement vide (`_txCats = []` si les blocs JSON sont absents). Ni l'un ni l'autre n'est fonctionnel. La fusion garantit l'atomicité.

---

### TEMPLATE — _qualify_modal.html.twig (5 substitutions de code + 2 réécritures de commentaires)

**[T1C] L4 — Commentaire Twig : documenter le nouveau contrat JSON block**

```twig
AVANT : "    categoriesJson  — JSON string pour window.txCategories"
APRÈS : "    categoriesJson  — JSON string injecté dans #bx-tx-categories-data"
```

**[T2C] L5 — Commentaire Twig : documenter le nouveau contrat JSON block**

```twig
AVANT : "    libellesJson    — JSON string pour window.txLibelles"
APRÈS : "    libellesJson    — JSON string injecté dans #bx-tx-libelles-data"
```

**[T1] L9 — Script exécutable → JSON block categories**

```twig
AVANT : <script>window.txCategories = {{ categoriesJson|raw }};</script>
APRÈS : <script type="application/json" id="bx-tx-categories-data">{{ categoriesJson|replace({'</': '<\/'}) |raw }}</script>
```

**[T2] L10 — Script exécutable → JSON block libelles**

```twig
AVANT : <script>window.txLibelles   = {{ libellesJson|raw }};</script>
APRÈS : <script type="application/json" id="bx-tx-libelles-data">{{ libellesJson|replace({'</': '<\/'}) |raw }}</script>
```

**[T3] L41 — qualifySubcategoryGroup : style inline → d-none**

```twig
AVANT : <div class="bx-tx-modal-field" id="qualifySubcategoryGroup" style="display:none;">
APRÈS : <div class="bx-tx-modal-field d-none" id="qualifySubcategoryGroup">
```

**[T4] L48 — qualifyLibelleGroup : style inline → d-none**

```twig
AVANT : <div class="bx-tx-modal-field" id="qualifyLibelleGroup" style="display:none;">
APRÈS : <div class="bx-tx-modal-field d-none" id="qualifyLibelleGroup">
```

**[T5] L57 — qualifyCreateRuleGroup : style inline → d-none**

```twig
AVANT : <div id="qualifyCreateRuleGroup" style="display:none;">
APRÈS : <div id="qualifyCreateRuleGroup" class="d-none">
```

---

### JS — inbox-qualify.js (14 modifications de code + 1 réécriture de commentaires)

**[J0C] L13-14 — JSDoc : documenter le nouveau contrat _txCats/_txLibs**

```js
AVANT L13 : " *  - Cascade catégorie → sous-catégorie (window.txCategories)"
APRÈS L13 : " *  - Cascade catégorie → sous-catégorie (_txCats depuis #bx-tx-categories-data)"

AVANT L14 : " *  - Filtrage libellés par catégorie effective (window.txLibelles)"
APRÈS L14 : " *  - Filtrage libellés par catégorie effective (_txLibs depuis #bx-tx-libelles-data)"
```

**[J1] ADDITION — après L41 : bloc readJsonArray + initialisations**

Insérer le bloc complet après `var currentHasRule = false;` :

```js
// ── Données JSON — lues depuis les blocs <script type="application/json"> ────

function readJsonArray(elementId, label) {
    var el = document.getElementById(elementId);
    if (!el) { return []; }
    try {
        var parsed = JSON.parse(el.textContent);
        if (!Array.isArray(parsed)) {
            console.error('[inbox-qualify] ' + label + ': not an array');
            return [];
        }
        return parsed;
    } catch (e) {
        console.error('[inbox-qualify] ' + label + ' parse error:', e);
        return [];
    }
}

var _txCats = readJsonArray('bx-tx-categories-data', 'categories');
var _txLibs = readJsonArray('bx-tx-libelles-data', 'libelles');
```

**[J2] L51 — Suppression fallback window.txReviewContext**

```js
AVANT : : (window.txReviewContext || 'all');
APRÈS : : 'all';
```

**[J3] L95 — Retrait style="font-size:14px;" dans badge.innerHTML (updateRowAfterQualify)**

```js
AVANT : badge.innerHTML = '<i class="material-icons" aria-hidden="true" style="font-size:14px;">check_circle</i>Validée';
APRÈS : badge.innerHTML = '<i class="material-icons" aria-hidden="true">check_circle</i>Validée';
```

Justification : `components.css:1215-1216` — `.bx-pill .material-icons { font-size: var(--bx-fs-sm); }` = 0.875rem = 14px. Suppression pure, zéro delta visuel.

**[J4] L149 — style.fontSize → classList (updateNavBadge)**

```js
AVANT : badge.style.fontSize = '.65rem';
APRÈS : badge.classList.add('bx-tx-nav-badge');
```

**[J5] L188 — window.txCategories → _txCats (getParents)**

```js
AVANT : return (window.txCategories || []).filter(function (c) { return !c.parentId; });
APRÈS : return _txCats.filter(function (c) { return !c.parentId; });
```

**[J6] L193 — window.txCategories → _txCats (getChildren)**

```js
AVANT : return (window.txCategories || []).filter(function (c) {
APRÈS : return _txCats.filter(function (c) {
```

**[J7] L200 — window.txLibelles → _txLibs (getLibelles)**

```js
AVANT : return (window.txLibelles || []).filter(function (l) {
APRÈS : return _txLibs.filter(function (l) {
```

**[J8] L223 — style.display = 'none' → classList.add (updateSubcategorySelect — branche vide)**

```js
AVANT : subcategoryGroup.style.display = 'none';
APRÈS : subcategoryGroup.classList.add('d-none');
```

**[J9] L226 — style.display = '' → classList.remove (updateSubcategorySelect — branche non-vide)**

```js
AVANT : subcategoryGroup.style.display = '';
APRÈS : subcategoryGroup.classList.remove('d-none');
```

**[J10] L246 — style.display = 'none' → classList.add (updateLibelleSelect — branche vide)**

```js
AVANT : libelleGroup.style.display = 'none';
APRÈS : libelleGroup.classList.add('d-none');
```

**[J11] L248 — style.display = '' → classList.remove (updateLibelleSelect — branche non-vide)**

```js
AVANT : libelleGroup.style.display = '';
APRÈS : libelleGroup.classList.remove('d-none');
```

**[J12] L279 — style.display conditionnel → classList conditionnel (click listener — createRuleGroup)**

```js
AVANT :
    createRuleGroup.style.display = currentHasRule ? '' : 'none';

APRÈS :
    if (currentHasRule) { createRuleGroup.classList.remove('d-none'); } else { createRuleGroup.classList.add('d-none'); }
```

**[J13] L283 — style.display = 'none' → classList.add (click listener — reset subcategoryGroup)**

```js
AVANT : subcategoryGroup.style.display = 'none';
APRÈS : subcategoryGroup.classList.add('d-none');
```

**[J14] L284 — style.display = 'none' → classList.add (click listener — reset libelleGroup)**

```js
AVANT : libelleGroup.style.display     = 'none';
APRÈS : libelleGroup.classList.add('d-none');
```

---

### TESTS — TodoPageTest.php (3 méthodes à ajouter)

Ajouter dans la classe `TodoPageTest extends AppTestCase` :

**[P1] testQualifyModalContainsJsonDataBlocks**

```php
public function testQualifyModalContainsJsonDataBlocks(): void
{
    $user    = $this->createUser();
    $account = $this->createAccount($user);
    $this->client->loginUser($user);

    // Transaction non catégorisée pour que le modal soit inclus dans la page
    $this->createTransaction($user, $account, false, null, '10.00');

    $this->client->request('GET', '/app/a-traiter');
    $this->assertResponseIsSuccessful();
    $response = (string) $this->client->getResponse()->getContent();

    // Blocs JSON non exécutables présents
    $this->assertStringContainsString(
        '<script type="application/json" id="bx-tx-categories-data">',
        $response
    );
    $this->assertStringContainsString(
        '<script type="application/json" id="bx-tx-libelles-data">',
        $response
    );

    // Variables globales absentes
    $this->assertStringNotContainsString('window.txCategories', $response);
    $this->assertStringNotContainsString('window.txLibelles', $response);
}
```

**[P2] testQualifyModalDisplayNoneReplacedByDNone**

```php
public function testQualifyModalDisplayNoneReplacedByDNone(): void
{
    $user    = $this->createUser();
    $account = $this->createAccount($user);
    $this->client->loginUser($user);

    $this->createTransaction($user, $account, false, null, '10.00');

    $crawler = $this->client->request('GET', '/app/a-traiter');
    $this->assertResponseIsSuccessful();

    // Aucun style="display:none;" dans la page
    $response = (string) $this->client->getResponse()->getContent();
    $this->assertStringNotContainsString('style="display:none;"', $response);

    // Les 3 groupes du modal ont la classe d-none
    $subGroup    = $crawler->filter('#qualifySubcategoryGroup');
    $libGroup    = $crawler->filter('#qualifyLibelleGroup');
    $ruleGroup   = $crawler->filter('#qualifyCreateRuleGroup');

    $this->assertCount(1, $subGroup,  '#qualifySubcategoryGroup doit exister');
    $this->assertCount(1, $libGroup,  '#qualifyLibelleGroup doit exister');
    $this->assertCount(1, $ruleGroup, '#qualifyCreateRuleGroup doit exister');

    $this->assertStringContainsString('d-none', $subGroup->attr('class')  ?? '');
    $this->assertStringContainsString('d-none', $libGroup->attr('class')  ?? '');
    $this->assertStringContainsString('d-none', $ruleGroup->attr('class') ?? '');
}
```

**[P3] testQualifyModalJsonEscapesScriptClosingTag**

```php
public function testQualifyModalJsonEscapesScriptClosingTag(): void
{
    $user    = $this->createUser();
    $account = $this->createAccount($user);
    $this->client->loginUser($user);

    // Catégorie dont le nom contient </script> — vecteur XSS classique
    $dangerousCat = new Category();
    $dangerousCat->setUser($user)
                 ->setName('Probe</script><script>alert(1)')
                 ->setType(Category::TYPE_EXPENSE);
    $this->em->persist($dangerousCat);
    $this->em->flush();

    $this->createTransaction($user, $account, false, null, '10.00');

    $crawler = $this->client->request('GET', '/app/a-traiter');
    $this->assertResponseIsSuccessful();
    $response = (string) $this->client->getResponse()->getContent();

    // [1] Bloc JSON catégories non exécutable présent
    $this->assertStringContainsString(
        '<script type="application/json" id="bx-tx-categories-data">',
        $response
    );

    // [2] Bloc JSON libelles non exécutable présent
    $this->assertStringContainsString(
        '<script type="application/json" id="bx-tx-libelles-data">',
        $response
    );

    // [3] Séquence dangereuse BRUTE absente
    // Si présente, </script> fermerait le bloc JSON prématurément → alert(1) exécutable.
    // Après replace({'</': '<\/'}), la réponse contient '<\/script>' (backslash), pas '</script>'.
    $this->assertStringNotContainsString(
        '</script><script>alert(1)',
        $response,
        'La séquence </script> brute ne doit pas apparaître dans la réponse.'
    );

    // [4] Séquence neutralisée présente (<\/ n'est pas reconnu fin-de-tag par le parseur HTML5)
    $this->assertStringContainsString('<\/script>', $response);

    // [5] Aucun script exécutable ne contient alert(1)
    // IMPORTANT : ne PAS asserter l'absence de '<script>alert(1)' dans la réponse brute.
    // Après neutralisation, la chaîne JSON contient légitimement '<\/script><script>alert(1)'
    // dont '<script>alert(1)' est une sous-chaîne présente dans le texte JSON mais non exécutée.
    // On vérifie à la place qu'aucun nœud script exécutable ne contient alert(1).
    $dangerousScripts = $crawler->filter('script')->reduce(function ($node) {
        $type = $node->attr('type');
        $isExecutable = ($type === null || $type === '' || $type === 'text/javascript');
        return $isExecutable && str_contains($node->text(), 'alert(1)');
    });
    $this->assertCount(
        0,
        $dangerousScripts,
        'Aucun script exécutable ne doit contenir alert(1) — le payload ne doit pas sortir du bloc JSON.'
    );

    // [6] Validité JSON du bloc catégories
    // Méthode retenue : getNode(0)->textContent — accès direct au nœud DOM libxml,
    // plus fiable que ->text() pour les éléments script (évite toute normalisation interne).
    $catBlock    = $crawler->filter('script[type="application/json"]#bx-tx-categories-data');
    $this->assertCount(1, $catBlock, 'Le bloc JSON catégories doit être présent');
    $jsonContent = trim($catBlock->getNode(0)->textContent);
    $decoded     = json_decode($jsonContent, true);
    $this->assertSame(
        JSON_ERROR_NONE,
        json_last_error(),
        'Le bloc JSON catégories doit être du JSON valide : ' . json_last_error_msg()
    );
    $this->assertIsArray($decoded);

    // [7] Le nom original est restauré après json_decode
    // json_decode reconvertit <\/ → </ → le nom original Probe</script><script>alert(1) est intact.
    $names = array_column($decoded, 'name');
    $this->assertContains(
        'Probe</script><script>alert(1)',
        $names,
        'Le json_decode doit restaurer le nom original Probe</script><script>alert(1).'
    );
}
```

Note : `Category` est déjà importé dans `TodoPageTest` à L6 — aucun import supplémentaire requis.
La closure `reduce(function ($node)` n'est pas typée — pas de `use Symfony\Component\DomCrawler\Crawler` à ajouter.

---

### Contrôles AVANT (LOT-2)

Motifs **sémantiques** — code exécutable uniquement, excluent les commentaires.

```bash
# Template — code exécutable seulement (<script> préfixe exclut les commentaires Twig)
grep -c '<script>window\.txCategories'  templates/transaction/_qualify_modal.html.twig   # → 1
grep -c '<script>window\.txLibelles'    templates/transaction/_qualify_modal.html.twig   # → 1
grep -c 'style="display:none;"'         templates/transaction/_qualify_modal.html.twig   # → 3
grep -c 'type="application/json"'       templates/transaction/_qualify_modal.html.twig   # → 0

# JS — motifs ciblant le code exécutable (|| [] exclut les JSDoc sans ||)
grep -c 'window\.txCategories || \[\]'  public/js/inbox-qualify.js   # → 2
grep -c 'window\.txLibelles || \[\]'    public/js/inbox-qualify.js   # → 1
grep -c 'window\.txReviewContext || '   public/js/inbox-qualify.js   # → 1
grep -c '\.style\.fontSize'             public/js/inbox-qualify.js   # → 1
grep -c 'font-size:14px'                public/js/inbox-qualify.js   # → 1
grep -c '\.style\.display'              public/js/inbox-qualify.js   # → 7
```

Note : `grep -c 'window\.txCategories'` brut retourne **2** dans le template (1 code + 1 commentaire Twig L4) et **3** dans `inbox-qualify.js` (2 code + 1 commentaire JSDoc L13). Ces compteurs bruts ne sont PAS des préconditions bloquantes.

### Contrôles APRÈS (LOT-2)

Motifs **sémantiques** — code exécutable et commentaires réécris, zéro résidu.

```bash
# Template — code exécutable : zéro script window.* exécutable
grep -c '<script>window\.txCategories'    templates/transaction/_qualify_modal.html.twig   # → 0
grep -c '<script>window\.txLibelles'      templates/transaction/_qualify_modal.html.twig   # → 0
grep -c 'style="display:none;"'           templates/transaction/_qualify_modal.html.twig   # → 0
grep -c 'type="application/json"'         templates/transaction/_qualify_modal.html.twig   # → 2
# Template — commentaires réécris : zéro référence window.* résiduelle
grep -c 'window\.txCategories'            templates/transaction/_qualify_modal.html.twig   # → 0
grep -c 'window\.txLibelles'              templates/transaction/_qualify_modal.html.twig   # → 0

# JS — code exécutable : zéro fallback window.*
grep -c 'window\.txCategories'    public/js/inbox-qualify.js   # → 0
grep -c 'window\.txLibelles'      public/js/inbox-qualify.js   # → 0
grep -c 'window\.txReviewContext' public/js/inbox-qualify.js   # → 0
grep -c '\.style\.fontSize'       public/js/inbox-qualify.js   # → 0
grep -c 'font-size:14px'          public/js/inbox-qualify.js   # → 0
grep -c '\.style\.display'        public/js/inbox-qualify.js   # → 0
# (row.style.transition L71 + row.style.opacity L72 sont CONSERVÉS
#  mais ne matchent PAS '\.style\.display' — compteur correct → 0)
grep -c 'readJsonArray'           public/js/inbox-qualify.js   # → 3 (def + 2 appels)
grep -c 'bx-tx-nav-badge'         public/js/inbox-qualify.js   # → 1
```

### Tests (LOT-2)

```bash
node.exe --check public/js/inbox-qualify.js
php bin/console lint:twig templates/transaction --no-debug
php bin/console lint:container --no-debug
git diff --check
php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage
```

### Message de commit (LOT-2)

```
refactor(transactions): migrate qualify modal to JSON data blocks, classList visibility, and remove inline styles
```

### Règle d'arrêt (LOT-2)

Arrêt si un compteur AVANT ≠ attendu.
Arrêt si `node --check` échoue.
Arrêt si `lint:twig` échoue.
Arrêt si PHPUnit Todo rouge.

---

## LOT-TXJS-3-REVIEW

**Classification** : AUTO-DELTA
**Dépendances** : LOT-1 (classe `bx-tx-nav-badge`)
**Fichier** : `public/js/transaction-review.js`
**Modifications** : **2**

**[R1] L19-22 — Ajout feedEl, suppression window.txReviewContext, réécriture reviewFilter**

```js
AVANT (3 lignes) :
    var tableEl      = document.getElementById('transactionsTable');
    var reviewFilter = tableEl
        ? (tableEl.dataset.reviewFilter || 'all')
        : (window.txReviewContext || 'all');

APRÈS (4 lignes) :
    var tableEl      = document.getElementById('transactionsTable');
    var feedEl       = document.getElementById('todoFeed');
    var reviewFilter = tableEl ? (tableEl.dataset.reviewFilter || 'all')
                     : feedEl  ? (feedEl.dataset.reviewFilter  || 'all')
                     : 'all';
```

Justification : `#todoFeed` porte `data-review-filter="pending"` (`_todo_feed.html.twig:10`). Pattern identique à `inbox-qualify.js:47-51` (préexistant).

**[R2] L229 — style.fontSize → classList (updateNavBadge)**

```js
AVANT : badge.style.fontSize = '.65rem';
APRÈS : badge.classList.add('bx-tx-nav-badge');
```

### Contrôles AVANT

```bash
grep -c 'window\.txReviewContext' public/js/transaction-review.js   # → 1
grep -c '\.style\.fontSize'       public/js/transaction-review.js   # → 1
grep -c 'feedEl'                  public/js/transaction-review.js   # → 0
```

### Contrôles APRÈS

```bash
grep -c 'window\.txReviewContext' public/js/transaction-review.js   # → 0
grep -c '\.style\.fontSize'       public/js/transaction-review.js   # → 0
grep -c 'feedEl'                  public/js/transaction-review.js   # → 2 (décl + condition)
grep -c 'bx-tx-nav-badge'         public/js/transaction-review.js   # → 1
```

### Tests

```bash
node.exe --check public/js/transaction-review.js
php -d memory_limit=1G bin/phpunit --filter Transaction --no-coverage
git diff --check
```

### Message de commit

```
refactor(transactions): adopt feedEl pattern in transaction-review and extract nav badge to CSS class
```

### Règle d'arrêt

Arrêt si un compteur AVANT ≠ attendu.
Arrêt si `node --check` échoue.

---

## LOT-TXJS-4-SUGGEST

**Classification** : AUTO
**Dépendances** : aucune (indépendant de LOT-3, mais LOT-5 dépend que ce lot soit CLOSED)
**Fichier** : `public/js/transaction-suggest.js`
**Modifications** : **2**

**[G1] L118 — Retrait style="font-size:14px;" dans reviewBadge.innerHTML**

```js
AVANT :
    reviewBadge.innerHTML =
        '<i class="material-icons" aria-hidden="true" style="font-size:14px;">check_circle</i>Validée';

APRÈS :
    reviewBadge.innerHTML =
        '<i class="material-icons" aria-hidden="true">check_circle</i>Validée';
```

Justification identique à J3 : `components.css:1215-1216` — `.bx-pill .material-icons { font-size: var(--bx-fs-sm); }`. Zéro delta visuel.

**[G2] L16 — Suppression fallback window.txReviewContext**

```js
AVANT : var reviewFilter = rootEl.dataset.reviewFilter || (window.txReviewContext || 'all');
APRÈS : var reviewFilter = rootEl.dataset.reviewFilter || 'all';
```

Justification : `rootEl` est `table || feed`, les deux portent `data-review-filter`. Le fallback `window.txReviewContext` sera supprimé en LOT-5 — G2 doit être CLOSED avant LOT-5.

### Contrôles AVANT

```bash
grep -c 'font-size:14px'          public/js/transaction-suggest.js   # → 1
grep -c 'window\.txReviewContext' public/js/transaction-suggest.js   # → 1
```

### Contrôles APRÈS

```bash
grep -c 'font-size:14px'          public/js/transaction-suggest.js   # → 0
grep -c 'window\.txReviewContext' public/js/transaction-suggest.js   # → 0
```

### Tests

```bash
node.exe --check public/js/transaction-suggest.js
git diff --check
```

### Message de commit

```
refactor(transactions): remove redundant inline font-size and txReviewContext fallback from suggest
```

### Règle d'arrêt

Arrêt si `font-size:14px` count ≠ 1 avant modification.
Arrêt si `window.txReviewContext` count ≠ 1 avant modification.

---

## LOT-TXJS-5-CONTEXT

**Classification** : AUTO
**Dépendances** : LOT-3 (`transaction-review.js` ne lit plus `window.txReviewContext`) ET LOT-4 (`transaction-suggest.js` ne lit plus `window.txReviewContext`)
**Fichier** : `templates/todo/index.html.twig`
**Modifications** : **1**

**[C1] L124 — Suppression script window.txReviewContext**

```twig
AVANT :
<script>window.txReviewContext = 'pending';</script>
<div class="bx-todo-layout">

APRÈS :
<div class="bx-todo-layout">
```

### Contrôles AVANT

```bash
grep -c 'window\.txReviewContext' templates/todo/index.html.twig   # → 1
```

### Contrôles APRÈS

```bash
grep -c 'window\.txReviewContext' templates/todo/index.html.twig   # → 0

# Vérification globale — code exécutable uniquement (exclut commentaires et tests)
grep -rn '<script>window\.txCategories'   templates/               # → 0 résultats
grep -rn '<script>window\.txLibelles'     templates/               # → 0 résultats
grep -rn 'window\.txReviewContext'        templates/               # → 0 résultats
grep -rn 'window\.txCategories || \[\]'   public/js/              # → 0 résultats
grep -rn 'window\.txLibelles || \[\]'     public/js/              # → 0 résultats
grep -rn 'window\.txReviewContext || '    public/js/              # → 0 résultats
```

### Tests

```bash
php bin/console lint:twig templates/todo --no-debug
git diff --check
php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage
```

### Message de commit

```
refactor(transactions): remove obsolete txReviewContext inline script from todo page
```

### Règle d'arrêt

Arrêt si `window.txReviewContext` count ≠ 1 avant modification.
Arrêt si vérification globale post-modification trouve des résidus.

---

## Suite de tests finale

```bash
node.exe --check public/js/transaction-index.js
node.exe --check public/js/transaction-review.js
node.exe --check public/js/inbox-qualify.js
node.exe --check public/js/transaction-suggest.js
node.exe --check public/js/todo-feed.js

php bin/console lint:twig templates/transaction templates/todo --no-debug
php bin/console lint:container --no-debug

php -d memory_limit=1G bin/phpunit --filter Transaction --no-coverage
php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage

git diff --check

# Vérification finale — CODE EXÉCUTABLE uniquement (distingue code / commentaires / tests)
# Scripts exécutables window.* dans les templates
grep -rn '<script>window\.txCategories'   templates/               # → 0
grep -rn '<script>window\.txLibelles'     templates/               # → 0
grep -rn 'window\.txReviewContext'        templates/               # → 0
# Fallbacks exécutables window.* dans les fichiers JS
grep -rn 'window\.txCategories || \[\]'   public/js/              # → 0
grep -rn 'window\.txLibelles || \[\]'     public/js/              # → 0
grep -rn 'window\.txReviewContext || '    public/js/              # → 0
# (Les éventuels commentaires ou assertions de test ne doivent pas déclencher de faux blocage)
```

Baseline attendue : 153 tests Transaction + 19 tests Todo + 3 nouveaux Todo = **175 tests · 0 failures**.

---

## Prompt Codex — exécution autonome (AMEND 2026-06-12)

```
Tu es Codex. Reprends la campagne CAMPAGNE-TEMPLATES-JS-TRANSACTIONS au LOT 2.
LOT-TXJS-1-CSS est CLOSED (commit 48088b0, déjà poussé). Ne le rejoue pas.

Manifeste local : .claude/code-campaigns/transactions-templates-js.md

HEAD de reprise : 48088b0
Branch : master = origin/master

═══════════════════════════════════════════════════════════
PRÉCONTRÔLE OBLIGATOIRE avant chaque lot
═══════════════════════════════════════════════════════════
1. git status --short
   Si "M config/reference.php" apparaît : git restore -- config/reference.php
2. git status --short → doit être vide (0 ligne)
3. git rev-parse HEAD = git rev-parse origin/master → synchronisé
   Si ≠ : ARRÊT IMMÉDIAT

RÈGLES D'ARRÊT GLOBALES
- Divergence HEAD ≠ origin/master
- Fichier modifié hors allowlist du lot
- Compteur SÉMANTIQUE non atteint (ne jamais utiliser grep brut 'window\.txCategories'
  ou 'window\.txLibelles' comme précondition bloquante — ces patterns comptent code ET commentaires)
- node --check rouge
- lint:twig rouge
- PHPUnit rouge
- Résidu window.* exécutable détecté après le lot annoncé comme le supprimant

═══════════════════════════════════════════════════════════
VALIDATION DE REPRISE — obligatoire avant LOT 2
═══════════════════════════════════════════════════════════

Vérifier HEAD = origin/master = 48088b0 :
  git rev-parse HEAD                      # → doit commencer par 48088b0
  git rev-parse origin/master             # → idem

Restaurer config/reference.php si dirty :
  git status --short
  # Si "M config/reference.php" : git restore -- config/reference.php

Valider le code avant toute modification :
  node.exe --check public/js/transaction-index.js
  node.exe --check public/js/transaction-review.js
  node.exe --check public/js/inbox-qualify.js
  node.exe --check public/js/transaction-suggest.js
  node.exe --check public/js/todo-feed.js
  php bin/console lint:twig templates/transaction templates/todo --no-debug
  php bin/console lint:container --no-debug
  php -d memory_limit=1G bin/phpunit --filter Transaction --no-coverage
  php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage
  git diff --check

Restaurer config/reference.php si elle est devenue dirty après les validations :
  git restore -- config/reference.php

Si une validation échoue :
  Écrire "BLOCKED" dans le champ Statut du manifeste.
  Ne pas modifier de fichier métier.
  ARRÊT IMMÉDIAT.

═══════════════════════════════════════════════════════════
LOT-TXJS-2-MODAL-INBOX — 19 code + 4 commentaires + 3 méthodes de test
═══════════════════════════════════════════════════════════
Fichiers : templates/transaction/_qualify_modal.html.twig
           public/js/inbox-qualify.js
           tests/Domain/Todo/TodoPageTest.php

Contrôles AVANT (motifs SÉMANTIQUES — code exécutable uniquement) :
  grep -c '<script>window\.txCategories'  templates/transaction/_qualify_modal.html.twig   # → 1
  grep -c '<script>window\.txLibelles'    templates/transaction/_qualify_modal.html.twig   # → 1
  grep -c 'style="display:none;"'         templates/transaction/_qualify_modal.html.twig   # → 3
  grep -c 'type="application/json"'       templates/transaction/_qualify_modal.html.twig   # → 0

  grep -c 'window\.txCategories || \[\]'  public/js/inbox-qualify.js   # → 2
  grep -c 'window\.txLibelles || \[\]'    public/js/inbox-qualify.js   # → 1
  grep -c 'window\.txReviewContext || '   public/js/inbox-qualify.js   # → 1
  grep -c '\.style\.fontSize'             public/js/inbox-qualify.js   # → 1
  grep -c 'font-size:14px'                public/js/inbox-qualify.js   # → 1
  grep -c '\.style\.display'              public/js/inbox-qualify.js   # → 7

IMPORTANT : grep brut 'window\.txCategories' retourne 2 dans le template et 3 dans inbox-qualify.js
(commentaires inclus). Ces compteurs bruts ne sont PAS des préconditions bloquantes.

Actions sur templates/transaction/_qualify_modal.html.twig (T1C, T2C, T1-T5) :
  [T1C] L4 : Réécrire commentaire Twig :
          AVANT : "    categoriesJson  — JSON string pour window.txCategories"
          APRÈS : "    categoriesJson  — JSON string injecté dans #bx-tx-categories-data"
  [T2C] L5 : Réécrire commentaire Twig :
          AVANT : "    libellesJson    — JSON string pour window.txLibelles"
          APRÈS : "    libellesJson    — JSON string injecté dans #bx-tx-libelles-data"
  [T1] L9  : Remplacer "<script>window.txCategories = {{ categoriesJson|raw }};</script>"
           par "<script type=\"application/json\" id=\"bx-tx-categories-data\">{{ categoriesJson|replace({'</': '<\/'}) |raw }}</script>"
  [T2] L10 : Remplacer "<script>window.txLibelles   = {{ libellesJson|raw }};</script>"
           par "<script type=\"application/json\" id=\"bx-tx-libelles-data\">{{ libellesJson|replace({'</': '<\/'}) |raw }}</script>"
  [T3] L41 : Remplacer 'class="bx-tx-modal-field" id="qualifySubcategoryGroup" style="display:none;"'
           par 'class="bx-tx-modal-field d-none" id="qualifySubcategoryGroup"'
  [T4] L48 : Remplacer 'class="bx-tx-modal-field" id="qualifyLibelleGroup" style="display:none;"'
           par 'class="bx-tx-modal-field d-none" id="qualifyLibelleGroup"'
  [T5] L57 : Remplacer '<div id="qualifyCreateRuleGroup" style="display:none;">'
           par '<div id="qualifyCreateRuleGroup" class="d-none">'

Actions sur public/js/inbox-qualify.js (J0C, J1-J14) :
  [J0C] L13-14 : Réécrire les lignes JSDoc :
          AVANT L13 : " *  - Cascade catégorie → sous-catégorie (window.txCategories)"
          APRÈS L13 : " *  - Cascade catégorie → sous-catégorie (_txCats depuis #bx-tx-categories-data)"
          AVANT L14 : " *  - Filtrage libellés par catégorie effective (window.txLibelles)"
          APRÈS L14 : " *  - Filtrage libellés par catégorie effective (_txLibs depuis #bx-tx-libelles-data)"
  [J1]  Insérer après "var currentHasRule = false;" le bloc readJsonArray + _txCats + _txLibs
        (voir section LOT-TXJS-2-MODAL-INBOX / JS / [J1] du manifeste pour le code exact)
  [J2]  Remplacer ": (window.txReviewContext || 'all');" par ": 'all';"
  [J3]  Supprimer ' style="font-size:14px;"' dans badge.innerHTML de updateRowAfterQualify
  [J4]  Remplacer "badge.style.fontSize = '.65rem';" par "badge.classList.add('bx-tx-nav-badge');"
  [J5]  Remplacer "(window.txCategories || []).filter" par "_txCats.filter" dans getParents()
  [J6]  Remplacer "(window.txCategories || []).filter" par "_txCats.filter" dans getChildren()
  [J7]  Remplacer "(window.txLibelles || []).filter" par "_txLibs.filter" dans getLibelles()
  [J8]  Remplacer "subcategoryGroup.style.display = 'none';" par
        "subcategoryGroup.classList.add('d-none');" dans updateSubcategorySelect (branche vide)
  [J9]  Remplacer "subcategoryGroup.style.display = '';" par
        "subcategoryGroup.classList.remove('d-none');" dans updateSubcategorySelect
  [J10] Remplacer "libelleGroup.style.display = 'none';" par
        "libelleGroup.classList.add('d-none');" dans updateLibelleSelect (branche vide)
  [J11] Remplacer "libelleGroup.style.display = '';" par
        "libelleGroup.classList.remove('d-none');" dans updateLibelleSelect
  [J12] Remplacer "createRuleGroup.style.display = currentHasRule ? '' : 'none';" par
        "if (currentHasRule) { createRuleGroup.classList.remove('d-none'); } else { createRuleGroup.classList.add('d-none'); }"
  [J13] Remplacer "subcategoryGroup.style.display = 'none';" par
        "subcategoryGroup.classList.add('d-none');" dans le click listener (réinitialisation)
  [J14] Remplacer "libelleGroup.style.display     = 'none';" par
        "libelleGroup.classList.add('d-none');" dans le click listener (réinitialisation)

Actions sur tests/Domain/Todo/TodoPageTest.php (P1-P3) :
  [P1] Ajouter testQualifyModalContainsJsonDataBlocks()
  [P2] Ajouter testQualifyModalDisplayNoneReplacedByDNone()
  [P3] Ajouter testQualifyModalJsonEscapesScriptClosingTag()
  (voir section TESTS du manifeste pour le code exact)

Contrôles APRÈS :
  grep -c '<script>window\.txCategories'    templates/transaction/_qualify_modal.html.twig   # → 0
  grep -c '<script>window\.txLibelles'      templates/transaction/_qualify_modal.html.twig   # → 0
  grep -c 'style="display:none;"'           templates/transaction/_qualify_modal.html.twig   # → 0
  grep -c 'type="application/json"'         templates/transaction/_qualify_modal.html.twig   # → 2
  grep -c 'window\.txCategories'            templates/transaction/_qualify_modal.html.twig   # → 0
  grep -c 'window\.txLibelles'              templates/transaction/_qualify_modal.html.twig   # → 0

  grep -c 'window\.txCategories'    public/js/inbox-qualify.js   # → 0
  grep -c 'window\.txLibelles'      public/js/inbox-qualify.js   # → 0
  grep -c 'window\.txReviewContext' public/js/inbox-qualify.js   # → 0
  grep -c '\.style\.fontSize'       public/js/inbox-qualify.js   # → 0
  grep -c 'font-size:14px'          public/js/inbox-qualify.js   # → 0
  grep -c '\.style\.display'        public/js/inbox-qualify.js   # → 0
  grep -c 'readJsonArray'           public/js/inbox-qualify.js   # → 3
  grep -c 'bx-tx-nav-badge'         public/js/inbox-qualify.js   # → 1

Tests :
  node.exe --check public/js/inbox-qualify.js
  php bin/console lint:twig templates/transaction --no-debug
  php bin/console lint:container --no-debug
  git diff --check
  php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage   # → 22 tests, 0 failures

Commit : refactor(transactions): migrate qualify modal to JSON data blocks, classList visibility, and remove inline styles
Push : git push

═══════════════════════════════════════════════════════════
LOT-TXJS-3-REVIEW — 2 modifications
═══════════════════════════════════════════════════════════
Fichier : public/js/transaction-review.js

Contrôles AVANT :
  grep -c 'window\.txReviewContext' public/js/transaction-review.js   # → 1
  grep -c '\.style\.fontSize'       public/js/transaction-review.js   # → 1
  grep -c 'feedEl'                  public/js/transaction-review.js   # → 0

Actions :
  [R1] Remplacer le bloc var tableEl/reviewFilter (L19-22) :
       AVANT :
         var tableEl      = document.getElementById('transactionsTable');
         var reviewFilter = tableEl
             ? (tableEl.dataset.reviewFilter || 'all')
             : (window.txReviewContext || 'all');
       APRÈS :
         var tableEl      = document.getElementById('transactionsTable');
         var feedEl       = document.getElementById('todoFeed');
         var reviewFilter = tableEl ? (tableEl.dataset.reviewFilter || 'all')
                          : feedEl  ? (feedEl.dataset.reviewFilter  || 'all')
                          : 'all';
  [R2] Remplacer "badge.style.fontSize = '.65rem';" par "badge.classList.add('bx-tx-nav-badge');"

Contrôles APRÈS :
  grep -c 'window\.txReviewContext' public/js/transaction-review.js   # → 0
  grep -c '\.style\.fontSize'       public/js/transaction-review.js   # → 0
  grep -c 'feedEl'                  public/js/transaction-review.js   # → 2
  grep -c 'bx-tx-nav-badge'         public/js/transaction-review.js   # → 1

Tests :
  node.exe --check public/js/transaction-review.js
  php -d memory_limit=1G bin/phpunit --filter Transaction --no-coverage
  git diff --check

Commit : refactor(transactions): adopt feedEl pattern in transaction-review and extract nav badge to CSS class
Push : git push

═══════════════════════════════════════════════════════════
LOT-TXJS-4-SUGGEST — 2 modifications
═══════════════════════════════════════════════════════════
Fichier : public/js/transaction-suggest.js

Contrôles AVANT :
  grep -c 'font-size:14px'          public/js/transaction-suggest.js   # → 1
  grep -c 'window\.txReviewContext' public/js/transaction-suggest.js   # → 1

Actions :
  [G1] Supprimer ' style="font-size:14px;"' dans reviewBadge.innerHTML :
       AVANT  : '<i class="material-icons" aria-hidden="true" style="font-size:14px;">check_circle</i>Validée'
       APRÈS  : '<i class="material-icons" aria-hidden="true">check_circle</i>Validée'
  [G2] L16 : Supprimer le fallback window.txReviewContext :
       AVANT  : var reviewFilter = rootEl.dataset.reviewFilter || (window.txReviewContext || 'all');
       APRÈS  : var reviewFilter = rootEl.dataset.reviewFilter || 'all';

Contrôles APRÈS :
  grep -c 'font-size:14px'          public/js/transaction-suggest.js   # → 0
  grep -c 'window\.txReviewContext' public/js/transaction-suggest.js   # → 0

Tests :
  node.exe --check public/js/transaction-suggest.js
  git diff --check

Commit : refactor(transactions): remove redundant inline font-size and txReviewContext fallback from suggest
Push : git push

═══════════════════════════════════════════════════════════
LOT-TXJS-5-CONTEXT — 1 modification
═══════════════════════════════════════════════════════════
Fichier : templates/todo/index.html.twig

Contrôle AVANT :
  grep -c 'window\.txReviewContext' templates/todo/index.html.twig   # → 1

Action :
  [C1] Supprimer la ligne L124 :
       "<script>window.txReviewContext = 'pending';</script>"

Contrôles APRÈS :
  grep -c 'window\.txReviewContext' templates/todo/index.html.twig   # → 0

  # Vérification globale — code exécutable uniquement (commentaires et tests exclus)
  grep -rn '<script>window\.txCategories'   templates/               # → 0
  grep -rn '<script>window\.txLibelles'     templates/               # → 0
  grep -rn 'window\.txReviewContext'        templates/               # → 0
  grep -rn 'window\.txCategories || \[\]'   public/js/              # → 0
  grep -rn 'window\.txLibelles || \[\]'     public/js/              # → 0
  grep -rn 'window\.txReviewContext || '    public/js/              # → 0

Tests :
  php bin/console lint:twig templates/todo --no-debug
  git diff --check
  php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage

Commit : refactor(transactions): remove obsolete txReviewContext inline script from todo page
Push : git push

═══════════════════════════════════════════════════════════
SUITE FINALE
═══════════════════════════════════════════════════════════
node.exe --check public/js/transaction-index.js
node.exe --check public/js/transaction-review.js
node.exe --check public/js/inbox-qualify.js
node.exe --check public/js/transaction-suggest.js
node.exe --check public/js/todo-feed.js
php bin/console lint:twig templates/transaction templates/todo --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter Transaction --no-coverage
php -d memory_limit=1G bin/phpunit --filter Todo --no-coverage
git diff --check

# Vérification finale — CODE EXÉCUTABLE uniquement (commentaires et tests exclus)
grep -rn '<script>window\.txCategories'   templates/               # → 0
grep -rn '<script>window\.txLibelles'     templates/               # → 0
grep -rn 'window\.txReviewContext'        templates/               # → 0
grep -rn 'window\.txCategories || \[\]'   public/js/              # → 0
grep -rn 'window\.txLibelles || \[\]'     public/js/              # → 0
grep -rn 'window\.txReviewContext || '    public/js/              # → 0

Attendu : 4 commits · 4 pushes · 0 fichier hors allowlist · 0 test rouge
          175 tests · 0 failures
```

---

## Rapport final (modèle)

```
## CAMPAGNE-TEMPLATES-JS-TRANSACTIONS — Rapport d'exécution

HEAD initial : 23d9058
HEAD final   : <hash>

| Lot | Hash | Fichiers | Modif | Tests | Statut |
|-----|------|----------|-------|-------|--------|
| LOT-TXJS-1-CSS         | <hash> | transactions.css (1)                           | 1  | OK | CLOSED |
| LOT-TXJS-2-MODAL-INBOX | <hash> | _qualify_modal.html.twig + inbox-qualify.js + TodoPageTest.php (3) | 19 prod + 3 tests | OK | CLOSED |
| LOT-TXJS-3-REVIEW      | <hash> | transaction-review.js (1)                      | 2  | OK | CLOSED |
| LOT-TXJS-4-SUGGEST     | <hash> | transaction-suggest.js (1)                     | 2 code | OK | CLOSED |
| LOT-TXJS-5-CONTEXT     | <hash> | todo/index.html.twig (1)                       | 1  | OK | CLOSED |

Total : 4 commits · 7 fichiers · 24 code prod + 4 commentaires · 3 méthodes de test · 175 tests suite · 0 failures

Verdict TEMPLATES TRANSACTIONS STRICTEMENT CLÔTURÉS : OUI/NON
Verdict JAVASCRIPT TRANSACTIONS STRICTEMENT CLÔTURÉ : OUI/NON
```

---

## Audit de clôture — VERDICT FINAL (2026-06-12)

Audit indépendant en lecture seule. Aucun fichier métier modifié.
Auditeur : Claude Code (claude-sonnet-4-6). Date : 2026-06-12.

---

### Reconciliation commits

| Commit | Lot | Statut |
|--------|-----|--------|
| `48088b0` | LOT-1 CSS | ✅ confirmé sur origin/master |
| `d07a7ea` | LOT-2 MODAL-INBOX | ✅ confirmé |
| `3e94321` | LOT-3 REVIEW | ✅ confirmé |
| `0d50f41` | LOT-4 SUGGEST | ✅ confirmé |
| `d973d4d` | LOT-5 CONTEXT | ✅ confirmé |

HEAD local = origin/master. Aucun commit en avance.

---

### Résultats des contrôles mécaniques

| Contrôle | Résultat |
|----------|---------|
| `node --check` inbox-qualify.js | ✅ EXIT 0 |
| `node --check` transaction-review.js | ✅ EXIT 0 |
| `node --check` transaction-suggest.js | ✅ EXIT 0 |
| `node --check` todo-feed.js | ✅ EXIT 0 |
| `lint:twig templates/transaction/ templates/todo/` | ✅ 8 fichiers valides |
| `lint:container` | ✅ OK |
| `phpunit --filter Transaction` | ✅ 153 tests · 440 assertions · 0 failures |
| `phpunit --filter Todo` | ✅ 22 tests · 98 assertions · 0 failures |
| `git diff --check` | ✅ 0 whitespace issues |
| `grep window.txCategories templates/ public/js/` | ✅ 0 résultats code |
| `grep window.txLibelles templates/ public/js/` | ✅ 0 résultats code |
| `grep window.txReviewContext templates/ public/js/` | ✅ 0 résultats |
| `grep style.fontSize public/js/*.js` (périmètre) | ✅ 0 résultats |
| `grep style="display:none" templates/transaction/_qualify_modal` | ✅ 0 résultats |
| `grep bx-tx-nav-badge transactions.css` | ✅ L2269 confirmé |

---

### Audit sections détaillées

**SECTION 2 — Contrat JSON**
- L9 `_qualify_modal.html.twig` : `<script type="application/json" id="bx-tx-categories-data">{{ categoriesJson|replace({'</': '<\/'}) |raw }}</script>` ✅
- L10 : idem pour libelles ✅
- `readJsonArray` avec try/catch, Array.isArray, fallback `[]` présent à L45-59 ✅
- `_txCats` L61, `_txLibs` L62 ✅

**SECTION 3 — Test XSS**
- `testQualifyModalJsonEscapesScriptClosingTag` présent à L492 de TodoPageTest.php ✅
- Assertions correctes : JSON blocks présents, `<\/script>` présent, aucun script exécutable avec alert(1), JSON valide, nom restauré par json_decode ✅
- Contrat P3 correct : ne teste PAS l'absence de la chaîne `<script>alert(1)` brute (évite faux positif) ✅

**SECTION 4 — Variables globales**
- `window.txCategories/txLibelles` : 2 occurrences dans `tests/Domain/Todo/TodoPageTest.php` seulement → ASSERTIONS DE TEST (assertStringNotContainsString), non code exécutable ✅
- Aucun global window.tx* dans templates/ ou public/js/ ✅

**SECTION 5 — Visibilité classList**
- `_qualify_modal.html.twig` L41/48/57 : `d-none` sur les 3 groupes ✅
- `inbox-qualify.js` : 7 classList.add/remove('d-none') — 0 style.display résiduel dans périmètre ✅
- EXCEPTION INTENTIONNELLE : `transaction-review.js` L418/420 `btnReviewAll.style.display = 'none'` — hors périmètre (bouton legacy, hide définitif) ✅

**SECTION 6 — Styles JS inline**
- `bx-tx-nav-badge` via `badge.classList.add(...)` : inbox-qualify.js L170, transaction-review.js L230 ✅
- G1 transaction-suggest.js : aucun `style="font-size:14px;"` dans innerHTML L117-118 ✅
- G2 transaction-suggest.js L16 : `rootEl.dataset.reviewFilter || 'all'` — no `window.txReviewContext` ✅

**SECTION 7 — innerHTML/XSS**
- 14 usages innerHTML sur 3 fichiers — tous strings statiques OU protégés
- transaction-suggest.js L124-125 : `escapeHtml(data.categoryName)` utilisé ✅
- `escapeHtml` L136-142 : complet (`&`, `<`, `>`, `"`) ✅
- Données variables systématiquement via `.textContent` : inbox-qualify.js L124, L173, L233, L252, L272 ✅

**SECTION 8 — Todo context**
- `todo/index.html.twig` : aucun script `window.txReviewContext` ✅ (confirmé lecture complète)
- `_todo_feed.html.twig` L10 : `data-review-filter="pending"` sur `#todoFeed` ✅
- feedEl pattern résout correctement : todo page → `reviewFilter = 'pending'`, tx index → `_dtReviewFilter` ✅

**SECTION 9 — Chargement/Bindings**
- `todo/index.html.twig` blocs javascripts : transaction-review.js + inbox-qualify.js + transaction-suggest.js + todo-feed.js ✅
- IIFE sur transaction-review.js et inbox-qualify.js ✅
- `DOMContentLoaded` sur transaction-suggest.js ✅

**SECTION 10 — CSS local**
- `.bx-tx-nav-badge { font-size: .65rem; }` à L2269 de transactions.css ✅
- Aucun fichier CSS figé modifié (bank.css, components.css, app.css, colors_and_type.css) ✅

**SECTION 11 — Responsive structurel**
- Aucune nouvelle structure layout ajoutée par la campagne ✅
- Changements purement logiques ou typographiques (badge font-size, JSON data, classList) ✅
- Comportement responsive inchangé ✅

**SECTION 12 — Tests**
- 3 nouvelles méthodes TodoPageTest.php aux L435, L463, L492 ✅
- Suite Transaction + Todo : 175 tests · 538 assertions · 0 failures ✅

**SECTION 13 — Manifeste**
- 5 lots CLOSED avec hashes corrects ✅
- Inventaire, compteurs sémantiques, réécritures commentaires, G2 LOT-4 présents ✅

---

### 10 VERDICTS FINAUX

| # | Verdict | Résultat |
|---|---------|---------|
| 1 | **TRANSACTIONS.CSS** | ✅ CONFORME — `bx-tx-nav-badge` L2269, aucun fichier figé touché |
| 2 | **TEMPLATES** | ✅ CONFORME — JSON data blocks + XSS escape + d-none + 0 script global |
| 3 | **JAVASCRIPT** | ✅ CONFORME — readJsonArray + _txCats/_txLibs + feedEl + classList + bx-tx-nav-badge |
| 4 | **CONTRAT JSON** | ✅ CONFORME — producteur Twig et consommateur JS alignés, escape `<\/` présent |
| 5 | **VARIABLES GLOBALES** | ✅ ÉLIMINÉES — 0 résultat `window.tx*` dans templates/ et public/js/ |
| 6 | **STYLES INLINE** | ✅ ÉLIMINÉS — 0 `style.fontSize` dans périmètre, CSS + classList en place |
| 7 | **innerHTML/XSS** | ✅ CONFORME/SÛRE — 14 usages : strings statiques ou escapeHtml, variables via textContent |
| 8 | **FONCTIONNELLEMENT STABILISÉ** | ✅ OUI — feedEl correct, 175 tests sans failure |
| 9 | **FIGEABLE** | ✅ OUI — 0 global résiduel, 0 style inline, 0 dette, tests verts |
| 10 | **CAMPAGNE VALIDÉE** | ✅ OUI — 5 commits atomiques · 7 fichiers · 24 code + 4 commentaires + 3 tests · 0 régression |

---

**CLÔTURE STRICTE DU MODULE TRANSACTIONS TRANSACTIONS PRONONCÉE — 2026-06-12**
