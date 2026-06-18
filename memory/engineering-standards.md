# engineering-standards.md
updated: 2026-05-20 (ADR-024 · clôture chantier Auth CSS/UX)
status: active

## Rôle du document

Ce document définit les standards techniques et conventions transverses du projet Budgex.

Il couvre :
- les conventions PHP / Symfony ;
- les conventions de structure ;
- les standards frontend ;
- les patterns UI établis ;
- les conventions Git.

Il ne remplace pas :
- les décisions d’architecture durables (`decision-log.md`) ;
- les règles de routing (`routing-matrix.md`, `agents-catalog.md`) ;
- les checklists de validation.

## Standards PHP / Symfony

- PSR-12 ;
- attributs PHP 8 ;
- pas de logique métier dans les contrôleurs ;
- services injectés par constructeur ;
- Voters pour l'autorisation par ressource ;
- `make:migration`, jamais `doctrine:schema:update --force` ;
- validation serveur obligatoire sur les entrées utilisateur.

## Standards de structure

- méthodes suffisamment courtes pour rester lisibles et testables ;
- une responsabilité par service autant que possible ;
- pas de SQL brut hors cas justifié ;
- requêtes via QueryBuilder, DQL ou repository dédié.

## Standards frontend

- Twig sans logique métier ;
- données et états préparés côté backend avant rendu ;
- WCAG 2.2 AA minimum comme cible ;
- `aria-label` sur tout bouton icon-only ;
- un seul `<h1>` principal par page ;
- pas de CSS inline sauf justification ;
- pas de `!important` sans justification.

### Sécurité JS frontend (patterns transversaux)

> Règle transversale, applicable à tout module exposant des données utilisateur en JS — pas
> spécifique aux transactions. Remontée depuis l'historique de campagnes archivé
> (`archive/campaigns/2026-06-18/code-campaigns/transactions-templates-js.md`).

- **Transit de données JSON** : injecter via `<script type="application/json" id="bx*Data">`, jamais en variables JS inline. Lire avec `JSON.parse()`, jamais `eval()`.
- **JSON safe contre l'injection de balise** : si le JSON injecté peut contenir la séquence `</`, l'échapper (`replace('</', '<\\/')`) avant de l'écrire dans le `<script>`, pour empêcher une fermeture prématurée du tag.
- **Parsing défensif** : tout `JSON.parse()` sur des données externes ou utilisateur est entouré d'un `try/catch`, valide le type attendu (ex. `Array.isArray()`), et retombe sur une valeur par défaut sûre (`[]`, `{}`) en cas d'échec — jamais de crash silencieux de l'UI.
- **Injection DOM de données variables** : `textContent`, jamais `innerHTML`, pour toute valeur issue de l'utilisateur ou du backend. Si `innerHTML` est strictement nécessaire (ex. construction de markup avec icônes), échapper systématiquement la donnée variable via une fonction `escapeHtml()` avant insertion — les chaînes statiques du template n'ont pas besoin d'échappement.
- **Attributs `data-*`** : toute donnée portée par un attribut `data-*` consommé en JS doit être validée/bornée avant d'être réinjectée en CSS custom property ou en logique conditionnelle.
- **Pas de JS inline non justifié** : pas d'`onclick="..."` ni de gestionnaire inline dans le Twig — délégation d'événements via `addEventListener` (IIFE ou module dédié), guard par `closest()`/sélecteur plutôt que par attribut inline.
- **Externalisation au-delà du seuil** : tout script de rendu ou de logique dépassant ~30 lignes est extrait vers `public/js/<page>.js` — aucun bloc `<script>` substantiel inline dans `{% block javascripts %}`.

## Patterns UI établis

- `card-header-icons`
- `page-header-row`
- `responsive-tables`
- `mobile-period-selector`

Toute régression de pattern doit être signalée dans `RISKS`.

### Largeur des pages (règle ADR-016 — source primaire : bible §5 "Largeur des sections par type de page")

- Pages opérationnelles (comptes, transactions, admin) : `col-12` / full-width.
- Pages analytiques (dashboard, patrimoine) : full-width ou grille justifiée — jamais colonne secondaire décorative.
- Pages formulaire / paramètres / légales : `col-lg-8` ou `max-width` 720–900 px.
- Mobile : masquer colonnes secondaires, `text-overflow: ellipsis`, cible tactile 44 × 44 px min.

### Icônes de navigation (règle ADR-015 — source primaire : bible §6.J)

- `chevron_right` : colonne d'action de ligne (tableau / liste) ouvrant une fiche de détail interne.
- `arrow_forward` : CTA autonome, lien "Tout voir", lien de section, navigation inter-espaces.
- La classe `.bx-row-arrow` est un wrapper de colonne (28 px) — l'icône à l'intérieur doit être `chevron_right`.

### Boutons danger (règle ADR-017 — source primaire : bible §6.E)

- **Danger outline** → `.bx-btn-outline-app.bx-btn-outline-app--danger` : déclencheur page principale, trigger modale, action sensible mais annulable.
- **Danger filled** → `.bx-btn-danger-app` : confirmation finale destructive dans modale uniquement. Interdit comme CTA permanent.
- **Annuler** → `.bx-btn-outline-app` neutre, jamais rouge.
- Règle d'intensité : jamais plusieurs rouge filled visibles simultanément sur une même page.

### Origine CSS et réutilisation des classes (ADR-020)

Avant d'utiliser ou de réutiliser une classe CSS existante, vérifier :

1. où la classe est définie (fichier source exact) ;
2. quel fichier CSS la contient (`components.css`, `profile.css`, `accounts.css`, `cashflow.css`, etc.) ;
3. si ce fichier CSS est chargé sur la page cible (layout `base.html.twig`, `base_admin.html.twig`, `legal.html.twig`, `home.html.twig`) ;
4. si la classe est canonique / réutilisable ou spécifique à un module ;
5. si elle doit être promue vers une couche commune, notamment `components.css` ;
6. qu'aucune classe locale ne soit copiée sans rendre son style disponible sur la page cible ;
7. qu'aucun style inline ou doublon local ne soit ajouté pour contourner un CSS manquant.

**Arbre de décision :**

| Situation | Action |
|---|---|
| Classe canonique (`components.css` / `colors_and_type.css`) + fichier chargé sur la page cible | Réutiliser directement. |
| Classe module-locale + pattern à généraliser | Promouvoir proprement dans `components.css`, puis utiliser. |
| Classe module-locale + pattern non généralisable | Ne pas utiliser hors du module d'origine. |
| CSS non chargé sur la page cible | Charger le fichier ou promouvoir dans une couche commune — jamais de style inline de substitution. |
| Doute sur le chargement | Vérifier les `<link>` du layout cible avant toute implémentation. |

**Interdictions absolues :**
- Ne jamais copier une classe depuis un module sans vérifier le chargement CSS de la page cible.
- Ne jamais ajouter un style inline ou un doublon local pour contourner un CSS non chargé.
- Ne jamais prétendre harmoniser une UI sans vérifier le rendu réel et l'origine des classes utilisées.

**Phrase obligatoire dans tout prompt Codex traitant une tâche UI :**
> "Avant d'utiliser une classe CSS existante, auditer son fichier de définition, son chargement sur la page cible et son statut canonique ou module-local."

*Origine — lot P-UI-Legal-4E : un bouton admin utilisait des classes de `profile.css`, non chargé sur `base_admin.html.twig`, produisant un rendu HTML brut. Correction : promotion du style dans `components.css`.*

## Design System (officiel 2026-04-19)

> **Source primaire depuis 2026-05-11 :** `.claude/references/budgex-visual-bible.md` — ADR-012.
> La section ci-dessous est une source secondaire autorisée : règles d'application code + rappel des primitives.
> En cas de conflit entre les deux fichiers, la bible l'emporte.

### Source de vérité unique

- `public/css/colors_and_type.css` est la **seule** source de vérité pour les tokens de design (couleurs, type, spacing `--bx-sp-*`, radii `--bx-radius-*`, shadows, gradients, motion).
- Les previews canoniques vivent sous `public/design-system-previews/*.html` et sont exposées via `/admin/design-system`.
- Aucun hex en dur ni rem arbitraire dans un CSS de feature. Toujours `var(--bx-*)`.
- Aucune duplication complète de tokens dans un autre fichier CSS. Les alias legacy (ex. `--bx-space-*` → `--bx-sp-*` dans `app.css`) sont tolérés en transition mais doivent référencer le canonique.

### Doctrine dark-first (officielle 2026-04-19)

- La zone authentifiée (`/app/*` et `/admin/*`) est **dark-first par défaut**.
- Les composants app consomment exclusivement les tokens sémantiques `var(--bx-app-*)` :
  `--bx-app-bg`, `--bx-app-chrome`, `--bx-app-surface`, `--bx-app-surface-2`, `--bx-app-inset`,
  `--bx-app-fg`, `--bx-app-fg-2/3/4`, `--bx-app-border`, `--bx-app-border-2`,
  `--bx-app-accent`, `--bx-app-accent-hover`, `--bx-app-accent-on`, `--bx-app-accent-tint`, `--bx-app-focus-ring`,
  `--bx-app-success/danger/warning/info` (+ leurs tints),
  `--bx-app-hover`, `--bx-app-elev-sm/elev/elev-lg`.
- Le light theme est un **opt-in utilisateur** uniquement, activé par `html[data-theme="light"]`.
- Quand aucune préférence n'est exprimée, la zone authentifiée rend en dark (le mode `system` ne s'applique qu'à la landing).
- La landing (`/`) conserve sa propre logique (dark hero + sections claires alternées, tokens `--bx-dark-*` + `--bx-grad-*`). Pas de contamination app ↔ landing.

### Primitives canoniques app

Définies dans `public/css/components.css` et consommées partout dans la zone authentifiée :

- `.bx-btn-app`, `.bx-btn-outline-app`, `.bx-btn-icon-app`
- `.bx-kpi` (card KPI : label + icône + valeur mono + sub)
- `.bx-tx-row` (ligne transaction : icône + libellé + meta + montant mono droite)
- `.bx-notice` (+ `.notice-success / .notice-danger / .notice-warning / .notice-info`)
- `.bx-pill` (+ `.pill-success / .pill-danger / .pill-warning / .pill-info / .pill-cat / .pill-soon`)
- `.bx-card` / `.bx-card-header` / `.bx-card-body` / `.bx-card-footer`
- Shell : `body.nav-fixed`, `.top-app-bar`, `.drawer`, `.nav-link`, `.bx-page-header` — override dark-first depuis `components.css`.

Jamais dupliquer ces primitives ni créer une variante locale. Une exception justifiée doit être discutée et, si elle est retenue, intégrée dans `components.css` comme variante officielle.

### Architecture CSS officielle Budgex — Hiérarchie L0–L6 (CSS-7B · ADR-022 · 2026-05-19)

> Source doctrinale primaire : `references/budgex-visual-bible.md` §13.
> Cette section est la référence d'application technique opérationnelle.

| Couche | Fichier(s) | Rôle | Règle clé |
|---|---|---|---|
| **L0 — Tokens** | `colors_and_type.css` | Source de vérité unique (hex, rem, radii, shadows, motion) | Seul fichier autorisé à définir des raw hex ou valeurs de base |
| **L1 — Vendor** | `styles.css` | Reset et base Bootstrap/vendor | Ne jamais enrichir — legacy figé |
| **L2 — Transition** | `app.css` | Couche legacy : alias, overrides globaux, contenu historique non migré | À drainer lot par lot (ADR-014, ADR-021). Aucune nouvelle classe sans justification explicite |
| **L3 — Primitives** | `components.css` | Primitives `.bx-*` canoniques app/admin | Toute nouvelle primitive réutilisable va ici. Chargé sur `base.html.twig` + `base_admin.html.twig` uniquement |
| **L4 — Modules** | `profile.css` · `transactions.css` · `accounts.css` · `dashboard.css` · `cashflow.css` · `patrimoine.css` · `goal.css` | Styles spécifiques à un module fonctionnel | Module-local : interdiction de réutiliser hors module sans promotion dans L3 |
| **L5 — Zones publiques** | `landing.css` · `legal.css` | Zones publiques autonomes (home, auth, légal) | Indépendantes de `components.css` — ne pas y consommer des primitives app sans vérification |
| **L6 — Page-specific** | block stylesheets Twig | Style ultra-local, exceptionnel | Justification obligatoire — aucun token défini ici |

**Chargement par layout :**

| Layout | Couches présentes |
|---|---|
| `base.html.twig` (zone app/admin) | L0 → L1 → L2 → L3 → L4 (via block stylesheet) |
| `home.html.twig` | L0 → L1 → L5 (`landing.css`) |
| `legal.html.twig` | L0 → L1 → L5 (`legal.css`) |
| Auth (login, register, 2FA…) | L0 → L1 → L5 (`_auth.css`) — `app.css` retiré (ADR-024) |

**Point critique :** `components.css` (L3) **n'est pas chargé** sur home, legal et auth. Toute classe `.bx-*` utilisée sur ces zones doit être vérifiée ou promue dans le fichier de zone approprié.

### Règles d'ajout d'une classe CSS

| Besoin | Destination |
|---|---|
| Bouton réutilisable app/admin | `components.css` (L3) |
| Input / textarea réutilisable app/admin | `components.css` (L3) |
| Card réutilisable | `components.css` (L3) |
| Notice / alerte inline | `components.css` (L3) |
| Badge / pill | `components.css` (L3) |
| Table générique app/admin | `components.css` (L3) |
| Style spécifique à un domaine fonctionnel | CSS métier L4 correspondant |
| Marketing / landing | `landing.css` (L5) |
| Légal public | `legal.css` (L5) |
| Auth | `_auth.css` (L5) — zone autonome (ADR-024). Ne pas importer `app.css`. Ne pas utiliser `components.css` sans vérification layout. Toute primitive réutilisable app/admin → `components.css` (L3). |
| Admin spécifique | Futur `admin.css` (non encore créé). En attendant : `components.css` si canonique, sinon lot dédié |

### Interdictions CSS

- Ne **jamais enrichir** `styles.css` (L1).
- Ne **plus ajouter de nouvelle classe** dans `app.css` (L2) sans justification explicite validée.
- Ne **pas réutiliser une classe module-local** (L4) hors de son module sans promotion préalable dans `components.css` (L3).
- Ne **pas utiliser** une classe `components.css` sur home / legal / auth sans vérifier le chargement sur le layout cible (ADR-020).
- Ne **jamais copier** des styles entre fichiers — promouvoir ou créer une primitive officielle.
- Ne **pas créer un nouveau fichier CSS** sans décision de lot dédiée.

### Tokens sémantiques propres aux features (ADR-030 · 2026-06-09)

> Source doctrinale : `memory/decision-log.md` ADR-030.

Autorisés dans `public/css/colors_and_type.css` (L0) lorsque :
- le composant est strictement local à une feature ;
- aucun token `--bx-app-*` existant ne couvre le besoin dans les deux thèmes ;
- la valeur doit être consommée sans raw hex/rgb dans la feuille métier ;
- une primitive partagée serait prématurée.

Convention de nommage : `--bx-{feature}-{composant}-{rôle}` (ex. `--bx-bank-status-danger-fg`).

Règles :
- Définis **uniquement dans `colors_and_type.css`** — jamais dans la feuille métier.
- Les tokens `--bx-app-*` restent **prioritaires** — vérifier l'équivalence exacte avant de créer.
- Un token feature-scoped dont les valeurs light **et** dark coïncident toutes deux avec un token existant est interdit (alias pur).
- Les fonds et bordures translucides se dérivent via `color-mix(in srgb, var(--bx-TOKEN) N%, transparent)`.
- Valeurs light dans `html[data-theme="light"]`, valeurs dark dans `:root`.
- Promotion vers token global dès qu'un usage réel hors feature est confirmé (F17/ADR-020).

### Dettes CSS identifiées (à traiter lot par lot)

- `app.css` à drainer progressivement — ADR-014, ADR-021.
- Doublon `.bx-form-btn` : `profile.css` vs `components.css` — à résoudre en lot dédié.
- `bx-tx-*` transversal : patterns transactions à auditer pour promotion éventuelle dans L3.
- Patterns dashboard (KPI, graphes) potentiellement transverses — candidats `components.css`.
- Admin encore trop dépendant de `app.css` — futur `admin.css` à planifier.
- **Auth — `styles.css` (L1) assumé** : dépendance Bootstrap/vendor conservée délibérément dans le layout auth (ADR-024). Ne pas traiter en lot CSS standard — attend un lot migration Bootstrap auth dédié.

### Règles d'application

1. Toute nouvelle page ou passe de refonte part des previews `/admin/design-system` et consomme les primitives `.bx-*` + tokens `--bx-app-*` + `--bx-sp-*` + `--bx-fs-*`.
2. Une couleur hex hors composition très locale (ex. badge catégorie coloré par l'utilisateur) doit être codée en token avant d'être utilisée.
3. Les surcharges `!important` sont tolérées uniquement pour neutraliser des règles Bootstrap/SB Admin legacy depuis `components.css`.
4. Les `style="..."` inline couleurs/tailles sont à éliminer lors de chaque passe touchant une page.

## Standards Git

Format :

```text
type(scope): description courte
feat(billing): ajoute la résiliation en fin de période
fix(auth): corrige la vérification d'email expirée
```

## Secrets et variables d'environnement

### Règle absolue

Aucune valeur secrète ne doit jamais apparaître dans :
- un fichier versionné (`.env`, `.env.test`, config, source PHP, Twig, YAML) ;
- un fichier `.claude` ;
- un message de commit ou une PR.

Seuls les **noms** de variables sont autorisés dans les fichiers versionnés.

### Variables Stripe

| Variable | Usage |
|---|---|
| `STRIPE_SECRET_KEY` | Backend uniquement — jamais en Twig, jamais en JS |
| `STRIPE_PUBLISHABLE_KEY` | Frontend uniquement (Stripe.js) — pas encore utilisée en V1 |
| `STRIPE_WEBHOOK_SECRET` | Backend uniquement — vérification signature webhook |
| `STRIPE_PREMIUM_PRICE_ID` | Backend — création Checkout Session |

Setup local : ajouter les vraies valeurs dans `.env.local` (gitignored).
Référence complète : `references/reference-pack-billing.md`.

### En cas d'exposition accidentelle

1. Rôter la clé immédiatement dans le Stripe Dashboard.
2. Vérifier qu'aucune transaction frauduleuse n'a eu lieu.
3. Mettre à jour `.env.local` avec la nouvelle clé.
4. Ne jamais laisser une clé exposée "en attendant".

## Politique navigateurs et compatibilité CSS (ADR-029 · 2026-06-09)

> Source doctrinale : `memory/decision-log.md` ADR-029.

### Cible officielle

Budgex cible les **navigateurs evergreen** prenant en charge les fonctionnalités CSS Baseline 2023.

| Navigateur | Version minimale |
|---|---|
| Chrome / Edge / Android WebView | ≥ 111 |
| Firefox / Firefox Android | ≥ 113 |
| Safari / iOS Safari / iOS WebView | ≥ 16.2 |

Les versions antérieures ne sont **pas supportées**. Aucune obligation de fallback CSS.

### color-mix()

`color-mix()` est **autorisé sans fallback** dans les feuilles applicatives lorsque :

1. il dérive une couleur depuis un token canonique `var(--bx-app-*)` ;
2. il conserve le rendu attendu (couleur + opacité calculée) ;
3. il n'introduit pas de raw hex dans l'expression.

Usage canonique pour les couleurs alpha dérivées d'un token :

```css
/* ✓ canonique */
color-mix(in srgb, var(--bx-app-warning) 45%, transparent)

/* ✗ interdit — raw hex dans color-mix */
color-mix(in srgb, #fbbf24 45%, transparent)
color-mix(in srgb, #f59e0b 15%, transparent)
```

### Pipeline de build

- CSS servis depuis `public/css/` sans transformation PostCSS ni autoprefixer.
- Vite traite uniquement `assets/styles/entries/main.css` et `auth.css`.
- Aucun pipeline de génération de fallbacks — non nécessaire sur la cible définie.
- Ne pas ajouter `browserslist`, PostCSS ni autoprefixer sans décision architecturale dédiée (ADR).