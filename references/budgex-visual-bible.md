---
Statut : Source de référence design Budgex V1
Rôle : doctrine visuelle et UX/UI
Source technique des tokens : `public/css/colors_and_type.css` · `public/css/components.css`
Ne pas créer de nouveaux tokens sans décision explicite
Origine : Bible Visuelle Budgex.html — Claude Design · 2026-05
---

# Bible Visuelle Budgex — V1

**Version :** V1 · 2026.05
**Statut :** Source de vérité
**Source tokens :** `public/css/colors_and_type.css`
**Source composants :** `public/css/components.css`
**Thème :** Dark-first (light = opt-in)

Document de référence à partir duquel toute nouvelle page Budgex doit être conçue. L'objectif n'est pas de redéfinir l'identité existante mais de la stabiliser : tokens, layout, composants, règles de tableaux, de graphes et d'alertes — tels qu'ils existent déjà dans `colors_and_type.css` et `components.css`. Tout écart par rapport à ce document doit être justifié et tracé.

---

## Sommaire

1. Vision visuelle générale
2. Principes directeurs
3. Palette officielle & tokens
4. Typographie
5. Layouts standards
6. Composants UI
7. Règles pour les graphiques
8. Règles pour les tableaux
9. Règles pour les alertes & toasts
10. Règles responsive
11. Do / Don't
12. Checklist de validation
13. Recommandations d'intégration code
14. Points à harmoniser dans les captures actuelles
- Annexe A — Archétypes de pages
- **Annexe B — Points à arbitrer avant intégration** ← incohérences identifiées entre la bible et le code réel

---

## 1. Vision visuelle générale

Budgex est un SaaS de finances personnelles, dark-first, sobre, dense mais respiré. L'expérience doit donner le sentiment d'un outil patrimonial premium, pas d'un back-office comptable.

### Ce que Budgex EST

- Un produit sombre, posé, lisible immédiatement.
- Une lecture qui démarre par le résumé patrimonial, puis descend dans le détail.
- Un usage clavier-friendly, dense, mais jamais saturé.
- Une palette neutre froide ponctuée d'un violet de marque et d'accents sémantiques précis.
- Une typographie hiérarchisée : titres forts, libellés techniques en majuscules, chiffres en chasse fixe.

### Ce que Budgex N'EST PAS

- Un tableau Excel déguisé.
- Un dashboard générique violet-bleu-gradient.
- Un back-office ERP avec 14 colonnes par défaut.
- Un template Bootstrap brut (cartes blanches, ombres molles, badges multicolores).
- Un terrain d'expérimentation pour chaque page (chaque page hérite des patterns définis ici).

### Référentiel d'inspiration

L'esprit visuel se situe dans la lignée des fintechs patrimoniales modernes (Finary, Origin, Copilot). Aucune copie directe. Le marqueur Budgex est : **violet de marque + accents cyan/verts/oranges/rouges sur surfaces bleu nuit**, avec une rigueur typographique forte.

---

## 2. Principes directeurs

Sept principes qui priment sur toute préférence locale.

| # | Principe | Règle |
|---|---|---|
| 01 | **Sobriété** | Une seule couleur de marque (violet). Les couleurs accent ne sortent que pour porter une information. |
| 02 | **Hiérarchie** | Chaque page démarre par un résumé (hero, KPI, alerte). Le détail vient ensuite, jamais avant. |
| 03 | **Lecture rapide** | Les montants sont en chasse fixe tabulaire. Les libellés techniques sont en uppercase légère. |
| 04 | **Cohérence** | Même usage = même composant. Pas de variant local non documenté. |
| 05 | **Densité maîtrisée** | Pages denses, mais aérées par `--bx-sp-5` (24 px) entre sections et `--bx-sp-6` (32 px) entre blocs majeurs. |
| 06 | **Couleur = sens** | Vert = revenu/actif/succès · Rouge/rose = dépense/danger · Orange = warning · Cyan = info/action secondaire · Violet = marque/sélection. |
| 07 | **États systématiques** | Chaque composant a un état vide, loading, erreur, et données partielles. |

---

## 3. Palette officielle & tokens

La palette ci-dessous reflète exactement `--bx-app-*` tel que défini dans le code. Aucune nouvelle teinte n'est créée pour V1. Toute consommation se fait via le token, jamais via la valeur hexadécimale.

### A · Surfaces (backgrounds)

| Token | Valeur CSS | Rôle |
|---|---|---|
| `--bx-app-bg` | `#0f1320` | Fond global de l'application, `<body>` et zone de contenu principale. |
| `--bx-app-chrome` | `#0b0f1a` | Topbar, sidebar, footer. Le « chrome » contour de l'app. |
| `--bx-app-surface` | `#1a2030` | Card principale, page header flush, panneaux KPI. |
| `--bx-app-surface-2` | `#222a3d` | Sub-cards, dropdowns, lignes de tableau hover, header tableau. |
| `--bx-app-inset` | `#0b0f1a` | Inputs, wells, intérieur des barres de progression. |
| `--bx-app-hover` | `rgba(255,255,255,0.04)` | Overlay hover universel sur boutons ghost / lignes / icônes. |

### B · Bordures

| Token | Valeur CSS | Rôle |
|---|---|---|
| `--bx-app-border` | `rgba(255,255,255,0.08)` | Bordure standard cards, séparateurs. |
| `--bx-app-border-2` | `rgba(255,255,255,0.14)` | Bordure outline button, dropdown actif, focus visible. |
| Accent active | `#7c3aed` (via `--bx-app-accent`) | Indicateur d'item actif sidebar (bordure gauche 3 px). |
| `--bx-app-focus-ring` | `rgba(167,139,250,0.35)` | Outline focus visible 2 px, offset 1 px. |

### C · Textes

| Token | Valeur CSS | Rôle |
|---|---|---|
| `--bx-app-fg` | `#f8fafc` | Titres, montants, texte principal. |
| `--bx-app-fg-2` | `#cbd5e1` | Sous-titres, corps de texte, valeurs secondaires. |
| `--bx-app-fg-3` | `#94a3b8` | Captions, labels uppercase, headers tableau. |
| `--bx-app-fg-4` | `rgba(255,255,255,0.45)` | Placeholder, métadonnées très discrètes, état « à venir ». |

### D · Couleurs fonctionnelles & sémantiques

| Token | Valeur CSS | Rôle |
|---|---|---|
| `--bx-app-accent` | `#7c3aed` | Brand, CTA primaire, sélection |
| `--bx-app-accent-hover` | `#8b5cf6` | Hover sur primary |
| `--bx-app-accent-on` | `#a78bfa` | Texte/liens accent sur fond sombre |
| `--bx-app-info` | `#22d3ee` | Information, action secondaire |
| `--bx-app-success` | `#22c55e` | Revenus, soldes positifs, états valides |
| `--bx-app-warning` | `#fbbf24` | Épargne en cours, alertes d'attention |
| `--bx-app-danger` | `#f87171` | Dépenses, soldes négatifs, suppression |

**Règle d'usage** : chaque couleur sémantique dispose d'un tint à 14–16 % d'opacité — `--bx-app-{*}-tint` — utilisé pour le fond d'alertes, de pills et de cellules de tableau. Le full color est réservé aux icônes, bordures et chiffres-clés.

| Token tint | Valeur CSS |
|---|---|
| `--bx-app-accent-tint` | `rgba(124,58,237,0.14)` |
| `--bx-app-accent-tint-2` | `rgba(124,58,237,0.22)` |
| `--bx-app-success-tint` | `rgba(34,197,94,0.14)` |
| `--bx-app-danger-tint` | `rgba(248,113,113,0.14)` |
| `--bx-app-warning-tint` | `rgba(251,191,36,0.16)` |
| `--bx-app-info-tint` | `rgba(34,211,238,0.14)` |

### E · Sémantique financière (mapping non négociable)

| Famille | Token | Usage |
|---|---|---|
| Revenus / actifs / succès | `--bx-app-success` | Encaissements, valeur d'actif, soldes positifs, état actif, « dans le budget ». |
| Dépenses / dettes / danger | `--bx-app-danger` | Décaissements, passifs, soldes négatifs, dépassement de budget, suppression. |
| Épargne / objectif / warning | `--bx-app-warning` | Épargne en cours, objectif partiellement atteint, alertes d'attention. Jamais succès. |
| Patrimoine / marque / sélection | `--bx-app-accent` | Card hero patrimoine, item actif, eyebrow, CTA principal. Pas pour un chiffre brut. |
| Info / placements / action sec. | `--bx-app-info` | Lien de détail, badge « placement », alertes informatives, pulse live. |
| Inactif / exclu / à venir | `--bx-app-fg-3` / `--bx-app-fg-4` | Comptes désactivés, lignes exclues, « bientôt disponibles ». Pill pointillée. |

### F · Espacements & rayons

**Échelle d'espacement (`--bx-sp-*`) — valeurs en rem, équivalent px indicatif**

| Token | Valeur CSS | ~px |
|---|---|---|
| `--bx-sp-1` | `0.25rem` | 4 px |
| `--bx-sp-2` | `0.5rem` | 8 px |
| `--bx-sp-3` | `0.75rem` | 12 px |
| `--bx-sp-4` | `1rem` | 16 px |
| `--bx-sp-5` | `1.5rem` | 24 px |
| `--bx-sp-6` | `2rem` | 32 px |
| `--bx-sp-7` | `2.5rem` | 40 px |
| `--bx-sp-8` | `3rem` | 48 px |
| `--bx-sp-9` | `4rem` | 64 px |
| `--bx-sp-10` | `5.5rem` | 88 px |

**Échelle de rayons**

| Token | Valeur CSS | ~px | Usage |
|---|---|---|---|
| `--bx-radius-sm` | `0.4rem` | ~6 px | pills, chips |
| `--bx-radius` | `0.5rem` | 8 px | inputs |
| `--bx-radius-md` | `0.625rem` | 10 px | boutons |
| `--bx-radius-lg` | `0.875rem` | 14 px | cards standard |
| `--bx-radius-xl` | `1rem` | 16 px | hero patrimoine (⚠ voir Annexe B) |
| `--bx-radius-2xl` | `1.25rem` | 20 px | réservé |
| `--bx-radius-pill` | `100px` | — | counters, pills |

### G · Élévations

Tokens d'élévation définis dans le CSS — à consommer, jamais à redéfinir en local.

| Token | Usage |
|---|---|
| `--bx-app-elev-sm` | Ombre légère (cards secondaires, drawers) |
| `--bx-app-elev` | Ombre standard (cards principales) |
| `--bx-app-elev-lg` | Ombre forte (modals, dropdowns) |

---

## 4. Typographie

Une famille principale (Roboto) et une mono (Roboto Mono) pour les libellés techniques et les chiffres financiers. **Pas de troisième famille.**

| Spec | Valeur |
|---|---|
| Family sans | `"Roboto", system-ui, -apple-system, "Segoe UI", "Helvetica Neue", Arial, sans-serif` |
| Family mono | `"Roboto Mono", SFMono-Regular, Menlo, Monaco, Consolas, monospace` |
| Chiffres financiers | Roboto Mono **ou** Roboto sans + `font-variant-numeric: tabular-nums` obligatoire. |
| Poids autorisés | 300 (rare), 400 body, 500 medium, 600 semibold (titres), 700 bold (display) |
| Eyebrow | Mono 11 px · `tracking 0.20em` · `UPPERCASE` · couleur `--bx-app-accent-on` |
| Label technique | Mono 10.5 px · `tracking 0.18em` · `UPPERCASE` · couleur `--bx-app-fg-3` |

### Échelle complète

| Rôle | Taille | Line-height | Letter-spacing | Poids |
|---|---|---|---|---|
| Display | 44 px | 1.05 | −0.025em | 700 |
| H1 page | 34 px | 1.10 | −0.022em | 700 |
| H2 section | 26 px | 1.15 | −0.018em | 700 |
| H3 card | 20 px | 1.20 | −0.005em | 600 |
| H4 sub | 16 px | 1.25 | 0 | 600 |
| Body | 15 px | 1.55 | 0 | 400 |
| Small | 13 px | 1.50 | 0 | 400 |
| Eyebrow | 11 px | — | 0.20em UPPER | 600 |
| Label tech | 10.5 px | — | 0.18em UPPER | 500 |
| Montant | 28 px | — | mono · tabular | 600 |

### Règles d'usage

- **Un seul eyebrow par section.** Toujours violet (`--bx-app-accent-on`), jamais blanc ni gris.
- **Pas de texte plus petit que 12 px** en lecture courante. Captions ≥ 11 px et seulement pour les métadonnées.
- **Pas de texte gris sur gris.** Libellé important = `--bx-app-fg` ou `--bx-app-fg-2`, jamais `fg-4`.
- **Chiffres financiers** : toujours tabulaires, signe « − » plutôt que « - », séparateur d'unité fine (« 128 430 »), devise après le montant (« € »), pas de couleur sauf signe explicite (vert/rouge).
- **Aucun all-caps long.** Uppercase = eyebrows, labels, en-têtes de tableau, badges.

---

## 5. Layouts standards

Toutes les pages app suivent le même squelette. Trois archétypes seulement : *vue résumée* (dashboard), *listing* (comptes, transactions), *détail* (compte, catégorie).

### Coquille globale (shell)

`Topbar 56 px (chrome)` + `Drawer 240 px (chrome)` + `Main (bg)` + `Footer (chrome)`.

### Espacements standards (à respecter)

| Élément | Valeur |
|---|---|
| Largeur drawer | 240 px (fixe ou sticky) |
| Hauteur topbar | 56 px, fond `--bx-app-chrome`, border-bottom 1 px |
| Max-width contenu | 1280 px (1440 max pour pages d'analyse avec sankey) |
| Padding global page | `--bx-sp-6` haut · `--bx-sp-7` latéral (32 / 40 px) |
| Header → contenu | `--bx-sp-6` (32 px) |
| Entre sections | `--bx-sp-7` (40 px) ; `--bx-sp-8` (48 px) pour grands blocs |
| Padding card | `--bx-sp-5` (24 px) ; `--bx-sp-6` (32 px) pour hero patrimoine |
| Hauteur row tableau | 48 px (dense) · 56 px (confort) |
| Radius cards | `--bx-radius-lg` (14 px standard) · `--bx-radius-xl` (16 px hero) · `--bx-radius-md` (10 px sub-card) |
| Radius boutons | `--bx-radius-md` (10 px) |

### Page header standard

Structure obligatoire : *(back ronde) → eyebrow violet → titre H1 → sous-titre → action(s) droite*.

**Variantes** :
- `--flush` : header sur fond `--bx-app-bg`, sans border-bottom — quand une card hero patrimoine suit immédiatement.
- `--simple` : eyebrow + titre seuls, pas de sous-titre ni d'action — pages admin et paramètres.

### Largeur des sections par type de page — ADR-016

La largeur d'une card ou section est décidée par l'**usage utilisateur**, pas par une convention de grille uniforme.

#### Principe directeur

| Usage | Largeur |
|---|---|
| Scanner / comparer / gérer | Full-width (`col-12`) |
| Analyser deux blocs complémentaires | Grille (`8/4`, `7/5`, `6/6`) |
| Lire / saisir / configurer | Largeur contrainte (`col-lg-8`, `max-width 720–900 px`) |

#### Pages opérationnelles → full-width

Exemples : Comptes · Transactions · À traiter · Règles automatiques · Budgets · Admin utilisateurs.

- La surface principale (liste / table / feed) prend toute la largeur utile : `col-12` ou équivalent.
- Ne pas contraindre en `col-lg-8` ou `col-lg-10` si cela réduit la lisibilité du tableau.
- Une colonne secondaire n'est autorisée que si elle porte une information distincte et utile (filtre persistant, résumé latéral). Jamais décorative.

#### Pages analytiques → full-width ou grille justifiée

Exemples : Budget analyse · Cashflow · Patrimoine · Dashboard.

- Les sections structurantes (hero, KPI, graphique principal) peuvent être full-width.
- Les grilles `8/4`, `7/5`, `6/6` sont autorisées uniquement si les deux blocs sont complémentaires et lus simultanément.
- Interdiction de créer une colonne secondaire vide ou purement décorative.

#### Pages formulaire / paramètres / lecture → largeur contrainte

Exemples : Profil · Création / édition de ressource · Paramètres · Pages légales · Contenus textuels.

- Utiliser une largeur contrainte pour préserver la lisibilité : `col-lg-8`, `col-xl-7`, ou `max-width` 720–900 px selon le volume de contenu.
- Les formulaires ne doivent pas s'étirer sur toute la largeur desktop — un champ de saisie à 1 200 px de large est illisible.

#### Mobile — règles spécifiques

- Ne pas tenter de conserver la mise en page tableau desktop.
- Réduire l'information à l'essentiel : conserver les colonnes primaires, masquer les secondaires (`d-none d-md-table-cell`).
- Utiliser `text-overflow: ellipsis` CSS pour les libellés longs — pas de troncature serveur pour des raisons responsive.
- Min cible tactile : 44 × 44 px pour tout élément interactif (boutons, chevrons, cases à cocher).

---

## 6. Composants UI

Inventaire canonique. Chaque composant a une seule implémentation autorisée. Toute variation doit revenir ici avant d'être utilisée en production.

### A · Sidebar

| Spec | Valeur |
|---|---|
| Fond | `--bx-app-chrome` + border-right `--bx-app-border` |
| Item simple | 8 / 18 px padding · icône `material-icons-outlined` 17 px · texte `--bx-app-fg-2` · 13.5 px |
| Item hover | Fond `--bx-app-hover` · texte `--bx-app-fg` · icône `--bx-app-fg` |
| Item actif | Fond `--bx-app-accent-tint` · bordure gauche 3 px `--bx-app-accent` · texte & icône `--bx-app-accent-on` |
| Sous-menu | Indent + 32 px · même style, 13 px, `--bx-app-fg-3` |
| Badge compteur | Pill `--bx-app-warning-tint` · `--bx-app-warning` · mono 9.5 px · 1 / 6 px padding |
| Item « à venir » | Texte `--bx-app-fg-4` · pill grise + texte `--bx-app-fg-3` · pas de hover actif |
| Bloc Premium | 14 px pad · radius 10 px · gradient violet→cyan 18 / 12 % · border `rgba(124,58,237,0.45)` |
| Section admin | `border-top: 1px solid --bx-app-border` + label kicker uppercase « Administration » mono 10 px |

### B · Topbar

| Spec | Valeur |
|---|---|
| Hauteur | 56 px stricte |
| Fond | `--bx-app-chrome` · border-bottom 1 px · `--bx-app-elev-sm` |
| Logo | Wordmark Roboto Mono UPPERCASE 13 px + glyphe 22 × 22 px |
| Burger / menu | `.bx-btn--icon` 36 × 36 px, hover `--bx-app-hover` |
| Icônes droite | Recherche · notifications (pulse cyan si non lues) · avatar 32 px gradient violet→cyan |

### C · Page header

Voir Section 5.

### D · Cards

**Card standard**

| Spec | Valeur |
|---|---|
| Fond | `--bx-app-surface` |
| Border | 1 px `--bx-app-border` |
| Radius | `--bx-radius-lg` (14 px) |
| Padding | `--bx-sp-5` (24 px) |
| Titre interne | H4 16 px / 600 · couleur `--bx-app-fg` |
| Sub-card | Fond `--bx-app-surface-2` · radius `--bx-radius-md` (10 px) · pad `--bx-sp-4` |

**Card KPI** : label mono uppercase + valeur tabulaire 26 px + delta colorisé. Hauteur ~100 px.

**Card hero patrimoine** : radius `--bx-radius-xl` · halo violet 18 % radial · eyebrow + valeur 48 px mono + rangée 4 stats.

**Card détail de compte** : titre H3 + ligne de pills (statut / devise / sync) + valeur 28 px mono + métadonnées 13 px `--bx-app-fg-3`.

### E · Boutons

| Variant | Spec |
|---|---|
| Primary | Fond `--bx-app-accent` · texte #fff · shadow violet 4 / 12 px / 25 % · hover `--bx-app-accent-hover` + translateY(-1px) |
| Outline | Border `--bx-app-border-2` · texte `--bx-app-accent-on` · hover fond `--bx-app-accent-tint` |
| Info (cyan) | Fond `--bx-app-info-tint` · texte `#67e8f9` |
| Ghost | Transparent · texte `--bx-app-fg-2` · hover `--bx-app-hover` |
| Danger | Transparent · texte `--bx-app-danger` · border 1 px `rgba(248,113,113,0.4)` · hover tint — **jamais filled rouge plein** |
| Icon-only | 36 × 36 px circle · ghost · hover `--bx-app-hover` |
| Taille SM | Padding 6 / 12 px · 12.5 px · radius `--bx-radius` (8 px) |
| Disabled | Opacity 0.45 · cursor not-allowed · pas d'ombre · pas de transform |
| Focus | Outline 2 px `--bx-app-focus-ring`, offset 1 px |

### F · Badges & pills

États autorisés : `actif` · `exclu` · `premium` · `à venir` · `warning` · `danger` · `success` · `info` · `counter` · `cat-{*}`.

**Règle pill** : maximum 3 pills par bloc. Au-delà = badge catégorie, bascule en liste. Une pill ne porte qu'*un état* ou *une catégorie*, jamais les deux.

### G · Alertes & toasts

4 niveaux uniquement : success (vert) · info (cyan) · warning (orange) · danger (rouge).
Structure : icône sémantique + titre gras + sous-texte + (optionnel) action à droite.
Icônes : `check_circle` · `info` · `priority_high` · `error`.

### H · Tableaux

| Spec | Valeur |
|---|---|
| Header | Fond `rgba(255,255,255,0.025)` · mono uppercase 10.5 px · `--bx-app-fg-3` |
| Row hover | Fond `--bx-app-surface-2` · cursor pointer si row cliquable |
| Row height | 48 px (dense) ou 56 px (confort) — figé par page |
| Montants | Alignés à droite, mono tabulaire, signe explicite |
| Statuts | Toujours en pill colorisée — jamais en texte coloré brut |
| Actions row | Icon-only droite 32 × 32 px ghost · **`chevron_right`** pour ouvrir une fiche de détail interne — voir §J |
| Tri | En-tête cliquable + flèche mono · couleur active `--bx-app-accent-on` |
| Vide | Illustration neutre + texte `--bx-app-fg-3` + CTA primaire — pas de spinner permanent |

### J · Icônes de navigation — `chevron_right` vs `arrow_forward`

Règle fixée lors du lot Accounts-Polish v1 (2026-05-11). **ADR-015.**

| Icône | Contextes d'usage | Sémantique |
|---|---|---|
| `chevron_right` | Ligne de tableau · ligne de liste · item ouvrant une fiche de détail · navigation dans une hiérarchie | "Ouvrir le détail de cet élément" — navigation interne, pas de changement de contexte |
| `arrow_forward` | CTA autonome · bouton ou lien "Tout voir" · lien de section · action qui quitte la vue courante ou avance vers un autre espace | "Aller vers une autre vue / poursuivre" — changement de contexte ou de niveau de navigation |

**Règle d'application :**
- Toute colonne d'action de ligne (dernière colonne d'une `<table>` ou d'une liste flex) ouvrant une page de détail : `chevron_right` icon-only 32 × 32 px ghost.
- `arrow_forward` est réservé aux éléments qui se comportent comme des CTA ou des liens de navigation de niveau supérieur (hors ligne de tableau).
- La classe `.bx-row-arrow` (wrapper de colonne 28 px) est compatible avec `chevron_right` — l'icône à l'intérieur doit être `chevron_right`, pas `arrow_forward`.

**Dettes connues à migrer (lot futur, ne pas corriger à la volée) :**
- `templates/patrimoine/index.html.twig` — `bx-row-arrow` + `arrow_forward` (× 2 lignes)
- `templates/patrimoine/comptes_bancaires.html.twig` — `bx-row-arrow` + `arrow_forward`
- `templates/patrimoine/livrets.html.twig` — `bx-row-arrow` + `arrow_forward`
- `templates/patrimoine/credits.html.twig` — `bx-row-arrow` + `arrow_forward`
- `templates/patrimoine/immobilier.html.twig` — `bx-row-arrow` + `arrow_forward`
- `templates/patrimoine/actions_fonds.html.twig` — `bx-row-arrow` + `arrow_forward`
- `templates/patrimoine/fonds_euros.html.twig` — `bx-row-arrow` + `arrow_forward`
- `templates/admin/user/index.html.twig:300` — ligne de tableau utilisateur → `arrow_forward`
- Note CSS : le commentaire `/* Cible icon-table-action (arrow_forward) dans toute la famille */` dans `patrimoine.css:221` devra être mis à jour en même temps que la migration d'icône.

**Usages légitimes à ne pas migrer :**
- `dashboard/index.html.twig` — "Tout voir" (`arrow_forward` → correct)
- `category_rule/index.html.twig` — CTA bouton "Créer la règle" (`arrow_forward` → correct)
- `action_center/index.html.twig` — CTA de section (`arrow_forward` → correct)
- `home/pricing.html.twig` — CTA landing public (`arrow_forward` → correct)

### I · Formulaires

| Spec | Valeur |
|---|---|
| Fond input | `--bx-app-inset` |
| Border | 1 px `--bx-app-border` · focus `--bx-app-accent-on` + ring `--bx-app-focus-ring` |
| Hauteur | ~38 px (pad 9 / 12 px) ; SM 32 px |
| Label | 12 px / 500 · `--bx-app-fg-3` · marge bas 6 px |
| Aide | 12 px · `--bx-app-fg-3` · marge haut 6 px |
| Erreur | Border `rgba(248,113,113,0.55)` · message 12 px couleur `--bx-app-danger` |
| Disabled | Fond `--bx-app-inset` · opacity 0.55 · cursor not-allowed |

---

## 7. Règles pour les graphiques

Les graphes sont des outils de lecture, pas des illustrations. Pas de gradient sans raison, pas de 3D, pas d'ombre.

### Palette graphique (max 6 segments)

`#7c3aed` · `#22d3ee` · `#22c55e` · `#fbbf24` · `#f87171` · `#a78bfa` · `#94a3b8` (autre/divers).

Ces valeurs correspondent aux tokens `--bx-app-accent`, `--bx-app-info`, `--bx-app-success`, `--bx-app-warning`, `--bx-app-danger`, `--bx-app-accent-on`, `--bx-app-fg-3`.

### Donut

- Label central au repos = « Total » avec valeur formatée. Hover/click segment = nom + part.
- 6 segments max ; le reste = « Autres » sur `--bx-app-fg-3`.
- Épaisseur d'anneau = 22 px sur diamètre 220 px (~10 %).
- Légende droite ou bas, valeur + pourcentage mono tabulaire.
- Pas d'ombre, gradient ni effet « pull » au hover. Hover = 100 % d'opacité, autres à 0.55.

### Courbe d'évolution

- Trait 2 px `--bx-app-accent-on` · area fill gradient violet → transparent.
- Grille horizontale uniquement, 1 px `rgba(255,255,255,0.06)`, max 4 lignes.
- Axe vertical sans ligne, libellés mono 10.5 px `--bx-app-fg-3`, alignés droite hors graphe.
- Tooltip : card `--bx-app-surface-2` radius 10 px, date eyebrow + valeur mono 14 px.
- Hover : cercle plein 3.5 px + ligne verticale guide 1 px `--bx-app-border-2`.

### Sankey / flux de dépenses

- Nodes : barre verticale 8 px de la couleur sémantique, hauteur proportionnelle.
- Liens : gradient entre couleurs des deux nodes, opacité 0.35 (0.55 hover).
- Libellés : sources à gauche, destinations à droite, montants mono.
- Plafond 8 × 8. Au-delà = regroupement « Autres ».

### Barres de progression & budget consommé

- Hauteur 8 px · radius 100 px · fond `--bx-app-inset` + 1 px border.
- ≤ 80 % → `--bx-app-success` · 80–99 % → `--bx-app-warning` · ≥ 100 % → `--bx-app-danger`.
- Label + montant en mono tabulaire au-dessus, jamais à l'intérieur.
- Pas d'animation au hover ; transition initiale `width 0.8s ease-out`.

### Règles transverses (à éviter)

- Pas de couleur rose-bonbon, turquoise pâle ou jaune fluo. Palette fermée.
- Pas de gradient multi-stops dans une courbe — gradient toléré uniquement en area fill.
- Pas de fond clair derrière un graphique sur page dark.
- Contraste minimum 3:1 pour toute série contre `--bx-app-surface`.

---

## 8. Règles pour les tableaux

1. **Premier coup d'œil = total ou résumé.** Toujours afficher au-dessus de la table un compteur (« 218 transactions, 4 218 € de dépenses ») en H4 + mono.
2. **Header sticky** dès que la table dépasse 8 lignes visibles.
3. **Pas de bordures verticales.** Séparation horizontale uniquement (`border-bottom 1px --bx-app-border`).
4. **Alignement** : texte gauche, dates centre, montants droite. Toujours.
5. **Catégorisation** : badge pill en couleur catégorie sur fond tint, jamais en texte coloré brut.
6. **Densité** : 48 px (défaut) ou 56 px. Toggle Confort/Dense pour listings > 50 lignes.
7. **Actions de ligne** : icônes ghost 32 × 32 px, dernière colonne 120 px, chevron systématique si row cliquable.
8. **État vide** : illustration neutre + libellé `--bx-app-fg-2` + CTA primaire. Pas de « No data ».
9. **Pagination** : max 25 lignes / page. Numéros mono, boutons ghost icon-only.
10. **Tri** : flèche mono à droite du label, `--bx-app-fg-3` au repos, `--bx-app-accent-on` actif.
11. **Multi-sélection** : checkbox carrée 16 px radius 4 px, accent au check. Barre d'actions sticky en bas dès qu'une row est cochée.

---

## 9. Règles pour les alertes & toasts

- **4 niveaux uniquement** : success · info · warning · danger.
- **Structure obligatoire** : icône sémantique + titre gras + sous-texte + (optionnel) action droite.
- **Icônes** : `check_circle` · `info` · `priority_high` · `error`.
- **Position** : inline dans la page (au-dessus du contenu lié) *ou* toast bottom-right.
- **Pas de full-page modal** pour une alerte, sauf erreur critique (paiement, perte de données).
- **Durée toast** : 5 s par défaut, sticky pour danger.
- **Empilement** : 2 toasts max visibles, gap 12 px, retrait FIFO.
- **Texte** : titre ≤ 50 caractères, sous-texte ≤ 110 caractères. Action = verbe à l'infinitif.

---

## 10. Règles responsive

Budgex est conçu desktop-first mais reste pleinement utilisable sur tablette et mobile.

### Breakpoints

| Range | Layout |
|---|---|
| ≥ 1280 px | Desktop large — layout complet, drawer ouvert |
| 1024–1279 px | Desktop — drawer collapsé en rail icônes (60 px) |
| 768–1023 px | Tablette — drawer overlay (off-canvas) déclenché par burger |
| ≤ 767 px | Mobile — drawer caché, layout 1 colonne, KPI empilés |

### Règles d'adaptation

- Page header : action principale descend sous le titre en mobile, plein-largeur.
- Grilles de KPI : 4 col → 2 col (tablette) → 1 col (mobile).
- Tableaux : deviennent liste cards à partir de 767 px ; actions repliées en menu kebab.
- Hero patrimoine : la rangée de stats devient un scroll horizontal sur mobile (snap CSS).
- Donuts : largeur fixe 220 px, légende sous le donut en mobile.
- Sankey : non disponible < 1024 px ; remplacé par barres horizontales.
- Min taille cible tactile : 44 × 44 px (boutons icon-only et chevrons inclus).

---

## 11. Do / Don't

### ✓ Do

- Démarrer chaque page par un résumé (hero, KPI ou alerte).
- Utiliser le même header pattern partout (eyebrow + titre + sous-titre).
- Aligner les montants à droite, en mono tabulaire, avec signe explicite.
- Réserver le violet à la marque et à la sélection.
- Garder un seul CTA primaire par écran.
- Prévoir les états vides, loading, erreur, données partielles.
- Utiliser pill + tint pour les statuts, jamais texte coloré nu.
- Espacer généreusement entre sections (`--bx-sp-7`).
- Conserver « Total » au centre des donuts au repos.

### ✗ Don't

- Empiler 5 cards sans hiérarchie de tailles ou de couleurs.
- Mélanger violet, bleu et rose comme couleurs décoratives.
- Mettre des bordures verticales dans les tableaux.
- Créer une page sans header standard.
- Utiliser un rouge filled pour un bouton danger.
- Mettre du texte en couleur sans signification (vert = succès uniquement).
- Multiplier les pills sur une même ligne (≥ 4).
- Ajouter une 3ᵉ famille de police.
- Afficher un spinner permanent en remplacement d'un état vide.
- Faire des graphes 3D, gradient multi-stops ou ombres portées.
- Utiliser un raw hex ou un `rem` en dur dans une feuille métier ou un template Twig.

---

## 12. Checklist de validation d'une nouvelle page

Une page Budgex n'est pas livrable tant que les 14 points ci-dessous ne sont pas cochés.

- [ ] Header standard présent (eyebrow + H1 + sous-titre, back rond si détail)
- [ ] Aucun raw hex / rem (tout via `--bx-app-*` / `--bx-sp-*` / `--bx-radius-*`)
- [ ] Une seule CTA primaire (le reste = outline, ghost, icon-only)
- [ ] Résumé en haut (hero, KPI row ou alerte avant tout détail tabulaire)
- [ ] Montants en mono tabulaire (signe explicite, séparateur d'unité fine, devise après)
- [ ] Pills pour les statuts (catégories en pill, jamais texte coloré nu)
- [ ] Tableaux : header sticky, alignement à droite montants, pas de bordures verticales, hover surface-2
- [ ] Graphes : palette fermée 6 couleurs max ; donut central = « Total »
- [ ] 4 états couverts (vide, loading, erreur, données partielles)
- [ ] Espacement (`--bx-sp-7` entre sections, `--bx-sp-5` intérieur cards)
- [ ] Responsive vérifié (1280, 1024, 768, 375)
- [ ] Focus visible (outline 2 px `--bx-app-focus-ring`)
- [ ] Texte minimum 12 px (aucune lecture courante en dessous)
- [ ] Pas de troisième famille typo (Roboto + Roboto Mono uniquement)

---

## 13. Recommandations d'intégration code

Ce design system existe déjà dans `colors_and_type.css` et `components.css`. Les recommandations ci-dessous visent à le faire respecter durablement.

### Hiérarchie des feuilles de style

1. `colors_and_type.css` — source de vérité des tokens. Aucun raw hex hors de ce fichier.
2. `styles.css` — reset / base.
3. `app.css` — typographie sémantique.
4. `components.css` — primitives `.bx-*`. Chargé en dernier, pas d'`!important` sauf override Bootstrap.
5. Feuilles métier (`accounts.css`, `patrimoine.css`, `cashflow.css`) — overrides locaux uniquement, jamais de nouveau token.

### Règles de code

- **Aucun raw hex ni rgb** dans les feuilles métier et templates Twig. Tout consomme `var(--bx-app-*)`.
- **Aucun rem en dur** pour les espacements. Toujours `var(--bx-sp-N)`.
- **Pas de nouvelle famille typo importée.** Pas de `@import` Google Fonts hors `colors_and_type.css`.
- **Composants Bootstrap** : utilisés tels quels uniquement si surchargés dans `components.css` (drawer, dropdown, modal). Sinon, primitive `.bx-*`.
- **Iconographie** : Material Icons Outlined uniquement. Pas de Font Awesome ni SVG inline pour icônes courantes.
- **Twig** : créer un partial pour chaque composant récurrent (`_app_page_header.html.twig`, `_bx_kpi.html.twig`, `_bx_alert.html.twig`) et l'utiliser systématiquement.
- **Light theme** : opt-in via `html[data-theme="light"]`. Aucune CSS métier ne doit forcer une couleur claire.
- **Linting** : un script (`bin/console design:lint` ou équivalent) doit scanner les feuilles métier pour détecter raw hex / rem, et faire échouer la CI si trouvé.

### Stratégie d'introduction sur du code existant

1. Vérifier que la page consomme `nav-fixed` sur `<body>` (déclenche les overrides `components.css`).
2. Remplacer les classes Bootstrap génériques (`btn btn-primary`) par les primitives `.bx-btn-app` / `.bx-btn-outline-app`.
3. Remplacer les `card` Bootstrap par la card canonique (`--bx-app-surface` + radius 14 px + border 1 px).
4. Aligner les titres sur l'échelle Section 4 (`.bx-display`, `.bx-kicker`, etc.).
5. Remplacer les couleurs en dur (`color: #fff`) par `color: var(--bx-app-fg)`.
6. Ajouter le partial `_app_page_header.html.twig` en haut de chaque page.

---

## 14. Points à harmoniser dans les captures actuelles

Lecture critique des captures de production. Ces écarts existent *déjà* dans l'app et doivent être corrigés avant que de nouvelles pages s'en inspirent.

### 14.1 · Tableau de bord

- L'alerte « transactions à traiter » varie entre *card warning* et *banner full-width* selon l'écran. **Unifier en alert inline warning**, jamais en bannière.
- La card patrimoine utilise tantôt un gradient violet plein, tantôt un fond surface plat. **Choisir : surface + halo violet 18 % radial.**
- Les KPI du mois alternent entre 3 et 4 cartes. **Standardiser à 4 KPI** : Revenus · Dépenses · Épargne · Cashflow net.

### 14.2 · Mes comptes

- Le toggle « modes d'affichage » (liste / cartes) utilise un style boutons différent du reste de l'app. **Aligner sur `.bx-btn--outline bx-btn--sm`** en groupe (radio).
- La colonne « Statut » mélange pills et texte coloré. **Toujours pill**.
- La flèche d'accès au détail est parfois un chevron, parfois un bouton « Voir ». **Standardiser sur le chevron icon-only à droite.**

### 14.3 · Détail compte

- Le bouton retour rond n'est pas constant (parfois absent, parfois fil d'Ariane). **Systématiser le back rond + chevron à gauche du titre.**
- L'alerte « taux non configuré » est tantôt jaune, tantôt cyan. **Warning (orange)** uniquement.
- Les métadonnées (établissement / devise / statut) sont parfois en texte courant, parfois en pills. **En pills**, alignées sous le titre.

### 14.4 · Analyse budget du mois

- La navigation temporelle (mois précédent / suivant) utilise plusieurs styles. **Unifier en pair de boutons icon-only + libellé mois en H3 mono uppercase.**
- Les insights textuels sortent en gris sur gris parfois illisible. **Couleur `--bx-app-fg-2` minimum**, avec eyebrow violet pour la catégorie.
- Les barres de progression budget utilisent parfois un fond clair. **Toujours `--bx-app-inset`** + border 1 px (voir Section 7).
- Le Sankey n'a pas de limite de nodes — certains écrans en montrent 14+. **Plafonner à 8 × 8** avec regroupement « Autres ».

### 14.5 · Transversal

- Plusieurs pages utilisent `--bx-primary: #6200ea` (legacy Material) au lieu de `--bx-app-accent: #7c3aed` (brand). **Migrer vers `--bx-app-accent`.**
- Bordures verticales encore présentes dans des tableaux d'admin. **À retirer.**
- Padding intérieur des cards oscille entre 16 et 28 px. **Forcer `--bx-sp-5` (24 px)**, `--bx-sp-6` (32 px) uniquement pour la hero.
- Roboto Mono n'est pas toujours appliqué aux chiffres financiers. **Audit nécessaire** : tout montant ≥ 14 px doit être en mono ou `tabular-nums`.

---

## Annexe A · Archétypes de pages

Squelettes verticaux à recopier pour démarrer une nouvelle page. Trois archétypes couvrent ~90 % des cas Budgex.

### Archétype 1 — Vue résumée (dashboard, analyse mois)

| # | Bloc | Description |
|---|---|---|
| 01 | Page header | eyebrow violet + titre H1 + sous-titre · action principale à droite |
| 02 | Alerte contextuelle *(optionnelle)* | warning ou info inline, action à droite |
| 03 | Hero patrimoine OU bandeau navigation temporelle | card `--bx-radius-xl` radius, halo violet, valeur 48 px mono |
| 04 | Rangée 4 KPI | cards `--bx-radius-lg` radius, label mono uppercase + valeur tabulaire + delta |
| 05 | Graphique principal (donut OU courbe) | card surface, légende intégrée, centre « Total » |
| 06 | Insights textuels *(optionnel)* | 2–4 puces avec eyebrow couleur + corps `--bx-app-fg-2` |
| 07 | Section secondaire (table ou liste compacte) | card avec header + 5–10 lignes max, lien « Voir tout » |

### Archétype 2 — Listing (mes comptes, transactions)

| # | Bloc | Description |
|---|---|---|
| 01 | Page header avec action principale | « Ajouter » en CTA primaire à droite |
| 02 | Bandeau compteurs (3–4 KPI inline) | total, encours, dernière sync, alertes |
| 03 | Card listing principale | toolbar : recherche + filtres + toggle dense/confort · table sticky · pagination mono |
| 04 | État vide / état partiel | placeholder neutre, CTA primaire |

### Archétype 3 — Détail (compte, catégorie, transaction)

| # | Bloc | Description |
|---|---|---|
| 01 | Page header `--flush` avec back rond | eyebrow = contexte parent (« Mes comptes »), back + titre + sous-titre |
| 02 | Card solde / valeur principale | valeur 28–48 px mono + pills méta (statut, devise, sync) |
| 03 | Alerte spécifique *(optionnelle)* | configuration manquante, taux, reconnexion… |
| 04 | Graphique d'évolution | courbe 12 mois sur card surface |
| 05 | Sous-listing lié | 5–10 dernières transactions / mouvements, lien « Voir tout » |
| 06 | Actions secondaires | en bas de page : éditer, exclure, supprimer (danger outline) |

---

## Annexe B · Points à arbitrer avant intégration

Incohérences identifiées entre la bible visuelle et le code CSS réel (`colors_and_type.css`). Ces points ne bloquent pas la publication de la bible en tant que référence, mais doivent être résolus avant toute utilisation normative sur les composants concernés.

### B.1 · `--bx-radius-xl` : 18 px (bible) vs 16 px (CSS)

**Constat** : la bible spécifie 18 px pour la hero patrimoine. Le CSS déclare `--bx-radius-xl: 1rem` soit 16 px (base 16 px). Le token `--bx-radius-2xl: 1.25rem` (20 px) existe mais n'est pas documenté dans la bible.

**Options** :
- A — Accepter 16 px comme valeur canonique, mettre à jour la bible.
- B — Mettre à jour le CSS : `--bx-radius-xl: 1.125rem` (18 px) et `--bx-radius-2xl: 1.375rem` (22 px).
- C — Utiliser `--bx-radius-2xl` pour la hero (20 px, valeur intermédiaire acceptable).

**Décision requise avant** : toute refonte de la card hero patrimoine.

---

### B.2 · Règle de progression budget : ambiguïté 80–99 %

**Constat** : le fichier source HTML indiquait « ≤ 80 % → success · 80–99 % → success · ≥ 100 % → warning / danger ». Les deux premières tranches ont la même couleur, ce qui ne sert à rien.

**Correction appliquée dans cette bible** : ≤ 80 % → `--bx-app-success` · 80–99 % → `--bx-app-warning` · ≥ 100 % → `--bx-app-danger`.

**Statut** : correction intégrée dans la Section 7 de ce fichier. Valider avec l'équipe produit si une seuil warning à 80 % est pertinent (vs 90 %).

---

### B.3 · Token legacy `--bx-primary: #6200ea` encore dans `colors_and_type.css`

**Constat** : le fichier CSS conserve `--bx-primary: #6200ea` (Material Design legacy) dans le bloc `:root` global. Ce token est utilisé par des composants Bootstrap overrides non encore migrés.

**Impact** : plusieurs pages affichent encore le violet Material (#6200ea) à côté du violet brand (#7c3aed). La bible documente cette migration comme obligatoire (Section 14.5).

**Action** : audit des usages de `--bx-primary` et migration incrémentale vers `--bx-app-accent`. Ne pas supprimer avant audit complet — risque de régression Bootstrap.

---

### B.4 · Light theme : `--bx-app-accent` en mode clair reste `#6200ea`

**Constat** : la bible documente `--bx-app-accent: #7c3aed` comme token brand universel. En mode clair (`html[data-theme="light"]`), le CSS surcharge avec `--bx-app-accent: #6200ea`.

**Impact** : les utilisateurs en mode clair voient le violet Material, pas le violet brand. Cohérence cassée entre dark et light.

**Action** : décider si le thème clair adopte `#7c3aed` ou garde un violet plus foncé pour le contraste (le #6200ea est plus lisible sur fond blanc). Documenter la décision dans ce fichier.

---

### B.5 · Tokens d'élévation absents de la section palette

**Constat** : `--bx-app-elev-sm`, `--bx-app-elev`, `--bx-app-elev-lg` existent dans le CSS et sont utilisés dans les composants (cards, topbar, dropdowns). La bible ne les documentait pas dans la section palette.

**Correction appliquée** : Section 3.G ajoutée dans cette bible avec les trois tokens.

**Statut** : résolu dans cette version.

---

**Bible Visuelle Budgex — V1** · Source de vérité du design system applicatif. Dark-first · Roboto · Violet `#7c3aed`.
