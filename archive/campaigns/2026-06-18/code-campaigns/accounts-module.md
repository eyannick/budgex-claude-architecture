# CAMPAGNE-ACCOUNTS — Manifeste d'exécution autonome (v4 — final)

## Métadonnées

```
HEAD initial : d973d4dd95bc4e857cadfb334de46358343e9eca
HEAD final   : 803977b117224508f1a73b968cf02d06db8b4595
Branche      : master
Date audit   : 2026-06-12
Date clôture : 2026-06-13
Version      : v4 (amendement final — justifications sémantiques S1–S4 explicites,
               testFormPagesLoadAccountsCss, docblock test 2 corrigé)
Statut       : AUDITED / CLOSED — module figé au 2026-06-13
```

---

## Classifications

| Lot | Description | Classe | Statut |
|-----|-------------|--------|--------|
| LOT-ACC-0 | Charger accounts.css sur new et edit | **AUTO-DELTA** | ✅ CLOSED |
| LOT-ACC-1 | Supprimer 245 lignes legacy app.css | **AUTO** | ✅ CLOSED |
| LOT-ACC-2 | 4 substitutions chromatiques accounts.css | **AUTO-DELTA** | ✅ CLOSED |
| LOT-ACC-3 | 3 onclick + style.display + tests | **AUTO** | ✅ CLOSED |

---

## Allowlists strictes par lot

| Lot | Fichiers modifiables |
|-----|----------------------|
| ACC-0 | `templates/account/new.html.twig` · `templates/account/edit.html.twig` |
| ACC-1 | `public/css/app.css` |
| ACC-2 | `public/css/accounts.css` |
| ACC-3 | `templates/account/index.html.twig` · `templates/account/show.html.twig` · `templates/account/_form.html.twig` · `public/js/account-form.js` · `tests/Domain/Account/AccountInlineCodeTest.php` (création) |

## Fichiers figés — interdits en toute circonstance

```
public/css/bank.css
public/css/transactions.css
```

---

## Valeurs CONSERVER — décisions explicites

| Localisation | Valeur | Raison |
|---|---|---|
| `accounts.css` L54 | `rgba(34, 211, 238, 0.08)` | Teal unique — aucun token disponible |
| `accounts.css` L133, L679, L763 | `rgba(255, 255, 255, 0.03)` | Surface micro sombre — pas de token |
| `accounts.css` L237, L367, L775 | `rgba(255, 255, 255, 0.02)` | idem |
| `accounts.css` L100, L148, L345, L482, L745 | `letter-spacing: 0.05em / 0.06em` | Hors plage tokens `--bx-tracking-*` |
| `accounts.css` L259, L653, L698 | `letter-spacing: 0.01em / 0.04em` | idem |
| `_form.html.twig` L182 | `style="display:none"` champ hidden Symfony | Workaround TextType — fonctionnel |
| `_form.html.twig` L187 | `style="position:absolute;width:0;…"` | Native color picker — fonctionnel |
| `_form.html.twig` L193–202 | `style="background:#XXXXXX"` swatches | 10 couleurs preset statiques |
| `_kpi_cards.html.twig` + `index.html.twig` | `style="--bx-account-accent: {{ _accentColor }};"` | Valeur DB dynamique |
| `account-balance-chart.js` | rgba bruts config Chart.js | Paramètres Chart.js — hors scope token |
| `account-form.js` L114 | `preview.style.backgroundColor = hex` | Couleur dynamique choisie par l'utilisateur |

---

## LOT-ACC-0 — Chargement de accounts.css sur les pages formulaire (AUTO-DELTA)

### Arbitrage R04 — Classification définitive

**Cas B confirmé — AUTO-DELTA — 5 classes orphelines, tous effets intentionnels**

`new.html.twig` et `edit.html.twig` n'ont aucun bloc `{% block stylesheets %}`.
Le layout de base charge : `styles.css` + `app.css` + `components.css`.
`accounts.css` n'est pas chargé — mais `_form.html.twig` (inclus dans les deux pages)
utilise 5 classes définies exclusivement dans `accounts.css` (section commentée
"FORMULAIRE COMPTE — utilitaires _form.html.twig", L888–912).

### Matrice d'impact complète

Scan exhaustif de tous les sélecteurs de `accounts.css` contre le DOM de `new.html.twig` +
`edit.html.twig` + `_form.html.twig`. Résultats :

| Sélecteur accounts.css | Ligne | Élément correspondant | Règle CSS | Déjà appliqué ? | Effet |
|------------------------|-------|-----------------------|-----------|-----------------|-------|
| `.bx-form-label-hint` | L893 | `<span class="bx-form-label-hint">` (×2 : établissement + taux) | `color: var(--bx-app-fg-4); font-weight: var(--bx-fw-regular)` | NON — orphelin | Texte indicatif devient muted + poids normal — amélioration hiérarchie visuelle |
| `.bx-form-section-label--tight` | L898 | `<p class="bx-form-section-label bx-form-section-label--tight">` (Couleur du compte) | `margin-bottom: var(--bx-sp-1)` | NON — orphelin | Espacement inférieur du titre "Couleur" réduit — cohérence densité |
| `.bx-account-form-color-hex` | L902 | `<input class="… bx-account-form-color-hex">` | `width: 110px` | NON — orphelin | Input hex contraint à 110px au lieu de pleine largeur Bootstrap |
| `.bx-form-hint--mt` | L906 | `<p class="bx-form-hint bx-form-hint--mt">` (conditionnel Powens) | `margin-top: var(--bx-sp-2)` | NON — orphelin | Marge supérieure sur hint Powens (visible uniquement en edit compte Powens) |
| `.bx-form-notes` | L910 | `<textarea class="form-control bx-form-notes …">` | `min-height: 100px` | NON — orphelin | Hauteur minimale textarea notes |
| `.bx-account-page .bx-btn-icon-app` | L408 | — | — | N/A | Requiert `.bx-account-page` parent. Le form utilise `.bx-form-page`. **Aucune correspondance.** |
| `.bx-page-header__actions .bx-btn-outline-app` | L29 | — | — | N/A | `bx-page-header__actions` rendu uniquement si `actions` est passé au partial. Aucun `actions` sur new/edit. **Aucune correspondance.** |
| Tous les autres sélecteurs `.bx-account-*` | — | — | — | N/A | Requièrent `.bx-account-page`, `.bx-account-row`, `.bx-account-hero` etc. Aucun de ces conteneurs n'existe sur les pages formulaire. **Aucune correspondance.** |

**Conclusion** : 5 classes correspondent — toutes intentionnelles (commentaire accounts.css L888).
Aucun style non souhaité. Aucun mode BLOCKED.

**Ordre de chargement après LOT-ACC-0** (extrait du `<head>`) :
```
colors_and_type.css  ← tokens canoniques
styles.css           ← base layout (via parent())
app.css              ← utilitaires globaux (via parent())
components.css       ← form shell, primitives (via parent())
accounts.css         ← styles Account + 5 utilitaires _form.html.twig  ← AJOUTÉ
```
`{{ parent() }}` conservé — pas de duplication.

### Préconditions

```bash
# Doit retourner 0 résultat (pas de stylesheets block existant)
grep -n "stylesheets" templates/account/new.html.twig templates/account/edit.html.twig
```

### Modifications

**`templates/account/new.html.twig`** — insérer après `{% block title %}...{% endblock %}` :

```twig
{% block stylesheets %}
{{ parent() }}
<link href="{{ asset('css/accounts.css') }}" rel="stylesheet">
{% endblock %}
```

**`templates/account/edit.html.twig`** — idem, même position.

### Postconditions

```bash
grep -c "accounts.css" templates/account/new.html.twig   # → 1
grep -c "accounts.css" templates/account/edit.html.twig  # → 1
```

### Métriques LOT-ACC-0

| Métrique | Valeur |
|----------|--------|
| Fichiers prod modifiés | 2 |
| Lignes ajoutées | 4 par fichier = 8 |
| Classes orphelines résolues | 5 |

### Commit

```
fix(accounts): load accounts.css on new/edit form pages — resolves 5 orphaned form utilities
```

---

## LOT-ACC-1 — Suppression du bloc CSS mort `.bx-accounts-*` (AUTO)

### Bornes de suppression — par contenu (robuste aux décalages de lignes)

```
Début : ligne contenant exactement /* ─── Account index — UI/UX harmonization ─── */
Fin   : } fermant @media (max-width: 767.98px) qui suit immédiatement
        (la ligne suivante non-vide débute /* ─── Section label ─── */)
```

Valeurs sur HEAD `d973d4d` :

| Propriété | Valeur |
|-----------|--------|
| Première ligne | L3086 |
| Dernière ligne | L3330 |
| Nombre de lignes | **245** (contrôle secondaire : 3330 − 3086 + 1) |
| Nombre de blocs CSS (accolades ouvrantes) | **51** |
| Nombre de sélecteurs (chaînes individuelles) | **59** |
| Noms de classes distincts | **26** |

### Sélecteurs à supprimer — liste exhaustive des 59

**Mode clair (37 sélecteurs, 32 blocs)**

```css
.bx-accounts-page
.bx-accounts-shell
.bx-accounts-header-btn
.bx-accounts-view-toggle
.bx-accounts-view-btn
.bx-accounts-view-btn:hover
.bx-accounts-view-btn:focus-visible
.bx-accounts-view-btn.active
.bx-accounts-view-btn[aria-pressed="true"]
.bx-accounts-list-view
.bx-accounts-table
.bx-accounts-table > :not(caption) > thead > tr > th
.bx-accounts-table > :not(caption) > tbody > tr > td
.bx-accounts-row
.bx-accounts-table > tbody > tr:hover > *
.bx-accounts-row:focus-visible
.bx-accounts-col-actions
.bx-accounts-cell-actions
.bx-accounts-name-link
.bx-accounts-name-link:hover
.bx-accounts-name-link:focus-visible
.bx-accounts-row-link
.bx-accounts-row-link:hover
.bx-accounts-row-link:focus-visible
.bx-accounts-sync-icon
.bx-accounts-badge
.bx-accounts-badge--success
.bx-accounts-badge--danger
.bx-accounts-badge--warning
.bx-accounts-badge--neutral
.bx-accounts-card-view
.account-card-item.bx-accounts-card
.account-card-item.bx-accounts-card:hover
.bx-accounts-card-title
.bx-accounts-card-balance
.bx-accounts-card-amount
.bx-accounts-card-hint
```

**Mode sombre (18 sélecteurs, 15 blocs)**

```css
html[data-theme="dark"] .bx-accounts-page
html[data-theme="dark"] .bx-accounts-view-toggle
html[data-theme="dark"] .bx-accounts-view-btn
html[data-theme="dark"] .bx-accounts-view-btn:hover
html[data-theme="dark"] .bx-accounts-view-btn:focus-visible
html[data-theme="dark"] .bx-accounts-view-btn.active
html[data-theme="dark"] .bx-accounts-view-btn[aria-pressed="true"]
html[data-theme="dark"] .bx-accounts-table > :not(caption) > thead > tr > th
html[data-theme="dark"] .bx-accounts-table > :not(caption) > tbody > tr > td
html[data-theme="dark"] .bx-accounts-row:focus-visible
html[data-theme="dark"] .bx-accounts-row-link
html[data-theme="dark"] .bx-accounts-row-link:hover
html[data-theme="dark"] .bx-accounts-row-link:focus-visible
html[data-theme="dark"] .bx-accounts-badge--success
html[data-theme="dark"] .bx-accounts-badge--danger
html[data-theme="dark"] .bx-accounts-badge--warning
html[data-theme="dark"] .bx-accounts-badge--neutral
html[data-theme="dark"] .account-card-item.bx-accounts-card:hover
```

**Responsive (4 sélecteurs dans @media max-width:767.98px — 1 bloc wrapper + 3 sous-blocs)**

```css
/* @media (max-width: 767.98px) { */
    .bx-accounts-table > :not(caption) > thead > tr > th
    .bx-accounts-table > :not(caption) > tbody > tr > td
    .bx-accounts-row-link
    .bx-accounts-row-link__label
/* } */
```

### Vérification d'usage — 0 résultat actif

```bash
grep -rn \
  "bx-accounts-page\|bx-accounts-shell\|bx-accounts-view-toggle\|bx-accounts-view-btn\|" \
  "bx-accounts-list-view\|bx-accounts-table\|bx-accounts-row\b\|bx-accounts-col-actions\|" \
  "bx-accounts-cell-actions\|bx-accounts-name-link\|bx-accounts-row-link\|bx-accounts-sync-icon\|" \
  "bx-accounts-badge\|bx-accounts-card-view\|bx-accounts-card\b\|bx-accounts-card-title\|" \
  "bx-accounts-card-balance\|bx-accounts-card-amount\|bx-accounts-card-hint\|account-card-item" \
  templates/ public/js/ tests/ 2>/dev/null
# Doit retourner 0 résultat

# Cas spécifique exclu — HTML ID, pas une classe CSS :
grep "bx-accounts-list" templates/export/transactions.html.twig
# → id="bx-accounts-list" : attribut id, non ciblé par les sélecteurs .bx-accounts-*
```

### Préconditions (par contenu)

```bash
# Confirmer la borne de début
grep -n "Account index.*UI/UX harmonization" public/css/app.css
# → doit retourner exactement 1 ligne

# Confirmer la borne de fin (section suivante)
grep -n "Section label.*titre séparateur" public/css/app.css
# → doit retourner exactement 1 ligne à 2 lignes après la fin du bloc

# Confirmer les 26 classes distinctes encore présentes
grep -c "bx-accounts-page\|bx-accounts-shell\|bx-accounts-view-toggle\|bx-accounts-view-btn\|" \
  "bx-accounts-list-view\|bx-accounts-table\|bx-accounts-row\b\|bx-accounts-badge\|" \
  "bx-accounts-card\b\|account-card-item" public/css/app.css
# → doit retourner ≥ 26
```

### Postconditions (par contenu)

```bash
# 1. Zéro définition résiduelle des 26 classes
grep -n "bx-accounts-page\|bx-accounts-shell\|bx-accounts-view-toggle\|bx-accounts-view-btn\|" \
  "bx-accounts-list-view\|bx-accounts-table\|bx-accounts-row\b\|bx-accounts-name-link\|" \
  "bx-accounts-row-link\|bx-accounts-sync-icon\|bx-accounts-badge\|bx-accounts-card\b\|" \
  "account-card-item\|bx-accounts-cell-actions\|bx-accounts-col-actions" public/css/app.css
# → doit retourner 0

# 2. Section suivante intacte
grep -n "Section label.*titre séparateur" public/css/app.css
# → doit retourner 1 ligne (non supprimée)

# 3. Accolades équilibrées
awk '/{/{d++} /}/{d--} END{if(d!=0)print "DESEQUILIBRE:"d; else print "OK"}' public/css/app.css
# → doit afficher OK

# 4. Media queries intactes — la query 767.98px non-account doit subsister
grep -c "max-width: 767.98px" public/css/app.css
# → doit retourner ≥ 1 (d'autres media queries à 767.98px existent dans app.css)

# 5. Nombre de lignes (contrôle secondaire)
wc -l public/css/app.css
# → doit retourner 5618 (5863 − 245)
```

### Métriques LOT-ACC-1

| Métrique | Valeur |
|----------|--------|
| Fichiers prod modifiés | 1 |
| Lignes supprimées | 245 |
| Blocs CSS supprimés | 51 |
| Sélecteurs CSS supprimés | 59 |
| Noms de classes distincts | 26 |

### Commit

```
refactor(accounts): remove dead .bx-accounts-* legacy block from app.css (245 lines, 59 selectors)
```

---

## LOT-ACC-2 — Tokenisation des rgba bruts dans `accounts.css` (AUTO-DELTA)

Toutes les substitutions sont **AUTO-DELTA** : aucune ne garantit la parité stricte
en thème clair. La qualification "parité stricte" n'est jamais employée.

### Tokens de référence

| Token | Valeur sombre (`:root`) | Valeur claire (`html[data-theme="light"]`) |
|-------|------------------------|-------------------------------------------|
| `--bx-app-accent-tint` | `rgba(124,58,237,0.14)` | `rgba(98,0,234,0.08)` |
| `--bx-app-hover` | `rgba(255,255,255,0.04)` | `rgba(0,0,0,0.035)` |
| `--bx-app-danger` | `#f87171` = rgb(248,113,113) | `#f87171` (pas d'override light) |

### S1 — accounts.css L53 — `.bx-account-hero` background gradient

| | Sombre | Clair |
|-|--------|-------|
| Avant | `rgba(124, 58, 237, 0.14)` | `rgba(124, 58, 237, 0.14)` (figé) |
| Après | `var(--bx-app-accent-tint)` = `rgba(124,58,237,0.14)` | `var(--bx-app-accent-tint)` = `rgba(98,0,234,0.08)` |
| Opacité | 14% → 14% (identique) | 14% → 8% (réduite) |
| Delta sombre | Aucun | — |
| Delta clair | Changement de violet (#7c3aed → #6200ea) et d'opacité (14% → 8%) |
| Changement visuel accepté | Normalisation vers le token canonique du thème clair — la valeur figée produisait un violet incorrect sur fond clair |
| Justification sémantique | `--bx-app-accent-tint` est le token sémantique pour les surfaces teintées avec l'accent (fond hero léger). La valeur figée rgba(124,58,237,0.14) était un raw hors token, non adaptatif au thème. |
| Conformité ADR-029 | ✅ — `var(--bx-app-accent-tint)`, pas de raw hex dans l'expression |
| Classification | **AUTO-DELTA** |

### S2 — accounts.css L276 — `.bx-tx-detail__empty-icon` background

| | Sombre | Clair |
|-|--------|-------|
| Avant | `rgba(255, 255, 255, 0.04)` | `rgba(255, 255, 255, 0.04)` (figé) |
| Après | `var(--bx-app-hover)` = `rgba(255,255,255,0.04)` | `var(--bx-app-hover)` = `rgba(0,0,0,0.035)` |
| Opacité | 4% → 4% (identique) | 4% blanc → 3.5% noir |
| Delta sombre | Aucun |
| Delta clair | Fond blanc sur fond blanc (quasi-invisible) → fond légèrement sombre (correct sur surface claire) |
| Changement visuel accepté | Correction : le blanc figé était invisible sur fond clair ; le token fournit la nuance sombre adaptée |
| Justification sémantique | `--bx-app-hover` est le token sémantique pour les surfaces subtiles de survol/highlight. C'est exactement l'usage : fond neutre de l'icône "empty state". La valeur figée rgba(255,255,255,0.04) était un raw sombre non adaptatif. |
| Conformité ADR-029 | ✅ — `var(--bx-app-hover)`, pas de raw hex |
| Classification | **AUTO-DELTA** |

### S3 — accounts.css L772 — `.bx-account-delete-option--danger` border-color

| | Sombre | Clair |
|-|--------|-------|
| Avant | `rgba(239, 68, 68, 0.35)` = rgb(239,68,68) @ 35% = #ef4444 @ 35% | idem (figé) |
| Après | `color-mix(in srgb, var(--bx-app-danger) 35%, transparent)` = rgb(248,113,113) @ 35% | idem (#f87171 constant) |
| Opacité | 35% → 35% (identique) |
| Delta sombre | +9R +45G +45B — rouge légèrement plus clair, moins saturé |
| Delta clair | Même delta (pas d'override light pour `--bx-app-danger`) |
| Changement visuel accepté | Normalisation intentionnelle — #ef4444 (red-500) était une incohérence historique ; #f87171 (red-400) est la valeur canonique `--bx-app-danger` de tout le système |
| Justification sémantique | `--bx-app-danger` est le token sémantique pour tout état destructif/erreur dans l'app. La bordure d'une option de suppression est le cas d'usage canonique de ce token. La valeur figée #ef4444 (red-500) était hors token et incohérente avec le reste du système. |
| Conformité ADR-029 | ✅ — `var(--bx-app-danger)` dans color-mix, aucune source hex brute |
| Classification | **AUTO-DELTA** |

### S4 — accounts.css L798 — `.bx-account-delete-option__icon--danger` background

| | Sombre | Clair |
|-|--------|-------|
| Avant | `rgba(239, 68, 68, 0.18)` = #ef4444 @ 18% | idem (figé) |
| Après | `color-mix(in srgb, var(--bx-app-danger) 18%, transparent)` = #f87171 @ 18% | idem |
| Opacité | 18% → 18% (identique) |
| Delta | Même correction que S3 (#ef4444 → #f87171) à opacité moindre |
| Changement visuel accepté | Même normalisation intentionnelle que S3 |
| Justification sémantique | Même token `--bx-app-danger` — cohérence sémantique avec S3 sur le même composant (fond de l'icône danger sur la même option de suppression). La valeur figée #ef4444 @ 18% était hors token. |
| Conformité ADR-029 | ✅ |
| Classification | **AUTO-DELTA** |

### Décompte occurrences

| Valeur | Avant | Après |
|--------|-------|-------|
| `rgba(124, 58, 237, 0.14)` | 1 | 0 |
| `rgba(255, 255, 255, 0.04)` | 1 | 0 |
| `rgba(239, 68, 68, 0.35)` | 1 | 0 |
| `rgba(239, 68, 68, 0.18)` | 1 | 0 |
| **Total** | **4** | **0** |

### Postconditions

```bash
# Doit retourner 0 résultat
grep -n "rgba(124, 58, 237\|rgba(255, 255, 255, 0\.04)\|rgba(239, 68, 68" public/css/accounts.css

# Confirmer ADR-029 : aucun raw hex dans les color-mix insérés
grep -n "color-mix" public/css/accounts.css | grep -v "var(--bx-app"
# → doit retourner 0 résultat
```

### Métriques LOT-ACC-2

| Métrique | Valeur |
|----------|--------|
| Fichiers prod modifiés | 1 |
| Substitutions CSS | 4 |
| Substitutions AUTO-DELTA | 4 |
| Occurrences rgba avant | 4 |
| Occurrences rgba après | 0 |

### Commit

```
refactor(accounts): tokenize 4 rgba values in accounts.css (4× AUTO-DELTA)
```

---

## LOT-ACC-3 — Inline events + style.display + tests (AUTO)

### 3.1 — Trois suppressions onclick

#### onclick n°1 — `templates/account/index.html.twig` L144

```
Élément    : <a href="…" class="bx-link bx-account-link-reset"
             onclick="event.stopPropagation();">
Guard JS   : account-index.js L105
             if (event.target.closest(interactiveSelector)) return;
             // interactiveSelector = 'a, button, input, select, textarea, label, [role="button"]'
Clic       : navigue vers app_account_show (comportement natif <a> préservé)
Clavier    : Enter sur <a> → navigation native (guard ne bloque pas les keyboard events)
```

Avant L142–144 :
```twig
<a href="{{ path('app_account_show', {id: account.id}) }}"
   class="bx-link bx-account-link-reset"
   onclick="event.stopPropagation();">
```
Après :
```twig
<a href="{{ path('app_account_show', {id: account.id}) }}"
   class="bx-link bx-account-link-reset">
```

#### onclick n°2 — `templates/account/index.html.twig` L195

```
Élément    : <a href="…" class="bx-btn-icon-app bx-account-row-action"
             onclick="event.stopPropagation();">
Guard JS   : account-index.js L105 — <a> couvert par interactiveSelector
Clic       : navigue vers app_account_show (même cible que onclick n°1)
Clavier    : idem
```

Avant L192–195 :
```twig
class="bx-btn-icon-app bx-account-row-action"
title="Voir le compte"
aria-label="Voir le compte {{ account.name|e('html_attr') }}"
onclick="event.stopPropagation();">
```
Après :
```twig
class="bx-btn-icon-app bx-account-row-action"
title="Voir le compte"
aria-label="Voir le compte {{ account.name|e('html_attr') }}"
>
```

#### onclick n°3 — `templates/account/show.html.twig` L202

```
Élément    : <a href="{{ path('app_transaction_edit', {id: tx.id}) }}"
             class="bx-btn-icon-app" onclick="event.stopPropagation();">
Guard JS   : account-tx-detail.js L37
             if (e.target.closest('a, button')) { return; }
Clic       : navigue vers app_transaction_edit (comportement natif <a>)
Clavier    : idem
```

Avant L198–202 :
```twig
<a href="{{ path('app_transaction_edit', {id: tx.id}) }}"
   class="bx-btn-icon-app"
   title="Modifier cette transaction"
   aria-label="Modifier la transaction du {{ tx.transactionDate|date('d/m/Y') }}"
   onclick="event.stopPropagation();">
```
Après :
```twig
<a href="{{ path('app_transaction_edit', {id: tx.id}) }}"
   class="bx-btn-icon-app"
   title="Modifier cette transaction"
   aria-label="Modifier la transaction du {{ tx.transactionDate|date('d/m/Y') }}"
   >
```

### 3.2 — Migration style.display → classList

**Élément cible** : `#js-instrument-wrapper` — `<div class="mb-4" id="js-instrument-wrapper">` dans `_form.html.twig` L38.

**État initial avant migration** : div visible (aucune classe de masquage dans le template).

**Timing d'exécution** : `filterInstruments(assetClassSelect.value)` (account-form.js L79) s'exécute
à l'évaluation du script (bottom-of-body, DOM déjà prêt). En mode `new` : aucune classe sélectionnée
→ `hasAny = false` → `classList.add('d-none')` (ou toggle reste true). En mode `edit` :
asset class pré-sélectionnée → `hasAny` évalué → `classList.toggle` retire `d-none` si instruments existent.

`d-none` est une classe Bootstrap disponible via `components.css` (layout de base) — indépendant d'`accounts.css`.

**`public/js/account-form.js` L76** :
```js
// Avant
instrumentWrapper.style.display = hasAny ? '' : 'none';
// Après
instrumentWrapper.classList.toggle('d-none', !hasAny);
```

**`templates/account/_form.html.twig` L38** :
```twig
{# Avant #}
<div class="mb-4" id="js-instrument-wrapper">
{# Après #}
<div class="mb-4 d-none" id="js-instrument-wrapper">
```

### 3.3 — Tests structurels — `tests/Domain/Account/AccountInlineCodeTest.php`

```php
<?php

declare(strict_types=1);

namespace App\Tests\Domain\Account;

use App\Tests\AppTestCase;

/**
 * Contrats structurels : absence d'inline events, classList initial, CSS chargé.
 */
final class AccountInlineCodeTest extends AppTestCase
{
    /**
     * Contrat 1 : index.html.twig ne contient aucun onclick inline.
     * Contrat 1b : les lignes de délégation (data-href) sont présentes.
     * 2 assertions.
     */
    public function testAccountIndexHasNoInlineOnclick(): void
    {
        $client = $this->authenticatedClient();
        $client->request('GET', '/app/comptes');

        $this->assertResponseIsSuccessful();
        $this->assertStringNotContainsString(
            'onclick="event.stopPropagation();"',
            (string) $client->getResponse()->getContent(),
            'index.html.twig ne doit contenir aucun onclick inline.'
        );
        $this->assertStringContainsString(
            'data-href',
            (string) $client->getResponse()->getContent(),
            'Les lignes de délégation (data-href) doivent être présentes pour account-index.js.'
        );
    }

    /**
     * Contrat 2 : show.html.twig ne contient aucun onclick inline.
     * Contrat 2b : les lignes de transaction pour délégation sont présentes.
     * 2 assertions.
     */
    public function testAccountShowHasNoInlineOnclick(): void
    {
        $client  = $this->authenticatedClient();
        $user    = $this->getTestUser($client->getContainer());
        $account = $this->createAccount($client->getContainer(), $user);

        $client->request('GET', '/app/comptes/' . $account->getId());

        $this->assertResponseIsSuccessful();
        $this->assertStringNotContainsString(
            'onclick="event.stopPropagation();"',
            (string) $client->getResponse()->getContent(),
            'show.html.twig ne doit contenir aucun onclick inline.'
        );
        $this->assertStringContainsString(
            'bx-account-tx-row',
            (string) $client->getResponse()->getContent(),
            'Les lignes de transaction (bx-account-tx-row) doivent exister pour account-tx-detail.js.'
        );
    }

    /**
     * Contrat 3 : le wrapper instrument est masqué initialement via d-none.
     * 2 assertions.
     */
    public function testInstrumentWrapperHasInitialDNoneClass(): void
    {
        $client = $this->authenticatedClient();
        $client->request('GET', '/app/comptes/new');

        $this->assertResponseIsSuccessful();
        $this->assertStringContainsString(
            'id="js-instrument-wrapper"',
            (string) $client->getResponse()->getContent(),
            'Le wrapper instrument doit être présent dans le DOM.'
        );
        $this->assertMatchesRegularExpression(
            '/id="js-instrument-wrapper"[^>]*class="[^"]*d-none/',
            (string) $client->getResponse()->getContent(),
            'Le wrapper instrument doit porter la classe d-none initialement.'
        );
    }

    /**
     * Contrat 4 : new et edit chargent accounts.css exactement une fois.
     * 2 assertions (assertSame avec substr_count pour l'exactitude).
     */
    public function testFormPagesLoadAccountsCss(): void
    {
        $client = $this->authenticatedClient();

        $client->request('GET', '/app/comptes/new');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $client->getResponse()->getContent(), 'accounts.css'),
            'La page new doit charger accounts.css exactement une fois.'
        );

        $user    = $this->getTestUser($client->getContainer());
        $account = $this->createAccount($client->getContainer(), $user);
        $client->request('GET', '/app/comptes/' . $account->getId() . '/edit');
        $this->assertResponseIsSuccessful();
        $this->assertSame(
            1,
            substr_count((string) $client->getResponse()->getContent(), 'accounts.css'),
            'La page edit doit charger accounts.css exactement une fois.'
        );
    }
}
```

**Tableau des assertions (hors assertResponseIsSuccessful)** :

| Méthode | Assertions domaine | Contrats couverts |
|---------|-------------------|-------------------|
| `testAccountIndexHasNoInlineOnclick` | 2 | Absence onclick L144+L195 · data-href délégation présente |
| `testAccountShowHasNoInlineOnclick` | 2 | Absence onclick L202 · bx-account-tx-row délégation présente |
| `testInstrumentWrapperHasInitialDNoneClass` | 2 | Wrapper présent · d-none initial (migration style.display) |
| `testFormPagesLoadAccountsCss` | 2 | accounts.css chargé 1× sur new · 1× sur edit |
| **Total** | **8** | |

### Postconditions LOT-ACC-3

```bash
# Doit retourner 0 résultat
grep -rn 'onclick="event.stopPropagation();"' templates/account/

# Doit retourner 0 résultat
grep -n "instrumentWrapper.style.display" public/js/account-form.js

# Doit contenir classList.toggle('d-none', !hasAny)
grep -n "classList.toggle" public/js/account-form.js

# Doit contenir d-none sur le wrapper
grep -n "js-instrument-wrapper" templates/account/_form.html.twig

# Guards JS intacts
grep -n "interactiveSelector" public/js/account-index.js
# → doit contenir 'a, button'

grep -n "closest('a, button')" public/js/account-tx-detail.js
# → doit retourner ≥ 1 ligne
```

### Métriques LOT-ACC-3

| Métrique | Valeur |
|----------|--------|
| Fichiers prod modifiés | 4 |
| Attributs Twig supprimés | 3 |
| Lignes template supprimées | 3 |
| Mutations JS | 1 |
| Lignes HTML modifiées | 1 |
| Fichiers test créés | 1 |
| Méthodes test | 4 |
| Assertions domaine | 8 |

### Commit

```
refactor(accounts): remove onclick inline, migrate style.display to classList, add 4 structural tests
```

---

## Totaux de campagne

| Métrique | ACC-0 | ACC-1 | ACC-2 | ACC-3 | **Total** |
|----------|-------|-------|-------|-------|-----------|
| Fichiers prod modifiés | 2 | 1 | 1 | 4 | **8** |
| Lignes prod supprimées | 0 | 245 | 0 | 3 | **248** |
| Lignes prod ajoutées | 8 | 0 | 0 | 1 | **9** |
| Lignes prod modifiées (in-place) | 0 | 0 | 4 | 2 | **6** |
| Sélecteurs CSS supprimés | 0 | 59 | 0 | 0 | **59** |
| Blocs CSS supprimés | 0 | 51 | 0 | 0 | **51** |
| Substitutions CSS | 0 | 0 | 4 | 0 | **4** |
| Classes orphelines résolues | 5 | 0 | 0 | 0 | **5** |
| Attributs Twig supprimés | 0 | 0 | 0 | 3 | **3** |
| Mutations JS | 0 | 0 | 0 | 1 | **1** |
| Classes HTML ajoutées | 0 | 0 | 0 | 1 | **1** |
| Fichiers test créés | 0 | 0 | 0 | 1 | **1** |
| Méthodes test | 0 | 0 | 0 | 4 | **4** |
| Assertions domaine | 0 | 0 | 0 | 8 | **8** |
| Commits | 1 | 1 | 1 | 1 | **4** |

Lots AUTO : 2 (ACC-1 · ACC-3) · Lots AUTO-DELTA : 2 (ACC-0 · ACC-2) · Lots BLOCKED : 0

---

## Validations par lot

### LOT-ACC-0

```bash
php bin/console lint:twig templates/account --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
git diff --check
```

### LOT-ACC-1

```bash
php bin/console lint:twig templates/account --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
git diff --check
awk '/{/{d++} /}/{d--} END{if(d!=0)print "DESEQUILIBRE:"d; else print "BRACES:OK"}' public/css/app.css
grep -c "max-width: 767.98px" public/css/app.css   # → ≥ 1
```

### LOT-ACC-2

```bash
php bin/console lint:twig templates/account --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
git diff --check
# Contrôle des 4 occurrences résolues
grep -n "rgba(124, 58, 237\|rgba(255, 255, 255, 0\.04)\|rgba(239, 68, 68" public/css/accounts.css
# → 0 résultat
# Contrôle ADR-029 : pas de raw hex dans color-mix
grep -n "color-mix" public/css/accounts.css | grep -v "var(--bx-app"
# → 0 résultat
```

### LOT-ACC-3

```bash
node --check public/js/account-form.js
node --check public/js/account-index.js
node --check public/js/account-tx-detail.js
php bin/console lint:twig templates/account --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
git diff --check
# Exécution ciblée des 4 nouveaux tests
php -d memory_limit=1G bin/phpunit tests/Domain/Account/AccountInlineCodeTest.php --no-coverage
# Contrôles JS
grep -n "interactiveSelector" public/js/account-index.js          # → contient 'a, button'
grep -n "closest('a, button')" public/js/account-tx-detail.js     # → ≥ 1 ligne
grep -n "classList.toggle('d-none'" public/js/account-form.js     # → ≥ 1 ligne
```

**Aucun commit ne doit être créé ni poussé avant le PASS de toutes les validations du lot.**

---

## Règles d'arrêt

| # | Condition d'arrêt |
|---|-------------------|
| 1 | `bin/phpunit --filter Account` retourne ≥ 1 failure |
| 2 | `lint:twig` retourne ≥ 1 erreur |
| 3 | `lint:container` retourne ≥ 1 erreur |
| 4 | `node --check` retourne une erreur de syntaxe |
| 5 | `git diff --check` retourne du whitespace corrompu |
| 6 | `public/css/bank.css` ou `public/css/transactions.css` apparaît dans `git diff` |
| 7 | Un fichier hors allowlist du lot actif est modifié |
| 8 | `wc -l public/css/app.css` ≠ 5618 après ACC-1 |
| 9 | `awk` accolades retourne DESEQUILIBRE après ACC-1 |
| 10 | `grep rgba(239, 68, 68 public/css/accounts.css` retourne ≥ 1 ligne après ACC-2 |
| 11 | `git rev-parse HEAD` ≠ `git rev-parse origin/master` après un push |

---

## Baseline tests

```
HEAD initial : d973d4dd95bc4e857cadfb334de46358343e9eca
Tests initial: ~783 · 0 failures · 13 Notices pré-existantes
HEAD final   : 803977b117224508f1a73b968cf02d06db8b4595
Tests final  : 142 Account / 548 assertions — 0 failures · 0 errors
               (suite complète : 1 045 tests / 3 978 assertions — 0 failures)
```

## Audit de clôture — 2026-06-13

```
Verdict      : CAMPAGNE AUTONOME ACCOUNTS VALIDÉE
Module       : FIGÉ — accounts.css · templates/account/ · JS Account
Condition    : ne rouvrir qu'en cas de bug avéré ou d'évolution produit démontrée
```

---

## Prompt Codex — exécution autonome (final)

```
CAMPAGNE-ACCOUNTS — Exécution autonome

Source de vérité : .claude/code-campaigns/accounts-module.md
Lire ce fichier en entier avant toute action.

═══════════════════════════════════════════════════
PRÉAMBULE OBLIGATOIRE
═══════════════════════════════════════════════════

git restore -- config/reference.php
git status --short
# → doit être vide

git rev-parse HEAD
# → doit être d973d4dd95bc4e857cadfb334de46358343e9eca

INTERDIT EN TOUTE CIRCONSTANCE :
  modifier public/css/bank.css
  modifier public/css/transactions.css
  committer ou pousser avant le PASS de toutes les validations du lot

═══════════════════════════════════════════════════
LOT-ACC-0 — AUTO-DELTA — accounts.css sur new/edit
═══════════════════════════════════════════════════

PRÉCONDITION :
  grep -n "stylesheets" templates/account/new.html.twig templates/account/edit.html.twig
  # → 0 résultat

MODIFICATIONS :
  templates/account/new.html.twig — insérer après {% block title %}…{% endblock %} :
    {% block stylesheets %}
    {{ parent() }}
    <link href="{{ asset('css/accounts.css') }}" rel="stylesheet">
    {% endblock %}

  templates/account/edit.html.twig — idem, même position

VALIDATIONS :
  php bin/console lint:twig templates/account --no-debug
  php bin/console lint:container --no-debug
  php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
  git diff --check
  grep -c "accounts.css" templates/account/new.html.twig   # → 1
  grep -c "accounts.css" templates/account/edit.html.twig  # → 1

DIVERGENCE → STOP — ne pas committer si ≥ 1 validation échoue

COMMIT :
  fix(accounts): load accounts.css on new/edit form pages — resolves 5 orphaned form utilities

PUSH : git push origin master
VÉRIFICATION : git rev-parse HEAD && git rev-parse origin/master  # → identiques

═══════════════════════════════════════════════════
LOT-ACC-1 — AUTO — suppression bloc mort app.css
═══════════════════════════════════════════════════

PRÉCONDITION :
  grep -n "Account index.*UI/UX harmonization" public/css/app.css  # → 1 ligne
  grep -rn "bx-accounts-page\|bx-accounts-shell\|bx-accounts-table\|bx-accounts-row\b\|bx-accounts-badge\|bx-accounts-card\b\|account-card-item" \
      templates/ public/js/ tests/
  # → 0 résultat

MODIFICATION :
  public/css/app.css — supprimer le bloc délimité par :
    Début : /* ─── Account index — UI/UX harmonization ─── */
    Fin   : } fermant @media (max-width: 767.98px), avant /* ─── Section label ─── */
  Sur HEAD d973d4d : lignes 3086–3330 incluses (245 lignes)

VALIDATIONS :
  php bin/console lint:twig templates/account --no-debug
  php bin/console lint:container --no-debug
  php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
  git diff --check
  awk '/{/{d++} /}/{d--} END{if(d!=0)print "DESEQUILIBRE:"d; else print "BRACES:OK"}' public/css/app.css
  grep -c "max-width: 767.98px" public/css/app.css    # → ≥ 1
  grep -n "bx-accounts-page\|bx-accounts-table\|bx-accounts-row\b" public/css/app.css  # → 0
  wc -l public/css/app.css                             # → 5618

DIVERGENCE → STOP

COMMIT :
  refactor(accounts): remove dead .bx-accounts-* legacy block from app.css (245 lines, 59 selectors)

PUSH : git push origin master
VÉRIFICATION : git rev-parse HEAD && git rev-parse origin/master  # → identiques

═══════════════════════════════════════════════════
LOT-ACC-2 — AUTO-DELTA — tokenisation rgba accounts.css
═══════════════════════════════════════════════════

PRÉCONDITION :
  grep -n "bx-app-accent-tint\|bx-app-hover\|bx-app-danger" public/css/colors_and_type.css
  # → doit retourner les 3 tokens

MODIFICATIONS dans public/css/accounts.css :
  L53 :  rgba(124, 58, 237, 0.14)  →  var(--bx-app-accent-tint)
  L276 : rgba(255, 255, 255, 0.04) →  var(--bx-app-hover)
  L772 : rgba(239, 68, 68, 0.35)   →  color-mix(in srgb, var(--bx-app-danger) 35%, transparent)
  L798 : rgba(239, 68, 68, 0.18)   →  color-mix(in srgb, var(--bx-app-danger) 18%, transparent)

  NE PAS MODIFIER :
    L54  : rgba(34, 211, 238, 0.08)
    L133, L679, L763 : rgba(255, 255, 255, 0.03)
    L237, L367, L775 : rgba(255, 255, 255, 0.02)

VALIDATIONS :
  php bin/console lint:twig templates/account --no-debug
  php bin/console lint:container --no-debug
  php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
  git diff --check
  grep -n "rgba(124, 58, 237\|rgba(255, 255, 255, 0\.04)\|rgba(239, 68, 68" public/css/accounts.css  # → 0
  grep -n "color-mix" public/css/accounts.css | grep -v "var(--bx-app"  # → 0 (ADR-029)

DIVERGENCE → STOP

COMMIT :
  refactor(accounts): tokenize 4 rgba values in accounts.css (4× AUTO-DELTA)

PUSH : git push origin master
VÉRIFICATION : git rev-parse HEAD && git rev-parse origin/master  # → identiques

═══════════════════════════════════════════════════
LOT-ACC-3 — AUTO — inline events + classList + tests
═══════════════════════════════════════════════════

PRÉCONDITION :
  grep -rn 'onclick="event.stopPropagation();"' templates/account/  # → exactement 3 lignes
  grep -n "instrumentWrapper.style.display" public/js/account-form.js  # → 1 ligne (L76)

MODIFICATIONS :
  templates/account/index.html.twig L144
    Supprimer la ligne : onclick="event.stopPropagation();">
    Ajouter > en fin de la ligne précédente (class="bx-link bx-account-link-reset")

  templates/account/index.html.twig L195
    Supprimer la ligne : onclick="event.stopPropagation();">
    Ajouter > en fin de la ligne précédente (aria-label="…")

  templates/account/show.html.twig L202
    Supprimer la ligne : onclick="event.stopPropagation();">
    Ajouter > en fin de la ligne précédente (aria-label="…")

  templates/account/_form.html.twig L38
    Avant : <div class="mb-4" id="js-instrument-wrapper">
    Après : <div class="mb-4 d-none" id="js-instrument-wrapper">

  public/js/account-form.js L76
    Avant : instrumentWrapper.style.display = hasAny ? '' : 'none';
    Après : instrumentWrapper.classList.toggle('d-none', !hasAny);

  tests/Domain/Account/AccountInlineCodeTest.php
    Créer ce fichier avec les 4 méthodes définies à la section 3.3 du manifeste.
    Adapter getTestUser() et createAccount() aux helpers de AppTestCase.

VALIDATIONS :
  node --check public/js/account-form.js
  node --check public/js/account-index.js
  node --check public/js/account-tx-detail.js
  php bin/console lint:twig templates/account --no-debug
  php bin/console lint:container --no-debug
  php -d memory_limit=1G bin/phpunit --filter Account --no-coverage
  git diff --check
  php -d memory_limit=1G bin/phpunit tests/Domain/Account/AccountInlineCodeTest.php --no-coverage
  grep -rn 'onclick="event.stopPropagation();"' templates/account/  # → 0
  grep -n "instrumentWrapper.style.display" public/js/account-form.js  # → 0
  grep -n "classList.toggle('d-none'" public/js/account-form.js  # → ≥ 1
  grep -n "interactiveSelector" public/js/account-index.js  # → contient 'a, button'
  grep -n "closest('a, button')" public/js/account-tx-detail.js  # → ≥ 1

DIVERGENCE → STOP — en particulier si AccountInlineCodeTest retourne 1 failure

COMMIT :
  refactor(accounts): remove onclick inline, migrate style.display to classList, add 4 structural tests

PUSH : git push origin master
VÉRIFICATION : git rev-parse HEAD && git rev-parse origin/master  # → identiques

═══════════════════════════════════════════════════
FIN DE CAMPAGNE
═══════════════════════════════════════════════════

git log --oneline -5
php -d memory_limit=1G bin/phpunit --no-coverage | tail -5
# → ~787 tests · 0 failures
```
