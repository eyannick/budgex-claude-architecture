# CAMPAGNE-DASHBOARD - Manifeste d'execution autonome final

## Metadonnees

```text
HEAD de reference : 53fa1c68f42161fa3e5d2822e843c66842aface9
Branche            : master
Date de cloture    : 2026-06-14
Version            : finale ADR-029
Statut             : READY - compteurs figes
```

Ce manifeste applique les sources primaires suivantes :

- `.claude/memory/decision-log.md` ADR-029 ;
- `.claude/memory/engineering-standards.md` ;
- `.claude/references/budgex-visual-bible.md` ;
- `.claude/memory/error-guardrails.md`.

La mention synthetique "~96 % tokenise" est informative uniquement. Elle ne constitue
ni une precondition, ni une postcondition, ni un garde-fou Codex.

---

## 1. Perimetre et classifications finales

| Lot | Objet | Classification | Decision |
|---|---|---|---|
| LOT-DASH-0 | Nettoyage cible dans `app.css` | AUTO | Executer |
| LOT-DASH-1 | Deux custom properties modale | AUTO | Executer |
| LOT-DASH-2 | Deux gradients hero `color-mix()` | AUTO-DELTA | Executer obligatoirement |
| LOT-DASH-3 | `DashboardInlineCodeTest.php` | AUTO | Executer |

Ordre obligatoire : LOT-DASH-0, LOT-DASH-1, LOT-DASH-2, LOT-DASH-3.

Interventions utilisateur prevues : **0**.

### Allowlists

| Lot | Fichiers modifiables |
|---|---|
| LOT-DASH-0 | `public/css/app.css` |
| LOT-DASH-1 | `public/css/dashboard.css` |
| LOT-DASH-2 | `public/css/dashboard.css` |
| LOT-DASH-3 | `tests/Domain/Dashboard/DashboardInlineCodeTest.php` |

### Modules figes

Toute modification des fichiers suivants, ainsi que de leurs templates et scripts, est interdite :

- `public/css/bank.css` ;
- `public/css/transactions.css` ;
- `public/css/accounts.css` ;
- `public/css/patrimoine.css` ;
- `public/css/budget.css`.

Action Center est hors perimetre. Sa lecture est autorisee uniquement pour verifier un
consommateur partage.

Avant d'utiliser une classe CSS existante, auditer son fichier de definition, son
chargement sur la page cible et son statut canonique ou module-local.

---

## 2. ADR-029 - LOT-DASH-2 obligatoire

ADR-029 fixe les cibles minimales :

| Navigateur | Version minimale |
|---|---|
| Chrome / Edge / Android WebView | 111 |
| Firefox / Firefox Android | 113 |
| Safari / iOS Safari / iOS WebView | 16.2 |

`color-mix()` est autorise sans fallback dans les feuilles applicatives lorsqu'il derive
une couleur depuis un token canonique `var(--bx-app-*)`, conserve l'opacite attendue et
n'embarque aucun hex/rgb brut.

Consequences definitives :

- aucune recherche de `.browserslistrc` ;
- aucune decision utilisateur ;
- aucune branche `SKIPPED` ;
- aucune detection navigateur par Codex ;
- aucun fallback `rgba` ;
- LOT-DASH-2 est toujours execute si ses deux occurrences initiales sont exactes.

---

## 3. LOT-DASH-2 - Gradients G1/G2

La propriete initiale complete est :

```css
background:
    radial-gradient(circle at 0% 0%, rgba(124,58,237,0.18) 0%, transparent 55%),
    radial-gradient(circle at 100% 100%, rgba(34,211,238,0.10) 0%, transparent 55%),
    var(--bx-app-surface);
```

La propriete finale complete doit etre :

```css
background:
    radial-gradient(circle at 0% 0%, color-mix(in srgb, var(--bx-app-accent) 18%, transparent) 0%, transparent 55%),
    radial-gradient(circle at 100% 100%, color-mix(in srgb, var(--bx-app-info) 10%, transparent) 0%, transparent 55%),
    var(--bx-app-surface);
```

| ID | Ligne initiale | Selecteur | rgba initial | Expression finale | Token source | Part | Valeur dark | Valeur light | Delta chromatique | Geometrie conservee | Classe |
|---|---:|---|---|---|---|---:|---|---|---|---|---|
| G1 | 66 | `.bx-hero` | `rgba(124,58,237,0.18)` | `color-mix(in srgb, var(--bx-app-accent) 18%, transparent)` | `--bx-app-accent` | 18 % | `#7c3aed` | `#6200ea` | dark : parite, RGB `(0,0,0)` ; light : base `#7c3aed` vers `#6200ea`, RGB `(-26,-58,-3)`, alpha inchange | `circle at 0% 0%`, stops `0%/55%`, couche 1 et ordre inchanges | AUTO-DELTA |
| G2 | 67 | `.bx-hero` | `rgba(34,211,238,0.10)` | `color-mix(in srgb, var(--bx-app-info) 10%, transparent)` | `--bx-app-info` | 10 % | `#22d3ee` | `#22d3ee` par heritage | parite dark et light, RGB `(0,0,0)`, alpha inchange | `circle at 100% 100%`, stops `0%/55%`, couche 2 et ordre inchanges | AUTO-DELTA |

G1/G2 sont conformes ADR-029 :

- source sous forme `var(--bx-app-*)` ;
- aucun hex/rgb brut dans `color-mix()` ;
- aucune modification de l'angle, de la forme, des positions, des stops, de l'ordre des
  couches ou de `var(--bx-app-surface)`.

Preconditions exactes :

```text
rgba(124,58,237,0.18) : 1 occurrence dans dashboard.css
rgba(34,211,238,0.10) : 1 occurrence dans dashboard.css
color-mix(in srgb, var(--bx-app-accent) 18%, transparent) : 0
color-mix(in srgb, var(--bx-app-info) 10%, transparent) : 0
```

Postconditions exactes : compteurs inverses `0 / 0 / 1 / 1`.

---

## 4. LOT-DASH-0 - Compteurs exacts

### Etat initial de `app.css`

```text
Lignes ReadAllLines : 4733
Accolades ouvrantes : 853
Accolades fermantes : 853
Media queries       : 54
```

### B0-A - Hero legacy

| Champ | Valeur |
|---|---|
| Bornes initiales | lignes 1604 a 1615 incluses |
| Contenu | commentaire `Hero patrimoine` + docblock + 4 regles + ligne vide terminale |
| Lignes supprimees | 12 |
| Regles supprimees | 4 |
| Selecteurs supprimes | 4 |
| Liste exhaustive | `.bx-hero-label`, `.bx-hero-value`, `.bx-hero-currency`, `.bx-hero-sublabel` |
| Variantes dark | 0 |
| Media queries | 0 |
| Pseudo-classes/elements | 0 |
| Consommateurs runtime dans le depot | 0 |
| Mentions non consommatrices | commentaires `app.css` et manifeste uniquement |
| Classification | DEAD |
| Decision | supprimer tout le segment |

### B0-B - Famille progress legacy

| Champ | Valeur |
|---|---|
| Bornes du bloc initial | lignes 1620 a 1630 incluses |
| Taille initiale | 11 lignes |
| Regles initiales | 2 |
| Selecteurs initiaux | `.bx-progress`, `.bx-progress-sm` |
| Variantes dark | 0 |
| Media queries | 0 |
| Pseudo-classes/elements | 0 |
| Classification du bloc initial | MIXED |

Detail fonctionnel :

- `.bx-progress { height: 8px; }` est DEAD : `components.css`, charge apres `app.css`,
  definit `.bx-progress { height: 6px; ... }`.
- `.bx-progress-sm { height: 5px; }` est SHARED et actif. Il n'existe dans aucune autre
  feuille et doit rester dans `app.css`.

Consommateurs exhaustifs :

| Selecteur | Consommateurs |
|---|---|
| `.bx-progress` | `templates/budget/index.html.twig`, `templates/budget/analyse.html.twig`, `templates/dashboard/index.html.twig`, `templates/goal/_card.html.twig`, `templates/goal/show.html.twig`, `templates/patrimoine/immobilier_show.html.twig` |
| `.bx-progress-sm` | `templates/budget/index.html.twig` (1 occurrence), `templates/budget/analyse.html.twig` (2 occurrences) |

Suppression autorisee :

```text
Supprimer les lignes initiales 1620 a 1629 incluses :
- commentaire Progress bars complet ;
- regle morte .bx-progress.

Conserver strictement la ligne initiale 1630 :
.bx-progress-sm { height: 5px; }
```

Compteurs de cette plage :

```text
Lignes supprimees : 10
Regles supprimees : 1
Selecteurs supprimes : 1 (.bx-progress)
Regles conservees : 1
Selecteurs conserves : 1 (.bx-progress-sm)
```

Le bloc MIXED n'est donc pas supprime integralement. Seule sa sous-partie DEAD est retiree.
Toute suppression de `.bx-progress-sm` est un echec bloquant.

### B0-C - Deuxieme `.bx-chart-wrap`

| Champ | Valeur |
|---|---|
| Bornes | lignes 4439 a 4441 incluses |
| Contenu | deuxieme regle `.bx-chart-wrap` + deux lignes vides |
| Lignes supprimees | 3 |
| Regles supprimees | 1 |
| Selecteurs supprimes | 1 |
| Liste exhaustive | `.bx-chart-wrap` |
| Variantes dark | 0 |
| Media queries | 0 |
| Pseudo-classes/elements | 0 |
| Classification | DEAD, doublon exact de la premiere definition lignes 454-457 |
| Decision | supprimer la deuxieme definition uniquement |

Le selecteur reste SHARED via sa premiere definition. Consommateurs runtime exhaustifs :

- `templates/account/_balance_chart.html.twig` ;
- `templates/admin/analytics/errors.html.twig` ;
- `templates/admin/analytics/logins.html.twig` ;
- `templates/admin/analytics/registration.html.twig` ;
- `templates/admin/analytics/users.html.twig` ;
- `templates/admin/dashboard/index.html.twig` ;
- `templates/dashboard/index.html.twig` ;
- `templates/patrimoine/actions_fonds.html.twig` ;
- `templates/patrimoine/comptes_bancaires.html.twig` ;
- `templates/patrimoine/fonds_euros.html.twig` ;
- `templates/patrimoine/index.html.twig` ;
- `templates/patrimoine/livrets.html.twig`.

Les mentions dans `account-balance-chart.js` et `dashboard-charts.js` sont des commentaires,
pas des consommateurs DOM supplementaires.

### Totaux LOT-DASH-0

| Metrique | Initial | Delta | Final attendu |
|---|---:|---:|---:|
| Lignes `app.css` | 4733 | -25 | 4708 |
| Plages traitees | 3 | - | 2 supprimees integralement, 1 elaguee |
| Regles | non utilise comme total global | -6 | 6 regles retirees |
| Selecteurs | non utilise comme total global | -6 | 6 selecteurs retires |
| Accolades ouvrantes | 853 | -6 | 847 |
| Accolades fermantes | 853 | -6 | 847 |
| Media queries | 54 | 0 | 54 |

Liste exhaustive des selecteurs retires :

```text
.bx-hero-label
.bx-hero-value
.bx-hero-currency
.bx-hero-sublabel
.bx-progress
.bx-chart-wrap (deuxieme definition uniquement)
```

Postconditions :

```text
declarations .bx-hero-label/value/currency/sublabel : 0
declarations .bx-progress dans app.css              : 0
declarations .bx-progress-sm dans app.css           : 1
declarations .bx-chart-wrap dans app.css             : 1
```

---

## 5. LOT-DASH-1 - Custom properties T1/T2

Les custom properties sont consommees par le moteur CSS du navigateur dans
`background: linear-gradient(...)`. Elles ne sont pas transmises directement a Canvas ou
Chart.js. Le cas BLOQUANT "var() transmise a une API sans getComputedStyle()" ne s'applique pas.

| ID | Ligne initiale | Selecteur | Custom property | Hex initial | Token final | Theme | Valeur token | Consommateur | Parite/delta |
|---|---:|---|---|---|---|---|---|---|---|
| T1 | 750 | `body.nav-fixed #modalQuickContribute .modal-content` | `--_modal-grad-from` | `#4c1d95` | `var(--bx-violet-900)` | dark + light | `#4c1d95` | `.modal-header` L771, `linear-gradient(135deg, var(--_modal-grad-from) 0%, ...)` | parite exacte |
| T2 | 751 | `body.nav-fixed #modalQuickContribute .modal-content` | `--_modal-grad-to` | `#7c3aed` | `var(--bx-app-accent)` | dark | `#7c3aed` | `.modal-header` L771, stop final `100%` | parite exacte |
| T2 | 751 | meme | meme | `#7c3aed` | `var(--bx-app-accent)` | light | `#6200ea` | meme | AUTO-DELTA RGB `(-26,-58,-3)`, geometrie et stop inchanges |

Preconditions exactes :

```text
--_modal-grad-from: #4c1d95; : 1
--_modal-grad-to: #7c3aed;   : 1
```

Postconditions exactes :

```text
--_modal-grad-from: var(--bx-violet-900); : 1
--_modal-grad-to: var(--bx-app-accent);   : 1
#4c1d95 dans dashboard.css                : 0
#7c3aed dans dashboard.css                : 0
```

Ne modifier aucune autre custom property de la modale.

---

## 6. LOT-DASH-3 - Cinq methodes et 42 assertions

Fichier a creer :

```text
tests/Domain/Dashboard/DashboardInlineCodeTest.php
```

Classe :

```php
namespace App\Tests\Domain\Dashboard;

use PHPUnit\Framework\TestCase;

final class DashboardInlineCodeTest extends TestCase
```

Test structurel pur, sans DB et sans `AppTestCase`. Le repertoire projet est resolu par
`dirname(__DIR__, 3)`. Les helpers de lecture ne portent aucune assertion implicite.

### Methodes exactes

| Methode | Contrat | Fichiers inspectes | Assertions exactes | Nombre |
|---|---|---|---|---:|
| `testDashboardTemplateLoadsDashboardCssWithoutGlobalLayoutFalsePositive` | Le template Dashboard charge sa feuille une fois ; le layout global ne sert pas de faux positif | `templates/dashboard/index.html.twig`, `templates/layouts/app.html.twig` | presence du block `stylesheets` ; `substr_count("asset('css/dashboard.css')") === 1` dans le template ; compteur `dashboard.css === 0` dans le layout | 3 |
| `testAppCssKeepsOnlyLiveSharedContractsAfterLegacyCleanup` | Les quatre hero legacy et `.bx-progress` sont absents ; `.bx-progress-sm` et la premiere `.bx-chart-wrap` restent | `public/css/app.css` | 4 `assertDoesNotMatchRegularExpression` hero ; 1 absence declaration `.bx-progress` ; 1 compteur `.bx-progress-sm === 1` ; 1 compteur `.bx-chart-wrap === 1` | 7 |
| `testDashboardCssOwnsTokenizedColorAndFeatureContracts` | F12 post-lots et contrats proprietaires Dashboard | `public/css/dashboard.css` | absence des 2 hex modale ; absence des 2 rgba hero ; presence exacte G1 ; presence exacte G2 ; presence exacte T1 ; presence exacte T2 ; presence `.bx-hero__layout` ; presence `.bx-dashboard-progress-bar` ; compteur `.bx-chart-wrap--tall === 2` (base + media query) | 11 |
| `testDashboardTemplatesHaveNoTargetedInlineCodeAndJsonIsNonExecutable` | Aucun inline cible dans `templates/dashboard`; bloc JSON non executable et lu sans `eval` | les 2 templates `templates/dashboard/*.html.twig`, `public/js/dashboard-charts.js` | liste des 2 templates exacte ; 2 absences d'event inline ; 2 absences de `style=` ; 1 bloc JSON ; 7 `json_encode|raw` ; aucun script inline executable apres retrait du bloc JSON ; presence `getElementById("bx-dashboard-data")` ; presence `JSON.parse(_dataEl.textContent)` ; absence `eval(` ; absence d'assignation globale `window.<nom> =` | 12 |
| `testDynamicDashboardCustomPropertiesRemainDataDrivenAndValidated` | Les donnees dynamiques legitimes restent en `data-*`, sont bornees/validees puis resolues par CSS | `templates/dashboard/index.html.twig`, `public/js/dashboard-progress.js`, `public/css/dashboard.css` | compteurs `data-dashboard-progress === 4`, `data-dashboard-color === 1`, `data-goal-color === 2`, `data-goal-icon-color === 1` ; presence des consommateurs CSS progress/color ; regex validation avant `--bx-dashboard-color` ; regex validation avant `--bx-goal-color` et tint ; regex validation avant `--bx-goal-icon-color` | 9 |

Total exact :

```text
Methodes   : 5
Assertions : 42
```

Le test ne doit pas rechercher simplement `window.` : `dashboard-charts.js` contient une
mention documentaire `window.resize`. Le contrat cible uniquement une assignation globale
executable de forme `window.<identifiant> =`.

---

## 7. Valeurs CONSERVER - 14 decisions exactes

Le compteur porte sur **14 decisions documentees**, certaines regroupant des occurrences
homogenes. Le depot contient cinq `rgba(255,255,255,alpha)` dans `dashboard.css` et un
`#fff` opaque, soit six valeurs blanches CSS ; il serait factuellement incorrect de les
decrire comme "six rgba translucides".

| ID | Fichier / ligne | Selecteur ou fonction | Propriete / sortie | Valeur exacte | Role | Justification |
|---|---|---|---|---|---|---|
| C1 | `dashboard.css:148` | `.bx-hero__stat` | `background` | `rgba(255,255,255,0.03)` | micro-surface hero | aucun token canonique a 3 % |
| C2 | `dashboard.css:221` | `.bx-kpi__icon--neutral` | `background` | `rgba(255,255,255,0.06)` | fond icone KPI neutre | aucun token canonique a 6 % |
| C3 | `dashboard.css:700` | `.bx-quick-link__icon--neutral` | `background` | `rgba(255,255,255,0.06)` | fond icone lien neutre | meme role local, pas de token canonique |
| C4 | `dashboard.css:752` | `body.nav-fixed #modalQuickContribute .modal-content` | `--_modal-header-fg` | `#fff` | foreground absolu du header violet | blanc opaque volontaire ; pas un rgba |
| C5 | `dashboard.css:753` | meme | `--_modal-header-muted` | `rgba(255,255,255,0.72)` | eyebrow du header | contraste local sur gradient, sans equivalent semantique |
| C6 | `dashboard.css:754` | meme | `--_modal-header-border` | `rgba(255,255,255,0.15)` | surface de l'icone header | valeur locale entre les bordures canoniques |
| C7 | `dashboard-charts.js:88-97` | `palette` via `cssVar()` | fallbacks Chart.js | `#6366f1`, `#22c55e`, `#ef4444`, `#06b6d4`, `rgba(255,255,255,0.87)`, `#1e293b`, `rgba(255,255,255,0.60)`, `#475569`, `#94a3b8`, `rgba(255,255,255,0.45)`, `rgba(255,255,255,0.08)`, `rgba(0,0,0,0.05)`, `rgba(30,30,30,0.97)`, `rgba(255,255,255,0.97)` | filet de securite Canvas | `getComputedStyle()` puis `getPropertyValue()` resolvent d'abord les vrais tokens CSS |
| C8 | `dashboard-charts.js:66-84` | `withAlpha()` | chaine rgba derivee | ``rgba(${r},${g},${b},${alpha})`` ou ``rgba(${channels.join(",")},${alpha})`` | opacite datasets Chart.js | valeur calculee depuis la palette resolue, pas une couleur CSS statique |
| C9 | `dashboard-progress.js:31-45` | `hexToTint()` | chaine rgba derivee | `'rgba(' + red + ',' + green + ',' + blue + ',0.125)'` | tint couleur objectif | donnee utilisateur validee par `isHexColor()` |
| C10 | `dashboard.css` | icones, dots, canvas, modal | dimensions fixes | `8px`, `10px`, `14px`, `18px`, `20px`, `22px`, `32px`, `40px`, `300px`, `360px`, `420px` | geometrie fonctionnelle locale | dimensions exactes d'icones, pastilles, canvas et modale ; aucun token strictement equivalent |
| C11 | `dashboard.css` | hero et KPI | typographie fluide/relative | `clamp(2rem, 5vw, 3rem)`, `clamp(1.25rem, 3vw, 1.75rem)`, `clamp(1.5rem, 2.5vw, 1.75rem)`, `50%`, `55%` | hierarchie responsive | valeurs relatives fonctionnelles, non substituables par un token fixe |
| C12 | `dashboard.css` | headings, labels, controles | micro-ajustements | `2px`, `4px`, `0.05em`, `0.06em`, `0.15em`, `0.2em`, `2px 4px`, `12rem`, `11rem`, `18rem`, `45vw`, `5.75rem`, `9rem`, `2.75rem` | alignement, tracking et contraintes locales | valeurs hors granularite des tokens ou contraintes de composant |
| C13 | `dashboard.css:375,669` | `.bx-legend-btn`, `.bx-quick-link` | `transition` | `color .15s, opacity .15s` ; `border-color .2s, box-shadow .2s` | feedback local | transitions courtes propres aux composants, sans token motion strictement equivalent |
| C14 | template + `dashboard-progress.js` + `dashboard-goals.js` | attributs `data-*`, `applyProgressBars()`, `applyDynamicColors()` | custom properties / largeur | `#7c3aed`, `#a78bfa`, couleurs DB, pourcentages, `--bx-dashboard-progress`, `--bx-dashboard-color`, `--bx-goal-color`, `--bx-goal-color-tint`, `--bx-goal-icon-color`, `bar.style.width` | donnees dynamiques | valeurs metier/utilisateur, validees ou bornees avant application ; une tokenisation statique serait fausse |

Frontiere de cloture :

- F12 est clos pour les substitutions actionnables de cette campagne : 2 AUTO et
  2 AUTO-DELTA ;
- les six valeurs blanches CSS C1-C6 restent une dette acceptee et explicitement bornee ;
- les fallbacks Canvas et donnees dynamiques sont hors dette CSS statique ;
- F13 est clos avec 0 substitution : les valeurs C10-C13 sont locales et justifiees ;
- aucune de ces decisions n'empeche la cloture F12/F13 au sens du perimetre Dashboard.

---

## 8. Validations obligatoires apres chaque lot

Chaque lot suit exactement cette sequence. Le premier echec ou ecart arrete la campagne.

1. Restaurer uniquement `config/reference.php` s'il a ete regenere :

```powershell
$status = git status --short
if ($status | Select-String -Quiet 'config/reference.php') {
    git restore --staged -- config/reference.php 2>$null
    git restore -- config/reference.php
}
```

2. Verifier que le diff non indexe ne contient que l'allowlist du lot.
3. Executer les controles d'occurrences propres au lot.
4. Verifier les scripts Dashboard :

```powershell
node --check public/js/dashboard-charts.js
node --check public/js/dashboard-goals.js
node --check public/js/dashboard-progress.js
```

5. Linter Twig et le container :

```powershell
php bin/console lint:twig templates/dashboard
php bin/console lint:container
```

6. Executer PHPUnit Dashboard :

```powershell
php -d memory_limit=1G bin/phpunit tests/Domain/Dashboard --no-coverage
```

7. Executer les tests dedies disponibles :

```powershell
if (Test-Path tests/Domain/Dashboard/DashboardInlineCodeTest.php) {
    php -d memory_limit=1G bin/phpunit tests/Domain/Dashboard/DashboardInlineCodeTest.php --no-coverage
}
```

LOT-DASH-0 ajoute en lecture seule :

```powershell
php -d memory_limit=1G bin/phpunit tests/Domain/Budget/BudgetInlineCodeTest.php --no-coverage
```

8. Verifier le diff :

```powershell
git diff --check
```

9. Indexer uniquement l'allowlist du lot avec `git add -- <fichier(s)>`.
10. Verifier `git diff --cached --name-only` et `git diff --cached --check`.
11. Creer le commit atomique du lot.
12. Pousser immediatement le commit avec `git push origin master`.
13. Verifier `git status --short` vide avant le lot suivant.

Ne restaurer automatiquement aucun autre fichier que `config/reference.php`. En cas
d'echec, ne pas committer, ne pas pousser et s'arreter avec le diagnostic et le diff courant.

---

## 9. Commits atomiques

| Lot | Message exact |
|---|---|
| LOT-DASH-0 | `refactor(dashboard): remove dead legacy selectors from app css` |
| LOT-DASH-1 | `refactor(dashboard): tokenize quick contribute modal gradient` |
| LOT-DASH-2 | `refactor(dashboard): tokenize hero gradients with color mix` |
| LOT-DASH-3 | `test(dashboard): add structural inline code contracts` |

Total attendu : **4 commits pousses**, un par lot.

---

## 10. Totaux finaux figes

| Metrique | Total |
|---|---:|
| Lignes supprimees | 25 |
| Plages LOT-DASH-0 traitees | 3 |
| Blocs integralement supprimes | 2 |
| Blocs MIXED elagues | 1 |
| Regles supprimees | 6 |
| Selecteurs supprimes | 6 |
| Substitutions F12 AUTO | 2 |
| Substitutions F12 AUTO-DELTA | 2 |
| Substitutions F13 | 0 |
| Decisions CONSERVER | 14 |
| Methodes de test ajoutees | 5 |
| Assertions ajoutees | 42 |
| Fichiers uniques modifies par la campagne | 3 |
| Fichiers de production modifies par la campagne future | 2 |
| Fichiers de test crees | 1 |
| Commits | 4 |

Fichiers uniques de la campagne future :

```text
public/css/app.css
public/css/dashboard.css
tests/Domain/Dashboard/DashboardInlineCodeTest.php
```

---

## 11. Prompt Codex final

```text
Tu es Codex dans le depot Budgex.

MISSION
Executer integralement et sans intervention utilisateur les quatre lots du manifeste
`.claude/code-campaigns/dashboard-module.md`, dans l'ordre LOT-DASH-0, LOT-DASH-1,
LOT-DASH-2, LOT-DASH-3.

PRECONTROLE GIT OBLIGATOIRE
Executer exactement :

$status = git status --short
$status

if ($status | Select-String -Quiet 'config/reference.php') {
    git restore --staged -- config/reference.php 2>$null
    git restore -- config/reference.php
}

git status --short
git status -sb
git fetch origin
git rev-parse HEAD
git rev-parse origin/master

Continuer uniquement si :
- working tree propre ;
- index vide ;
- HEAD = origin/master = 53fa1c68f42161fa3e5d2822e843c66842aface9.

REGLES ABSOLUES
- Lire AGENTS.md et les sources `.claude/` obligatoires avant toute modification.
- Ne demander aucune decision utilisateur.
- LOT-DASH-2 est obligatoire en application d'ADR-029.
- Ne rechercher ni `.browserslistrc`, ni PostCSS, ni fallback navigateur.
- Ne creer aucun fallback rgba.
- S'arreter au premier test en echec, compteur inattendu, fichier hors allowlist ou push en echec.
- Ne restaurer automatiquement aucun fichier sauf `config/reference.php`.
- Ne jamais modifier bank.css, transactions.css, accounts.css, patrimoine.css, budget.css,
  ni leurs templates ou scripts.
- Action Center est lecture seule.
- Aucun fichier metier, controller, entity, repository, migration ou configuration n'est modifiable.
- Avant d'utiliser une classe CSS existante, auditer son fichier de definition, son
  chargement sur la page cible et son statut canonique ou module-local.

LOT-DASH-0
Allowlist : public/css/app.css.

Verifier avant edition :
- app.css = 4733 lignes ReadAllLines ;
- 853 accolades ouvrantes et 853 fermantes ;
- 54 media queries ;
- 4 declarations hero legacy ;
- 1 declaration .bx-progress ;
- 1 declaration .bx-progress-sm ;
- 2 declarations exactes .bx-chart-wrap.

Appliquer strictement les trois plages du manifeste :
1. supprimer les lignes initiales 1604-1615 ;
2. supprimer les lignes initiales 1620-1629, mais conserver
   `.bx-progress-sm { height: 5px; }` ;
3. supprimer les lignes initiales 4439-4441, donc uniquement la deuxieme
   definition .bx-chart-wrap et ses deux lignes vides.

Postconditions obligatoires :
- 4708 lignes ;
- 847 accolades ouvrantes et 847 fermantes ;
- 54 media queries ;
- 0 declaration hero legacy ;
- 0 declaration .bx-progress dans app.css ;
- 1 declaration .bx-progress-sm ;
- 1 declaration exacte .bx-chart-wrap ;
- 25 lignes et 6 regles supprimees.

Executer toute la sequence de validation du manifeste, y compris
BudgetInlineCodeTest.php. Apres PASS, indexer uniquement app.css, verifier le staging,
committer avec :
refactor(dashboard): remove dead legacy selectors from app css
puis pousser sur origin/master.

LOT-DASH-1
Allowlist : public/css/dashboard.css.

Preconditions :
- `--_modal-grad-from: #4c1d95;` exactement 1 ;
- `--_modal-grad-to: #7c3aed;` exactement 1.

Remplacer uniquement :
- `--_modal-grad-from: #4c1d95;`
  par `--_modal-grad-from: var(--bx-violet-900);`
- `--_modal-grad-to: #7c3aed;`
  par `--_modal-grad-to: var(--bx-app-accent);`

Ne modifier aucune autre partie du bloc modal.
Executer toute la sequence de validation. Apres PASS, indexer uniquement dashboard.css,
verifier le staging, committer avec :
refactor(dashboard): tokenize quick contribute modal gradient
puis pousser sur origin/master.

LOT-DASH-2
Allowlist : public/css/dashboard.css.
Classification : AUTO-DELTA, execution obligatoire.

Preconditions :
- `rgba(124,58,237,0.18)` exactement 1 ;
- `rgba(34,211,238,0.10)` exactement 1 ;
- les deux expressions color-mix finales absentes.

Dans la propriete background de `.bx-hero`, remplacer uniquement :
- `rgba(124,58,237,0.18)`
  par `color-mix(in srgb, var(--bx-app-accent) 18%, transparent)`
- `rgba(34,211,238,0.10)`
  par `color-mix(in srgb, var(--bx-app-info) 10%, transparent)`

Conserver strictement circle, positions, stops 0%/55%, transparent, ordre des couches
et var(--bx-app-surface). Aucun hex/rgb brut dans color-mix. Aucun fallback.
Executer toute la sequence de validation. Apres PASS, indexer uniquement dashboard.css,
verifier le staging, committer avec :
refactor(dashboard): tokenize hero gradients with color mix
puis pousser sur origin/master.

LOT-DASH-3
Allowlist : tests/Domain/Dashboard/DashboardInlineCodeTest.php.

Creer exactement la classe et les cinq methodes documentees dans le manifeste :
1. testDashboardTemplateLoadsDashboardCssWithoutGlobalLayoutFalsePositive
2. testAppCssKeepsOnlyLiveSharedContractsAfterLegacyCleanup
3. testDashboardCssOwnsTokenizedColorAndFeatureContracts
4. testDashboardTemplatesHaveNoTargetedInlineCodeAndJsonIsNonExecutable
5. testDynamicDashboardCustomPropertiesRemainDataDrivenAndValidated

Le total PHPUnit doit etre exactement 5 tests et 42 assertions pour ce fichier.
Le test est structurel pur, etend PHPUnit\Framework\TestCase et n'utilise pas la DB.
Respecter exactement les contrats et compteurs de la section LOT-DASH-3.
Executer toute la sequence de validation, avec le fichier dedie obligatoire.
Apres PASS, indexer uniquement le test, verifier le staging, committer avec :
test(dashboard): add structural inline code contracts
puis pousser sur origin/master.

RAPPORT FINAL
Fournir :
- statut initial et final ;
- SHA des quatre commits ;
- resultat de chaque validation par lot ;
- compteurs finaux exacts ;
- liste exacte des trois fichiers modifies ;
- confirmation des 4 substitutions F12 ;
- confirmation des 14 decisions CONSERVER ;
- confirmation des 5 methodes / 42 assertions ;
- confirmation qu'aucun module fige ni fichier hors allowlist n'a ete modifie ;
- confirmation des quatre push ;
- campagne autonome executable : OUI ;
- interventions utilisateur : 0.
```

---

## 12. Verdict

| Question | Reponse |
|---|---|
| Campagne autonome executable | **OUI** |
| LOT-DASH-2 obligatoire | **OUI** |
| Decision navigateur restante | **NON** |
| Branche `SKIPPED` | **NON** |
| Interventions utilisateur prevues | **0** |
| Fichiers de production modifies pendant la finalisation du manifeste | **0** |
| Commit cree pendant la finalisation du manifeste | **0** |

---

## Audit independant — 2026-06-14

### Statut : AUDITED / CLOSED

### Lots clotures
- LOT-DASH-0 : CLOSED — 16088d5ecdfcc0d0a9b41ce74f24edd7d459fdf4
- LOT-DASH-1 : CLOSED — 88ec548ca0538ecdcc57397135f8d573a4748342
- LOT-DASH-2 : CLOSED — c4a8ee7b588b6690c3324c2aa8e261ccca9dff3b
- LOT-DASH-3 : CLOSED — 9b1058bb0086ccef13e46befa5c667bb40a128cd

### HEAD final
9b1058bb0086ccef13e46befa5c667bb40a128cd = origin/master

### Resultats tests
- `node --check` dashboard-charts.js / dashboard-goals.js / dashboard-progress.js : OK (0 erreur)
- `lint:twig templates/dashboard` : OK (2 fichiers valides)
- `lint:container` : OK
- `DashboardInlineCodeTest.php` : 5 tests, 42 assertions — PASS
- `--filter Dashboard` : 52 tests, 277 assertions — PASS
- `BudgetInlineCodeTest.php` (regression) : 7 tests, 28 assertions — PASS
- `git diff --check` : rien
- Working tree post-audit : propre (config/reference.php restaure)

### 14 decisions CONSERVER confirmees
- C1 : dashboard.css:148 rgba(255,255,255,0.03) micro-surface hero — CONSERVER
- C2 : dashboard.css:221 rgba(255,255,255,0.06) fond icone KPI neutre — CONSERVER
- C3 : dashboard.css:700 rgba(255,255,255,0.06) fond icone lien neutre — CONSERVER
- C4 : dashboard.css:752 #fff palette locale modale header — CONSERVER
- C5 : dashboard.css:753 rgba(255,255,255,0.72) eyebrow header violet — CONSERVER
- C6 : dashboard.css:754 rgba(255,255,255,0.15) bordure icone header — CONSERVER
- C7 : dashboard-charts.js fallbacks Canvas via cssVar() — CONSERVER
- C8 : dashboard-charts.js withAlpha() rgba derivee dynamique — CONSERVER
- C9 : dashboard-progress.js hexToTint() rgba derivee validee — CONSERVER
- C10 : dashboard.css dimensions fixes (8px, 40px, 300px, 360px, 420px...) — CONSERVER
- C11 : dashboard.css typographie fluide clamp() et relatives (55%, 50%...) — CONSERVER
- C12 : dashboard.css micro-ajustements (2px, 4px, 0.06em, 12rem...) — CONSERVER
- C13 : dashboard.css transitions locales (.15s, .2s) — CONSERVER
- C14 : template + progress.js + goals.js custom properties data-driven validees — CONSERVER

### Verdicts
DASHBOARD.CSS F12 STRICTEMENT CLOTURE : OUI
DASHBOARD.CSS F13 STRICTEMENT CLOTURE : OUI
LEGACY DASHBOARD APP.CSS SUPPRIME : OUI
CONTRATS PARTAGES APP.CSS PRESERVES : OUI
TEMPLATES DASHBOARD STRICTEMENT CLOTURES : OUI
JAVASCRIPT DASHBOARD STRICTEMENT CLOTURE : OUI (reserve mineure : innerHTML avec data-goal-icon — non bloquant, cf. reserves)
CUSTOM PROPERTIES DYNAMIQUES JUSTIFIEES : OUI
CONTRATS JSON SURS : OUI
GRAPHIQUES DASHBOARD STABILISES : OUI
DONNEES METIER INCHANGEES : OUI
RESPONSIVE STRUCTURELLEMENT STABILISE : OUI
MODULE DASHBOARD FONCTIONNELLEMENT STABILISE : OUI
MODULE DASHBOARD FIGEABLE : OUI
CAMPAGNE AUTONOME DASHBOARD VALIDEE : OUI

### Reserves non bloquantes
1. dashboard-goals.js L30 : `iconEl.innerHTML = '<i class="material-icons-outlined" ...>' + icon + '</i>'`
   La variable `icon` vient de `btn.getAttribute('data-goal-icon')`, rendu par Twig avec auto-escape.
   Risque XSS minimal (nom d'icone Material controle cote serveur). Pattern courant acceptable.
   A remplacer par `textContent` sur un element existant ou `createElement` si durcissement securite demande.
2. dashboard-charts.js fallbacks Canvas : 14 valeurs brutes dans `palette` (C7).
   Legitimes et documentes comme filet de securite si `getComputedStyle()` echoue. Non substituables.
3. Audit visuel navigateur non execute (hors perimetre de cet audit statique).

### Directive
dashboard.css, templates/dashboard/ et les scripts Dashboard sont figes.
Ne pas rouvrir sans bug ou evolution produit explicitement demontree.
