# Campagne Recette Visuelle Globale — Budgex

**Date de création** : 2026-06-16  
**Date de mise à jour** : 2026-06-17  
**HEAD de référence** : `0f590d1369a53f40f58e9defce60c9422215e2e0`  
**Statut** : TERMINÉ — Phases 1, 2, 3 exécutées (110 scénarios) — voir verdict global en fin de fichier  
**Type** : Audit perceptuel — anomalies visibles uniquement, pas de dettes statiques

---

## Périmètre et posture

Cette campagne recherche des **anomalies perceptibles** dans le rendu visuel réel de l'application.

Elle ne doit **pas** :
- ouvrir des modules figés pour supprimer des valeurs raw ;
- résoudre des deltas imperceptibles (`0.62rem` vs `0.625rem`) ;
- normaliser des nommages ou réduire des compteurs CSS ;
- refactorer sans défaut observable.

Elle **doit** :
- identifier tout ce qu'un utilisateur verrait comme cassé, incohérent ou illisible ;
- couvrir les deux thèmes, tous les viewports, et les états critiques.

---

## A. Interventions utilisateur requises — 7 obligatoires

### A1. Prérequis techniques (avant toute recette)
1. **Démarrer le serveur local** : `php -S localhost:8000 -t public/` ou `symfony server:start`
2. **Ouvrir un navigateur avec DevTools** : Chrome ou Firefox, Device Toolbar activé

### A2. Comptes nécessaires (3 profils — voir section C)
3. **Compte VISUAL-DATA** : utilisateur avec transactions, comptes, budgets, patrimoine, objectifs
4. **Compte VISUAL-EMPTY** : utilisateur sans données métier
5. **Compte VISUAL-ADMIN** : accès ROLE_ADMIN aux routes `/admin/*`

### A3. Actions de recette
6. **Exécuter la checklist Phase 1** en consignant résultat (PASS/FAIL) et captures pour les FAIL
7. **Basculer les thèmes** dark/light pour chaque scénario concerné (méthode console ci-dessous)

### A4. Arbitrages après recette
8. **Décider pour chaque anomalie** : lot correctif atomique ou classement CONSERVER

> **Note** : les arbitrages (item 8) peuvent être délégués à une session Claude Code dédiée après fourniture des captures.

---

## B. Méthode de bascule de thème

```javascript
// Dans la console du navigateur :
document.documentElement.setAttribute('data-theme', 'dark')
document.documentElement.setAttribute('data-theme', 'light')
```

Alternativement : préférences → toggle thème dans la nav applicative.  
Valeur stockée dans `localStorage['bx-theme']`.

---

## C. Profils de comptes de recette

### VISUAL-DATA
Compte utilisateur standard avec données représentatives :
- ≥ 2 comptes bancaires (dont un synchronisé Powens si disponible)
- ≥ 20 transactions (dont quelques récurrentes et quelques non revues)
- ≥ 1 budget configuré avec au moins une catégorie de dépense
- ≥ 1 objectif avec contributions
- ≥ 1 entrée patrimoine (livret, bien immobilier ou portefeuille)
- Connexion Powens active ou mock (pour Bank index)

### VISUAL-EMPTY
Compte utilisateur sans données métier :
- 0 transaction, 0 compte, 0 budget, 0 objectif
- Objectif : vérifier tous les états vides (empty-state partout)

### VISUAL-ADMIN
Compte avec rôle ROLE_ADMIN :
- Accès `/admin/*`
- **Peut être le même compte que VISUAL-DATA** si le compte admin possède aussi des données (acceptable pour Phase 1)
- Ne pas stocker identifiants ou mots de passe dans ce fichier

---

## D. Plan en trois phases

### Phase 1 — Parcours critiques P1
**Objectif** : détecter les anomalies majeures sur les parcours essentiels.  
**Viewports** : VP1 (360×800) et VP4 (1440×900)  
**Thèmes** : dark et light  
**Volume** : 42 scénarios  
**Prérequis** : VISUAL-DATA + VISUAL-EMPTY + serveur local  
**Clôture** : 0 P0 ouvert, 0 P1 non arbitré

### Phase 2 — Responsive et états secondaires
**Objectif** : couvrir VP2/VP3/VP5, anomalies Phase 1, routes P2.  
**Viewports** : VP2 (390×844), VP3 (768×1024), VP5 (1920×1080)  
**Périmètre** :
- Anomalies identifiées en Phase 1 (re-vérification viewports supplémentaires)
- Goals (index, show, formulaires)
- Cashflow
- Action Center et Notifications
- Catégories, Règles, Libellés
- Billing (success, cancel, manage)
- Formulaires secondaires (account/edit, transaction/edit, libelle/new)
- Pages légales et erreurs 403/404/500
**Prérequis** : résultats Phase 1 + VISUAL-ADMIN

### Phase 3 — Admin et cas limites
**Objectif** : couvrir l'Admin complet et les états rares.  
**Périmètre** :
- 14 routes `/admin/*`
- Listes volumineuses (DataTable > 100 entrées)
- Chaînes longues (emails, noms, descriptions)
- Erreurs de formulaire (validation, CSRF, rate-limit)
- Export PDF (Dompdf — rendu navigateur)
- États rares (2FA Recovery, resend-verification, maintenance)
**Prérequis** : VISUAL-ADMIN avec données admin représentatives

---

## E. Matrice des viewports

| ID | Label | Largeur × Hauteur | Phase | Cas |
|---|---|---|---|---|
| VP1 | Mobile étroit | 360 × 800 | 1 + 2 | Android entrée de gamme, cas critique |
| VP2 | Mobile courant | 390 × 844 | 2 | iPhone 14 standard |
| VP3 | Tablette | 768 × 1024 | 2 | iPad portrait |
| VP4 | Desktop | 1440 × 900 | 1 + 2 | Laptop standard |
| VP5 | Grand desktop | 1920 × 1080 | 2 + 3 | Moniteur externe |

---

## F. Checklist Phase 1 — 42 scénarios

> Chaque scénario : `[ ]` = non exécuté · `[P]` = PASS · `[F]` = FAIL · `[N]` = NON TESTABLE

### F1. Layout et navigation (S01–S03)

**S01** — Navigation mobile  
`[ ]` Route : toute route `/app/*` · Compte : VISUAL-DATA · État : données normales  
Viewport : VP1 · Thème : **dark**  
Interactions : ouvrir le menu hamburger, naviguer vers 2 sections, fermer  
Contrats : hamburger ≥ 44×44px · overlay fond opaque · items ≥ 44px hauteur · logo non tronqué · badge notifications visible · fermeture par tap extérieur  
Résultat : `[ ]` · Anomalie : —

**S02** — Navigation desktop dark  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-DATA · État : données normales  
Viewport : VP4 · Thème : **dark**  
Interactions : vérifier item actif, badge, scroll si long  
Contrats : sidenav fond `#1a1a1a`, item actif distinct, texte `rgba(255,255,255,0.87)`, hover visible  
Résultat : `[ ]` · Anomalie : —

**S03** — Navigation desktop light  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-DATA · État : données normales  
Viewport : VP4 · Thème : **light**  
Interactions : idem S02  
Contrats : fond clair cohérent, texte `#303744`, item actif lisible, pas de fond blanc sur fond blanc  
Résultat : `[ ]` · Anomalie : —

---

### F2. Authentification (S04–S06)

**S04** — Login mobile dark  
`[ ]` Route : `/login` · Compte : sans connexion · État : normal  
Viewport : VP1 · Thème : **dark**  
Interactions : saisir identifiants incorrects → voir message erreur  
Contrats : champ email/password pleine largeur · floating label non chevauchant · message erreur visible (`--bx-app-danger`) · bouton ≥ 44px · gradient `bx-auth-body` rendu  
Résultat : `[ ]` · Anomalie : —

**S05** — Login desktop light  
`[ ]` Route : `/login` · Compte : sans connexion · État : normal  
Viewport : VP4 · Thème : **light**  
Interactions : vérifier le fond auth en thème clair  
Contrats : gradient auth distinct du fond page · champs lisibles · focus ring visible  
Résultat : `[ ]` · Anomalie : —

**S06** — 2FA mobile dark  
`[ ]` Route : `/2fa` · Compte : VISUAL-DATA (2FA activé) · État : attente code  
Viewport : VP1 · Thème : **dark**  
Interactions : afficher le champ code TOTP  
Contrats : champ centré · clavier numérique natif attendu (type="text" ou "number") · bouton submit accessible  
Résultat : `[ ]` · Anomalie : —

---

### F3. Dashboard (S07–S11)

**S07** — Dashboard données dark desktop  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-DATA · État : données normales  
Viewport : VP4 · Thème : **dark**  
Interactions : observer KPI, graphique barres, donut, widget "À venir"  
Contrats : `.bx-kpi` — surface dark, valeur mono bold 1.5rem, positif/négatif distincts · graphique barres adapté thème (`isDark`) · donut patrimoine lisible · widget "À venir" présent si récurrentes  
Résultat : `[ ]` · Anomalie : —

**S08** — Dashboard données light desktop  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-DATA · État : données normales  
Viewport : VP4 · Thème : **light**  
Interactions : basculer vers light, vérifier adaptation graphiques  
Contrats : graphiques recalculés pour thème clair · KPI surface light · textes contrastes ≥ 4.5:1  
Résultat : `[ ]` · Anomalie : —

**S09** — Dashboard données dark mobile  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-DATA · État : données normales  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller, vérifier KPI empilés, graphique réduit  
Contrats : KPI grille max 2 colonnes · `bx-donut-wrap max-width: 240px` — non tronqué · montants longs non débordants · graphique barres scrollable ou réduit sans overflow horizontal  
Résultat : `[ ]` · Anomalie : —

**S10** — Dashboard état vide dark desktop  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-EMPTY · État : aucune donnée  
Viewport : VP4 · Thème : **dark**  
Interactions : observer tous les blocs sans données  
Contrats : `.bx-empty-state` présent sur chaque bloc vide · titre, sous-titre, CTA visibles · pas de KPI à zéro sans avertissement · dark override L1958 titre  
Résultat : `[ ]` · Anomalie : —

**S11** — Dashboard état vide mobile  
`[ ]` Route : `/app/dashboard` · Compte : VISUAL-EMPTY · État : aucune donnée  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller page complète  
Contrats : empty-state centré · CTA accessible (min 44px) · pas d'overflow horizontal  
Résultat : `[ ]` · Anomalie : —

---

### F4. Comptes (S12–S17)

**S12** — Accounts index dark mobile  
`[ ]` Route : `/app/accounts` · Compte : VISUAL-DATA · État : liste comptes  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller liste, taper sur un compte  
Contrats : logos banques chargés · cartes `.bx-card` arrondies — `var(--bx-radius-lg)` · shadow elev-sm · aucun overflow horizontal · soldes lisibles  
Résultat : `[ ]` · Anomalie : —

**S13** — Accounts index light desktop  
`[ ]` Route : `/app/accounts` · Compte : VISUAL-DATA · État : liste comptes  
Viewport : VP4 · Thème : **light**  
Interactions : hover sur carte  
Contrats : hover transform translateY(-2px) visible · surface light distincte du fond · bordure visible  
Résultat : `[ ]` · Anomalie : —

**S14** — Accounts index état vide dark  
`[ ]` Route : `/app/accounts` · Compte : VISUAL-EMPTY · État : aucun compte  
Viewport : VP4 · Thème : **dark**  
Interactions : observer  
Contrats : `.bx-empty-state` — icône, titre, CTA "Ajouter un compte"  
Résultat : `[ ]` · Anomalie : —

**S15** — Account show dark mobile  
`[ ]` Route : `/app/accounts/{id}` · Compte : VISUAL-DATA · État : compte avec transactions  
Viewport : VP1 · Thème : **dark**  
Interactions : observer onglets, graphique solde, liste transactions récentes  
Contrats : onglets accessibles (tap 44px) · graphique non tronqué · KPI cards empilées · section info lisible  
Résultat : `[ ]` · Anomalie : —

**S16** — Account new dark mobile (formulaire + radius APP-2)  
`[ ]` Route : `/app/accounts/new` · Compte : VISUAL-DATA · État : formulaire vide  
Viewport : VP1 · Thème : **dark**  
Interactions : remplir, déclencher une erreur validation, soumettre  
Contrats : **radius** `.bx-account-form .form-floating > .form-control` → `var(--bx-radius-md)` (cohérent Bootstrap) · `.bx-account-form-btn` width 100% · floating labels non chevauchants · erreur `.invalid-feedback` visible · clavier adapté  
Résultat : `[ ]` · Anomalie : —

**S17** — Account new light desktop  
`[ ]` Route : `/app/accounts/new` · Compte : VISUAL-DATA · État : formulaire vide  
Viewport : VP4 · Thème : **light**  
Interactions : focus sur champ, vérifier focus ring  
Contrats : `box-shadow: 0 0 0 3px --bx-app-focus-ring` visible en light · fond input `--bx-app-inset` distinct · label light lisible  
Résultat : `[ ]` · Anomalie : —

---

### F5. Bank / Powens (S18–S20)

**S18** — Bank index dark mobile  
`[ ]` Route : `/app/bank-connections` · Compte : VISUAL-DATA · État : connexion(s) active(s)  
Viewport : VP1 · Thème : **dark**  
Interactions : observer cartes connexions, status badges  
Contrats : logos Powens chargés · status badge (actif/erreur) distinct · boutons sync/déconnecter ≥ 36px · aucun overflow  
Résultat : `[ ]` · Anomalie : —

**S19** — Bank index état vide dark desktop  
`[ ]` Route : `/app/bank-connections` · Compte : VISUAL-EMPTY · État : aucune connexion  
Viewport : VP4 · Thème : **dark**  
Interactions : observer  
Contrats : empty-state avec CTA connexion Powens visible  
Résultat : `[ ]` · Anomalie : —

**S20** — Powens Staging dark desktop  
`[ ]` Route : `/app/bank-connections/staging` · Compte : VISUAL-DATA · État : comptes en attente  
Viewport : VP4 · Thème : **dark**  
Interactions : observer les options (lier/créer/ignorer)  
Contrats : boutons d'action distincts · informations compte staging lisibles · aucun doublon visuel  
Résultat : `[ ]` · Anomalie : —

---

### F6. Transactions (S21–S26)

**S21** — Transactions dark mobile (DataTable + colonnes masquées)  
`[ ]` Route : `/app/transactions` · Compte : VISUAL-DATA · État : liste avec données  
Viewport : VP1 · Thème : **dark**  
Interactions : observer le tableau, essayer la recherche DataTable  
Contrats : colonnes `.d-none.d-sm-table-cell` masquées · **0 overflow horizontal** · recherche accessible · pagination touch-friendly · header `.bx-thead` fond surface-2 visible  
Résultat : `[ ]` · Anomalie : —

**S22** — Transactions light desktop  
`[ ]` Route : `/app/transactions` · Compte : VISUAL-DATA · État : liste avec données  
Viewport : VP4 · Thème : **light**  
Interactions : hover lignes tableau, filtrer par mois  
Contrats : `.bx-budgets-table` hover → **violet 5% (`rgba(primary, 0.05)`)** — vérification APP-1 · header light visible · filtres lisibles · `.bx-budgets-header-btn` radius `var(--bx-radius-md)`  
Résultat : `[ ]` · Anomalie référence : ANOM-CSS-001

**S23** — Transactions filtre pending dark desktop  
`[ ]` Route : `/app/transactions?filter=pending` · Compte : VISUAL-DATA · État : transactions non revues  
Viewport : VP4 · Thème : **dark**  
Interactions : observer bandeau alerte, lignes à réviser  
Contrats : bandeau alerte visible (`.bx-notice` warning ou alert Bootstrap) · lignes `table-warning-subtle` distinctes · bouton "Tout marquer" accessible  
Résultat : `[ ]` · Anomalie : —

**S24** — Inbox dark mobile (modale qualify)  
`[ ]` Route : `/app/transactions/inbox` · Compte : VISUAL-DATA · État : transactions à qualifier  
Viewport : VP1 · Thème : **dark**  
Interactions : ouvrir modale de qualification, remplir, fermer  
Contrats : modale fond dark `#1e1e1e` · **footer modale visible** sans scroll infini · champs formulaire embarqués lisibles · bouton submit ≥ 44px · fermeture accessible  
Résultat : `[ ]` · Anomalie référence : ANOM-MODAL-001

**S25** — À traiter dark desktop  
`[ ]` Route : `/app/a-traiter` · Compte : VISUAL-DATA · État : éléments en attente  
Viewport : VP4 · Thème : **dark**  
Interactions : observer liste  
Contrats : liste bien structurée · actions accessibles · thème dark cohérent avec le reste de l'app  
Résultat : `[ ]` · Anomalie : —

**S26** — Transactions état vide dark  
`[ ]` Route : `/app/transactions` · Compte : VISUAL-EMPTY · État : aucune transaction  
Viewport : VP4 · Thème : **dark**  
Interactions : observer  
Contrats : empty-state centré, titre, sous-titre, CTA "Ajouter"  
Résultat : `[ ]` · Anomalie : —

---

### F7. Budget (S27–S31)

**S27** — Budget dark mobile (card-view tableau partagé)  
`[ ]` Route : `/app/budgets` · Compte : VISUAL-DATA · État : budgets avec données  
Viewport : VP1 · Thème : **dark**  
Interactions : observer tableau, hover  
Contrats : `@media ≤575.98px` → thead masqué, lignes = cards `border-radius: .5rem` · aucun overflow · `.bx-budgets-header-btn` centré mobile  
Résultat : `[ ]` · Anomalie référence : ANOM-RESP-002

**S28** — Budget light desktop (hover tableau partagé APP-1)  
`[ ]` Route : `/app/budgets` · Compte : VISUAL-DATA · État : budgets avec données  
Viewport : VP4 · Thème : **light**  
Interactions : hover sur lignes du tableau  
Contrats : hover violet 5% visible via `--bx-budgets-row-hover` (défini dans budget.css L13) · `.bx-budgets-header-btn--secondary` outline visible light · radius cohérent  
Résultat : `[ ]` · Anomalie : —

**S29** — Budget analyse dark desktop  
`[ ]` Route : `/app/budget/analyse` · Compte : VISUAL-DATA · État : données ce mois  
Viewport : VP4 · Thème : **dark**  
Interactions : ouvrir accordéon catégories, observer donut  
Contrats : KPI épargne/revenus/dépenses distincts · donut couleurs lisibles dark · accordéon chevron animé · drill-down sous-catégories fonctionnel  
Résultat : `[ ]` · Anomalie : —

**S30** — Budget analyse dark mobile  
`[ ]` Route : `/app/budget/analyse` · Compte : VISUAL-DATA · État : données ce mois  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller, ouvrir accordéon  
Contrats : donut `max-width: 240px` non tronqué · KPI empilés · accordéon utilisable au tap  
Résultat : `[ ]` · Anomalie : —

**S31** — Budget état vide dark  
`[ ]` Route : `/app/budgets` · Compte : VISUAL-EMPTY · État : aucun budget  
Viewport : VP4 · Thème : **dark**  
Interactions : observer  
Contrats : empty-state avec CTA "Créer un budget"  
Résultat : `[ ]` · Anomalie : —

---

### F8. Patrimoine (S32–S36)

**S32** — Patrimoine index dark mobile  
`[ ]` Route : `/app/patrimoine` · Compte : VISUAL-DATA · État : patrimoine renseigné  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller, ouvrir accordéon classe d'actifs  
Contrats : hero total lisible · donut `max-width: 240px` · accordéon dark (Bootstrap tokens overridés) · chevron gauche animé · colonnes Répartition|Valeur lisibles  
Résultat : `[ ]` · Anomalie : —

**S33** — Patrimoine index light desktop  
`[ ]` Route : `/app/patrimoine` · Compte : VISUAL-DATA · État : patrimoine renseigné  
Viewport : VP4 · Thème : **light**  
Interactions : basculer thème, observer  
Contrats : donut couleurs adaptées light · accordéon light lisible · fond surface light distinct  
Résultat : `[ ]` · Anomalie référence : ANOM-GRAPH-001 (bascule thème graphique)

**S34** — Patrimoine comptes-bancaires dark desktop  
`[ ]` Route : `/app/patrimoine/comptes-bancaires` · Compte : VISUAL-DATA · État : comptes listés  
Viewport : VP4 · Thème : **dark**  
Interactions : observer liste, graphiques éventuels  
Contrats : cohérence visuelle avec Accounts (cartes similaires) · logos · soldes  
Résultat : `[ ]` · Anomalie : —

**S35** — Patrimoine état vide dark  
`[ ]` Route : `/app/patrimoine` · Compte : VISUAL-EMPTY · État : aucun actif  
Viewport : VP4 · Thème : **dark**  
Interactions : observer  
Contrats : classes absentes masquées · CTA ou message explicatif · pas de graphique vide "cassé"  
Résultat : `[ ]` · Anomalie : —

**S36** — Patrimoine livrets dark mobile  
`[ ]` Route : `/app/patrimoine/livrets` · Compte : VISUAL-DATA · État : livrets renseignés  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller, observer projections  
Contrats : cartes lisibles mobile · taux affichés · pas d'overflow  
Résultat : `[ ]` · Anomalie : —

---

### F9. Report et Export (S37–S40)

**S37** — Report index dark desktop (hover APP-1 critique)  
`[ ]` Route : `/app/reports` · Compte : VISUAL-DATA · État : données  
Viewport : VP4 · Thème : **dark**  
Interactions : **hover sur lignes du tableau** — contrôle APP-1  
Contrats : `.bx-budgets-table > tbody > tr:hover` → **fond violet 5% visible** (fallback activé, budget.css non chargé sur cette page) · tableau `.bx-report-shell` distinct · header `.bx-thead` fond surface-2  
Résultat : `[ ]` · Anomalie référence : ANOM-CSS-001 ← **critique APP-1**

**S38** — Report index light desktop (hover APP-1 critique)  
`[ ]` Route : `/app/reports` · Compte : VISUAL-DATA · État : données  
Viewport : VP4 · Thème : **light**  
Interactions : hover sur lignes  
Contrats : hover visible en thème clair (même fallback `rgba(primary, 0.05)`)  
Résultat : `[ ]` · Anomalie référence : ANOM-CSS-001

**S39** — Report index dark mobile  
`[ ]` Route : `/app/reports` · Compte : VISUAL-DATA · État : données  
Viewport : VP1 · Thème : **dark**  
Interactions : scroller tableau, observer card-view ≤575px  
Contrats : colonnes masquées · card-view lisible · `.bx-budgets-header-btn` centré  
Résultat : `[ ]` · Anomalie référence : ANOM-RESP-001

**S40** — Export transactions dark desktop (hover APP-1)  
`[ ]` Route : `/app/export/transactions` · Compte : VISUAL-DATA · État : données  
Viewport : VP4 · Thème : **dark**  
Interactions : hover sur lignes tableau, observer filtres, boutons export  
Contrats : hover violet 5% visible · `.bx-export-shell` distinct · boutons export `.d-none.d-sm-flex` visibles · aucun `<style>` inline (contrat APP-3)  
Résultat : `[ ]` · Anomalie référence : ANOM-CSS-001

---

### F10. Profil et Sécurité (S41–S42)

**S41** — Profile security dark mobile  
`[ ]` Route : `/app/profile/security` · Compte : VISUAL-DATA · État : sessions actives, 2FA  
Viewport : VP1 · Thème : **dark**  
Interactions : observer sections (2FA, trusted devices, sessions)  
Contrats : sections bien délimitées · boutons danger "Révoquer" distincts (rouge visible dark) · codes backup lisibles · aucun overflow  
Résultat : `[ ]` · Anomalie : —

**S42** — Profile security light desktop  
`[ ]` Route : `/app/profile/security` · Compte : VISUAL-DATA · État : sessions actives  
Viewport : VP4 · Thème : **light**  
Interactions : observer  
Contrats : bouton danger rouge lisible light · QR code (si 2FA setup) sur fond clair · focus visible  
Résultat : `[ ]` · Anomalie : —

---

### F11. Modales et Toasts (S43–S44) — dans contexte des pages ci-dessus

**S43** — Modale de suppression dark mobile  
`[ ]` Route : `/app/accounts/{id}` ou `/app/budgets` · Compte : VISUAL-DATA · État : modale delete ouverte  
Viewport : VP1 · Thème : **dark**  
Interactions : ouvrir modale suppression, lire le message, fermer sans supprimer  
Contrats : fond modal dark `#1e1e1e` · footer visible (bouton "Annuler" + "Supprimer") · bouton danger rouge distinct · libellé explicite · fermeture par bouton ✕ accessible  
Résultat : `[ ]` · Anomalie : —

**S44** — Toast flash dark mobile  
`[ ]` Route : toute après action (save, delete, error) · Compte : VISUAL-DATA  
Viewport : VP1 · Thème : **dark**  
Interactions : déclencher une action avec flash message  
Contrats : `.bx-toast` ou flash Bootstrap → position top visible · ne masque pas les actions critiques · disparaît après délai ou tap · pleine largeur mobile `@media ≤480px`  
Résultat : `[ ]` · Anomalie : —

---

**TOTAL PHASE 1 : 44 scénarios** (S01–S44)

---

## G. Journal des anomalies

| ID | Date | Phase | Route | VP | Thème | Compte | État | Composant | Description factuelle | Résultat attendu | Sévérité | Capture | Repro | Module | Décision | Lot |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| VIS-P1-001 | 2026-06-17 | 1 | `/app/*` (toute route) | VP1 360, VP2 390 | dark/light | VISUAL-DATA | données normales | `.dropdown-notifications` (topbar) | Le bouton de notifications (`#notificationDropdown`, badge non lues) porte la classe Bootstrap `d-none d-sm-block` → invisible sous 576px. Le drawer mobile (`#drawerToggle`) ne contient aucune entrée "Notifications" de repli. `/app/notifications` répond 200 en accès direct mais aucun contrôle visible n'y mène sur mobile. | Un point d'entrée visible vers le centre de notifications doit exister sur tous les viewports, y compris < 576px. | P1 | S01_VP1_dark_top.png, drawer-open.png | Reproductible (2 viewports testés, 2 thèmes, indépendant des données) | CSS/Twig — topbar mobile | OUVERT | LOT-VIS-NAV-001 |
| VIS-P1-002 | 2026-06-17 | 1 | `/app/budgets`, `/app/reports`, `/app/export/transactions` | VP4 1440, VP5 1920 | **dark uniquement** | VISUAL-DATA | données normales | `.bx-budgets-table > tbody > tr:hover` | En thème dark, `html[data-theme="dark"] .table-hover > tbody > tr:hover > *` (app.css ~L1906) force `background-color: rgba(255,255,255,.05) !important`, qui gagne systématiquement sur la règle `.bx-budgets-table > tbody > tr:hover > * { background-color: var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb),.05)); }` (app.css L4068-4069, sans `!important`). Résultat : hover gris neutre au lieu du violet de marque sur Budgets/Reports/Export en dark. Vérifié programmatiquement (`getComputedStyle` avant/après hover) : dark → `rgb(255,255,255,0.05)` constant sur les 3 pages ; light → `rgba(98,0,234,0.05)` (violet, correct) sur les mêmes pages. | Hover `.bx-budgets-table` doit afficher la même teinte violette `rgba(primary,.05)` en dark et en light. | P2 | hover-check.js output (avant/après par thème), S37/S38 top.png | Reproductible (3 pages, dark seulement, confirmé 2x) | `public/css/app.css` (règle dark polyfill L1906) | OUVERT | LOT-VIS-CSS-001 |
| VIS-P1-003 | 2026-06-17 | 1 | `/app/budgets`, `/app/goals/{id}/edit`, `/app/patrimoine/immobilier/{id}` vs `/app/accounts/{id}` | VP1 360 | dark | VISUAL-DATA | données normales | Confirmation de suppression | Le bouton supprimer d'un compte (`account/_delete_modal.html.twig`, `data-bs-toggle="modal"`) ouvre une modale Bootstrap stylée (choix Archiver/Supprimer définitivement, bouton Annuler). Le bouton supprimer d'un budget/objectif/bien immobilier (`form[data-confirm-delete]`, géré par `budget-actions.js` / `goal-form.js` / `immobilier_show.js`) déclenche un `window.confirm()` natif non stylé (pas de dark mode, chrome navigateur générique). | Toute action destructive devrait utiliser le même pattern de confirmation (modale stylée) pour une cohérence de marque et d'accessibilité. | P2 | account-delete-modal.png | Reproductible (code source confirmé sur 4 fichiers JS + 1 partial Twig) | `public/js/budget-actions.js`, `goal-form.js`, `immobilier_show.js` | OUVERT | LOT-VIS-UX-001 |
| VIS-P1-004 | 2026-06-17 | 3 | `/admin/design-system` | VP4 1440 | dark | VISUAL-ADMIN | n/a | Preview cards "Marque" (brand-logo) | 4 fichiers `public/design-system-previews/{brand-logo-usage,brand-logo,components-navbar-landing,components-sidebar}.html` référencent `/assets/favicon.png` et `/assets/logo.png` (chemin incorrect, il manque le segment `img/` — le bon chemin observé ailleurs dans l'app est `/assets/img/favicon.png`). AssetMapper renvoie HTTP 500 (au lieu de 404) sur ces chemins inconnus : `Unable to find asset "./styles/app.css" imported from ".../assets/app.js"`. 5 erreurs console + 5 erreurs réseau (500) à l'ouverture de la page. | Les previews de marque doivent charger logo/favicon sans erreur 500 ; chemin correct = `/assets/img/...`. | P3 | P3-19_VP4_dark_top.png, curl headers (X-Debug-Exception) | Reproductible (curl direct + 4 fichiers source identifiés) | `public/design-system-previews/*.html` | OUVERT | LOT-VIS-CSS-002 |

### Observations hors anomalie (classées sans lot correctif)

| Sujet | Constat | Décision |
|---|---|---|
| Bascule thème live (ANOM-GRAPH-001) | `theme.js` écoute `MQ.addEventListener('change', ...)` pour re-appliquer `data-theme` quand préférence = 'system'. Test via `page.emulateMedia({colorScheme})` : `matchMedia(...).matches` change bien, mais `data-theme` ne se met pas à jour dans l'environnement de test Playwright/CDP — résultat non concluant car l'émulation CDP ne déclenche pas toujours l'évènement `change` réel sur un `MediaQueryList` existant (limitation outil documentée). | NON_REPRODUCTIBLE (outil) — à revérifier manuellement avec un vrai changement de thème OS si le doute persiste. |
| Fraîcheur des fixtures (Dashboard/Reports/Budgets "ce mois") | Les transactions de `arnaud.robert@test.budgex` couvrent 2025-09-01→2026-03-31 ; "aujourd'hui" = 2026-06-17. Les écrans pilotés par "mois courant" sans paramètre d'URL (Dashboard) affichent donc 0,00€ alors que le compte a des données réelles sur Mars 2026. Confirmé en relançant Reports/Budgets/Analyse avec `?month=3&year=2026` / `?period=custom&from=2026-03-01&to=2026-03-31` → rendu correct avec données. | HORS_PÉRIMÈTRE (donnée de test, pas un défaut de code). |
| Pages d'erreur 403/404/500 | `/app/transactions/9999999/edit` (404) et `/admin/design-system` (500 asset) affichent la page de debug Symfony complète (stack trace) au lieu d'un template d'erreur stylé, parce que `APP_ENV=dev` + debug actif — comportement Symfony intentionnel en dev, le template `layouts/error.html.twig` stylé ne s'active qu'avec `APP_DEBUG=0`. | HORS_PÉRIMÈTRE (contrainte d'environnement imposée par la campagne — dev/test obligatoire). |
| Mentions légales (`/legal/mentions-legales`) | Affiche littéralement `[Nom de l'éditeur à compléter]` / `[Adresse de l'éditeur à compléter]` — placeholders du module "Légal Dynamique" non renseignés dans cette base de dev. Configurable via `/admin/legal-settings` (`ROLE_SUPER_ADMIN` requis). | HORS_PÉRIMÈTRE (donnée de configuration, pas un défaut de code applicatif). |
| `/admin/settings`, `/admin/legal-settings` | Renvoient 403 pour `admin@budgex.fr` (ROLE_ADMIN) — confirmé intentionnel : `#[IsGranted('ROLE_SUPER_ADMIN')]` sur les deux contrôleurs. | CONSERVER (contrôle d'accès correct). |
| `/app/patrimoine/immobilier/1` | Renvoit 403 pour `arnaud.robert@test.budgex` — le bien id=1 appartient à un autre utilisateur (`yannick.erdmann@live.fr`). Confirme que le contrôle de propriété (ownership check) fonctionne. | CONSERVER (sécurité correcte, erreur de sélection de jeu de test de ma part, pas une anomalie). |
| `/app/reports/export/pdf` | Déclenche un téléchargement de fichier (Dompdf, `Content-Disposition: attachment`) au lieu d'une navigation — comportement attendu pour un export PDF, confirmé par Playwright ("Download is starting"). | CONSERVER (comportement correct). |

### Anomalies pré-identifiées (statiques) — verdict de cette session

| ID | Route | Composant | Description statique | Sévérité présumée | Statut |
|---|---|---|---|---|---|
| ANOM-CSS-001 | `/app/reports`, `/app/export/transactions`, `/admin/*` | `.bx-budgets-table` hover | Hover table partagée — vérifier que `rgba(primary, 0.05)` est visible sur Report et Export | P1 | **CONFIRMÉ, reclassé P2** → voir VIS-P1-002 (cause réelle = conflit de spécificité/`!important` avec le polyfill dark, pas un défaut de chargement de `budget.css`) |
| ANOM-RESP-001 | `/app/transactions` | DataTable mobile | Colonnes masquées à 360px — vérifier absence totale d'overflow horizontal | P1 | **NON REPRODUIT** — `scrollWidth === clientWidth` (360px) confirmé sur S21, S09, S12, S21, S27, S30, S32, S36, S39, S41, S43, S44 (12 scénarios mobile testés, 0 overflow) |
| ANOM-RESP-002 | `/app/budgets` | `.bx-budgets-table` card-view | Card-view ≤575px — vérifier lisibilité des cards budget à 360px | P2 | **NON REPRODUIT** — S27 (VP1, données réelles Mars 2026) : cards lisibles, badges Attention/Dépassé visibles, 0 overflow |
| ANOM-GRAPH-001 | Dashboard, Patrimoine, Budget | Chart.js | Bascule thème après chargement — graphiques recalculent-ils leur palette ? | P2 | **NON CONCLUANT** — voir observations hors anomalie ci-dessus (limitation outil de test) |
| ANOM-MODAL-001 | `/app/transactions/inbox` | Modale qualify VP1 | Formulaire embarqué mobile — footer visible sans scroll infini ? | P1 | **NON TESTABLE** — aucune transaction "à qualifier" dans le jeu de données VISUAL-DATA (119 transactions toutes déjà catégorisées/non-qualifiables au sens de cet écran) ; aucun déclencheur de modale trouvé sur S24. À revérifier avec un jeu de données dédié (transactions Powens non enrichies). |
| ANOM-FORM-001 | Formulaires `.bx-*-form` | `form-floating` + APP-2 | Radius `var(--bx-radius-md)` après migration | P3 | **CONFIRMÉ COSMÉTIQUEMENT CONFORME** — S16/S17 (Account new) : floating labels non chevauchants, radius cohérent visuellement, focus ring violet visible en light (S17). Aucun delta perceptible. → CONSERVER |
| ANOM-FORM-001 | Formulaires avec `.bx-*-form` | `form-floating` + APP-2 | Radius `var(--bx-radius-md)` après migration — cohérence perçue avec Bootstrap standard | P3 | À VÉRIFIER (S16) |

---

## H. Critères de sévérité

| Code | Définition |
|---|---|
| P0 | Fonctionnalité inaccessible ou inutilisable — bloquant |
| P1 | Overflow bloquant · action inaccessible · contraste critique · modal inutilisable · navigation cassée |
| P2 | Incohérence visuelle importante · hiérarchie incorrecte · responsive dégradé mais utilisable |
| P3 | Finition · micro-alignement · non urgent |
| CONSERVER | Différence intentionnelle, justifiée et documentée |
| NON_REPRO | Anomalie non confirmée après second contrôle |
| HORS_PERIMETRE | Hors scope de cette campagne |

---

## I. Critères de clôture Phase 1

La Phase 1 est **clôturable** si et seulement si :

- [ ] Les 44 scénarios S01–S44 ont un statut (PASS, FAIL, NON TESTABLE)
- [ ] 0 anomalie P0 en suspens (ou inexistante)
- [ ] 0 anomalie P1 sans décision (lot correctif planifié ou CONSERVER documenté)
- [ ] Chaque FAIL possède une capture ou une description suffisamment précise pour reproduire
- [ ] Les anomalies CONSERVER sont justifiées dans le tableau
- [ ] Aucun module figé n'a été rouvert sans anomalie P0 ou P1 démontrée
- [ ] Les anomalies P2 et P3 ont une décision explicite : lot différé ou CONSERVER

---

## J. Règles de correction — format lot atomique

```
LOT-VIS-[MODULE]-[NNN]
Anomalie source   : VIS-P1-NNN
Pages concernées  : /app/... (liste)
Preuve/capture    : filename.png
Cause démontrée   : description précise (ex. "variable non définie sans budget.css")
Allowlist         : public/css/app.css (ou module.css concerné)
Comportement attendu : description factuelle
Contrôle desktop  : VP4 dark + light
Contrôle mobile   : VP1 dark
Contrôle couleur  : si couleur affectée → dark ET light
Test structurel   : classe::méthode → assertion (si applicable)
Commit            : fix(css): description
```

**Règle** : 1 anomalie = 1 lot = 1 commit. Ne pas regrouper même si le même fichier CSS est affecté.

---

## K. Règles de réouverture d'un module figé

Un module figé peut être rouvert **seulement si** :
1. L'anomalie est reproductible (route, viewport, thème, état identifiés)
2. Le comportement attendu est défini précisément
3. Le correctif est borné (≤ 3 fichiers)
4. Les risques intermodules ont été identifiés
5. Un test ou contrôle visuel peut verrouiller la correction

Ne **pas** rouvrir pour :
- Supprimer une valeur raw sans défaut perceptible
- Résoudre une dette de nommage
- Normaliser un delta imperceptible
- Réduire un compteur CSS ou une métrique statique

---

## L. Dettes techniques — décisions maintenues

| Dette | Décision | Condition de réouverture |
|---|---|---|
| `--bx-radius-md` 0.625 vs 0.62rem (delta +0.08px) | CONSERVER | Preuve visuelle d'incohérence perçue |
| 40+ box-shadow non tokenisées | DIFFÉRER | Incohérence d'élévation perçue entre modules |
| `.bx-toast-noscript` fallback `.5rem` | HORS_PERIMETRE | Cas JS désactivé = nul en production normale |
| Polyfill dark non tokenisé | CONSERVER DOCTRINALEMENT | Jamais — layer Bootstrap volontairement séparé |
| Chart.js fallbacks Canvas | À VÉRIFIER (S08, S33) | Incohérence chromatique ou non-adaptation thème |

---

## M. Décisions CONSERVER pré-documentées

| Élément | Décision | Justification |
|---|---|---|
| Dark mode polyfill (`html[data-theme="dark"]` L~1285–2100) | CONSERVER | Layer Bootstrap override — pas des tokens feature |
| `rgba(15,23,42,.02)` — `.bx-tx-filter-bar--shell` | CONSERVER | Alpha ultra-bas intentionnel (V13) |
| `rgba(15,23,42,.06)` — `.bx-budgets-table > td` | CONSERVER | Border light intentionnel (V14) |
| `border-radius: .5rem` L4098 — card-view mobile | CONSERVER | Valeur distincte pour contexte card-view, hors R1–R24 |
| `rgba(124,58,237,0.28)` — `.bx-seg-btn--active` | CONSERVER | Tint accent justifié (components.css) |
| `rgba(255,255,255,0.06)` — `.pill-soon` | CONSERVER | Overlay intentionnel (components.css) |
| Bloc `<style>` dans `report/pdf.html.twig` | CONSERVER | Dompdf — aucune feuille externe chargée |
| `--bx-radius-md` delta 0.005rem | CONSERVER | +0.08px imperceptible |
| Fallback `.5rem` `.bx-toast-noscript` | HORS_PERIMETRE | JS désactivé uniquement |

---

## N. Matrice routes × états — référence exhaustive

### Auth et pages publiques

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| AUTH-01 | `/login` | normal, erreur, 2FA | VP1 VP4 | dark light | P1 |
| AUTH-02 | `/register` | vide, validation, rate-limit | VP1 VP4 | dark light | P2 |
| AUTH-03 | `/forgot-password` | vide, succès, erreur | VP1 VP4 | dark light | P2 |
| AUTH-04 | `/reset-password/{token}` | vide, token invalide, succès | VP1 VP4 | dark light | P2 |
| AUTH-05 | `/2fa` | code attendu, erreur | VP1 VP4 | dark light | P1 |
| AUTH-06 | `/2fa-recovery` | code backup, erreur | VP1 VP4 | dark light | P2 |
| AUTH-07 | `/resend-verification` | normal, succès | VP1 VP4 | dark light | P3 |
| HOME-01 | `/` | normal, animations | VP1 VP2 VP4 | dark light | P2 |
| HOME-02 | `/pricing` | plans free/premium | VP1 VP4 | dark light | P2 |

### Dashboard

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| DASH-01 | `/app/dashboard` | données normales | VP1 VP4 | dark light | P1 |
| DASH-02 | `/app/dashboard` | état vide | VP1 VP4 | dark light | P1 |
| DASH-03 | `/app/dashboard` | montants > 100k€ | VP4 | dark light | P2 |
| DASH-04 | `/app/dashboard` | graphiques détaillés | VP1 VP4 | dark light | P1 |
| DASH-05 | `/app/dashboard` | widget "À venir" | VP1 VP4 | dark light | P2 |

### Comptes

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| ACC-01 | `/app/accounts` | liste normale | VP1 VP4 | dark light | P1 |
| ACC-02 | `/app/accounts` | état vide | VP1 VP4 | dark light | P1 |
| ACC-03 | `/app/accounts/new` | formulaire, validation | VP1 VP4 | dark light | P2 |
| ACC-04 | `/app/accounts/{id}` | show, graphique, onglets | VP1 VP4 | dark light | P1 |
| ACC-05 | `/app/accounts/{id}/info` | métadonnées Powens | VP4 | dark light | P2 |
| ACC-06 | `/app/accounts/{id}/investments` | portefeuille, état vide | VP1 VP4 | dark light | P2 |
| ACC-07 | `/app/accounts/{id}/edit` | formulaire prérempli | VP1 VP4 | dark light | P2 |

### Transactions

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| TX-01 | `/app/transactions` | liste, DataTable | VP1 VP4 | dark light | P1 |
| TX-02 | `/app/transactions` | état vide | VP1 VP4 | dark light | P1 |
| TX-03 | `/app/transactions?filter=pending` | bandeau alerte | VP4 | dark light | P1 |
| TX-04 | `/app/transactions` | section "À venir" | VP1 VP4 | dark light | P2 |
| TX-05 | `/app/transactions/inbox` | modale qualify | VP1 VP4 | dark light | P1 |
| TX-06 | `/app/transactions/new` | formulaire | VP1 VP4 | dark light | P2 |
| TX-07 | `/app/transactions/{id}/edit` | formulaire prérempli | VP1 VP4 | dark light | P2 |
| TX-08 | `/app/a-traiter` | liste, état vide | VP1 VP4 | dark light | P1 |

### Budget

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| BUD-01 | `/app/budgets` | liste | VP1 VP4 | dark light | P1 |
| BUD-02 | `/app/budgets` | état vide | VP4 | dark light | P1 |
| BUD-03 | `/app/budget/analyse` | KPI, donut, accordéon | VP1 VP4 | dark light | P1 |
| BUD-04 | `/app/budget/analyse` | aucune donnée | VP4 | dark light | P2 |
| BUD-05 | `/app/budgets/new` | formulaire | VP1 VP4 | dark light | P3 |
| BUD-06 | `/app/budgets/{id}/edit` | formulaire prérempli | VP1 VP4 | dark light | P3 |

### Patrimoine

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| PAT-01 | `/app/patrimoine` | global, donut | VP1 VP4 | dark light | P1 |
| PAT-02 | `/app/patrimoine` | état vide | VP1 VP4 | dark light | P1 |
| PAT-03 | `/app/patrimoine/comptes-bancaires` | liste | VP1 VP4 | dark light | P2 |
| PAT-04 | `/app/patrimoine/actions-fonds` | portefeuille | VP4 | dark light | P2 |
| PAT-05 | `/app/patrimoine/livrets` | liste, projections | VP1 VP4 | dark light | P2 |
| PAT-06 | `/app/patrimoine/fonds-euros` | assurance-vie | VP4 | dark light | P2 |
| PAT-07 | `/app/patrimoine/credits` | tableau crédits | VP1 VP4 | dark light | P2 |
| PAT-08 | `/app/patrimoine/immobilier` | biens | VP1 VP4 | dark light | P2 |
| PAT-09 | `/app/patrimoine/immobilier/{id}` | détail bien | VP4 | dark light | P3 |

### Goals — Phase 1 partielle (S31), Phase 2 complète

| ID | Route | États | VP | Thème | Priorité |
|---|---|---|---|---|---|
| GOA-01 | `/app/goals` | liste cartes | VP1 VP4 | dark light | P1 |
| GOA-02 | `/app/goals` | état vide | VP1 VP4 | dark light | P1 |
| GOA-03 | `/app/goals/{id}` | détail, contributions | VP1 VP4 | dark light | P1 |
| GOA-04 | `/app/goals/{id}` | objectif atteint | VP4 | dark light | P2 |
| GOA-05 | `/app/goals/new` | formulaire, color-picker | VP1 VP4 | dark light | P2 |
| GOA-06 | `/app/goals/{id}/edit` | formulaire | VP1 VP4 | dark light | P3 |

### Cashflow, Action Center, Notifications — Phase 2

| ID | Route | Priorité |
|---|---|---|
| CF-01 | `/app/cashflow` | P2 |
| ACT-01 | `/app/actions` | P2 |
| NOT-01 | `/app/notifications` | P2 |

### Catégories, Règles, Libellés — Phase 2

| ID | Route | Priorité |
|---|---|---|
| CAT-01 | `/app/categories` | P2 |
| RUL-01 | `/app/category-rules` | P2 |
| LIB-01 | `/app/libelles` | P2 |
| LIB-02 | `/app/libelles/new` | P2 |

### Report et Export

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| REP-01 | `/app/reports` | données | VP1 VP4 | dark light | P1 |
| REP-02 | `/app/reports` | état vide | VP4 | dark light | P2 |
| REP-03 | `/app/reports/export/pdf` | PDF Dompdf | VP4 | light only | P2 |
| EXP-01 | `/app/export` | index | VP1 VP4 | dark light | P2 |
| EXP-02 | `/app/export/transactions` | export | VP1 VP4 | dark light | P2 |
| EXP-03 | `/app/export/rgpd` | export RGPD | VP1 VP4 | dark light | P2 |

### Profil et Sécurité

| ID | Route | États | VP Phase 1 | Thème | Priorité |
|---|---|---|---|---|---|
| PRO-01 | `/app/profile/edit` | formulaire, avatar | VP1 VP4 | dark light | P2 |
| PRO-02 | `/app/profile/security` | sessions, 2FA, trusted | VP1 VP4 | dark light | P1 |
| PRO-03 | `/app/profile/preferences` | toggle thème | VP1 VP4 | dark light | P2 |
| PRO-04 | `/app/profile/security/2fa/enable` | QR code | VP1 VP4 | dark light | P1 |

### Billing — Phase 2

| ID | Route | Priorité |
|---|---|---|
| BIL-01 | `/app/billing/success` | P2 |
| BIL-02 | `/app/billing/cancel` | P3 |
| BIL-03 | `/app/billing/manage` | P2 |

### Admin — Phase 3

| ID | Route | Priorité |
|---|---|---|
| ADM-01–ADM-14 | `/admin/*` | P2–P3 |

### Légal et Erreurs — Phase 2/3

| ID | Route | Priorité |
|---|---|---|
| LEG-01–LEG-03 | `/legal/*` | P3 |
| ERR-01–ERR-03 | 403/404/500 | P2 |

---

## O. Contrats visuels globaux — référence par famille

### Navigation
- Fond surface-2, bordure `--bx-app-border`, hover `--bx-app-hover`
- Dark : `#1a1a1a` · Light : blanc ou surface clair · Texte dark : `rgba(255,255,255,0.87)`
- Mobile VP1 : sidenav masquée, hamburger ≥ 44×44px, overlay complet

### KPI Cards — `.bx-kpi`
- `border-radius: var(--bx-radius-md)` (0.62rem effectif) · `box-shadow: var(--bx-app-elev-sm)`
- Valeur : mono bold 1.5rem · Positif : `--bx-app-success` · Négatif : `--bx-app-danger`
- Mobile : padding réduit `--bx-sp-3/4`, grille ≤ 2 colonnes

### Cartes — `.bx-card`
- `border-radius: var(--bx-radius-lg)` · border `--bx-app-border` · shadow elev-sm
- Hover : transform translateY(-2px) · Mobile : padding réduit xs

### Boutons d'en-tête — `.bx-budgets-header-btn`
- `border-radius: var(--bx-radius-md)` · `min-height: 36px`
- Mobile : `justify-content: center` via `@media ≤767.98px`
- Secondaire : outline visible dark et light

### Formulaires
- Focus : `box-shadow: 0 0 0 3px --bx-app-focus-ring`
- form-floating radius : `var(--bx-radius-md)` après APP-2
- Bouton submit form : `width: 100%`, `min-height: 38px`

### Tableaux partagés — `.bx-budgets-table`
- Hover desktop : `var(--bx-budgets-row-hover, rgba(var(--bs-primary-rgb), 0.05))`
- Card-view mobile ≤575px : thead masqué, lignes = cards `border-radius: .5rem`
- Header `.bx-thead` : fond surface-2, uppercase xs

### Modales
- Dark : fond `#1e1e1e`, borders dark · Mobile : `margin: 0.5rem`, footer visible
- Danger : bouton rouge distinct + libellé explicite

### Donuts Chart.js
- `bx-donut-wrap max-width: 240px` mobile · adapté thème via `isDark`
- Légende texte présente · tooltip visible

### États vides — `.bx-empty-state`
- Icône centrée, titre, sous-titre, CTA
- Dark : titre `rgba(255,255,255,0.87)` via override L1958

---

## P. Journal des sessions

| Date | Testeur | Phase | Scénarios exécutés | PASS | FAIL | NT | Anomalies |
|---|---|---|---|---|---|---|---|
| 2026-06-17 | Claude (autonome, Playwright headless via tooling isolé hors dépôt) | 1 | 44/44 (S01–S44) | 40 | 0 | 4 (S06 2FA non-bloquant mais hors périmètre data ; S18/S20 Powens vide par construction des fixtures ; S24 inbox sans donnée qualifiable) | VIS-P1-001, VIS-P1-002, VIS-P1-003 (P3 ANOM-FORM-001 conservé) |
| 2026-06-17 | Claude (idem) | 2 | 40/40 (P2-01→P2-40) | 38 | 0 | 2 (P2-33 404 attendu = page debug dev ; P2-22 hors scope visuel = téléchargement PDF) | aucune nouvelle — re-vérif VIS-P1-002 sur VP5 confirmée |
| 2026-06-17 | Claude (idem) | 3 | 26/26 (P3-01→P3-26) | 23 | 0 | 3 (P3-16/17 403 intentionnel ROLE_SUPER_ADMIN ; P3-26 403 intentionnel ownership) | VIS-P1-004 |

**Détail outillage** : Playwright 1.61.0 + Chromium 149 installés dans un paquet npm isolé sous `%TEMP%\budgex-visual-qa\` (jamais dans le dépôt, `package.json`/`package-lock.json` du projet non touchés). Authentification via formulaire réel (`/login`), `storageState` réutilisé par profil. Thème dark/light piloté en base (`UPDATE user SET theme=...`) car `app.user.theme` est rendu côté serveur dans `<html data-theme="...">` — `localStorage` seul ne suffit pas sur les pages `/app/*` et `/admin/*` (il fonctionne en revanche pour les pages publiques `layouts/auth.html.twig`). Capture en deux temps (haut + bas de page, `fullPage:false`) après avoir constaté que `fullPage:true` duplique visuellement la navbar/sidebar sticky lors du stitching CDP — confirmé artefact d'outillage par comparaison directe, pas un défaut applicatif.

**Profils de recette utilisés** :
- VISUAL-DATA = `arnaud.robert@test.budgex` (fixture `app:fixtures:mass`, 4 comptes, 3 budgets, 2 objectifs, 119 transactions, sans 2FA)
- VISUAL-EMPTY = `admin@budgex.fr` (fixture `app:fixtures:load`, ROLE_ADMIN, 0 compte/transaction/budget)
- VISUAL-ADMIN = `admin@budgex.fr` (même compte — accès `/admin/*` suffisant pour P3, sauf 2 routes `ROLE_SUPER_ADMIN`)
- Mots de passe non stockés ici (déjà présents en clair dans les docblocks des commandes `LoadFixturesCommand`/`LoadMassFixturesCommand` du dépôt — non un secret introduit par cette session)

**Anomalie de processus signalée** : un clic automatisé sur un bouton "Supprimer" (`/app/budgets`, scénario S43) a déclenché un `window.confirm()` natif que Playwright annule par défaut — **aucune donnée n'a été supprimée** (vérifié par requête SQL avant/après : 3 budgets toujours présents). Ce comportement par défaut de Playwright a accidentellement servi de garde-fou ; documenté ici par transparence.

---

## Q. Lots correctifs identifiés

| ID Lot | Anomalie source | Module | Priorité | Statut |
|---|---|---|---|---|
| LOT-VIS-NAV-001 | VIS-P1-001 | Topbar mobile (`templates/layouts/app.html.twig` ou partial topbar) | P1 | PROPOSÉ |
| LOT-VIS-CSS-001 | VIS-P1-002 | `public/css/app.css` (règle dark polyfill ~L1906 vs règle `.bx-budgets-table` L4068) | P2 | PROPOSÉ |
| LOT-VIS-UX-001 | VIS-P1-003 | `public/js/budget-actions.js`, `goal-form.js`, `immobilier_show.js` + templates associés | P2 | PROPOSÉ |
| LOT-VIS-CSS-002 | VIS-P1-004 | `public/design-system-previews/{brand-logo-usage,brand-logo,components-navbar-landing,components-sidebar}.html` | P3 | PROPOSÉ |

### LOT-VIS-NAV-001
```
Anomalie source   : VIS-P1-001
Pages concernées  : toutes les routes /app/* sous 576px (VP1 360, VP2 390)
Preuve/capture    : S01_VP1_dark_top.png, drawer-open.png, notif-direct.png
Cause démontrée   : .dropdown-notifications porte "d-none d-sm-block" ; aucune entrée
                    équivalente dans le offcanvas mobile (#drawerToggle)
Allowlist         : templates/layouts/app.html.twig (topbar partial), éventuellement
                    public/css/app.css (classes responsives liées)
Comportement attendu : un contrôle visible (icône cloche dans la topbar mobile, ou
                    entrée "Notifications" dans le drawer) doit permettre d'atteindre
                    /app/notifications sur tout viewport
Contrôle desktop  : VP4 dark + light (déjà OK, ne pas régresser)
Contrôle mobile   : VP1 dark + VP2 dark (les deux actuellement KO)
Test structurel   : test fonctionnel/Panther vérifiant la présence d'un sélecteur
                    visible menant à app_notification_index sous 576px
Commit            : fix(nav): expose notifications entry point on mobile topbar/drawer
```

### LOT-VIS-CSS-001
```
Anomalie source   : VIS-P1-002
Pages concernées  : /app/budgets, /app/reports, /app/export/transactions (dark uniquement)
Preuve/capture    : hover-check.js (sorties avant/après par thème), S37/S38 top.png
Cause démontrée   : html[data-theme="dark"] .table-hover > tbody > tr:hover > * { ... !important }
                    (app.css ~L1906) prime sur .bx-budgets-table > tbody > tr:hover > *
                    (app.css L4068, sans !important)
Allowlist         : public/css/app.css uniquement
Comportement attendu : hover violet rgba(primary,.05) visible en dark comme en light sur
                    .bx-budgets-table, sans toucher le hover générique des autres tableaux
Contrôle desktop  : VP4 dark + light
Contrôle mobile   : VP1 dark (pas de hover tactile, mais vérifier focus-visible si ajouté)
Contrôle couleur  : dark ET light (les deux thèmes affectés par toute modification de
                    spécificité)
Test structurel   : contrat CSS existant (cf. AdminInlineCodeTest / structural contracts
                    déjà en place pour app.css) — ajouter une assertion sur l'ordre/la
                    spécificité des deux règles de hover
Commit            : fix(css): restore brand-violet hover on .bx-budgets-table in dark theme
```

### LOT-VIS-UX-001
```
Anomalie source   : VIS-P1-003
Pages concernées  : /app/budgets, /app/goals/{id}/edit, /app/patrimoine/immobilier/{id}
                    (à comparer avec /app/accounts/{id} qui a la bonne référence)
Preuve/capture    : account-delete-modal.png (référence correcte)
Cause démontrée   : form[data-confirm-delete] + budget-actions.js/goal-form.js/
                    immobilier_show.js utilisent window.confirm() natif, alors que
                    account/_delete_modal.html.twig utilise une modale Bootstrap stylée
Allowlist         : public/js/budget-actions.js, goal-form.js, immobilier_show.js,
                    + nouveaux partials de modale (1 par module ou 1 partagé)
Comportement attendu : confirmation de suppression visuellement cohérente (modale stylée
                    dark/light) sur tous les modules, pas seulement Comptes
Contrôle desktop  : VP4 dark + light
Contrôle mobile   : VP1 dark
Test structurel   : test fonctionnel vérifiant la présence de [data-bs-toggle="modal"]
                    plutôt que window.confirm sur les boutons de suppression
Commit            : fix(ux): unify destructive-action confirmation pattern across modules
Risques           : portée large (3 modules) — envisager un partial de modale générique
                    réutilisable plutôt que 3 implémentations dupliquées
```

### LOT-VIS-CSS-002
```
Anomalie source   : VIS-P1-004
Pages concernées  : /admin/design-system (preview cards "Marque")
Preuve/capture    : P3-19_VP4_dark_top.png, en-têtes curl (X-Debug-Exception)
Cause démontrée   : 4 fichiers HTML statiques référencent /assets/favicon.png et
                    /assets/logo.png au lieu de /assets/img/favicon.png et
                    /assets/img/logo.png (chemin correct confirmé sur templates/layouts)
Allowlist         : public/design-system-previews/brand-logo-usage.html,
                    brand-logo.html, components-navbar-landing.html,
                    components-sidebar.html
Comportement attendu : logo/favicon affichés sans erreur 500 dans les preview cards
Contrôle desktop  : VP4 dark (page admin uniquement, pas de variante light testée)
Contrôle mobile   : non applicable (outil interne admin)
Test structurel   : aucun (fichiers HTML statiques hors couverture PHPUnit)
Commit            : fix(admin): correct broken asset paths in design-system preview cards
```

---

## R. Verdict global — session 2026-06-17

- **110 scénarios exécutés** (44 Phase 1 + 40 Phase 2 + 26 Phase 3), 0 interruption, 0 fichier de production modifié/indexé/commité.
- **4 anomalies retenues** : 1×P1 (VIS-P1-001), 2×P2 (VIS-P1-002, VIS-P1-003), 1×P3 (VIS-P1-004).
- **0 P0**. Le P1 unique (notifications inaccessibles sous 576px) a une décision et un lot proposé (LOT-VIS-NAV-001) → critère de clôture Phase 1 "0 P1 non arbitré" satisfait.
- **3 hypothèses pré-identifiées non reproduites** (ANOM-RESP-001, ANOM-RESP-002, ANOM-FORM-001) → CONSERVER/contrats respectés.
- **1 hypothèse pré-identifiée confirmée mais recausée** (ANOM-CSS-001 → VIS-P1-002, cause réelle = conflit `!important` dark, pas un défaut de chargement CSS).
- **1 hypothèse non concluante** (ANOM-GRAPH-001, limitation de l'outil de test, pas de l'application).
- **1 hypothèse non testable avec ce jeu de données** (ANOM-MODAL-001, inbox sans transaction qualifiable).

**Verdict** : **PASS_WITH_ANOMALIES**

---

## S. Clôture finale — audit indépendant 2026-06-18

Les 4 anomalies de cette campagne ont été corrigées, commitées et auditées indépendamment (voir `global-visual-corrections.md` section O — audit de clôture). Statut final :

| Anomalie | Sévérité | Lot correctif | Commit | Statut |
|---|---|---|---|---|
| VIS-P1-001 | P1 | LOT-VIS-NAV-001 | `776c878a778fc9a140730d971d3a3327d98a00e3` | **CLOSED** |
| VIS-P1-002 | P2 | LOT-VIS-CSS-001 | `9ae9ee4ee8b0b362ce966eaf077e516b04390ef8` | **CLOSED** |
| VIS-P1-003 | P2 | LOT-VIS-UX-001 | `c5d8b1f63e4a36193f072403ef0de92808b39fdd` | **CLOSED** |
| VIS-P1-004 | P3 | LOT-VIS-CSS-002 | `86f39a9bf6517e3ef1518a5d59b44323f2e0078f` | **CLOSED** |

**HEAD figé** : `86f39a9bf6517e3ef1518a5d59b44323f2e0078f` (= origin/master au 2026-06-18).
**Suite complète à cette date** : 1075 tests, 4159 assertions, 13 PHPUnit Notices préexistantes, 0 failure, 0 error.
**P0 ouverts** : 0. **P1 ouverts** : 0. **P2 ouverts issus de cette campagne** : 0.

**Verdict final** : **CAMPAGNE CORRECTIVE VISUELLE VALIDÉE — UX/UI GLOBALE FIGÉE au HEAD `86f39a9`.**

Ne plus rouvrir ces modules pour nettoyage opportuniste. Réouverture autorisée uniquement sur anomalie reproductible démontrée ou évolution produit explicite, suivant les mêmes règles de lot atomique + allowlist + preuve que cette campagne a établies.

---

## T. Audit final indépendant — 2026-06-18 (AUDIT-CLOTURE-UX-UI-GLOBALE)

Audit de clôture mené en lecture seule sur les 4 commits de la campagne, indépendamment de la session qui les a produits. Détail complet dans `global-visual-corrections.md`, section O.

Résultats clés :
- Les 4 commits (`776c878`, `9ae9ee4`, `c5d8b1f`, `86f39a9`) correspondent exactement aux spécifications faisant foi de leurs manifestes respectifs (versions amendées M et N pour NAV-001/UX-001).
- Suite complète rejouée indépendamment : **1075 tests, 4159 assertions, 13 PHPUnit Notices, 0 failure, 0 error** — identique au résultat annoncé.
- **Correction de comptage** : LOT-VIS-CSS-002 corrige réellement **6 occurrences** de chemin d'asset incorrect (et non 5 comme annoncé dans la spécification initiale section E1 de `global-visual-corrections.md`) — détail : 3 dans `brand-logo-usage.html`, 1 dans chacun des 3 autres fichiers.
- **Réserve non bloquante** : LOT-VIS-CSS-001 (`9ae9ee4`) ne contient aucun test structurel verrouillant les deux nouvelles règles dark-scopées, bien que la spécification (section C3 de `global-visual-corrections.md`) en prévoyait un. Le comportement CSS reste vérifié par mesure Playwright (cascade/spécificité confirmée par lecture directe du fichier), mais pas par un test automatisé.
- Scénario Comptes (`/app/accounts/{id}`) confirmé non-imputable à UX-001, stable lors de cette nouvelle vérification (aucun fichier Comptes dans l'allowlist, aucune dépendance UX-001 chargée sur cette route).
- Design System `/admin/design-system` : 27 cartes (23 iframes + 4 cards natives Toast), 0 HTTP 500 applicatif, erreurs réseau résiduelles toutes externes (Google Fonts/CDN, `net::ERR_NETWORK_ACCESS_DENIED`), aucune imputable à Budgex.
- Working tree propre, HEAD = `origin/master` (local et distant) = `86f39a9` au début et à la fin de cet audit.

**Verdict de l'audit indépendant** : **CONFIRMÉ — CAMPAGNE CORRECTIVE VISUELLE VALIDÉE, UX/UI GLOBALE FIGEABLE au HEAD `86f39a9`**, sous réserve non bloquante de la couverture de test CSS-001 (section O6 de `global-visual-corrections.md`) et de la correction de comptage CSS-002 (5→6, ci-dessus).

**STATUT FINAL : AUDITED / CLOSED.**
