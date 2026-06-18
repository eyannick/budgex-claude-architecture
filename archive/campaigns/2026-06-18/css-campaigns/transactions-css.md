# Transactions CSS Campaign — transactions-css.md

## Métadonnées

| Champ | Valeur |
|-------|--------|
| Campagne | CAMPAGNE-TRANSACTIONS-CSS |
| Module | Transactions / À traiter |
| Fichier principal | `public/css/transactions.css` (2267 lignes) |
| Fichier hors-périmètre actif | `public/css/action-center.css` (déjà tokenisé — 0 dette F12/F13) |
| Statut | CSS CLOSED — 2026-06-11 |
| Lots | 5 (1 AUTO-DELTA-PREREQUIS + 3 AUTO + 1 AUTO-DELTA) |
| Substitutions totales | 26 |
| Contrainte héritée | `public/css/bank.css` figé — ne jamais modifier |

---

## HEAD attendu

```
1fc086ea24aaa80e0eb7075d7cefb52fff4d5087
```

Commit : `refactor(bank): tokenize mobile logo border-radius to design token`
Working tree requis : **propre** (`git status --short` = vide après restore de `config/reference.php`).

---

## Token reference

Fichier source : `public/css/colors_and_type.css`

| Token | Valeur | Usage dans la campagne |
|-------|--------|----------------------|
| `--bx-fw-regular` | `400` | LOT-TX-FW |
| `--bx-fw-medium` | `500` | LOT-TX-FW |
| `--bx-fw-semibold` | `600` | LOT-TX-FW |
| `--bx-fw-bold` | `700` | LOT-TX-FW |
| `--bx-app-elev` | dark: `0 1px 2px rgba(0,0,0,.40), 0 8px 24px rgba(0,0,0,.35)` · light: `0 1px 3px rgba(0,0,0,.08), 0 4px 14px rgba(0,0,0,.06)` | LOT-TX-BLOQUANT |
| `--bx-app-accent-hover` | dark: `#8b5cf6` · light: `#4e00bb` | LOT-TX-COLOR-MIX |
| `--bx-tracking-wide` | `0.07em` | LOT-TX-EXACT |
| `--bx-lh-normal` | `1.5` | LOT-TX-EXACT |
| `--bx-fs-sm` | `0.875rem` (≡ 14 px @ base 16 px) | LOT-TX-EXACT |
| `--bx-app-accent` | dark: `#7c3aed` · light: `#6200ea` | LOT-TX-F12-SHADOWS |

Tokens manquants :
- `--bx-app-elev-md` → **INEXISTANT** — seuls `--bx-app-elev-sm`, `--bx-app-elev` et `--bx-app-elev-lg` sont définis.

---

## Bilan F12 — inventaire complet (16 instances)

| # | Ligne | Valeur | Lot / Décision |
|---|-------|--------|----------------|
| 1 | 179 | `rgba(124, 58, 237, 0.28)` | LOT-TX-F12-SHADOWS |
| 2 | 198 | `rgba(255, 255, 255, 0.22)` | CONSERVER — overlay badge intrinsèque |
| 3 | 199 | `#fff` | CONSERVER — texte blanc sur accent, pas de token |
| 4 | 479 | `#fff` | CONSERVER — texte blanc sur accent |
| 5 | 609 | `#fff` | CONSERVER — texte blanc sur accent |
| 6 | 621 | `rgba(124,58,237,0.28)` | LOT-TX-F12-SHADOWS |
| 7 | 728 | `rgba(255,255,255,0.06)` | CONSERVER — ring DT collection (élévation fine-tuned) |
| 8 | 729 | `rgba(0,0,0,.35)` | CONSERVER — ambient DT collection (élévation fine-tuned) |
| 9 | 730 | `rgba(0,0,0,.50)` | CONSERVER — ambient deep DT collection |
| 10 | 966 | `%236B7280` dans SVG URI | CONSERVER — structurel : tokens CSS non injectables dans data URI |
| 11 | 1051 | `#fff` | CONSERVER — texte blanc sur accent |
| 12 | 1053 | `rgba(124, 58, 237, 0.30)` | LOT-TX-F12-SHADOWS |
| 13 | 1973 | `rgba(0,0,0,.18)` (fallback `--bx-app-elev-md`) | LOT-TX-BLOQUANT |
| 14 | 2190 | `#fff` | CONSERVER — texte blanc sur accent |
| 15 | 2196 | `#000` dans `color-mix(…85%,#000)` | LOT-TX-COLOR-MIX — fallback mort, `--bx-app-accent-hover` défini |
| 16 | 2197 | `#fff` | CONSERVER — texte blanc sur accent |

**Après exécution :** 5 supprimées/remplacées · 11 CONSERVER documentées et exemptées.

---

## Lot 1 — LOT-TX-BLOQUANT

**Classification :** AUTO-DELTA-PREREQUIS
**Fichier :** `public/css/transactions.css`
**Priorité :** premier obligatoire — référence invalide à un token inexistant.

### Analyse delta

| Dimension | Fallback actuel | `--bx-app-elev` (cible) |
|-----------|-----------------|------------------------|
| Layers | 1 | 2 (dark) / 2 (light) |
| Dark offset/blur/opacity | `0 4px 16px 0.18` | `0 1px 2px 0.40` + `0 8px 24px 0.35` |
| Light offset/blur/opacity | même fallback | `0 1px 3px 0.08` + `0 4px 14px 0.06` |
| Impact dark mode | ombre faible → ombre riche profonde | **delta significatif, amélioration** |
| Impact light mode | ombre forte → ombre subtile | **delta modéré, cohérence design system** |

Delta existant mais pré-validé : token-cible = échelon "base" de la hiérarchie sm/base/lg.
Aucune alternative viable ; aucun arbitrage supplémentaire requis.

### Substitutions (1)

| Ligne | Sélecteur | Avant | Après |
|-------|-----------|-------|-------|
| 1973 | `.bx-todo-card:hover` | `box-shadow: var(--bx-app-elev-md, 0 4px 16px rgba(0,0,0,.18));` | `box-shadow: var(--bx-app-elev);` |

**Vérification post-lot :** `grep -n "elev-md" public/css/transactions.css` → 0 résultat attendu.
**Commit :** `refactor(transactions): fix undefined --bx-app-elev-md token on todo card hover`
**Test :** `php -d memory_limit=1G bin/phpunit --no-coverage tests/Domain/Transaction/ tests/Domain/Todo/`

---

## Lot 2 — LOT-TX-FW

**Classification :** AUTO (parité exacte)
**Fichier :** `public/css/transactions.css`

### Substitutions (16)

Distribution réelle : `500` ×6 · `600` ×6 · `700` ×2 · `400` ×2 = **16**.

| Ligne | Sélecteur | Avant | Après |
|-------|-----------|-------|-------|
| 771 | `.dt-button-collection .bx-dt-export-child` | `font-weight: 500 !important;` | `font-weight: var(--bx-fw-medium) !important;` |
| 1592 | `.bx-tx-suggestion__cat` | `font-weight: 500;` | `font-weight: var(--bx-fw-medium);` |
| 1613 | `.bx-tx-suggestion__btn` | `font-weight: 500;` | `font-weight: var(--bx-fw-medium);` |
| 1680 | `.bx-todo-summary__num` | `font-weight: 700;` | `font-weight: var(--bx-fw-bold);` |
| 1743 | `.bx-todo-aside__title` | `font-weight: 600;` | `font-weight: var(--bx-fw-semibold);` |
| 1773 | `.bx-todo-aside__stat-num` | `font-weight: 700;` | `font-weight: var(--bx-fw-bold);` |
| 1840 | `.bx-todo-aside__btn-secondary` | `font-weight: 500;` | `font-weight: var(--bx-fw-medium);` |
| 1930 | `#todoFeedCount` | `font-weight: 600;` | `font-weight: var(--bx-fw-semibold);` |
| 2010 | `.bx-todo-card__label` | `font-weight: 500;` | `font-weight: var(--bx-fw-medium);` |
| 2020 | `.bx-todo-card__amount` | `font-weight: 600;` | `font-weight: var(--bx-fw-semibold);` |
| 2080 | `.bx-todo-card__sugg-label` | `font-weight: 600;` | `font-weight: var(--bx-fw-semibold);` |
| 2090 | `.bx-todo-card__sugg-confidence` | `font-weight: 600;` | `font-weight: var(--bx-fw-semibold);` |
| 2113 | `.bx-todo-card__sugg-cat` | `font-weight: 600;` | `font-weight: var(--bx-fw-semibold);` |
| 2118 | `.bx-todo-card__sugg-parent` | `font-weight: 400;` | `font-weight: var(--bx-fw-regular);` |
| 2125 | `.bx-todo-card__sugg-sep` | `font-weight: 400;` | `font-weight: var(--bx-fw-regular);` |
| 2159 | `.bx-todo-card__btn` | `font-weight: 500;` | `font-weight: var(--bx-fw-medium);` |

**Vérification post-lot :** `grep -c "font-weight: [0-9]" public/css/transactions.css` → 0 attendu.
**Commit :** `refactor(transactions): tokenize raw font-weight values to design tokens`
**Test :** `php -d memory_limit=1G bin/phpunit --no-coverage tests/Domain/Transaction/ tests/Domain/Todo/`

---

## Lot 3 — LOT-TX-EXACT

**Classification :** AUTO (parité exacte)
**Fichier :** `public/css/transactions.css`

### Substitutions (5)

| Ligne | Sélecteur | Avant | Après | Token |
|-------|-----------|-------|-------|-------|
| 335 | `.bx-tx-index-table thead` | `letter-spacing: 0.07em;` | `letter-spacing: var(--bx-tracking-wide);` | `0.07em` EXACT |
| 1115 | `.bx-tx-upcoming-table thead` | `letter-spacing: 0.07em;` | `letter-spacing: var(--bx-tracking-wide);` | `0.07em` EXACT |
| 1822 | `.bx-todo-aside__warn` | `line-height: 1.5;` | `line-height: var(--bx-lh-normal);` | `1.5` EXACT |
| 2009 | `.bx-todo-card__label` | `font-size: 14px;` | `font-size: var(--bx-fs-sm);` | `0.875rem` ≡ 14 px EXACT |
| 2019 | `.bx-todo-card__amount` | `font-size: 14px;` | `font-size: var(--bx-fs-sm);` | `0.875rem` ≡ 14 px EXACT |

**Note L2009/L2019 :** Ne tokeniser que ces deux sélecteurs `.bx-todo-card__label` et `.bx-todo-card__amount`. Ne pas toucher les `14px` dans les contextes Material Icons.

**Vérifications post-lot :**
```
grep -n "letter-spacing: 0\.07em" public/css/transactions.css  → 0 résultat
grep -n "line-height: 1\.5;"      public/css/transactions.css  → 0 résultat
```
**Commit :** `refactor(transactions): tokenize exact letter-spacing, line-height and font-size values`
**Test :** `php -d memory_limit=1G bin/phpunit --no-coverage tests/Domain/Transaction/ tests/Domain/Todo/`

---

## Lot 4 — LOT-TX-COLOR-MIX

**Classification :** AUTO
**Fichier :** `public/css/transactions.css`

### Analyse

```css
/* L2196 — état actuel */
background: var(--bx-app-accent-hover, color-mix(in srgb, var(--bx-app-accent) 85%, #000));
```

`--bx-app-accent-hover` est **défini** dans `colors_and_type.css` pour les deux modes :
- dark : `#8b5cf6` (L363)
- light : `#4e00bb` (L412)

Le fallback `color-mix(in srgb, var(--bx-app-accent) 85%, #000)` ne s'exécute jamais.
ADR-029 interdit `#000` raw dans `color-mix()`. Décision : **Option A — supprimer le fallback mort.**

### Substitutions (1)

| Ligne | Sélecteur | Avant | Après |
|-------|-----------|-------|-------|
| 2196 | `.bx-todo-card__btn--primary:hover, :focus-visible` | `background: var(--bx-app-accent-hover, color-mix(in srgb, var(--bx-app-accent) 85%, #000));` | `background: var(--bx-app-accent-hover);` |

**Vérification post-lot :** `grep -n "#000\b" public/css/transactions.css` → 0 résultat attendu.
**Commit :** `refactor(transactions): remove dead color-mix fallback, --bx-app-accent-hover is always defined`
**Test :** `php -d memory_limit=1G bin/phpunit --no-coverage tests/Domain/Transaction/ tests/Domain/Todo/`

---

## Lot 5 — LOT-TX-F12-SHADOWS

**Classification :** AUTO-DELTA
**Fichier :** `public/css/transactions.css`

### Substitutions (3)

| Ligne | Sélecteur | Avant | Après |
|-------|-----------|-------|-------|
| 179 | `.bx-tx-badge--active` | `box-shadow: 0 4px 12px rgba(124, 58, 237, 0.28);` | `box-shadow: 0 4px 12px color-mix(in srgb, var(--bx-app-accent) 28%, transparent);` |
| 621 | `.bx-tx-pagination__item--active` | `box-shadow: 0 4px 12px rgba(124,58,237,0.28);` | `box-shadow: 0 4px 12px color-mix(in srgb, var(--bx-app-accent) 28%, transparent);` |
| 1053 | `.page-item.active .page-link` | `box-shadow: 0 2px 8px rgba(124, 58, 237, 0.30);` | `box-shadow: 0 2px 8px color-mix(in srgb, var(--bx-app-accent) 30%, transparent);` |

**Delta :** dark mode `--bx-app-accent = #7c3aed = rgb(124,58,237)` — parité exacte.
Light mode : teinte hardcodée → accent thématique (amélioration). Pattern validé dans `bank.css` (39 usages).

**Vérification post-lot :** `grep -n "rgba(124" public/css/transactions.css` → 0 résultat attendu.
**Commit :** `refactor(transactions): tokenize accent rgba shadows using color-mix pattern`
**Test :** `php -d memory_limit=1G bin/phpunit --no-coverage tests/Domain/Transaction/ tests/Domain/Todo/`

---

## CONSERVERs documentés

### F12 — 11 raw values exemptées

| Ligne(s) | Valeur | Justification |
|----------|--------|---------------|
| L199, L479, L609, L1051, L2190, L2197 | `#fff` ×6 | Texte blanc sur fond accent — `--bx-app-fg` cible le corps de texte, pas les boutons primaires |
| L198 | `rgba(255,255,255,0.22)` | Overlay badge tab — valeur intrinsèque du composant |
| L728–730 | `rgba(255,255,255,0.06)`, `rgba(0,0,0,.35)`, `rgba(0,0,0,.50)` | Élévation fine-tuned dropdown DT Buttons — 3 couches intentionnelles |
| L966 | `%236B7280` dans SVG data URI | Structurel : les tokens CSS ne sont pas injectables dans les attributs SVG de data URI ; remplacement nécessiterait JavaScript |

### F13 — Font-sizes exemptés

| Valeur(s) | Contexte | Justification |
|-----------|---------|---------------|
| 20px, 22px, 18px, 16px, 15px, 14px, 13px, 48px (contextes Material Icons) | Taille physique icône | `font-size` sur Material Icons = taille glyphe intrinsèque — ne pas tokeniser |
| 11px ×~6 (L192, L228, L1591, L1612, …) | Tabs denses, chips, suggestion | Densité explicite ; aucun token entre `--bx-fs-xxs` et zéro |
| 12px, 13px, 10px ×multiple | Badges, légendes | Entre tokens — pas de correspondance exacte |
| 15px (L1953) | `.bx-todo-feed__done p` | Entre `--bx-fs-sm` (14 px) et `--bx-fs-body` (16 px) |

### F13 — Letter-spacings exemptés

`0.01em` ×4, `-0.01em` ×2, `0.02em`, `0.04em`, `0.08em`, `0.03em` — aucun token correspondant.

### F13 — Line-heights exemptés

`1.0` (icônes flush), `1.15`, `1.25`, `1.3`, `1.4` (densités intermédiaires), `1.55` (entre lh-normal 1.5 et lh-relaxed 1.75).

### F13 — Transitions exemptées

`.15s` / `150ms` et `120ms` (pas de token exact) ; `200ms+250ms` mélangés dans une déclaration multi-propriété (découpage nuirait à la lisibilité).

### `!important` (128 occurrences — correction audit de clôture)

Les 128 occurrences sont réparties en quatre catégories — toutes justifiées :

| Bloc | Lignes | Rôle | Occurrences ~approx |
|------|--------|------|---------------------|
| DT Buttons override | L665–840 | Défaite du thème natif DT Buttons | ~84 |
| DataTables table width + Bootstrap .mb-3 | L284, L872 | Override Bootstrap layout | 2 |
| Bootstrap dark theme + table-hover | L1064–1093 | Override app.css dark mode cascade | ~13 |
| DataTable mobile responsive | L1375–1453 | Mobile card view layout | ~18 |
| Material Icons + suggestion icon sizes | L1584, L1623, L2073, L2171 | Icon glyph sizing overrides | 4 |
| Commentaires contenant "!important" | L6, L245, L1064, L1381 | Documentation uniquement | 4 (non compilés) |

Aucun `!important` gratuit. Exception locale justifiée — ne pas promouvoir comme règle canonique Budgex.

---

## Dettes hors campagne CSS

Ces éléments existent dans les templates et fichiers JS. Ils ne sont pas adressables dans une campagne CSS et ne bloquent pas la clôture F12/F13.

| Fichier | Ligne | Élément | Nature |
|---------|-------|---------|--------|
| `templates/todo/index.html.twig` | 124 | `<script>window.txReviewContext = 'pending';</script>` | Script de configuration inline dans template |
| `templates/transaction/_qualify_modal.html.twig` | 9 | `<script>window.txCategories = {{ categoriesJson\|raw }};</script>` | Injection JSON inline |
| `templates/transaction/_qualify_modal.html.twig` | 10 | `<script>window.txLibelles = {{ libellesJson\|raw }};</script>` | Injection JSON inline (omis dans AMEND) |
| `templates/transaction/_qualify_modal.html.twig` | 41, 48, 57 | `style="display:none;"` | État initial JS-contrôlé |
| `transaction-suggest.js` | 118 | `style="font-size:14px;"` dans innerHTML | Style inline icône Material dans DOM généré |
| `inbox-qualify.js` | 95 | `style="font-size:14px;"` dans innerHTML | Style inline icône Material dans DOM généré |
| `transaction-review.js` | 229 | `badge.style.fontSize = '.65rem'` | Taille badge nav définie en JS |
| `inbox-qualify.js` | 149 | `badge.style.fontSize = '.65rem'` | Taille badge nav définie en JS |

---

## ARBITRAGEs

**Aucun.** Tous les cas intermédiaires ont été résolus.

---

## BLOQUANTs

| ID | Fichier:Ligne | Token manquant | Résolution |
|----|---------------|----------------|------------|
| BLOQUANT-TX-ELEV-MD | `transactions.css:1973` | `--bx-app-elev-md` inexistant | LOT-TX-BLOQUANT (AUTO-DELTA-PREREQUIS) |

---

## Ordre d'exécution

```
1. LOT-TX-BLOQUANT    AUTO-DELTA-PREREQUIS   1 substitution
2. LOT-TX-FW          AUTO                  16 substitutions
3. LOT-TX-EXACT       AUTO                   5 substitutions
4. LOT-TX-COLOR-MIX   AUTO                   1 substitution
5. LOT-TX-F12-SHADOWS AUTO-DELTA             3 substitutions
                                          ──────────────────
                      TOTAL                 26 substitutions
```

---

## Prompt Codex — exécution autonome (AMEND 2026-06-11)

```
CAMPAGNE-TRANSACTIONS-CSS — Exécution autonome Codex

Manifeste     : .claude/css-campaigns/transactions-css.md
HEAD attendu  : 1fc086ea24aaa80e0eb7075d7cefb52fff4d5087

═══════════════════════════════════════════════════════════
RÈGLES ABSOLUES — lire avant toute action
═══════════════════════════════════════════════════════════
1. Modifier UNIQUEMENT public/css/transactions.css.
2. Ne jamais toucher public/css/bank.css, config/reference.php,
   ni aucun fichier PHP / Twig / JS / SQL.
3. Un lot = un commit atomique + un push immédiat, dans l'ordre.
4. Si un test échoue → STOP immédiat, ne pas continuer.
5. Si un grep de vérification retourne un résultat inattendu
   (compteur ≠ attendu) → STOP immédiat, signaler l'écart exact.
6. Ne pas regrouper plusieurs lots dans un seul commit.
7. Ne pas improviser si un compteur diffère du manifeste.
═══════════════════════════════════════════════════════════

──────────────────────────────────────────────────────────
ÉTAPE 0 — Préconditions
──────────────────────────────────────────────────────────
a) Restaurer config/reference.php si modifié :
     git restore -- config/reference.php

b) Vérifier HEAD :
     git rev-parse HEAD
   Attendu : 1fc086ea24aaa80e0eb7075d7cefb52fff4d5087
   Si différent → STOP.

c) Vérifier working tree propre :
     git status --short
   Attendu : aucune ligne (ou uniquement config/reference.php déjà restauré).
   Si d'autres fichiers sont modifiés → STOP.

d) Compter les font-weight bruts avant modification :
     grep -c "font-weight: [0-9]" public/css/transactions.css
   Attendu : 16
   Si différent → STOP, signaler.

──────────────────────────────────────────────────────────
ÉTAPE 1 — LOT-TX-BLOQUANT (AUTO-DELTA-PREREQUIS)
──────────────────────────────────────────────────────────
Fichier : public/css/transactions.css · Ligne : 1973

Remplacer :
  box-shadow: var(--bx-app-elev-md, 0 4px 16px rgba(0,0,0,.18));
Par :
  box-shadow: var(--bx-app-elev);

Vérification :
  grep -n "elev-md" public/css/transactions.css
  → 0 résultat attendu. Si résultat → STOP.

Test :
  php -d memory_limit=1G bin/phpunit --no-coverage \
    tests/Domain/Transaction/ tests/Domain/Todo/
  → 0 failure. Si failure → STOP.

Commit :
  git add public/css/transactions.css
  git commit -m "refactor(transactions): fix undefined --bx-app-elev-md token on todo card hover"
  git push

──────────────────────────────────────────────────────────
ÉTAPE 2 — LOT-TX-FW (AUTO — 16 substitutions)
──────────────────────────────────────────────────────────
Fichier : public/css/transactions.css

Substitutions exactes (remplacer chaque valeur numérique par le token) :

  L771  : font-weight: 500 !important;  →  font-weight: var(--bx-fw-medium) !important;
  L1592 : font-weight: 500;             →  font-weight: var(--bx-fw-medium);
  L1613 : font-weight: 500;             →  font-weight: var(--bx-fw-medium);
  L1680 : font-weight: 700;             →  font-weight: var(--bx-fw-bold);
  L1743 : font-weight: 600;             →  font-weight: var(--bx-fw-semibold);
  L1773 : font-weight: 700;             →  font-weight: var(--bx-fw-bold);
  L1840 : font-weight: 500;             →  font-weight: var(--bx-fw-medium);
  L1930 : font-weight: 600;             →  font-weight: var(--bx-fw-semibold);
  L2010 : font-weight: 500;             →  font-weight: var(--bx-fw-medium);
  L2020 : font-weight: 600;             →  font-weight: var(--bx-fw-semibold);
  L2080 : font-weight: 600;             →  font-weight: var(--bx-fw-semibold);
  L2090 : font-weight: 600;             →  font-weight: var(--bx-fw-semibold);
  L2113 : font-weight: 600;             →  font-weight: var(--bx-fw-semibold);
  L2118 : font-weight: 400;             →  font-weight: var(--bx-fw-regular);
  L2125 : font-weight: 400;             →  font-weight: var(--bx-fw-regular);
  L2159 : font-weight: 500;             →  font-weight: var(--bx-fw-medium);

Vérification :
  grep -c "font-weight: [0-9]" public/css/transactions.css
  → 0 attendu. Si résultat ≠ 0 → STOP, signaler les lignes restantes.

Test :
  php -d memory_limit=1G bin/phpunit --no-coverage \
    tests/Domain/Transaction/ tests/Domain/Todo/
  → 0 failure. Si failure → STOP.

Commit :
  git add public/css/transactions.css
  git commit -m "refactor(transactions): tokenize raw font-weight values to design tokens"
  git push

──────────────────────────────────────────────────────────
ÉTAPE 3 — LOT-TX-EXACT (AUTO — 5 substitutions)
──────────────────────────────────────────────────────────
Fichier : public/css/transactions.css

  L335  : letter-spacing: 0.07em;  →  letter-spacing: var(--bx-tracking-wide);
  L1115 : letter-spacing: 0.07em;  →  letter-spacing: var(--bx-tracking-wide);
  L1822 : line-height: 1.5;        →  line-height: var(--bx-lh-normal);
  L2009 : font-size: 14px;         →  font-size: var(--bx-fs-sm);
  L2019 : font-size: 14px;         →  font-size: var(--bx-fs-sm);

GARDE-FOU L2009/L2019 : ne modifier QUE les sélecteurs .bx-todo-card__label et
.bx-todo-card__amount. Ne pas toucher les autres 14px (contextes icônes Material).

Vérifications :
  grep -c "letter-spacing: 0\.07em" public/css/transactions.css  → 0
  grep -c "line-height: 1\.5;"      public/css/transactions.css  → 0
  Si résultat ≠ 0 → STOP.

Test :
  php -d memory_limit=1G bin/phpunit --no-coverage \
    tests/Domain/Transaction/ tests/Domain/Todo/
  → 0 failure. Si failure → STOP.

Commit :
  git add public/css/transactions.css
  git commit -m "refactor(transactions): tokenize exact letter-spacing, line-height and font-size values"
  git push

──────────────────────────────────────────────────────────
ÉTAPE 4 — LOT-TX-COLOR-MIX (AUTO — 1 substitution)
──────────────────────────────────────────────────────────
Fichier : public/css/transactions.css · Ligne : 2196

Remplacer :
  background: var(--bx-app-accent-hover, color-mix(in srgb, var(--bx-app-accent) 85%, #000));
Par :
  background: var(--bx-app-accent-hover);

Justification : --bx-app-accent-hover est défini dans colors_and_type.css pour dark
(#8b5cf6) et light (#4e00bb). Le fallback ne s'exécute jamais. Suppression conforme ADR-029.

Vérification :
  grep -n "#000\b" public/css/transactions.css
  → 0 résultat attendu. Si résultat → STOP.

Test :
  php -d memory_limit=1G bin/phpunit --no-coverage \
    tests/Domain/Transaction/ tests/Domain/Todo/
  → 0 failure. Si failure → STOP.

Commit :
  git add public/css/transactions.css
  git commit -m "refactor(transactions): remove dead color-mix fallback, --bx-app-accent-hover is always defined"
  git push

──────────────────────────────────────────────────────────
ÉTAPE 5 — LOT-TX-F12-SHADOWS (AUTO-DELTA — 3 substitutions)
──────────────────────────────────────────────────────────
Fichier : public/css/transactions.css

  L179  :
    Avant : box-shadow: 0 4px 12px rgba(124, 58, 237, 0.28);
    Après : box-shadow: 0 4px 12px color-mix(in srgb, var(--bx-app-accent) 28%, transparent);

  L621  :
    Avant : box-shadow: 0 4px 12px rgba(124,58,237,0.28);
    Après : box-shadow: 0 4px 12px color-mix(in srgb, var(--bx-app-accent) 28%, transparent);

  L1053 :
    Avant : box-shadow: 0 2px 8px rgba(124, 58, 237, 0.30);
    Après : box-shadow: 0 2px 8px color-mix(in srgb, var(--bx-app-accent) 30%, transparent);

Vérification :
  grep -n "rgba(124" public/css/transactions.css
  → 0 résultat attendu. Si résultat → STOP.

Test :
  php -d memory_limit=1G bin/phpunit --no-coverage \
    tests/Domain/Transaction/ tests/Domain/Todo/
  → 0 failure. Si failure → STOP.

Commit :
  git add public/css/transactions.css
  git commit -m "refactor(transactions): tokenize accent rgba shadows using color-mix pattern"
  git push

──────────────────────────────────────────────────────────
ÉTAPE 6 — Vérification finale
──────────────────────────────────────────────────────────
Après les 5 commits :

a) Compter les raw values résiduelles :
   grep -c "rgba(124\|font-weight: [0-9]\|letter-spacing: 0\.07em\|#000\b" \
     public/css/transactions.css
   → 0 attendu.

b) Vérifier working tree propre (hors config/reference.php) :
   git status --short

c) Confirmer les 5 commits dans le log :
   git log --oneline -6

d) Mettre à jour le manifeste :
   Dans .claude/css-campaigns/transactions-css.md,
   changer le Statut de "PRÊTE À EXÉCUTION" en "EXÉCUTÉE — [date]"
   et ajouter un tableau des 5 lots avec statut DONE.
   git add .claude/css-campaigns/transactions-css.md
   git commit -m "chore(css-campaign): mark transactions-css campaign as executed"
   NE PAS POUSSER ce commit final — laisser Claude réaliser l'audit de clôture.
```

---

## Statut des lots

| Lot | Classification | Substitutions | Statut |
|-----|---------------|---------------|--------|
| LOT-TX-BLOQUANT | AUTO-DELTA-PREREQUIS | 1 | CLOSED — `aeec0c3` |
| LOT-TX-FW | AUTO | 16 | CLOSED — `cc3d175` |
| LOT-TX-EXACT | AUTO | 5 | CLOSED — `510dd5b` |
| LOT-TX-COLOR-MIX | AUTO | 1 | CLOSED — `465aa25` |
| LOT-TX-F12-SHADOWS | AUTO-DELTA | 3 | CLOSED — `23d9058` |
| **Total** | — | **26** | **CSS CLOSED — 2026-06-11** |

---

## Audit de clôture — AUDIT-CLOTURE-TRANSACTIONS-CSS — 2026-06-11

### État Git
HEAD : `23d90584b428d6d781f4745beb96884afd48451f` = origin/master
Working tree : propre après restore `config/reference.php`.

### Réconciliation des lots
| Lot | Hash | Diff | Substitutions | Tests |
|-----|------|------|---------------|-------|
| LOT-TX-BLOQUANT | aeec0c3 | 1+/1- | 1/1 | 68/221 PASS |
| LOT-TX-FW | cc3d175 | 16+/16- | 16/16 | 68/221 PASS |
| LOT-TX-EXACT | 510dd5b | 5+/5- | 5/5 | 68/221 PASS |
| LOT-TX-COLOR-MIX | 465aa25 | 1+/1- | 1/1 | 68/221 PASS |
| LOT-TX-F12-SHADOWS | 23d9058 | 3+/3- | 3/3 | 68/221 PASS |

Tests finaux : `--filter Transaction` 153/440 PASS · `--filter Todo` 19/75 PASS · `lint:twig` 8 fichiers OK · `lint:container` OK · `node --check` 5 JS OK · `git diff --check` PASS.

### Color-mix final (9 occurrences — 0 source brute)
L179, L621, L1053 (LOT-TX-F12-SHADOWS, `--bx-app-accent` 28/28/30%) · L1764-1765 (`--bx-app-accent` 10/22%) · L2099-2101 (`--bx-app-success` 15/30%) · L2105-2107 (`--bx-app-warning` 15/30%). Toutes conformes ADR-029.

### F12 résiduel (11 CONSERVER)
`#fff` ×6, `rgba(255,255,255,0.22)` ×1, DT collection ×3, SVG URI `%236B7280` ×1. Toutes justifiées.

### F13 résiduel
font-weight numérique : 0. --bx-fw-* : 44 usages. --bx-tracking-wide : 2. --bx-lh-normal : 1. --bx-fs-sm texte : 2. CONSERVER : icônes px, denses, line-heights intermédiaires, transitions, 128 !important (voir section corrigée).

### Correction !important
La description "intégralité dans le bloc L665-840" était inexacte. Réel : 4 catégories justifiées — voir section CONSERVER mise à jour. Aucun !important non justifié.

### Omission détectée dans AMEND
`window.txLibelles = {{ libellesJson|raw }};` à L10 de `_qualify_modal.html.twig` absent de la liste dettes. Ajouté dans section Dettes hors campagne.

### Verdicts
| Verdict | Résultat |
|---------|---------|
| TRANSACTIONS.CSS F12 STRICTEMENT CLÔTURÉ | **OUI** |
| TRANSACTIONS.CSS F13 STRICTEMENT CLÔTURÉ | **OUI** |
| TRANSACTIONS.CSS RAW VALUES NON JUSTIFIÉES | **0** |
| TRANSACTIONS.CSS FONCTIONNELLEMENT STABILISÉ | **OUI** |
| TRANSACTIONS.CSS FIGEABLE | **OUI** |
| ACTION-CENTER.CSS HORS CAMPAGNE ET STABLE | **OUI** |
| TEMPLATES TRANSACTIONS STRICTEMENT CLÔTURÉS | **NON** (dettes JS/style inline persistantes) |
| JAVASCRIPT TRANSACTIONS STRICTEMENT CLÔTURÉ | **NON** (4 inline styles persistants dans JS) |
| CAMPAGNE AUTONOME TRANSACTIONS VALIDÉE | **OUI** |

CAMPAGNE TRANSACTIONS CSS — CSS CLOSED DÉFINITIVEMENT — Date : 2026-06-11
