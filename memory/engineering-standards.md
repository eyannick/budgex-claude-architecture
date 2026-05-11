# engineering-standards.md
updated: 2026-05-11
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