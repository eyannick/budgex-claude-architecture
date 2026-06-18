# Campagne CSS — bank.css / powens_staging

**Module :** `public/css/bank.css`  
**Templates consommateurs :** `templates/bank_connection/index.html.twig`, `templates/bank_connection/_connection_card.html.twig`, `templates/powens_staging/index.html.twig`  
**Tests associés :** `--filter BankConnection`, `--filter Powens`  
**Responsable architecture :** Claude  
**Responsable exécution :** Codex

---

## Historique des lots terminés

| Commit | Lot | Statut |
|---|---|---|
| `55a31b2` | F12 + F13-A : tokenize exact remaining values | CLOSED |
| `e9eff54` | F13-A : tokenize exact line-height equivalents | CLOSED |
| `53cedde` | warning token scope alignment | CLOSED |
| `55ce181` | LOT-BANK-RADIUS : CTA + badge radii | CLOSED |
| `84441b3` | LOT-BANK-DENSITY : list gap + kpi label + summary total | CLOSED |

---

## HEAD initial attendu pour cette campagne

Le premier lot de la présente campagne ne peut démarrer qu'après que
`LOT-BANK-DENSITY` est committé et poussé.

HEAD attendu : commit dont le message est exactement :

```
refactor(bank): normalize card gap and text sizes to spacing and type tokens
```

---

## Décisions CONSERVER (aucune action Codex)

Ces valeurs ont été arbitrées définitivement par Claude (ARB-BANK-F13-NEAR-TOKENS-1)
ou constituent des valeurs intrinsèques documentées. Codex ne les touche pas.

| Valeur | Ligne | Sélecteur | Justification |
|---|---|---|---|
| `column-gap: 1.25rem` | 19 | `.bx-bank-hero-bar` | Entre sp-4/sp-5 ; 4 px delta intentionnel |
| `padding: 0.34rem 0.82rem` | 41, 48 | hero btn / link | CTA padding fine-tuné |
| `letter-spacing: 0.01em` | 43, 50 | hero btn / link | Entre tracking-normal et tracking-wide |
| `border-radius: 0.72rem` | 61 | `.bx-bank-kpi` | KPI widget entre md (10 px) et lg (14 px) |
| `padding: 0.56rem 0.7rem` | 63 | `.bx-bank-kpi` | Padding compact fine-tuné |
| `line-height: 1.15` | 71 | `.bx-bank-kpi__label` | Entre lh-tight (1.1) et lh-snug (1.2) |
| `font-size: 1.28rem` | 78 | `.bx-bank-kpi__value` | Sémantique h4 mismatch ; valeur intrinsèque KPI |
| `width/height: 3.05rem` | 91-92 | `.bx-bank-empty__icon` | Dimension composant |
| `font-size: 1.8rem` | 103 | empty icon material | Taille icône custom |
| `padding: 0.34rem 0.92rem` | 108 | `.bx-bank-empty__cta` | CTA padding fine-tuné |
| `transition: 0.14s ease` | 170 | `.bx-bank-connection-summary` | Micro-interaction crisp (ARB) |
| `width: 1rem` | 190 | chevron container | Slot icône |
| `transition: 0.16s ease` | 197 | chevron material icon | Layered micro-animation (ARB) |
| `width: 46px; height: 46px` | 203-204 | `.bx-bank-connection-logo` | Dimension logo brand |
| `border-radius: 0.7rem` | 205 | `.bx-bank-connection-logo` | Silhouette logo intentionnelle (ARB) |
| `font-size: 1.35rem` | 226 | logo fallback icon | Taille icône custom |
| `font-size: 0.95rem` | 235 | `.bx-bank-connection-title` | Densité card intentionnelle (ARB) |
| `line-height: 1.3` | 236 | `.bx-bank-connection-title` | Entre lh-snug et lh-normal |
| `font-size: 0.74rem` | 241 | `.bx-bank-connection-subtitle` | Non-uppercase, entre xxs et sm (ARB) |
| `line-height: 1.25` | 242 | `.bx-bank-connection-subtitle` | Entre lh-snug et lh-normal |
| `gap: 0.62rem` | 185 | `summary__left` | Entre sp-2/sp-3 ; densité logo-texte (ARB) |
| `gap: 0.35rem` | 253 | `summary__meta` | Micro-density méta (ARB) |
| `margin-left: 0.15rem` | 261 | `summary__total` | Ajustement optique |
| `min-height: 1.45rem` | 271 | `.bx-bank-status` | Hauteur badge composant |
| `padding: 0.16rem 0.46rem` | 272 | `.bx-bank-status` | Padding badge fine-tuné |
| `font-size: 0.66rem` | 275 | `.bx-bank-status` | Compacité badge fonctionnelle (ARB) |
| `letter-spacing: 0.015em` | 277 | `.bx-bank-status` | Badge tracking, entre normal et wide |
| `width: 8px; height: 8px` | 329-330 | `.bx-account-dot` | Dimension dot |
| `line-height: 1.3` | 341, 345 | account row name/meta | Entre lh-snug et lh-normal |
| `padding: 0.3rem 0.72rem` | 378 | `.bx-bank-action-btn` | Action btn padding fine-tuné |
| `margin-left: 2.95rem` | 492 | meta mobile | Alignement optique sous logo |
| `padding-top/bottom: 0.82/0.62rem` | 511-512 | summary <576 | Responsive fine-tuné |
| `width: 40px; height: 40px` | 515-516 | logo <576 | Dimension logo mobile |
| `font-size: 0.9rem` | 520 | connection-title <576 | Entre sm et body, densité mobile |
| `font-size: 0.82rem` | 523 | account balance <576 | Compacité mobile intentionnelle |
| Density pass (ll. 534-553) | 534-553 | `@media(min-width:768)` | Valeurs compact fine-tunées, ensemble cohérent |
| Staging values | 572, 597-598, 604, 610, 614 | `.bx-staging-*` | Tailles icônes, opacités, dimensions custom |

---

## Lots de la campagne

### LOT-BANK-FW — Tokeniser les font-weights bruts

**Statut :** PASS — `bd17bc3`  
**Classe :** AUTO  
**Fichier autorisé :** `public/css/bank.css` uniquement  

**HEAD requis :** `refactor(bank): normalize card gap and text sizes`

**Tokens (parité stricte) :**

| Token | Valeur |
|---|---|
| `--bx-fw-medium` | `500` |
| `--bx-fw-semibold` | `600` |
| `--bx-fw-bold` | `700` |

**8 substitutions exactes :**

| Ligne | Sélecteur | Avant | Après |
|---|---|---|---|
| 42 | `.bx-bank-hero__btn` | `font-weight: 500` | `font-weight: var(--bx-fw-medium)` |
| 49 | `.bx-bank-hero__link` | `font-weight: 500` | `font-weight: var(--bx-fw-medium)` |
| 74 | `.bx-bank-kpi__label` | `font-weight: 600` | `font-weight: var(--bx-fw-semibold)` |
| 80 | `.bx-bank-kpi__value` | `font-weight: 700` | `font-weight: var(--bx-fw-bold)` |
| 237 | `.bx-bank-connection-title` | `font-weight: 600` | `font-weight: var(--bx-fw-semibold)` |
| 259 | `.bx-bank-connection-summary__total` | `font-weight: 700` | `font-weight: var(--bx-fw-bold)` |
| 276 | `.bx-bank-status` | `font-weight: 600` | `font-weight: var(--bx-fw-semibold)` |
| 340 | `.bx-account-row__name` | `font-weight: 500` | `font-weight: var(--bx-fw-medium)` |

**Parité :** stricte. Aucun delta visuel ou structurel. Substitution mécanique.

**Interdictions absolues :**
- Ne pas toucher les `font-weight: var(--bx-fw-*)` déjà tokenisés (ll. 115, 350, 361)
- Ne pas toucher les `font-size`, `line-height`, `border-radius`, paddings, gaps, couleurs
- Ne pas toucher les templates
- Ne pas toucher `colors_and_type.css`

**Occurrences finales attendues :**
- `grep "font-weight: [0-9]" public/css/bank.css` → 0 résultats
- `grep "font-weight: var" public/css/bank.css` → 11 résultats

**Validations :**
```
php bin/console lint:twig templates/bank_connection templates/powens_staging --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter BankConnection --no-coverage
php -d memory_limit=1G bin/phpunit --filter Powens --no-coverage
git diff --check
git diff --stat
git status --short
```

**Diff attendu :** `1 file changed, 8 insertions(+), 8 deletions(-)`  
**Statut final attendu :** `M public/css/bank.css`

**Message de commit :**
```
refactor(bank): tokenize raw font-weight values to design tokens
```

**Push :** OUI, immédiatement après PASS.

---

### LOT-BANK-RESPONSIVE — Tokeniser le rayon logo mobile

**Statut :** PASS — `1fc086e`  
**Classe :** AUTO-DELTA  
**Fichier autorisé :** `public/css/bank.css` uniquement  

**HEAD requis :** commit du lot LOT-BANK-FW

**Token :**

| Token | Valeur | Doctrine |
|---|---|---|
| `--bx-radius-md` | `0.625rem` | large CTAs |

**1 substitution :**

| Ligne | Bloc | Sélecteur | Avant | Après | Delta |
|---|---|---|---|---|---|
| 517 | `@media(max-width:575.98px)` | `.bx-bank-connection-logo` | `border-radius: 0.62rem` | `border-radius: var(--bx-radius-md)` | +0.005rem ≈ +0.08px |

**Qualification :** même delta sub-pixel que les CTA buttons tokenisés dans LOT-BANK-RADIUS. Cohérence du radius md pour tous les éléments bouton-like à <576px.

**Interdictions absolues :**
- Ne pas toucher `border-radius: 0.7rem` (l.205, desktop logo, conservé)
- Ne pas toucher `border-radius: 0.72rem` (l.61, KPI card, conservé)
- Ne pas toucher les autres déclarations du bloc responsive

**Occurrences finales attendues :**
- `grep "border-radius: 0\.62rem" public/css/bank.css` → 0 résultats
- `grep "border-radius: 0\.7rem" public/css/bank.css` → 1 résultat (logo desktop, conservé)
- `grep "border-radius: 0\.72rem" public/css/bank.css` → 1 résultat (KPI card, conservé)

**Validations :** identiques à LOT-BANK-FW.

**Diff attendu :** `1 file changed, 1 insertion(+), 1 deletion(-)`  
**Statut final attendu :** `M public/css/bank.css`

**Message de commit :**
```
refactor(bank): tokenize mobile logo border-radius to design token
```

**Push :** OUI, immédiatement après PASS.

---

## Règles Git pour Codex

### Avant chaque lot

```bash
git status --short
# Si config/reference.php apparaît :
git restore --staged -- config/reference.php 2>/dev/null
git restore -- config/reference.php
# Vérifier :
# - aucun fichier inattendu
# - HEAD attendu (git log -1 --oneline)
# - index vide
git status --short
git log -1 --oneline
```

### Après chaque lot

```bash
php bin/console lint:twig templates/bank_connection templates/powens_staging --no-debug
php bin/console lint:container --no-debug
php -d memory_limit=1G bin/phpunit --filter BankConnection --no-coverage
php -d memory_limit=1G bin/phpunit --filter Powens --no-coverage
git diff --check
git diff --stat
git status --short
# Si config/reference.php apparaît : git restore -- config/reference.php
# Commit atomique
# Push
# Mettre à jour le statut du lot dans ce manifeste
```

### Conditions d'arrêt

Codex s'arrête immédiatement si :
- un test échoue (hors PHPUnit Notices pré-existantes) ;
- `git diff --check` retourne des erreurs ;
- un fichier inattendu est modifié ;
- le HEAD attendu ne correspond pas ;
- un lot est classé ARBITRAGE ou BLOQUANT.

---

## Éléments hors périmètre

- `public/css/colors_and_type.css`
- `public/css/app.css`
- `public/css/components.css`
- Tous les templates (`.html.twig`)
- Toutes les valeurs classées CONSERVER ci-dessus
- La section density pass `@media(min-width:768px)` (ll. 531-554) sauf si un lot futur l'adresse explicitement
- Les opacités (0.55, 0.75)
- Les dimensions px/rem de composants (min-height, width, height fixes)
- Les letter-spacing bruts (0.01em, 0.015em)

---

## Prompt Codex — Exécution complète

```
CAMPAGNE bank-css — Exécution des lots AUTO

Projet : Budgex.
Manifeste : .claude/css-campaigns/bank-css.md
Fichier autorisé : public/css/bank.css uniquement.

RÈGLE GLOBALE
- Lire le manifeste avant de commencer.
- Exécuter les lots dans l'ordre : LOT-BANK-FW puis LOT-BANK-RESPONSIVE.
- Enchaîner automatiquement sur PASS.
- Arrêter immédiatement sur BLOCKED, FAILED ou tout test échoué.
- Restaurer config/reference.php s'il apparaît (avant ET après chaque lot).
- Ne modifier aucun autre fichier que public/css/bank.css.
- Ne jamais effectuer de remplacement global.
- Écrire le rapport final dans le manifeste.

AVANT CHAQUE LOT
1. git status --short — vérifier arbre propre
2. git log -1 --oneline — vérifier HEAD attendu
3. Restaurer config/reference.php si présent

LOT-BANK-FW (8 substitutions, AUTO)
HEAD requis : refactor(bank): normalize card gap and text sizes to spacing and type tokens

Substitutions exactes :
  font-weight: 500  → font-weight: var(--bx-fw-medium)     [lignes 42, 49, 340]
  font-weight: 600  → font-weight: var(--bx-fw-semibold)   [lignes 74, 237, 276]
  font-weight: 700  → font-weight: var(--bx-fw-bold)       [lignes 80, 259]

Vérification tokens dans colors_and_type.css :
  --bx-fw-medium: 500    --bx-fw-semibold: 600    --bx-fw-bold: 700

Occurrence finale : grep "font-weight: [0-9]" public/css/bank.css → 0 résultats

Validations, puis :
  git commit -m "refactor(bank): tokenize raw font-weight values to design tokens"
  git push
  Mettre à jour statut LOT-BANK-FW → PASS dans le manifeste

LOT-BANK-RESPONSIVE (1 substitution, AUTO)
HEAD requis : refactor(bank): tokenize raw font-weight values to design tokens

Substitution exacte :
  Dans @media(max-width:575.98px) .bx-bank-connection-logo :
  border-radius: 0.62rem  → border-radius: var(--bx-radius-md)

Vérification token : --bx-radius-md: 0.625rem

Occurrence finale :
  grep "border-radius: 0\.62rem" public/css/bank.css → 0 résultats
  grep "border-radius: 0\.7rem" public/css/bank.css  → 1 résultat (logo desktop, conservé)
  grep "border-radius: 0\.72rem" public/css/bank.css → 1 résultat (KPI card, conservé)

Validations, puis :
  git commit -m "refactor(bank): tokenize mobile logo border-radius to design token"
  git push
  Mettre à jour statut LOT-BANK-RESPONSIVE → PASS dans le manifeste

RAPPORT FINAL
Écrire dans le manifeste une section "## Rapport d'exécution" avec :
- date et heure
- lots exécutés et statuts
- commits SHA
- résultats des tests
- verdict : module bank.css F14 = 0 OUI/NON
```

---

## Verdict final de l'audit

| Catégorie | Nombre de lots | Nombre de substitutions |
|---|---|---|
| AUTO | 1 | 8 |
| AUTO-DELTA | 1 | 1 |
| CONSERVER | — | 33 valeurs documentées |
| ARBITRAGE | 0 | 0 |
| BLOQUANT | 0 | 0 |

**Campagne exécutable automatiquement par Codex : OUI**  
**Interventions utilisateur prévues : 0**  
**F14 bank.css après les 2 lots : 0 raw values non justifiées**

---

## Rapport d'exécution — 2026-06-11

**Exécutant :** Claude (session CAMPAGNE-BANK-CSS-EXECUTION)

| Lot | SHA | Statut | Tests |
|---|---|---|---|
| LOT-BANK-DENSITY | `84441b3` | PASS | BankConnection 33/33, Powens 134/134 |
| LOT-BANK-FW | `bd17bc3` | PASS | BankConnection 33/33, Powens 134/134 |
| LOT-BANK-RESPONSIVE | `1fc086e` | PASS | BankConnection 33/33, Powens 134/134 |

**État initial reconnu :** A — LOT-BANK-DENSITY présent dans le working tree.

**Notices PHPUnit pré-existantes :** 5 (Powens, constantes, non régressées).

**Contrôles finaux :**
- `font-weight: [0-9]` → 0 occurrences ✓
- `border-radius: 0.62rem` → 0 occurrences ✓
- `border-radius: 0.7rem` (logo desktop, CONSERVER) → 1 occurrence ✓
- `border-radius: 0.72rem` (KPI card, CONSERVER) → 1 occurrence ✓
- 33 valeurs CONSERVER intactes ✓
- Aucun fichier hors périmètre modifié ✓

**Verdict global : PASS**  
**module bank.css — F14 = 0 raw values non justifiées — DÉCLARÉ CLÔTURÉ**

---

## Audit de clôture — AUDIT-CLOTURE-BANK-CSS — 2026-06-11

**Exécutant :** Claude (session AUDIT-CLOTURE-BANK-CSS)  
**HEAD vérifié :** `1fc086e` = origin/master  
**Arbre propre :** OUI (config/reference.php restauré avant audit)

### Vérifications quantitatives

| Contrôle | Commande | Résultat attendu | Résultat constaté |
|---|---|---|---|
| Raw font-weights | `grep "font-weight: [0-9]"` | 0 | **0** ✓ |
| FW tokenisés | `grep "font-weight: var"` | 11 | **11** ✓ |
| `0.62rem` radius éliminé | `grep "border-radius: 0\.62rem"` | 0 | **0** ✓ |
| `0.7rem` radius conservé | `grep "border-radius: 0\.7rem"` | 1 | **1** (L205, logo desktop) ✓ |
| `0.72rem` radius conservé | `grep "border-radius: 0\.72rem"` | 1 | **1** (L61, KPI card) ✓ |
| Hex bruts | `grep "#[0-9a-fA-F]"` | 0 | **0** ✓ |
| rgba() bruts | `grep "rgba?("` | 0 | **0** ✓ |
| color-mix() bien formés | vérification manuelle | 39 usages / 0 hex dedans | **39 / 0** ✓ |

### Tests

| Suite | Résultat |
|---|---|
| `lint:twig` (3 fichiers) | OK ✓ |
| `lint:container` | OK ✓ |
| `BankConnection` | 33/33, 280 assertions ✓ |
| `Powens` | 134/134, 432 assertions, 5 Notices pré-existantes documentées ✓ |

### Constat F14

**F14** ("0 raw values non justifiées") est une **métrique de campagne** définie dans ce manifeste —
pas un standard canonique Budgex. Elle n'est référencée dans aucun ADR ni source-of-truth-map.
À utiliser dans les futures campagnes CSS, à élever en standard uniquement sur décision explicite.

### Inline style dynamique — _connection_card.html.twig L140

`style="background:{{ account.color ?? '#6366f1' }};"` — donnée entité (couleur choisie par
l'utilisateur pour le compte, fallback `#6366f1` = valeur par défaut du champ en base).
Pattern pré-existant, hors périmètre campagne. Non assimilable à une dette CSS.

### 8 Verdicts obligatoires

| Verdict | Décision |
|---|---|
| BANK.CSS F12 STRICTEMENT CLÔTURÉ | **OUI** — 0 hex/rgb/hsl brut |
| BANK.CSS F13 STRICTEMENT CLÔTURÉ | **OUI** — toutes substitutions confirmées, 33 CONSERVERs intacts |
| BANK.CSS RAW VALUES NON JUSTIFIÉES | **0** — F14 = 0 ✓ |
| BANK/STAGING TEMPLATES STRICTEMENT CLÔTURÉS | **OUI** — 0 nouveau style inline brut |
| BANK/STAGING JAVASCRIPT STRICTEMENT CLÔTURÉ | **OUI** — powens-staging.js 0 injection de style |
| MODULE BANK CSS FONCTIONNELLEMENT STABILISÉ | **OUI** — 167 tests verts, 0 régression |
| MODULE BANK CSS FIGEABLE | **OUI** — HEAD propre, origin/master, tous lots CLOSED |
| CAMPAGNE AUTONOME VALIDÉE | **OUI** — 3 lots exécutés sans intervention, manifeste complet |

### Statut final

**CAMPAGNE BANK CSS — CLÔTURÉE DÉFINITIVEMENT**  
Date de clôture : 2026-06-11  
Prochain module candidat : `public/css/transactions.css` ou `public/css/patrimoine.css`
