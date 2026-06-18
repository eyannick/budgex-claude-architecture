# Admin Module Campaign

## Metadata
- HEAD initial : 9b1058b
- Statut : READY
- Créé le : 2026-06-14
- Modules figés : bank.css · transactions.css · accounts.css · patrimoine.css · budget.css · dashboard.css
- Périmètre : `public/css/admin.css` · `public/js/admin-*.js` · `templates/admin/**/*.twig` · `tests/{Domain,Platform}/Admin/*.php`

---

## Cartographie

| Route | Template | CSS | JS externe | Tests |
|---|---|---|---|---|
| GET /admin | admin/dashboard/index.html.twig | admin.css | Chart.js CDN + inline | AdminAccessTest |
| GET /admin/users | admin/user/index.html.twig | admin.css + datatables | datatables-init.js + inline | AdminAccessTest |
| GET /admin/users/{id} | admin/user/show.html.twig | admin.css | — | AdminUserShowLoginHistoryTest |
| GET /admin/users/{id}/edit | admin/user/edit.html.twig | admin.css | — | — |
| GET /admin/logs | admin/log/index.html.twig | admin.css + datatables | admin-log.js | AdminAccessTest |
| GET /admin/analytics/users | admin/analytics/users.html.twig | admin.css | Chart.js CDN + inline | SavingProductReferenceAdminTest (indirect) |
| GET /admin/analytics/registrations | admin/analytics/registration.html.twig | admin.css + datatables | Chart.js CDN + admin-analytics.js + inline | — |
| GET /admin/analytics/logins | admin/analytics/logins.html.twig | admin.css + datatables | Chart.js CDN + inline | — |
| GET /admin/analytics/errors | admin/analytics/errors.html.twig | admin.css + datatables | Chart.js CDN + inline | — |
| GET /admin/security-events | admin/security_event/index.html.twig | admin.css + inline `<style>` | — | AdminUserSecurityEventTest · SecurityEventAdminTest |
| GET /admin/settings | admin/settings/edit.html.twig | admin.css | — | — |
| GET /admin/legal-settings | admin/legal_settings/edit.html.twig | admin.css | — | LegalSettingsAdminTest |
| GET /admin/powens-category-mappings | admin/powens_category_mapping/index.html.twig | admin.css | — | — |
| GET /admin/powens-debug | admin/powens_debug/index.html.twig | admin.css | — | — |
| GET /admin/saving-products | admin/saving_product_reference/index.html.twig | admin.css + datatables | — | SavingProductReferenceAdminTest |
| GET /admin/design-system | admin/design_system/index.html.twig | admin.css | — | DesignSystemAdminTest |
| GET /admin/ui-preview | admin/ui_preview/index.html.twig | admin.css | — | — |

**Contrôleurs (15)** : DashboardController · UserController · LogController · LoginAnalyticsController · RegistrationAnalyticsController · UserAnalyticsController · ErrorAnalyticsController · SecurityEventController · SettingsController · LegalSettingsController · PowensCategoryMappingController · PowensDebugController · SavingProductReferenceController · DesignSystemController · UiPreviewController

**Accès minimum** : ROLE_MODERATOR (lecture globale), ROLE_ADMIN (audit + données + design-system), ROLE_SUPER_ADMIN (settings + legal-settings)

---

## Stratégie

**Option B — Découpage en 4 lots indépendants avec dépendances minimales.**

Justification : admin.css est déjà une couche isolée (835 lignes). Aucun sélecteur admin dans app.css (grep : 0 résultat). La frontière est propre. Les lots peuvent être exécutés dans l'ordre indiqué, chacun avec son propre commit et ses propres tests de validation.

1. **LOT-ADM-1** : tokenisation des couleurs brutes dans admin.css (F12 + F13)
2. **LOT-ADM-2** : extraction CSS orphelin `<style>` inline dans security_event + log
3. **LOT-ADM-3** : mutualisation des règles dark-mode répétées
4. **LOT-ADM-4** : tests structurels inline code contracts

Pas de LOT-ADM-0 : app.css ne contient AUCUN sélecteur admin.

---

## Architecture CSS

### Frontière app.css / admin.css
- **Résultat grep** : AUCUNE occurrence admin dans app.css — frontière 100% propre.
- admin.css chargé exclusivement via `layouts/admin.html.twig` (ligne 32).
- report/export/todo ne chargent PAS admin.css — zéro consommateurs partagés.

### Chaîne de chargement dans admin.html.twig
```
colors_and_type.css  →  styles.css  →  app.css  →  components.css  →  admin.css  →  [datatables_css]
```

### Token --bx-app-bg-2 — ALERTE
Le token `--bx-app-bg-2` est utilisé dans le bloc `<style>` inline de `security_event/index.html.twig`
mais n'est **défini nulle part** dans la chaîne CSS (ni colors_and_type.css, ni app.css, ni components.css).
Lors de l'extraction LOT-ADM-2, remplacer `var(--bx-app-bg-2)` par `var(--bx-app-surface-2)` (token existant, valeur sémantiquement identique).

### Règles mortes
Aucune règle morte identifiée. Les 835 lignes sont toutes actives et référencées dans les templates.

### Doublons confirmés (audit ligne par ligne)
- `.bx-kpi-help` dark : 3 occurrences distinctes (lignes 288, 309, 380-383) — candidat LOT-ADM-3
- `.list-group-item` dark : 4 occurrences (lignes 452-456, 480-484, 490-494, 594-598) — candidat LOT-ADM-3
- `.bx-kpi-card:hover { transform:none !important }` : 4 occurrences (lignes 65, 286, 307, 374-377) — candidat LOT-ADM-3

### Décomposition LOT-ADM-2 (audit 2026-06-14)

**security_event/index.html.twig** :
- Bloc `<style>` : lignes 23 à 40 inclus = **18 lignes**
- Sélecteurs extraits (16) : `.bx-se-table`, `.bx-se-th`, `.bx-se-time`, `.bx-se-meta-toggle`, `.bx-se-meta-pre`, `.bx-se-critical > td:first-child`, `.bx-se-critical`, `.bx-se-warning`, `.bx-se-filter-bar`, `.bx-icon-badge`, `.bx-icon-vis`, `.bx-se-card-hd`, `.bx-se-icon-pill`, `.bx-se-icon-pill .material-icons-outlined`, `.bx-se-card-title`, `.bx-se-card-sub`
- Occurrences `--bx-app-bg-2` :
  - Ligne 28 : `.bx-se-meta-pre` → propriété `background` → remplacer par `var(--bx-app-surface-2)`
  - Ligne 32 : `.bx-se-filter-bar` → propriété `background` → remplacer par `var(--bx-app-surface-2)`

**log/index.html.twig** :
- Bloc `<style>` : lignes 34 à 36 inclus = **3 lignes**
- Sélecteur extrait (1) : `.bx-th { letter-spacing: .04em; }`

**Calcul admin.css après LOT-ADM-2** :
- Lignes ajoutées (bloc security_event) : 1 blank + 2 lignes commentaire + 1 `*/` + 14 règles CSS + 1 blank = **19 lignes**
- Lignes ajoutées (bloc log) : 1 ligne commentaire + 1 règle `.bx-th` = **2 lignes**
- Note : le code fourni dans LOT-ADM-2 commence par une ligne blank avant le commentaire, comptée → total **23 lignes ajoutées** (1+2+1+14+1+1+1+1+1 = recompte sur le code fourni dans la section LOT-ADM-2 : 23 lignes exactes)
- Delta net admin.css = **+23 lignes**
- **Taille finale admin.css après LOT-ADM-2 : 858 lignes** (835 + 23)

### DataTables overrides
- Pas de sélecteur `.dataTables_*` ou `.dt-*` dans admin.css.
- DataTables initialisé via `data-datatable` + `datatables-init.js` (external).
- `.bx-log-table`, `.bx-breakdown-table`, `.bx-sessions-table`, `.bx-history-table`, `.bx-network-table` : styles de taille police sur les tables — à conserver.
- `.d-none-xs` (ligne 729) : utilitaire responsive DataTables — à conserver.

---

## Frontière Admin / Report / Export

- `templates/report/` : ne charge PAS admin.css. Zéro classe bx-admin-* utilisée.
- `templates/export/` : ne charge PAS admin.css. Zéro classe bx-admin-* utilisée.
- `templates/todo/` : ne charge PAS admin.css.
- **Décision** : aucune règle partagée à gérer. Périmètre admin est étanche.

---

## CATALOGUE F12 — Couleurs brutes dans admin.css

**Méthode de classification :**
- AUTO-DELTA : rgba/hex remplaçable par token existant (delta de perception documenté)
- CONSERVER : valeur intentionnelle sans token équivalent fonctionnel
- ARBITRAGE : décision documentée, recommandation CONSERVER

### Occurrences actionnables (AUTO-DELTA)

| ID | Ligne | Sélecteur | Propriété | Avant | Après | Token | Thème | Delta |
|---|---|---|---|---|---|---|---|---|
| C1 | 12 | .bx-kpi-card | border | rgba(0,0,0,.07) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C2 | 62 | .bx-admin-dashboard .bx-kpi-card | border-color | rgba(15,23,42,0.08) | var(--bx-admin-sep) | via custom prop | light | déjà lié à sep |
| C3 | 70 | .bx-admin-dashboard .bx-period-bar | border-color | rgba(15,23,42,0.08) | var(--bx-admin-sep) | via custom prop | light | déjà lié à sep |
| C4 | 96 | html[dark] .bx-admin-dashboard .bx-quick-card | border-color | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C5 | 100 | html[dark] .bx-admin-dashboard .bx-quick-card:hover | background | rgba(255,255,255,0.06) | var(--bx-app-hover) | --bx-app-hover | dark | = valeur dark du token |
| C6 | 108 | .bx-health-row | border-bottom | rgba(0,0,0,.05) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C7 | 156 | .bx-wp-danger | background | rgba(220,38,38,.06) | rgba(var(--bs-danger-rgb),.06) | --bs-danger-rgb | both | parité exacte |
| C8 | 156 | .bx-wp-danger | border | rgba(220,38,38,.15) | rgba(var(--bs-danger-rgb),.15) | --bs-danger-rgb | both | parité exacte |
| C9 | 157 | .bx-wp-warning | background | rgba(245,158,11,.06) | rgba(var(--bs-warning-rgb),.06) | --bs-warning-rgb | both | parité exacte |
| C10 | 157 | .bx-wp-warning | border | rgba(245,158,11,.15) | rgba(var(--bs-warning-rgb),.15) | --bs-warning-rgb | both | parité exacte |
| C11 | 158 | .bx-wp-info | background | rgba(6,182,212,.06) | rgba(var(--bs-info-rgb),.06) | --bs-info-rgb | both | parité exacte |
| C12 | 158 | .bx-wp-info | border | rgba(6,182,212,.15) | rgba(var(--bs-info-rgb),.15) | --bs-info-rgb | both | parité exacte |
| C13 | 159 | .bx-wp-success | background | rgba(34,197,94,.06) | rgba(var(--bs-success-rgb),.06) | --bs-success-rgb | both | parité exacte |
| C14 | 159 | .bx-wp-success | border | rgba(34,197,94,.15) | rgba(var(--bs-success-rgb),.15) | --bs-success-rgb | both | parité exacte |
| C15 | 162 | .bx-quick-card | border | rgba(0,0,0,.08) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C16 | 190 | .bx-quick-icon--success | background | rgba(34,197,94,.1) | rgba(var(--bs-success-rgb),.1) | --bs-success-rgb | both | parité exacte |
| C17 | 192 | .bx-quick-icon--danger | background | rgba(220,38,38,.1) | rgba(var(--bs-danger-rgb),.1) | --bs-danger-rgb | both | parité exacte |
| C18 | 194 | .bx-quick-icon--info | background | rgba(6,182,212,.1) | rgba(var(--bs-info-rgb),.1) | --bs-info-rgb | both | parité exacte |
| C19 | 195 | .bx-quick-icon--neutral | background | rgba(100,116,139,.1) | rgba(var(--bx-slate-500),.1) | --bx-slate-500 | both | #64748b = var valeur |
| C20 | 265 | html[dark] .bx-admin-users .bx-log-filter.active | color | #111827 | var(--bx-slate-900) | --bx-slate-900 | dark | delta +5 bleu (#0f172a vs #111827) |
| C21 | 283 | html[dark] .bx-admin-logs .bx-log-filter.active | color | #111827 | var(--bx-slate-900) | --bx-slate-900 | dark | delta +5 bleu |
| C22 | 302 | .bx-admin-logs .bx-log-sensitive | background | rgba(239,68,68,.04) | rgba(var(--bs-danger-rgb),.04) | --bs-danger-rgb | both | parité exacte |
| C23 | 398 | .bx-dist-bar | background | rgba(0,0,0,.07) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C24 | 423 | .bx-signal-link | background | rgba(59,130,246,.1) | rgba(var(--bs-primary-rgb),.1) | --bs-primary-rgb | both | parité exacte |
| C25 | 428 | .bx-signal-link:hover | background | rgba(59,130,246,.18) | rgba(var(--bs-primary-rgb),.18) | --bs-primary-rgb | both | parité exacte |
| C26 | 433 | .bx-2fa-progress | background | rgba(0,0,0,.08) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C27 | 444 | html[dark] .bx-admin-analytics-users .bx-dist-bar | background | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C28 | 448 | html[dark] .bx-admin-analytics-users .bx-2fa-progress | background | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C29 | 453 | html[dark] .bx-admin-analytics-users .list-group-item | background-color | #1e1e1e | var(--bx-app-surface) | --bx-app-surface | dark | #1a2030 vs #1e1e1e — delta gris/bleu |
| C30 | 480 | html[dark] .bx-admin-analytics-registration .list-group-item | background-color | #1e1e1e | var(--bx-app-surface) | --bx-app-surface | dark | idem C29 |
| C31 | 490 | html[dark] .bx-admin-analytics-logins .list-group-item | background-color | #1e1e1e | var(--bx-app-surface) | --bx-app-surface | dark | idem C29 |
| C32 | 499 | .bx-top5-bar | background | rgba(0,0,0,.07) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C33 | 549 | .bx-risk-high | background | rgba(239,68,68,.12) | rgba(var(--bs-danger-rgb),.12) | --bs-danger-rgb | both | parité exacte |
| C34 | 551 | .bx-risk-medium | background | rgba(245,158,11,.12) | rgba(var(--bs-warning-rgb),.12) | --bs-warning-rgb | both | parité exacte |
| C35 | 553 | .bx-risk-low | background | rgba(34,197,94,.12) | rgba(var(--bs-success-rgb),.12) | --bs-success-rgb | both | parité exacte |
| C36 | 591 | html[dark] .bx-admin-analytics-errors .bx-bar-track | background | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C37 | 595 | html[dark] .bx-admin-analytics-errors .list-group-item | background-color | #1e1e1e | var(--bx-app-surface) | --bx-app-surface | dark | idem C29 |
| C38 | 602 | .bx-bar-track | background | rgba(0,0,0,.07) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C39 | 610 | .bx-sev-critical | background | rgba(220,38,38,.12) | rgba(var(--bs-danger-rgb),.12) | --bs-danger-rgb | both | parité exacte |
| C40 | 611 | .bx-sev-error | background | rgba(239,68,68,.12) | rgba(var(--bs-danger-rgb),.12) | --bs-danger-rgb | both | parité exacte |
| C41 | 613 | .bx-sev-info | background | rgba(6,182,212,.12) | rgba(var(--bs-info-rgb),.12) | --bs-info-rgb | both | parité exacte |
| C42 | 615 | .bx-http-5xx | background | rgba(220,38,38,.12) | rgba(var(--bs-danger-rgb),.12) | --bs-danger-rgb | both | parité exacte |
| C43 | 616 | .bx-http-ok | background | rgba(34,197,94,.12) | rgba(var(--bs-success-rgb),.12) | --bs-success-rgb | both | parité exacte |
| C44 | 634 | .bx-event-row | border-bottom | rgba(0,0,0,.05) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C45 | 653 | .bx-stat-row | border-bottom | rgba(0,0,0,.05) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C46 | 661 | .bx-stat-online | border-top | rgba(0,0,0,.06) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C47 | 712 | .bx-section-divider::after | background | rgba(0,0,0,.08) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C48 | 717 | .bx-period-bar | background | rgba(0,0,0,.03) | var(--bx-app-surface-2) | --bx-app-surface-2 | light | très subtil |
| C49 | 718 | .bx-period-bar | border | rgba(0,0,0,.07) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C50 | 723 | .bx-custom-range | border-top | rgba(0,0,0,.07) | var(--bx-app-border) | --bx-app-border | light | ~3% opacité |
| C51 | 820 | html[dark] .bx-section-divider::after | background | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C52 | 823 | html[dark] .bx-bar-track | background | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C53 | 828 | html[dark] .bx-period-bar | border-color | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C54 | 831 | html[dark] .bx-custom-range | border-top-color | rgba(255,255,255,0.12) | var(--bx-app-border) | --bx-app-border | dark | = valeur dark du token |
| C55 | 834 | html[dark] .bx-section-title | color | rgba(255,255,255,0.54) | var(--bx-app-fg-3) | --bx-app-fg-3 | dark | #94a3b8 vs rgba(.54) — delta visible |

**Total AUTO-DELTA actionnables : 55 substitutions**

### Occurrences CONSERVER (F12)

| ID | Ligne | Sélecteur | Propriété | Valeur | Raison |
|---|---|---|---|---|---|
| V1 | 27 | .bx-kpi-border-purple | border-left | #a855f7 | Bootstrap 5 manque purple sémantique |
| V2 | 28 | .bx-kpi-border-orange | border-left | #f97316 | Bootstrap 5 manque orange sémantique |
| V3 | 58 | .bx-admin-dashboard | --bx-admin-sep | rgba(15,23,42,0.08) | custom prop light, calibrée intentionnellement |
| V4 | 70 | .bx-admin-dashboard .bx-period-bar | background | rgba(15,23,42,0.03) | très subtil, pas de token équivalent 0.03 |
| V5 | 87 | html[dark] .bx-admin-dashboard | --bx-admin-sep | rgba(255,255,255,0.14) | calibrée (.14 > .12 standard) intentionnellement |
| V6 | 92 | html[dark] .bx-admin-dashboard .bx-period-bar | border-color | rgba(255,255,255,0.12) | cohérent avec --bx-app-border dark (doublon C4 — résolu via custom prop) |
| V7 | 193 | .bx-quick-icon--purple | background | rgba(168,85,247,.1) | cohérence purple sans token BS |
| V8 | 207 | .bx-log-filter | border | rgba(255,255,255,.4) | obligatoire sur fond bg-primary opaque |
| V9 | 208 | .bx-log-filter | background | rgba(255,255,255,.1) | idem — fond bg-primary |
| V10 | 209 | .bx-log-filter | color | rgba(255,255,255,.85) | idem — fond bg-primary |
| V11 | 217 | .bx-log-filter:hover | color | #fff | blanc pur intentionnel sur bg-primary |
| V12 | 229 | .bx-log-filter.active | background | #fff | blanc pur intentionnel |
| V13 | 521 | .bx-chart-legend-label | color | rgba(255,255,255,.75) | toujours sur fond sombre (card-header bg-primary) |
| V14 | 550 | .bx-risk-medium | color | #d97706 | amber-600 — Bootstrap warning (#ffc107) trop clair |
| V15 | 552 | .bx-risk-low | color | #16a34a | green-600 — Bootstrap success (#198754) légèrement différent |
| V16 | 557 | .bx-sev-warning | background | rgba(245,158,11,.12) | sans équivalent BS strict |
| V17 | 557 | .bx-sev-warning | color | #d97706 | amber-600 non tokenisé |
| V18 | 558 | .bx-sev-error | color | #b91c1c | rouge foncé distinct de critique (#dc2626) |
| V19 | 559 | .bx-sev-info | color | #0891b2 | cyan-600 distinct |
| V20 | 560 | .bx-http-4xx | background | rgba(249,115,22,.12) | orange-400 non tokenisé Bootstrap |
| V21 | 560 | .bx-http-4xx | color | #c2410c | orange-700 non tokenisé |
| V22 | 562 | .bx-http-ok | color | #16a34a | green-600 (idem V15) |
| V23 | 563 | .bx-evolution-down | color | #16a34a | green-600 (idem) |
| V24 | 691 | .bx-user-dot-purple | background | #a855f7 | cohérence purple (idem V1) |

**Total CONSERVER : 24 valeurs**

### Arbitrages — DÉCISIONS OFFICIELLES (clôturées 2026-06-14)

**ARBITRAGES RESTANTS : 0**

Les 4 arbitrages ont été tranchés officiellement et reclassés en CONSERVER (V25-V28) :

| ID ancien | ID nouveau | Ligne | Sélecteur | Propriété | Valeur | Décision officielle | Justification |
|---|---|---|---|---|---|---|---|
| ARB1 | V25 | 173 | .bx-quick-card:hover | box-shadow | 0 2px 12px rgba(0,0,0,.07) | CONSERVER | Delta spread 2px→1px, blur 12px→2px vs --bx-shadow-xs : ombre délibérément plus prononcée |
| ARB2 | V26 | 548 | .bx-risk-high | color | #dc2626 | CONSERVER | Cohérence palette Chart.js ; delta #dc2626 vs #d32f2f imperceptible en pratique |
| ARB3 | V27 | 610 | .bx-sev-critical | color | #dc2626 | CONSERVER | Même raisonnement qu'ARB2 |
| ARB4 | V28 | 617 | .bx-evolution-up | color | #dc2626 | CONSERVER | Rouge danger intentionnel — sémantique métier : hausse d'erreurs = danger |

**Récapitulatif F12 :**
- AUTO-DELTA actionnables : 55
- CONSERVER (V1-V28) : **28** (24 initiaux + 4 arbitrages reclassés)
- ARBITRAGE restants : **0**
- **Total F12 dans admin.css : 83 occurrences**

Note : le chiffre 88 du manifeste initial incluait certaines valeurs F13 (border-radius, font-size). Après séparation stricte F12/F13, le total F12 réel est 83.

---

## CATALOGUE F13 — Dimensions dans admin.css

**Critère** : border-radius et font-size uniquement (actionnables). Les autres dimensions (letter-spacing, line-height, width/height fixes sémantiques) sont CONSERVER.

### Substitutions AUTO (correspondance exacte token disponible)

| ID | Ligne | Sélecteur | Propriété | Avant | Après | Token | Parité |
|---|---|---|---|---|---|---|---|
| D1 | 11 | .bx-kpi-card | border-radius | .625rem | var(--bx-radius-md) | --bx-radius-md = 0.625rem | exacte |
| D2 | 49 | .bx-kpi-unit | font-size | 1rem | var(--bx-fs-body) | --bx-fs-body = 1rem | exacte |
| D3 | 130 | .bx-health-open-link | border-radius | .4rem | var(--bx-radius-sm) | --bx-radius-sm = 0.4rem | exacte |
| D4 | 146 | .bx-watchpoint | border-radius | .5rem | var(--bx-radius) | --bx-radius = 0.5rem | exacte |
| D5 | 161 | .bx-quick-card | border-radius | .5rem | var(--bx-radius) | --bx-radius = 0.5rem | exacte |
| D6 | 180 | .bx-quick-icon | border-radius | .4rem | var(--bx-radius-sm) | --bx-radius-sm = 0.4rem | exacte |
| D7 | 417 | .bx-signal-link | border-radius | .5rem | var(--bx-radius) | --bx-radius = 0.5rem | exacte |
| D8 | 621 | .bx-insight | border-radius | .5rem | var(--bx-radius) | --bx-radius = 0.5rem | exacte |
| D9 | 242 | .bx-pill-badge | border-radius | 1rem | var(--bx-radius-xl) | --bx-radius-xl = 1rem | exacte |

**Total substitutions F13 AUTO : 9**

Note D8 : le sélecteur `.bx-insight` démarre ligne 620, la déclaration `border-radius` est ligne 621 — convention manifeste = ligne de déclaration.
Note D9 : `.bx-pill-badge border-radius: 1rem` (ligne 242) a été omis dans l'audit du 2026-06-14. `--bx-radius-xl = 1rem` est une correspondance exacte (badge sémantique). Restauré le 2026-06-15. Les nombreuses occurrences de `.72rem` (≡ `--bx-fs-xxs`) et `.78rem` (≡ `--bx-fs-xs`) sont hors périmètre — typographie utilitaire relevante d'un chantier séparé. `.bx-watchpoint-icon font-size: 1rem` (ligne 152) est exclu : sémantique icon-sizing, pas typographique.
**Total LOT-ADM-1 : 64 opérations** (55 F12 + 9 F13).

### Valeurs CONSERVER F13

| ID | Ligne | Sélecteur | Propriété | Valeur | Raison |
|---|---|---|---|---|---|
| F1 | 33 | .bx-kpi-label | font-size | .67rem | volontairement < fs-xxs (0.72rem) — lecture compressée KPI |
| F2 | 35 | .bx-kpi-label | letter-spacing | .08em | > tracking-wide (0.07em) — intentionnel |
| F3 | 42 | .bx-kpi-value-lg | font-size | 1.9rem | entre font-2xl et font-3xl — valeur délibérée |
| F4 | 45 | .bx-kpi-value-lg | letter-spacing | -.02em | delta vs tracking-snug (-.025em) — intentionnel |
| F5 | 113 | .bx-health-dot | width/height | 8px | valeur sémantique fixe (dot graphique) |

**Total CONSERVER F13 : 5**

---

## Tableaux et filtres

- **adminLogsTable** (id) : DataTables via `data-datatable`, filtrage par `data-action-cat` sur TR, piloté par admin-log.js. Pattern solide.
- **adminUsersTable** (id) : DataTables via `data-datatable`, filtrage par `column(1).search()` sur data-search. Inline JS dans le template.
- **breakdownTable** (id) : DataTables via `data-datatable` dans analytics/registration. Inline JS.
- Responsive : colonnes cachées via `.d-none .d-sm-table-cell`, `.d-none .d-md-table-cell`, `.d-none .d-lg-table-cell`, `.d-none .d-xl-table-cell`.
- `.d-none-xs` dans admin.css (ligne 729-730) : custom xs breakpoint (< 576px show table-cell).
- Export DataTables : `data-dt-export="copy,csv,excel,pdf,print"` sur adminLogsTable et breakdownTable.

---

## Actions sensibles et modales

| # | Template | Modale/Formulaire | Action | Méthode | CSRF | Rôle requis |
|---|---|---|---|---|---|---|
| M1 | admin/user/show.html.twig | #avatarDeleteModal | Suppression photo profil | POST /admin/users/{id}/avatar/delete | `admin_avatar_delete_{id}` | ROLE_ADMIN |
| M2 | admin/user/show.html.twig | form inline | Renvoyer email confirmation | POST /admin/users/{id}/resend-verification | `admin_resend_{id}` | admin_user_resend_verification voter |
| M3 | admin/user/show.html.twig | form inline | Reset mot de passe | POST /admin/users/{id}/send-reset | `admin_send_reset_{id}` | admin_user_send_reset voter |
| M4 | admin/user/show.html.twig | form inline | Changer le rôle | POST /admin/users/{id}/role | `admin_role_{id}` | admin_user_change_role voter |
| M5 | admin/user/show.html.twig | form inline | Suspendre | POST /admin/users/{id}/suspend | `admin_suspend_{id}` | admin_user_suspend voter |
| M6 | admin/user/show.html.twig | form inline | Réactiver | POST /admin/users/{id}/activate | `admin_activate_{id}` | admin_user_suspend voter |
| M7 | admin/user/show.html.twig | a href | Impersonate | GET /app?_switch_user=email | — | CAN_SWITCH_USER voter |
| M8 | layouts/admin.html.twig | onclick JS | Déconnexion | POST /logout | `logout` | — |

**Observation** : Toutes les actions destructives ont un token CSRF distinct. La modale #avatarDeleteModal est la seule modale Bootstrap utilisée dans le module admin. Les formulaires de suspension/activation/rôle sont inline sans confirmation modale — acceptable pour l'admin (traçabilité via AdminLog).

---

## Analytics et graphiques

### Chart.js — inventaire complet

| # | Template | Canvas ID | Type | Données source | Couleurs | Destroy/recreate |
|---|---|---|---|---|---|---|
| C1 | dashboard/index | db-activity-chart | line (3 séries) | `<script type="application/json">` | #3b82f6, #22c55e, #ef4444 | Non (single init) |
| C2 | dashboard/index | db-incident-chart | bar horizontal | `<script type="application/json">` | incidentColors (dynamique PHP) | Non |
| C3 | analytics/users | chart-reg-daily | bar | inline Twig `{{ }}` | rgba(59,130,246,.65) | Non |
| C4 | analytics/users | chart-reg-monthly | bar | inline Twig `{{ }}` | rgba(34,197,94,.65) | Non |
| C5 | analytics/users | chart-statuts | doughnut | inline Twig `{{ }}` | #22c55e, #f59e0b, #ef4444 | Non |
| C6 | analytics/users | chart-roles | doughnut | inline Twig `{{ }}` | #64748b, #06b6d4, #3b82f6, #ef4444 | Non |
| C7 | analytics/registration | regErrorTrendChart | line (multi-dataset) | `<script type="application/json">` | via datasets (PHP) | Non |
| C8 | analytics/registration | fieldChart | bar horizontal | `<script type="application/json">` | rgba(245,158,11,.65) | Non |
| C9 | analytics/registration | ruleChart | bar horizontal | `<script type="application/json">` | ruleColors (PHP) | Non |
| C10 | analytics/registration | attemptsChart | bar empilé | `<script type="application/json">` | rgba(34,197,94,.7), rgba(239,68,68,.7) | Non |
| C11 | analytics/registration | failureRateChart | line | `<script type="application/json">` | #ef4444 | Non |
| C12 | analytics/registration | hourlyChart | bar | `<script type="application/json">` | rgba(59,130,246,.55/.25) | Non |
| C13 | analytics/registration | dowChart | bar | `<script type="application/json">` | rgba(168,85,247,.35/.6) | Non |
| C14 | analytics/logins | (multiples) | line/bar | `<script type="application/json">` | BS + hex | Non |
| C15 | analytics/errors | (multiples) | line/bar/doughnut | `<script type="application/json">` | BS + hex | Non |
| C16 | dashboard/index | adminRegistrationsChart | bar + gradient | `<script type="application/json">` via admin-registrations-chart.js | #6366f1 | Non |

**Observations** :
- Pattern data-injection sûr : `<script type="application/json">` + `JSON.parse()` — pas d'XSS.
- Aucun `innerHTML` ou `insertAdjacentHTML` dans les scripts analytics (sauf admin-analytics.js légende : DOM API createElement, sûr).
- Aucun destroy/recreate Chart (pas de risque de listener multiple).
- `window.addEventListener` non utilisé — DOMContentLoaded via IIFE.

---

## Données et sécurité

- Routes admin : toutes protégées par `#[IsGranted('ROLE_MODERATOR')]` minimum sur le contrôleur, avec granularité voter sur les actions sensibles.
- CSRF : systématique sur toutes les mutations POST.
- Impersonation : protégée par `CAN_SWITCH_USER` voter + guard `not is_granted('IS_IMPERSONATOR')`.
- Données JSON dans `<script type="application/json">` : pattern safe (non exécutable).
- `eval` : absent.
- `innerHTML` : utilisé dans admin-analytics.js uniquement via `createElement` (safe DOM API).
- Aucun `window.*` globaux exposés.
- Powens debug : avertissement affiché en clair dans le template (données sensibles financières — accès ROLE_ADMIN).

---

## Responsive (media queries)

admin.css contient 7 blocs `@media` :

| Breakpoint | Règles | Cibles |
|---|---|---|
| max-width: 575.98px | 4 | .bx-log-filter nowrap, .bx-period-actions .btn width:100% |
| max-width: 767.98px | 6 blocs | .bx-kpi-value-lg réduit, .bx-watchpoint, .bx-health-row, .bx-period-*, .bx-dist-legend, .bx-custom-form, .bx-section-title, .bx-event-row, .bx-signal-* |
| min-width: 576px | 1 | .d-none-xs → display:table-cell |

Couverture mobile correcte. Aucun breakpoint lg/xl dans admin.css (géré par Bootstrap grid dans les templates).

---

## Tests existants et manquants

### Existants
- `AdminAccessTest` : 7 tests RBAC (guest, user, moderator, admin, super-admin)
- `AdminUserSecurityEventTest` : actions sensibles (suspend, activate, role, avatar)
- `AdminUserShowLoginHistoryTest` : affichage historique connexions
- `AppDataIsolationTest` : isolation entre comptes
- `LegalSettingsAdminTest` : paramètres légaux
- `SecurityEventAdminTest` : événements sécurité
- `DesignSystemAdminTest` : accès /admin/design-system
- `SavingProductReferenceAdminTest` : produits d'épargne

### Manquants (candidats LOT-ADM-4)
- Test structurel inline code `admin/dashboard/index.html.twig` : vérifier présence `.bx-admin-dashboard`, `.bx-kpi-card`, `.bx-section-divider`, JSON blocks
- Test structurel inline code `admin/log/index.html.twig` : vérifier `.bx-admin-logs`, `.bx-log-filter`, `adminLogsTable`
- Test structurel inline code `admin/analytics/users.html.twig` : vérifier `.bx-admin-analytics-users`, canvas IDs
- Test structurel inline code `admin/user/index.html.twig` : vérifier `.bx-admin-users`, `.bx-log-filter`, `adminUsersTable`

---

## Lots autonomes

---

### LOT-ADM-1 — Tokenisation des couleurs brutes et border-radius dans admin.css

**Classification** : AUTO-DELTA (couleurs) + AUTO (dimensions)

**Motivation** : 83 occurrences de couleurs brutes (rgba/hex) dans admin.css. 8 occurrences de border-radius remplaçables par tokens exacts. 55 substitutions couleur actionnables (C1-C55). 24 valeurs CONSERVER. 4 arbitrages CONSERVER.

**Fichiers autorisés** :
- `public/css/admin.css`

**Fichiers interdits** :
- `public/css/app.css`, `public/css/styles.css`, `public/css/components.css`, `public/css/colors_and_type.css`
- Tous les fichiers `templates/`
- Tous les fichiers `public/js/`
- Tous les modules figés

**Compteurs exacts** :
- 55 substitutions AUTO-DELTA couleurs (C1-C55)
- 9 substitutions AUTO dimensions (D1-D9 : 8 border-radius + 1 font-size)
- **Total modifications : 64 déclarations remplacées**
- Lignes admin.css modifiées : ~63 (1 déclaration par ligne)
- Lignes supprimées : 0 (remplacement in-place)
- Lignes ajoutées : 0
- Taille finale admin.css après LOT-ADM-1 : 835 lignes (inchangé — remplacements in-place)

**Substitutions couleurs (C1-C55)** : voir CATALOGUE F12 ci-dessus.

**Substitutions dimensions (D1-D8)** : voir CATALOGUE F13 ci-dessus.

**Substitutions dimensions (D1-D9)** : voir CATALOGUE F13 ci-dessus.

**Valeurs CONSERVER** : V1-V28 (couleurs, dont V25-V28 = ex-ARB1-ARB4) + F1-F5 (dimensions)

**Condition d'arrêt** :
```bash
grep -c "rgba(0,0,0,\." public/css/admin.css
```
Doit retourner ≤ 3 (uniquement les valeurs CONSERVER : rgba(0,0,0,.03) period-bar bg, rgba(0,0,0,.04) quick-card hover, rgba(0,0,0,.06) stat-online).

```bash
grep -c "border-radius: \.[0-9]" public/css/admin.css
```
Doit retourner 0 (toutes les border-radius décimales remplacées par var()).

**Tests** :
```bash
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/AdminAccessTest.php --no-coverage
php -d memory_limit=1G bin/phpunit tests/Domain/Admin/ --no-coverage
```

**Commit** :
```
refactor(admin): tokenise rgba/hex colors and border-radius values in admin.css
```

**Dépendances** : aucune — premier lot

---

### LOT-ADM-2 — Extraction CSS orphelin `<style>` inline

**Classification** : AUTO

**Motivation** :
1. `admin/security_event/index.html.twig` contient un bloc `<style>` (lignes 23-40) avec 14 règles CSS inline dans `{% block stylesheets %}`.
2. `admin/log/index.html.twig` contient un bloc `<style>` (lignes 34-36) avec 1 règle CSS (`.bx-th { letter-spacing: .04em; }`).

**ALERTE token manquant** : les règles `bx-se-meta-pre` et `bx-se-filter-bar` utilisent `var(--bx-app-bg-2)` qui n'existe pas dans la chaîne CSS. Lors de l'extraction, remplacer `var(--bx-app-bg-2)` par `var(--bx-app-surface-2)` (défini dans colors_and_type.css, valeur sémantiquement identique).

**Fichiers autorisés** :
- `public/css/admin.css`
- `templates/admin/security_event/index.html.twig`
- `templates/admin/log/index.html.twig`

**Fichiers interdits** : tous les autres

**Compteurs exacts** :
- security_event/index.html.twig : bloc `<style>` lignes 23-40 inclus = **18 lignes** à supprimer (+ supprimer `{% block stylesheets %}` et `{% endblock %}` si vides après)
- log/index.html.twig : bloc `<style>` lignes 34-36 = **3 lignes** à supprimer
- Lignes supprimées dans security_event : 18 (le bloc style complet)
- Lignes supprimées dans log : 3 (le bloc style complet)
- Lignes ajoutées dans admin.css : **23 lignes** (1 blank + commentaire 3L + 16 règles security_event + 1 blank + commentaire 1L + 1 règle log)
- Delta net admin.css : **+23 lignes**
- Taille finale admin.css après LOT-ADM-2 : **858 lignes** (835 + 23)

**Code à ajouter à la fin de admin.css** (après ligne 835) :
```css

/* Admin Security Events
 * Extrait depuis security_event/index.html.twig - LOT-ADM-2
 */
.bx-se-table    { font-size: .84rem; width: 100%; }
.bx-se-th       { letter-spacing: .04em; }
.bx-se-time     { font-size: .78rem; }
.bx-se-meta-toggle { font-size: .76rem; cursor: pointer; color: var(--bx-app-accent-on); text-decoration: underline; text-underline-offset: 2px; }
.bx-se-meta-pre { font-size: .73rem; margin: .4rem 0 0; white-space: pre-wrap; word-break: break-all; background: var(--bx-app-surface-2); border: 1px solid var(--bx-app-border); border-radius: var(--bx-radius-sm); padding: .5rem .75rem; max-height: 180px; overflow-y: auto; }
.bx-se-critical > td:first-child { box-shadow: inset 3px 0 0 var(--bs-danger); }
.bx-se-critical { background: rgba(239,68,68,.04) !important; }
.bx-se-warning  { background: rgba(234,179,8,.03) !important; }
.bx-se-filter-bar { background: var(--bx-app-surface-2); border: 1px solid var(--bx-app-border); border-radius: var(--bx-radius-md); padding: 1rem 1.25rem; margin-bottom: 1.5rem; }
.bx-icon-badge { font-size: .8rem;  line-height: 1; }
.bx-icon-vis   { font-size: .75rem; line-height: 1; }
.bx-se-card-hd   { background: var(--bx-app-surface); border-bottom: 1px solid var(--bx-app-border) !important; }
.bx-se-icon-pill { display: flex; align-items: center; justify-content: center; width: 2rem; height: 2rem; border-radius: var(--bx-radius-sm); background: var(--bx-app-accent-tint); color: var(--bx-app-accent-on); flex-shrink: 0; }
.bx-se-icon-pill .material-icons-outlined { font-size: 1rem; line-height: 1; }
.bx-se-card-title { color: var(--bx-app-fg); font-weight: 500; }
.bx-se-card-sub   { color: var(--bx-app-fg-3); margin-top: .15rem; }

/* Admin Logs — inline extraction - LOT-ADM-2 */
.bx-th { letter-spacing: .04em; }
```

Note : `.bx-se-critical` et `.bx-se-warning` conservent leurs rgba brutes (couleurs sémantiques sans token BS équivalent — à gérer dans une campagne future si tokenisation BS étendue).

Note : `.bx-th` est distinct de `.bx-th-compact` (ligne 537) qui ajoute `white-space: nowrap`. Les deux coexistent sans conflit.

**Modification security_event/index.html.twig** :
Supprimer les lignes 23-40 (bloc `<style>...</style>` complet).
Le bloc `{% block stylesheets %}{% endblock %}` résultant peut être supprimé si vide.

**Modification log/index.html.twig** :
Supprimer les lignes 34-36 (`<style>.bx-th { letter-spacing: .04em; }</style>`).
Garder le `{% include '_partials/_datatables_css.html.twig' %}` (ligne 33).

**Condition d'arrêt** :
```bash
grep -c "<style>" templates/admin/security_event/index.html.twig
grep -c "<style>" templates/admin/log/index.html.twig
```
Les deux doivent retourner 0.

**Tests** :
```bash
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/SecurityEventAdminTest.php --no-coverage
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/AdminAccessTest.php --no-coverage
```

**Commit** :
```
refactor(admin): extract inline <style> blocks from security_event and log templates to admin.css
```

**Dépendances** : peut s'exécuter indépendamment de LOT-ADM-1

---

### LOT-ADM-3 — Mutualisation règles dark-mode répétées

**Classification** : AUTO

**Motivation** :
1. `.bx-kpi-help` dark : 3 occurrences distinctes (lignes 288, 309, 380-383) — delta groupe 1 = 0 net (extension du sélecteur combiné)
2. `.list-group-item` dark : 4 occurrences (lignes 452-456, 480-484, 490-494, 594-598) — delta groupe 2 = -13 lignes nettes
3. `.bx-kpi-card:hover transform:none` : 4 déclarations (lignes 65, 286, 307, 374-377) — delta groupe 3 = 0 net (extension du sélecteur combiné)

**Fichiers autorisés** :
- `public/css/admin.css`

**Fichiers interdits** : tous les autres

**Compteurs exacts** :
- Groupe 1 (kpi-help) : supprimer lignes 288 (1 ligne) + 309 (1 ligne) → intégrer dans le sélecteur combiné lignes 380-383 étendu à 6 contextes (+2 lignes sélecteur). Delta groupe 1 : -2 + 2 = **0 ligne nette**
- Groupe 2 (list-group-item) : supprimer lignes 452-456 (5) + 480-484 (5) + 490-494 (5) + 594-598 (5) = 20 supprimées → 1 sélecteur combiné (4 sélecteurs + 1 accolade + 3 propriétés + 1 accolade = 7 lignes). Delta groupe 2 : -20 + 7 = **-13 lignes**
- Groupe 3 (kpi-card hover) : supprimer lignes 286 (1 ligne) + 307 (1 ligne), étendre le sélecteur combiné existant (374-377) de 4→6 contextes (+2 lignes sélecteur). Delta groupe 3 : -2 + 2 = **0 ligne nette**
- **Delta net total LOT-ADM-3 : -13 lignes** (correction : -17 était erroné)
- Taille finale admin.css après LOT-ADM-3 : **845 lignes** (858 - 13)

**Substitutions détaillées** :

Groupe 1 — kpi-help dark (avant : 3 blocs, après : 1 sélecteur étendu) :
```css
/* Supprimer ligne 288 : */
html[data-theme="dark"] .bx-admin-logs .bx-kpi-help { color: rgba(255, 255, 255, 0.82) !important; }

/* Supprimer ligne 309 : */
html[data-theme="dark"] .bx-admin-users .bx-kpi-help { color: rgba(255, 255, 255, 0.82) !important; }

/* Remplacer lignes 380-383 par : */
html[data-theme="dark"] .bx-admin-logs .bx-kpi-help,
html[data-theme="dark"] .bx-admin-users .bx-kpi-help,
html[data-theme="dark"] .bx-admin-analytics-users .bx-kpi-help,
html[data-theme="dark"] .bx-admin-analytics-registration .bx-kpi-help,
html[data-theme="dark"] .bx-admin-analytics-logins .bx-kpi-help,
html[data-theme="dark"] .bx-admin-analytics-errors .bx-kpi-help { color: rgba(255, 255, 255, 0.82) !important; }
```
Note : `!important` à CONSERVER — override nécessaire sur `.text-muted` Bootstrap en dark mode.

Groupe 2 — list-group-item dark (avant : 4 blocs, après : 1 sélecteur combiné) :
```css
/* Supprimer les 4 blocs (452-456, 480-484, 490-494, 594-598) et les remplacer par : */
html[data-theme="dark"] .bx-admin-analytics-users .list-group-item,
html[data-theme="dark"] .bx-admin-analytics-registration .list-group-item,
html[data-theme="dark"] .bx-admin-analytics-logins .list-group-item,
html[data-theme="dark"] .bx-admin-analytics-errors .list-group-item {
    background-color: var(--bx-app-surface);
    border-color: var(--bx-app-border);
    color: rgba(255, 255, 255, 0.87);
}
```
Note : la tokenisation #1e1e1e → var(--bx-app-surface) est intégrée ici (combinaison avec LOT-ADM-1/C29-C31-C37 si LOT-ADM-3 s'exécute après LOT-ADM-1).

Groupe 3 — kpi-card hover transform:none (avant : lignes 65, 286, 307, 374-377) :
```css
/* Supprimer ligne 286 : */
.bx-admin-logs .bx-kpi-card:hover { transform: none !important; }

/* Supprimer ligne 307 : */
.bx-admin-users .bx-kpi-card:hover { transform: none !important; }

/* Remplacer lignes 374-377 (qui couvrent déjà analytics ×4) — ajouter les 2 contextes manquants : */
.bx-admin-logs .bx-kpi-card:hover,
.bx-admin-users .bx-kpi-card:hover,
.bx-admin-analytics-users .bx-kpi-card:hover,
.bx-admin-analytics-registration .bx-kpi-card:hover,
.bx-admin-analytics-logins .bx-kpi-card:hover,
.bx-admin-analytics-errors .bx-kpi-card:hover { transform: none !important; }
```
Note : `.bx-admin-dashboard .bx-kpi-card:hover` (ligne 65) reste distinct — le dashboard a sa propre logique de contexte.
Note : `!important` à CONSERVER — override du transform:translateY(-2px) de la règle base.

**Condition d'arrêt** :
```bash
grep -c "bx-kpi-help.*rgba(255,255,255,0.82)" public/css/admin.css
```
Doit retourner 1 (sélecteur mutualisé unique).

```bash
grep -c "#1e1e1e" public/css/admin.css
```
Doit retourner 0 (si LOT-ADM-1 exécuté avant) ou 4 (si LOT-ADM-3 exécuté seul — les #1e1e1e sont dans les blocs supprimés).

**Tests** :
```bash
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/AdminAccessTest.php --no-coverage
php -d memory_limit=1G bin/phpunit tests/Domain/Admin/ --no-coverage
```

**Commit** :
```
refactor(admin): merge repeated dark-mode selectors and consolidate kpi-card hover rules
```

**Dépendances** : LOT-ADM-1 recommandé avant (pour que group 2 bénéficie de la tokenisation #1e1e1e → var). Peut s'exécuter indépendamment si LOT-ADM-1 non terminé (les 4 blocs list-group-item avec #1e1e1e seront remplacés par le sélecteur mutualisé avec var() directement).

---

### LOT-ADM-4 — Tests structurels inline code contracts

**Classification** : AUTO

**Motivation** : Ajouter des tests structurels de contrat pour les templates admin principaux, dans la continuité du pattern établi (BudgetInlineCodeTest, DashboardInlineCodeTest). Ces tests vérifient la présence des classes BEM, IDs DataTables, blocs JSON et structures HTML critiques.

**Fichiers autorisés** :
- `tests/Domain/Admin/AdminInlineCodeTest.php` (NOUVEAU fichier à créer)

**Fichiers interdits** : tous les fichiers métier/production

**Compteurs exacts** : 1 fichier, 6 méthodes de test, **36 assertions**

**Méthodes et assertions par méthode** :

| Méthode | assertFileExists (readTemplate) | assertStringContains | assertStringNotContains | Total |
|---|---|---|---|---|
| testDashboardHasRequiredStructure | 1 | 6 | 0 | **7** |
| testUserIndexHasDataTableAndFilters | 1 | 5 | 0 | **6** |
| testLogIndexHasDataTableAndFilters | 1 | 4 | 1 | **6** |
| testAnalyticsUsersHasChartsAndKpi | 1 | 5 | 0 | **6** |
| testSecurityEventHasNoInlineStyleAndRequiredClasses | 1 | 2 | 1 | **4** |
| testUserShowHasModalAndCsrfForms | 1 | 5 | 1 | **7** |
| **TOTAL** | **6** | **27** | **3** | **36** |

Note : `readTemplate()` contient `self::assertFileExists($path)` → chaque appel compte comme 1 assertion PHPUnit. Correction de 30 → **36** assertions.

**Total : 6 méthodes, 36 assertions**

**Code complet** :
```php
<?php

namespace App\Tests\Domain\Admin;

use PHPUnit\Framework\TestCase;

/**
 * Structural contracts for admin templates.
 * Verifies CSS classes, DataTable IDs and JSON blocks are present
 * without rendering the full Symfony stack.
 *
 * Depends on LOT-ADM-2 for testSecurityEventHasNoInlineStyleAndRequiredClasses.
 */
final class AdminInlineCodeTest extends TestCase
{
    private function readTemplate(string $relative): string
    {
        $path = dirname(__DIR__, 3) . '/templates/' . $relative;
        self::assertFileExists($path);
        return file_get_contents($path);
    }

    public function testDashboardHasRequiredStructure(): void
    {
        $twig = $this->readTemplate('admin/dashboard/index.html.twig');
        self::assertStringContainsString('bx-admin-dashboard', $twig);
        self::assertStringContainsString('bx-kpi-card', $twig);
        self::assertStringContainsString('bx-section-divider', $twig);
        self::assertStringContainsString('bx-period-bar', $twig);
        self::assertStringContainsString('application/json', $twig);
        self::assertStringContainsString('db-activity-chart', $twig);
    }

    public function testUserIndexHasDataTableAndFilters(): void
    {
        $twig = $this->readTemplate('admin/user/index.html.twig');
        self::assertStringContainsString('bx-admin-users', $twig);
        self::assertStringContainsString('adminUsersTable', $twig);
        self::assertStringContainsString('bx-log-filter', $twig);
        self::assertStringContainsString('data-datatable', $twig);
        self::assertStringContainsString('data-search', $twig);
    }

    public function testLogIndexHasDataTableAndFilters(): void
    {
        $twig = $this->readTemplate('admin/log/index.html.twig');
        self::assertStringContainsString('bx-admin-logs', $twig);
        self::assertStringContainsString('adminLogsTable', $twig);
        self::assertStringContainsString('bx-log-filter', $twig);
        self::assertStringContainsString('data-action-cat', $twig);
        self::assertStringNotContainsString('<style>', $twig, 'Inline <style> must be extracted to admin.css (LOT-ADM-2)');
    }

    public function testAnalyticsUsersHasChartsAndKpi(): void
    {
        $twig = $this->readTemplate('admin/analytics/users.html.twig');
        self::assertStringContainsString('bx-admin-analytics-users', $twig);
        self::assertStringContainsString('chart-reg-daily', $twig);
        self::assertStringContainsString('chart-statuts', $twig);
        self::assertStringContainsString('chart-roles', $twig);
        self::assertStringContainsString('bx-kpi-value-lg', $twig);
    }

    public function testSecurityEventHasNoInlineStyleAndRequiredClasses(): void
    {
        $twig = $this->readTemplate('admin/security_event/index.html.twig');
        self::assertStringNotContainsString('<style>', $twig, 'Inline <style> must be extracted to admin.css (LOT-ADM-2)');
        self::assertStringContainsString('bx-se-table', $twig);
        self::assertStringContainsString('bx-se-critical', $twig);
    }

    public function testUserShowHasModalAndCsrfForms(): void
    {
        $twig = $this->readTemplate('admin/user/show.html.twig');
        self::assertStringContainsString('avatarDeleteModal', $twig);
        self::assertStringContainsString('csrf_token(', $twig);
        self::assertStringContainsString('bx-kpi-card', $twig);
        self::assertStringContainsString('bx-kpi-value-lg', $twig);
        self::assertStringNotContainsString('<style>', $twig, 'No inline <style> expected in user/show');
        self::assertStringContainsString('bx-kpi-value-md', $twig);
    }
}
```

**CORRECTION ARBITRAGE 2026-06-15** : ligne 80 `bx-admin-users` → `bx-kpi-value-md` (FALSE_TEST_CONTRACT — voir section ARBITRAGE ADM-4).

**Condition d'arrêt** :
```bash
php -d memory_limit=1G bin/phpunit tests/Domain/Admin/AdminInlineCodeTest.php --no-coverage
```
Doit retourner : 6 tests, 36 assertions, 0 failures.

Note : `testSecurityEventHasNoInlineStyleAndRequiredClasses` et `testLogIndexHasDataTableAndFilters` échoueront si LOT-ADM-2 n'a pas été exécuté. C'est intentionnel — les tests de contrat valident l'état cible.

**Commit** :
```
test(admin): add AdminInlineCodeTest structural contracts
```

**Dépendances** : LOT-ADM-2 doit être terminé avant l'exécution de ce test (les assertions `assertStringNotContainsString('<style>')` valident la suppression du bloc inline).

---

## Valeurs CONSERVER F12

| Valeur | Ligne | Contexte | Justification |
|---|---|---|---|
| #a855f7 | 27 | bx-kpi-border-purple | Bootstrap 5 manque purple sémantique |
| #f97316 | 28 | bx-kpi-border-orange | Bootstrap 5 manque orange sémantique |
| rgba(15,23,42,0.08) | 58 | --bx-admin-sep light | custom prop light, calibrée intentionnellement |
| rgba(15,23,42,0.03) | 70 | .bx-period-bar bg light | très subtil .03, pas de token equiv |
| rgba(255,255,255,0.14) | 87 | --bx-admin-sep dark | calibrée (.14 > .12 standard) |
| rgba(168,85,247,.1) | 193 | bx-quick-icon--purple | cohérence purple sans token BS |
| rgba(255,255,255,.4) | 207 | bx-log-filter border | obligatoire sur fond bg-primary |
| rgba(255,255,255,.1) | 208 | bx-log-filter bg | obligatoire sur fond bg-primary |
| rgba(255,255,255,.85) | 209 | bx-log-filter color | obligatoire sur fond bg-primary |
| #fff | 217,229 | bx-log-filter:hover/active | blanc pur intentionnel |
| rgba(255,255,255,.75) | 521 | bx-chart-legend-label | sur fond sombre card-header bg-primary |
| #d97706 | 550,557 | bx-risk-medium, bx-sev-warning color | amber-600 — Bootstrap warning trop clair |
| #16a34a | 552,562,563 | bx-risk-low, bx-http-ok, bx-evolution-down | green-600 — Bootstrap success différent |
| #b91c1c | 558 | bx-sev-error color | rouge foncé distinct de critique |

**Total CONSERVER F12 : 14 entrées distinctes** (certaines apparaissent sur plusieurs lignes)

---

## Valeurs CONSERVER F13

| Valeur | Ligne | Contexte | Justification |
|---|---|---|---|
| .67rem | 33 | .bx-kpi-label font-size | volontairement < fs-xxs (0.72rem) |
| .08em | 35 | .bx-kpi-label letter-spacing | > tracking-wide (0.07em) — intentionnel |
| 1.9rem | 42 | .bx-kpi-value-lg font-size | entre font-2xl et font-3xl |
| -.02em | 45 | .bx-kpi-value-lg letter-spacing | delta vs tracking-snug (-.025em) |
| 8px | 113 | .bx-health-dot width/height | valeur sémantique fixe (dot graphique) |

**Total CONSERVER F13 : 5 entrées**

---

## Arbitrages

**ARBITRAGES RESTANTS : 0** — tous tranchés officiellement le 2026-06-14 et reclassés CONSERVER (V25-V28).

Voir section "Occurrences ARBITRAGE — DÉCISIONS OFFICIELLES" dans le CATALOGUE F12 pour le détail complet.

Récapitulatif des décisions :
- ARB1 → V25 : `.bx-quick-card:hover` box-shadow — CONSERVER (ombre délibérément > --bx-shadow-xs)
- ARB2 → V26 : `.bx-risk-high` color #dc2626 — CONSERVER (cohérence palette Chart.js)
- ARB3 → V27 : `.bx-sev-critical` color #dc2626 — CONSERVER (idem ARB2)
- ARB4 → V28 : `.bx-evolution-up` color #dc2626 — CONSERVER (rouge danger sémantique métier)

---

## Bloquants

AUCUN bloquant identifié. Tous les lots sont exécutables de manière autonome.

---

## Chart.js — dette différée

**16 canvases Chart.js** répartis sur 5 templates.
**Couleurs JS inline** : ~35 valeurs hex/rgba dans les blocs `<script>` (J1-J12 inventoriés dans la cartographie analytics).
**Raison du report** : les couleurs Chart.js sont des paramètres de configuration JavaScript, non des propriétés CSS. La tokenisation nécessiterait un refactoring JS majeur (passage par des CSS custom properties lues en JS via `getComputedStyle`) — hors périmètre CSS-only de cette campagne.
**Condition future** : ouvrir une campagne `admin-chartjs-tokens` dédiée si le design system évolue vers des palettes Chart.js centralisées.

---

## Validations après chaque lot

```bash
# Après LOT-ADM-1
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/ --no-coverage
php -d memory_limit=1G bin/phpunit tests/Domain/Admin/ --no-coverage
grep -c "rgba(0,0,0,\." public/css/admin.css
grep -c "border-radius: \.[0-9]" public/css/admin.css

# Après LOT-ADM-2
grep -c "<style>" templates/admin/security_event/index.html.twig
grep -c "<style>" templates/admin/log/index.html.twig
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/SecurityEventAdminTest.php --no-coverage
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/AdminAccessTest.php --no-coverage

# Après LOT-ADM-3
grep -c "bx-kpi-help.*rgba(255,255,255,0.82)" public/css/admin.css
grep -c "#1e1e1e" public/css/admin.css
php -d memory_limit=1G bin/phpunit tests/Platform/Admin/ --no-coverage

# Après LOT-ADM-4
php -d memory_limit=1G bin/phpunit tests/Domain/Admin/AdminInlineCodeTest.php --no-coverage
```

---

## Compteurs finaux

| Lot | Fichiers touchés | Lignes modifiées | Delta lignes | admin.css après |
|---|---|---|---|---|
| LOT-ADM-1 | 1 (admin.css) | 64 déclarations | 0 | 835 |
| LOT-ADM-2 | 3 (admin.css + 2 twig) | 21 supprimées twig + 23 ajoutées admin.css | +23 net | 858 |
| LOT-ADM-3 | 1 (admin.css) | ~13 supprimées nettes | -13 net | 845 |
| LOT-ADM-4 | 1 (nouveau test) | — | +~70 | 845 |
| **TOTAL** | **4 fichiers prod + 1 test** | **97 déclarations recensées** | **+10 net** | **845** |

| Catégorie | F12 | F13 | Total |
|---|---|---|---|
| AUTO-DELTA actionnables | 55 | 9 | 64 |
| CONSERVER (V1-V28) | 28 | 5 | 33 |
| ARBITRAGE restants | 0 | 0 | 0 |
| **Total recensé** | **83** | **14** | **97** |

---

## Dette transversale (à ne pas absorber)

- **T2-T9** : Styles `font-size` inline dans user/show.html.twig et layouts/admin.html.twig — dette connue, non absorbée dans cette campagne. Reporter vers une campagne Twig inline cleanup.
- **Logout onclick inline** (admin.html.twig L87) : pattern établi documenté — ne pas modifier (compatibilité DomCrawler tests).
- **Chart.js couleurs** dans JS inline : configuration légitime, non tokenisable sans refactoring JS — reporter vers campagne admin-chartjs-tokens.
- **Annotation traçabilité** dans log/index.html.twig L363 : `target_email_masked` manquant dans AuditLogger — dette fonctionnelle, hors scope CSS.
- **bx-se-critical/bx-se-warning** rgba brutes : conservées lors de LOT-ADM-2 (pas de token BS équivalent) — à traiter dans une campagne F12 étendue si --bs-warning-rgb tokenisation devient applicable.

---

## AdminInlineCodeTest.php

Voir code complet dans la section LOT-ADM-4.

**Récapitulatif** :
- Fichier : `tests/Domain/Admin/AdminInlineCodeTest.php`
- Méthodes : 6
- Assertions : 36
- `testDashboardHasRequiredStructure` : 7 assertions (1 assertFileExists + 6 assertStringContains)
- `testUserIndexHasDataTableAndFilters` : 6 assertions (1 assertFileExists + 5 assertStringContains)
- `testLogIndexHasDataTableAndFilters` : 6 assertions (1 assertFileExists + 4 assertStringContains + 1 assertStringNotContains post-LOT-ADM-2)
- `testAnalyticsUsersHasChartsAndKpi` : 6 assertions (1 assertFileExists + 5 assertStringContains)
- `testSecurityEventHasNoInlineStyleAndRequiredClasses` : 4 assertions (1 assertFileExists + 2 assertStringContains + 1 assertStringNotContains post-LOT-ADM-2)
- `testUserShowHasModalAndCsrfForms` : 7 assertions (1 assertFileExists + 5 assertStringContains + 1 assertStringNotContains)
- **Total : 36 assertions** (correction de 30 : readTemplate() exécute assertFileExists = 1 assertion par appel)

---

## Prompt Codex

```
Tu es un agent d'exécution autonome pour le projet Budgex (Symfony 7, PHP, Twig, CSS).
Répertoire de travail : racine absolue du projet Budgex (C:\wamp64\www\projects\budgex ou équivalent).

RÈGLE ABSOLUE : ne modifier AUCUN fichier métier/production hors de la liste autorisée par chaque lot.
Modules figés — NE JAMAIS TOUCHER : bank.css · transactions.css · accounts.css · patrimoine.css · budget.css · dashboard.css · app.css · styles.css · components.css · colors_and_type.css

Avant de commencer :
1. Lis le manifeste .claude/code-campaigns/admin-module.md en entier.
2. Vérifie : git status --short → doit afficher uniquement "?? tests/Domain/Admin/AdminInlineCodeTest.php" (fichier non suivi). Aucun fichier modifié.
3. Vérifie : git rev-parse HEAD → doit être 2762a500fe3b79ab750c0108effe163716ec4309. Sinon STOP et signale.

Exécute les lots dans cet ordre : LOT-ADM-1 → LOT-ADM-2 → LOT-ADM-3 → LOT-ADM-4.

Pour chaque lot :
1. Identifie les "Fichiers autorisés" dans la section du lot dans le manifeste.
2. Applique UNIQUEMENT les substitutions du CATALOGUE F12 (C1-C55, 55 substitutions) et CATALOGUE F13 (D1-D9, 9 substitutions) pour LOT-ADM-1. Total : 64 opérations. ARBITRAGES RESTANTS = 0 (tous CONSERVER V25-V28).
3. Pour LOT-ADM-2 : extrait les blocs <style> selon les instructions exactes du manifeste. Remplace var(--bx-app-bg-2) par var(--bx-app-surface-2) lors de l'extraction.
4. Pour LOT-ADM-3 : applique les 3 groupes de mutualisation exactement comme documenté.
5. Pour LOT-ADM-4 : le fichier tests/Domain/Admin/AdminInlineCodeTest.php existe déjà (non suivi, non indexé). Il contient une erreur corrigée : la méthode `testUserShowHasModalAndCsrfForms` dernière assertion doit être `bx-kpi-value-md` et non `bx-admin-users`. Applique la correction exacte : remplace `self::assertStringContainsString('bx-admin-users', $twig);` par `self::assertStringContainsString('bx-kpi-value-md', $twig);`. Ne pas recréer le fichier — modifier uniquement cette ligne.
6. Préserve tous les commentaires existants dans les fichiers modifiés.
7. Exécute les tests indiqués dans "Tests" du lot avec : php -d memory_limit=1G bin/phpunit [chemin] --no-coverage
8. Si les tests passent : commite avec le message exact de "Commit" du lot.
9. Si un test échoue : exécute git restore sur les fichiers modifiés du lot et STOP immédiatement. Rapporte : test en échec, fichiers affectés, output PHPUnit.
10. Vérifie la condition d'arrêt (grep) avant de passer au lot suivant.

Contraintes absolues :
- Ne JAMAIS modifier app.css, styles.css, components.css, colors_and_type.css
- Ne JAMAIS modifier un module CSS figé
- Ne JAMAIS modifier les contrôleurs PHP, entités, ou repositories
- Ne JAMAIS commiter des fichiers non listés dans "Fichiers autorisés"
- Ne JAMAIS utiliser git push
- Ne JAMAIS lire ou indexer les fichiers sous .claude/ pendant l'exécution
- Préserver les !important existants dans admin.css — ils sont intentionnels

Commandes de test standard :
  php -d memory_limit=1G bin/phpunit tests/Platform/Admin/ --no-coverage
  php -d memory_limit=1G bin/phpunit tests/Domain/Admin/ --no-coverage

Si tous les lots passent : signale "Campagne admin-module terminée — 4 commits."

Tailles admin.css attendues à chaque étape :
- Avant LOT-ADM-1 : 835 lignes
- Après LOT-ADM-1 : 835 lignes (64 remplacements in-place, 0 ligne ajoutée/supprimée)
- Après LOT-ADM-2 : 858 lignes (+23 lignes)
- Après LOT-ADM-3 : 845 lignes (-13 lignes)

Identifiants F12 uniques : C1–C55 (55 substitutions)
Identifiants F13 uniques : D1–D9 (9 substitutions — 8 border-radius + 1 font-size)
ARBITRAGES RESTANTS : 0 (ARB1–ARB4 reclassés CONSERVER V25–V28)
Modules figés : NE JAMAIS TOUCHER bank.css · transactions.css · accounts.css · patrimoine.css · budget.css · dashboard.css
Fichiers Chart.js : NE JAMAIS MODIFIER
Répertoire .claude : NE JAMAIS INDEXER

Vérification post-ADM-2 :
  grep -c "bx-app-bg-2" templates/admin/security_event/index.html.twig → doit retourner 0
  grep -c "bx-app-surface-2" public/css/admin.css → doit retourner ≥ 3
  grep -c "<style>" templates/admin/security_event/index.html.twig → doit retourner 0
  grep -c "<style>" templates/admin/log/index.html.twig → doit retourner 0

Vérification post-ADM-4 : php -d memory_limit=1G bin/phpunit tests/Domain/Admin/AdminInlineCodeTest.php --no-coverage → 6 tests, 36 assertions, 0 failures.

CORRECTION ADM-4 (arbitrage 2026-06-15, FALSE_TEST_CONTRACT) :
- Fichier : tests/Domain/Admin/AdminInlineCodeTest.php (non suivi, modifier en place)
- Assertion incorrecte (ligne 80) : `self::assertStringContainsString('bx-admin-users', $twig);`
- Assertion correcte : `self::assertStringContainsString('bx-kpi-value-md', $twig);`
- Raison : bx-admin-users est la classe racine exclusive de index.html.twig (listing). show.html.twig n'a jamais eu cette classe. bx-kpi-value-md (admin.css L47) est présent en show.html.twig L88 et absent de index.html.twig.
- Compteurs inchangés : 6 méthodes, 36 assertions.

Restauration autorisée au démarrage : git restore -- config/reference.php (si M présent dans git status --short)
```

---

## Résumé campagne

| Lot | Commit | Fichiers | Opérations | Tests | Status |
|---|---|---|---|---|---|
| LOT-ADM-1 | 286542b | admin.css | 55 F12 + 9 F13 = 64 total | Platform/Admin + Domain/Admin | **CLOSED** |
| LOT-ADM-2 | 837da39 | admin.css + 2 templates | 24 lignes Twig retirées + 23 CSS ajoutées | SecurityEventAdminTest + AccessTest | **CLOSED** |
| LOT-ADM-3 | 2762a50 | admin.css | 3 familles mutualisées, **-13 lignes** nettes | Platform/Admin | **CLOSED** |
| LOT-ADM-4 | 61ba858 | 1 fichier test | 6 méthodes, **36 assertions**, correction FALSE_TEST_CONTRACT | Domain/Admin | **CLOSED** |

**Campagne autonome exécutable : OUI**
**Interventions utilisateur prévues : 0** (tous les lots sont AUTO ou AUTO-DELTA avec règles précises)
**Confirmation : aucun fichier de production modifié, indexé ou committé lors de cet audit.**

---

## AUDIT CLÔTURE — 2026-06-15

**HEAD final** : `61ba8585c7874c96c2ff6cdad0f283ecbd678d63`  
**Auditeur** : Claude Code (audit indépendant post-exécution)  
**Statut** : **AUDITED / CLOSED**

### Résultats des tests validés

| Suite | Résultat |
|---|---|
| AdminInlineCodeTest | **6 tests, 36 assertions, 0 failure** |
| Platform/Admin | **28 tests, 180 assertions, 0 failure** |
| Domain/Admin | **17 tests, 108 assertions, 0 failure** |
| Sécurité Admin | **14 tests, 138 assertions, 0 failure** |
| lint:twig templates/admin | **20 fichiers OK** |
| lint:container | **OK** |
| node --check (3 scripts) | **OK** |
| git diff --check | **OK** |

### État admin.css

- **845 lignes** exactes ✅
- Accolades équilibrées : 280 `{` = 280 `}` ✅
- 10 blocs media query ✅
- 0 occurrence `--bx-app-bg-2` ✅
- 0 occurrence `border-radius: .[0-9]` brute ✅
- 1 occurrence `rgba(0,0,0,...)` restante (L173 : `.bx-quick-card:hover` box-shadow = V25 CONSERVER) ✅

### Couleurs brutes restantes (toutes CONSERVER)

| Valeur | Référence | Justification |
|---|---|---|
| `rgba(0,0,0,.07)` L173 | V25 | box-shadow .bx-quick-card:hover — ombre délibérément distincte |
| `#a855f7` L27, L678 | V1, V7, V24 | Bootstrap 5 sans purple sémantique |
| `#f97316` L28 | V2 | Bootstrap 5 sans orange sémantique |
| `#fff` (×11) | V11, V12 | blanc pur sur fond bg-primary (obligatoire) |
| `rgba(255,255,255,...)` (×6) | V8-V13 | log-filter sur bg-primary + légende chart |
| `rgba(168,85,247,.1)` L193 | V7 | quick-icon--purple sans token BS |
| `rgba(239,68,68,.04)/.03)` L833-834 | post-ADM2 | bx-se-critical/warning — pas de token BS .04/.03 |
| `rgba(245,158,11,.12)` L599 | V16 | bx-sev-warning bg |
| `rgba(249,115,22,.12)` L601 | V20 | bx-http-4xx bg |
| `rgba(15,23,42,...)` L58,L70 | V3, V4 | --bx-admin-sep light (custom prop intentionnelle) |
| `rgba(255,255,255,.14)` L87 | V5 | --bx-admin-sep dark (calibré .14 > standard) |
| `#d97706/#c2410c/#dc2626/#b91c1c/#0891b2/#16a34a` | V14-V23, V26-V28 | couleurs sémantiques risk/sev/http/evolution |

**Toutes justifiées. CONSERVER F12 : OUI.**

### Dette graphique Chart.js (différée, non bloquante)

- 16 instances Chart.js (C1-C16) sur 5 templates
- JS admin non modifiés (dernier commit pré-campagne : 4daf515)
- Couleurs Chart.js : configuration JS légitime, non tokenisable sans refactoring JS
- **État stable, inchangé, non bloquant**
- À traiter dans campagne future : `admin-chartjs-tokens`

### Styles inline résiduels (hors périmètre ADM-2)

| Template | Classe(s) | Nature | Verdict |
|---|---|---|---|
| design_system/index.html.twig | `.bx-ds-*` | Preview documentation, scoped, commenté "pas de pollution" | Dette pré-existante, légitime |
| ui_preview/index.html.twig | `.bx-uipv-*` | Preview hub, scoped | Dette pré-existante, légitime |

Ces deux templates n'étaient pas dans l'allowlist ADM-2 et n'ont jamais été touchés par la campagne. Ils constituent une dette acceptable pour des pages de prévisualisation admin non-production.

### Observations de réconciliation

| Observation | Impact |
|---|---|
| ADM-1 : stat git 60+60 vs 64 opérations documentées | Écart de 4 : certaines subs sur lignes consécutives combinées en un hunk, ou 4 subs ciblaient des lignes déjà tokenisées. Conditions d'arrêt F12/F13 toutes vertes → exécution correcte |
| ADM-2 : 24 lignes Twig retirées vs "21" documentées | Manifeste dit "21 lignes" (security_event seul) mais log en ajoute 3 = 24 total. Le git stat (24 deletions) est la source de vérité. Documentation corrigée ci-dessus |
| design_system + ui_preview inline style | Pré-existants, hors périmètre, légitimes — ne pas traiter dans cette campagne |
| onsubmit powens_category_mapping (pré-existant) | Confirm() dialog admin — acceptable, non introduit par campagne |

---

## ARBITRAGE ADM-4 — Classification et correction du contrat show.html.twig

**Date** : 2026-06-15  
**HEAD au moment de l'arbitrage** : 2762a500fe3b79ab750c0108effe163716ec4309

### Problème

`testUserShowHasModalAndCsrfForms` (ligne 80) assert :
```php
self::assertStringContainsString('bx-admin-users', $twig); // FAIL
```
La classe `bx-admin-users` est absente de `templates/admin/user/show.html.twig`.

### Audit `.bx-admin-users`

**Consommateurs Twig** : `templates/admin/user/index.html.twig` ligne 32 — UNIQUE consommateur.

**Définitions CSS dans admin.css** (4 blocs scoped) :
1. L251-265 : dark mode `.bx-log-filter` pills → propre au listing (pills absentes du show)
2. L318 : responsive `.bx-kpi-value-lg` 1.65rem sur mobile
3. L371 : `.bx-kpi-card:hover { transform: none !important }` (suppression lift)
4. L379 : dark mode `.bx-kpi-help` color

**Consommateurs JS** : aucun.

**Rôle exact** : namespace CSS de la page listing `/admin/users`. Les effets 2, 3, 4 s'appliquent aux KPI cards du listing ; l'effet 1 ne concernerait pas le show (pas de `.bx-log-filter`).

### Classification : **A — FALSE_TEST_CONTRACT**

Preuves :
1. `.bx-admin-users` est la classe racine exclusive de `index.html.twig`. Elle n'a jamais été présente dans `show.html.twig`.
2. La page show n'a pas de classe wrapper BEM dédiée — c'est son état normal conforme au design du module.
3. Injecter `.bx-admin-users` dans show.html.twig serait sémantiquement faux (confondre listing et détail) et ne corrige rien de réel.
4. Les lacunes CSS résultantes (responsive KPI, hover suppression, dark mode kpi-help) sur la page show sont réelles mais mineures et relèvent d'une campagne CSS distincte (`bx-admin-user-show`) — pas de ce lot de tests.
5. Le test a été écrit en supposant incorrectement que le show partagerait la classe du listing.

Pas de lot correctif de production requis avant ADM-4.

### Assertion de remplacement

**Ancienne ligne 80** :
```php
self::assertStringContainsString('bx-admin-users', $twig);
```

**Nouvelle ligne 80** :
```php
self::assertStringContainsString('bx-kpi-value-md', $twig);
```

**Justification** :
- `bx-kpi-value-md` présent dans `show.html.twig` ligne 88 : KPI "Membre depuis" (format intermédiaire spécifique au show)
- Absent de `index.html.twig` (qui n'utilise que `bx-kpi-value-lg`)
- Classe BEM du design system (admin.css L47)
- Vérifie un contrat structurel réel et distinct de la page show

### Compteurs corrigés

Aucun compteur ne change — le remplacement est strictement 1-pour-1 :

| Méthode | assertFileExists | assertStringContains | assertStringNotContains | Total |
|---|---|---|---|---|
| testUserShowHasModalAndCsrfForms | 1 | 5 | 1 | **7** |
| **TOTAL GLOBAL** | **6** | **27** | **3** | **36** |

- Méthodes : **6** (inchangé)
- Assertions : **36** (inchangé)
- Failures attendues après correction : **0**

### Contrats CSRF et sécurité (show.html.twig — vérifiés)

| Contract | Présent | Détail |
|---|---|---|
| Actions destructives en POST | ✅ | suspend, activate, role, avatar replace, avatar delete, resend, reset |
| Tokens CSRF distincts | ✅ | 7 tokens : admin_resend_, admin_send_reset_, admin_role_, admin_suspend_, admin_activate_, admin_avatar_replace_, admin_avatar_delete_ |
| Modal de confirmation | ✅ | #avatarDeleteModal (seule action irréversible) |
| Guards voter | ✅ | is_granted('admin_user_*', user) sur chaque action |
| Impersonate GET | ✅ | CAN_SWITCH_USER voter + IS_IMPERSONATOR guard |
| Aucun formulaire destructif en GET | ✅ | — |
| Aucun `<style>` inline | ✅ | — |
| Aucun code dangereux | ✅ | pas d'eval, pas d'innerHTML |

---

## Journal des corrections d'audit

| Date | Correction | Ancienne valeur | Nouvelle valeur |
|---|---|---|---|
| 2026-06-14 | LOT-ADM-2 lignes ajoutées admin.css | +18 | +23 |
| 2026-06-14 | admin.css après LOT-ADM-2 | 853 | 858 |
| 2026-06-14 | LOT-ADM-3 delta lignes | -17 | -13 |
| 2026-06-14 | admin.css après LOT-ADM-3 | 836 | 845 |
| 2026-06-14 | LOT-ADM-4 assertions | 30 | 36 (assertFileExists dans readTemplate compte) |
| 2026-06-14 | ARB1-ARB4 reclassés | ARBITRAGE | CONSERVER V25-V28 |
| 2026-06-14 | CONSERVER F12 total | 24 | 28 (+ 4 ARB reclassés) |
| 2026-06-14 | ARBITRAGE restants | 4 | 0 |
| 2026-06-15 | F13 substitutions totales | 8 (D1-D8 — audit 2026-06-14) | 9 (D1-D9 — D9 = .bx-pill-badge ligne 242 border-radius 1rem → --bx-radius-xl restauré) |
| 2026-06-15 | LOT-ADM-1 opérations totales | 63 | 64 (55 F12 + 9 F13) |
| 2026-06-15 | F13 total recensé | 13 | 14 (9 actionnables + 5 CONSERVER) |
| 2026-06-15 | Total global recensé | 96 | 97 (83 F12 + 14 F13) |
| 2026-06-15 | Sélecteurs extraits security_event | 14 | 16 (liste correctement 16 sélecteurs) |
| 2026-06-15 | LOT-ADM-4 assertions récapitulatif | 30 (en-tête section) | 36 (corrigé — cohérent avec détail et tableau) |
| 2026-06-15 | D8 ligne de déclaration | 620 (sélecteur) | 621 (déclaration border-radius) |
| 2026-06-15 | LOT-ADM-4 testUserShowHasModalAndCsrfForms ligne 80 | `bx-admin-users` (FALSE_TEST_CONTRACT) | `bx-kpi-value-md` (contrat réel show.html.twig) |
| 2026-06-15 | LOT-ADM-4 Status | PRÊT après LOT-ADM-2 | CORRIGÉ 2026-06-15 — voir section ARBITRAGE ADM-4 |
