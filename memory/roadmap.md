# roadmap.md
updated: 2026-05-11
version: V3

Roadmap produit et technique Budgex — historique complet + plan actif.
Direction produit : se rapprocher progressivement du niveau Finary (lisibilité patrimoine, clarté actifs, synthèse utile) sans copie aveugle.

---

### Backlog non planifié (conservé de l'ancienne roadmap)

- [ ] Mode multi-utilisateurs / partage de compte (couple, famille)
- [ ] Thème couleur personnalisable par l'utilisateur (au-delà de light/dark)
- [ ] Internationalisation (i18n) complète — traductions EN, ES
- [ ] Archivage de comptes (clôturés mais conservés en lecture seule)
- [ ] Tableau de bord configurable (widgets déplaçables)
- [ ] Comparaison avec moyennes communautaires (opt-in anonymisé)

---

## PARTIE 2 — ROADMAP ACTIVE V3 (révisée 2026-03-25)

Direction : rapprochement progressif niveau Finary — lisibilité patrimoine, synthèse globale, expérience fluide.

**Décision produit 2026-03-25 :** crypto et métaux précieux exclus du périmètre fonctionnel actuel. Présence UI légère uniquement (badge "À venir"). Voir section Post-socle en bas de fichier.

### Vue d'ensemble

```
Phase A — Fondations Powens      Sprint 1 ✅ · 2 ✅ · 3 ✅   P0
Phase B — Boucle transactions    Sprint 4 ✅ · 5 ✅            P0/P1
Phase C — Vision financière      Sprint 6 ✅ · 7 ✅            P1
Phase D — Patrimoine structuré   Sprint 8 ✅                  P1
Phase E — Automatisation         Sprint 9 ✅ · 10 ✅           P2
```

---

### Phase A — Fondations Powens

Objectif : pipeline Powens fiable, staging résolu, page bank-connections opérationnelle.
Prérequis de toutes les phases suivantes.

#### Sprint 1 — Sync automatique Powens · P0 ✅ COMPLÉTÉ (2026-03-24)

- [x] Commande `app:powens:sync-all` (tous users actifs avec token, --force, --dry-run)
- [x] Tâche planifiée Windows `\Budgex\Sync Powens` — toutes les heures
- [x] Gestion gracieuse token expiré : status=error sur connexion, log, continue
- [x] Champs `lastSyncTriggeredAt` + `lastSyncStatus` sur BankConnection + migration 130000
- [x] Log résumé (nb syncs, tx importées, erreurs) en console + Monolog
- [x] `findAllDueForSync()` dans BankConnectionRepository
- [x] 6 tests fonctionnels verts
- Baseline : 334 tests · 916 assertions · 0 failures

#### Sprint 2 — Staging : flux de résolution complet · P0 ✅ COMPLÉTÉ (2026-03-24)

- [x] Flux lier / créer / ignorer complet et robuste
- [x] "Lier" : sélecteur comptes non encore liés, confirmation
- [x] "Créer" : pré-remplissage depuis staging (nom, type→assetClass, devise), formulaire inline
- [x] "Ignorer" : statut `ignored` sur PowensAccountStaging, rouvrable via "Rouvrir"
- [x] "Rouvrir" : route POST /{id}/reopen, remet ignored → pending, log audit
- [x] Indicateur "X comptes en attente" sur dashboard (bannière warning + lien)
- [x] Cas de bord : staging pending dont powensAccountId = Account.externalAccountId → auto-résolution silencieuse
- [x] Section "Comptes ignorés" en bas de page staging avec bouton Rouvrir
- Baseline : 337 tests · 921 assertions · 0 failures

#### Sprint 3 — Page bank-connections : complète et opérationnelle · P0 ✅ COMPLÉTÉ (2026-03-24)

- [x] Card enrichie : logo connecteur, badge santé (vert/orange/rouge), lastSyncedAt formaté, nb comptes, nb transactions ce mois
- [x] Gestion erreurs : message lisible par errorCode, CTA "Reconnecter" → relance webview avec connection_id
- [x] Stabilité connecteur : warning si stabilityStatus = unstable/down
- [x] Stats par connexion : solde total, delta vs mois précédent
- [x] Suppression : modal confirmation + liste données conservées
- [x] Debug ?debug=1 déplacé vers /admin/powens-debug (ROLE_ADMIN uniquement)
- Critère : connexion erreur → badge rouge → CTA → webview → connexion rétablie

---

### Phase B — Boucle transactions

Objectif : transactions importées traitables rapidement, catégorisées intelligemment.

#### Sprint 4 — Workflow révision transactions · P0 ✅ COMPLÉTÉ (2026-03-24)

- [x] Compteur "X à réviser" dans nav + dashboard
- [x] Vue filtrée isReviewed=false sur /app/transactions
- [x] Action inline : catégorie + "Valider" → isReviewed=true (AJAX)
- [x] Sélection multiple + action groupée (catégoriser + marquer révisé en masse)
- [x] Persistance du filtre dans session
- [x] Bugfix badge AJAX + bouton "Tout réviser"

#### Sprint 5 — Auto-catégorisation Powens → Budgex · P1 ✅ COMPLÉTÉ (2026-03-24)

- [x] Table `powens_category_mapping` + migration + admin UI (ROLE_ADMIN)
- [x] `CategoryAutoAssignService` (règles custom puis mapping Powens, cache mémoire)
- [x] Intégration dans `PowensSyncService` à l'import
- [x] Règles custom utilisateur : table `category_rule` + CRUD /app/category-rules
- [x] Commande `app:powens:apply-category-rules` (--dry-run, --user-id)
- [x] 27 tests (13 unit + 8 functional CRUD + 6 functional command)
- Baseline : 364 tests · 984 assertions · 0 failures

---

### Phase C — Vision financière

Objectif : vision consolidée patrimoine + budget vs réel. Valeur produit maximale.

#### Sprint 6 — Dashboard patrimoine / net worth · P1 ✅ COMPLÉTÉ (2026-03-25)

- [x] Net worth = somme Account.currentBalance (actifs inclus − passifs)
- [x] Donut répartition assetClass (Chart.js)
- [x] Courbe évolution net worth 12 mois + vue quotidienne 1J/7J
- [x] Vue "Cash disponible" (comptes_bancaires + livrets) vs "Patrimoine investi"
- [x] Groupement des comptes par classe d'actifs sur le dashboard
- [x] Sous-totaux par classe (trois états : calculable / multi-devise / vide)
- [x] Placeholder "Compléter votre patrimoine" pour actifs non bancaires
- [x] Bugfix classTotals (filtrage actifs+inclus uniquement)
- [x] 32 tests (net worth, sync, recette) · 412 tests baseline partagé
- Critère : net worth = somme vérifiable des soldes, donut cohérent, MAJ après sync

#### Sprint 7 — Budget vs réel + épargne nette · P1 ✅ COMPLÉTÉ (2026-03-25)

- [x] Vue budget vs réel enrichie : alloué / consommé / restant / % / barre colorée / badge statut
- [x] `BudgetService::checkOverruns()` déclenché par `PowensSyncService` après import (B1 : mois courant, une fois)
- [x] Série "Épargne nette" (A1 : income − expenses) sur le graphique cash flow mensuel
- [x] KPI card "Épargne nette" (renommage de "Bilan ce mois" — nommage explicite)
- [x] Badges "Dépassé" / "Attention" sur page /app/budgets
- [x] 16 tests Sprint 7 (alertes sync, savings chart, recette)
- Baseline : 412 tests · 1 247 assertions · 0 failures
- Dette documentée : cohérence status (80 % hardcodé) vs alertThreshold configurable → Sprint futur

---

### Phase D — Patrimoine structuré

Objectif : compléter la vision patrimoniale avec les actifs réels des utilisateurs (épargne réglementée).
Crypto et métaux : présence UI légère uniquement — voir section Post-socle.

#### Sprint 8 — Épargne réglementée + présence UI crypto/métaux · P1

- Liaison `SavingProductReference` → `Account` (champ savingProduct FK + migration)
- `InterestProjectionService` : projection solde épargne (taux nominal, durée, versements périodiques)
- Courbe projection sur la page compte (solde futur estimé)
- Intégration dans net worth : remplacement du placeholder livrets / fonds_euros
- **Crypto et métaux — présence UI légère uniquement :**
  - Badge "À venir" sur dashboard et page comptes pour les classes `crypto` et `metaux`
  - Lien vers une page informative ou entrée désactivée
  - Aucun CRUD, aucune valorisation, aucun calcul patrimonial, aucune API externe
- Critère : SavingProductReference liée → projection affichée, solde épargne dans net worth

---

### Phase E — Automatisation intelligente

#### Sprint 9 — Récurrences et règles intelligentes · P2

(nécessite historique > 3 mois de transactions catégorisées)
- Détection récurrences : même marchand ± 5 % montant, même fréquence sur 3+ mois
- Marquage `isRecurring` automatique
- Vue "À venir ce mois" (récurrences attendues non encore importées)
- Règles catégorisation persistantes (description contains → category)
- Critère : abonnement mensuel détecté, apparaît dans "à venir"

#### Sprint 10 — Objectifs et projections · P2 ✅ COMPLÉTÉ (2026-03-25)

- [x] Liaison Goal ↔ compte épargne (progression automatique si solde évolue)
- [x] Courbe progression actuel vs trajectoire cible (Chart.js sur goal/show)
- [x] `GoalService::addAutoContributionIfNew()` — idempotence guard + contrainte DB
- [x] `GoalService::getProgressionChartData()` — points actual + trajectoire linéaire
- [x] Hook dans `PowensSyncService::importTransactions()` — livrets + fonds_euros
- [x] Badge Source (Auto/Manuel) dans l'historique des versements
- [x] Migration Version20260325000000 appliquée (source + transaction_id)
- [x] 10 tests (GoalAutoContributionTest) — auto-contribution, idempotence, débits ignorés, chart data, show page
- Baseline : 459 tests · 1346 assertions · 0 failures
- Limite MVP (R-D7) : additif uniquement — les retraits ne décrémantent pas currentAmount

---

---

## Sprint transversal — Qualité & Gouvernance

Ces sprints ne sont pas des phases produit. Ils consolident l'existant sans créer de nouvelles fonctionnalités ni modifier la direction artistique.

---

### Sprint CSS — Mise en conformité visuelle et gouvernance design · P2

**Ajouté :** 2026-05-11
**Statut :** À planifier — aucun lot démarré
**Type :** Consolidation / qualité / gouvernance documentaire
**Prérequis :** `references/budgex-visual-bible.md` disponible et enregistrée dans `source-of-truth-map.md` ✅

**Objectif :**
Mettre toute l'interface Budgex en conformité avec la bible visuelle V1, refactoriser et organiser le CSS existant, supprimer les redondances inutiles, réutiliser les classes et composants existants, et vérifier que les fichiers `.claude` ne contiennent pas de doublons ou de sources de vérité concurrentes.

**Ce sprint N'EST PAS :**
- Une refonte visuelle.
- Un changement de direction artistique.
- La création d'une nouvelle palette ou d'un nouveau design system parallèle.
- Un gros refactor monolithique.

**Ce sprint EST :**
- Une consolidation de l'existant.
- Une mise en conformité progressive et auditable.
- Un nettoyage documentaire et gouvernance.

---

#### Lot 0A — Arbitrages avant refactor CSS · BLOQUANT · ✅ COMPLÉTÉ (2026-05-11)

**Rôle :** lot préalable obligatoire. Aucun lot de refactor CSS (Lot 1 et suivants) ne peut démarrer tant que ce lot n'est pas terminé.

**Arbitrage 1 — `user-directives.md`**
- [x] Diagnostic : le fichier contenait une copie tronquée de l'ancien `decision-log.md` (ADR-001→007, daté 2026-03-24, header `# decision-log.md`). Aucune vraie directive utilisateur.
- [x] Action retenue : **archiver + recréer proprement**
- [x] Archivé dans `.claude/archive/user-directives-migrated-2026-05-11.md`
- [x] Recréé avec les 11 directives utilisateur réelles (D-01 à D-11)
- [x] Plus aucune double vérité avec `decision-log.md`

**Arbitrage 2 — Thème light**
- [x] Décision : **dark = V1 officielle · light = toléré sans garantie V1**
- [x] La dette `--bx-app-accent: #6200ea` en mode clair est documentée (bible §Annexe B.4, ADR-013)
- [x] Aucune modification CSS dans ce lot
- [x] Aucun audit ni QA du thème light dans le sprint CSS V1

**Arbitrage 3 — `app.css` vs CSS métier**
- [x] Décision : **`components.css` = source des primitives** · **`app.css` = en transition** · **CSS métier = variantes spécifiques justifiées**
- [x] Overrides de radius dans `app.css` (`--bx-radius: 12px`, `--bx-radius-sm: 8px`) sont une dette connue documentée — à retirer per composant uniquement
- [x] Interdiction de suppressions massives confirmée
- [x] Stratégie de déduplication progressive fixée : raw hex → doublons exacts → aliases legacy → overrides radius
- [x] ADR-014 inscrit dans `decision-log.md`

**Critère de sortie :** ✅ atteint — tous les arbitrages documentés, aucun CSS/Twig/composant modifié.

---

#### Lot 0 — Cadrage et sources de vérité · lecture seule

- [ ] Confirmer que `.claude/references/budgex-visual-bible.md` est la source primaire design
- [ ] Confirmer que les fichiers CSS (`colors_and_type.css`, `components.css`) sont la source technique d'exécution
- [ ] Confirmer que `source-of-truth-map.md` indique clairement les responsabilités
- [ ] Identifier les documents `.claude` redondants, concurrents ou obsolètes
- [ ] Vérifier la cohérence entre `engineering-standards.md §Design System` et la bible (chevauchement connu — voir analyse gouvernance ci-dessous)
- [ ] Vérifier le contenu de `user-directives.md` (contenu suspect — identique à `decision-log.md` ?)
- [ ] Produire un constat écrit sans modifier le code

**Critère de sortie :** rapport de cadrage produit, aucune modification de code.

---

#### Lot 1 — Audit CSS · lecture seule

- [ ] Inventorier tous les fichiers CSS du projet (`public/css/*.css`)
- [ ] Lister les tokens existants : `--bx-app-*`, `--bx-sp-*`, `--bx-radius-*`, `--bx-*` legacy
- [ ] Lister les classes globales définies dans `components.css` (primitives `.bx-*`)
- [ ] Lister les classes page-spécifiques par fichier (`accounts.css`, `dashboard.css`, `cashflow.css`, `patrimoine.css`, `transactions.css`, `profile.css`, `legal.css`)
- [ ] Identifier les raw hex et rem en dur hors `colors_and_type.css`
- [ ] Identifier les classes quasi-identiques (doublons fonctionnels)
- [ ] Identifier les styles `style="..."` inline dans les templates Twig (scan lecture seule)
- [ ] Identifier les écarts à la bible (Section 14 et Annexe B de la bible)
- [ ] Identifier les classes Bootstrap non overridées par des primitives `.bx-*`
- [ ] Produire un rapport d'audit structuré — aucune modification

**Critère de sortie :** rapport d'audit complet. Aucun fichier CSS ni Twig modifié.

---

#### Lot 2 — Organisation CSS cible · proposition uniquement

- [ ] Proposer l'organisation cible des fichiers CSS sans créer de nouvelle surcouche
- [ ] Distinguer clairement : tokens · base · layout · composants · utilities · pages spécifiques exceptionnelles
- [ ] Préciser les règles de nommage des classes (`.bx-{composant}__element--modifier`)
- [ ] Préciser les règles de réutilisation : quand une classe `components.css` suffit, quand une classe page-spécifique est autorisée
- [ ] Définir la règle : une classe page-spécifique est autorisée uniquement si elle ne peut pas être absorbée par un composant canonique existant ou un token
- [ ] Valider la proposition avec le Product Owner avant toute implémentation

**Critère de sortie :** proposition validée. Aucun fichier CSS ni Twig modifié.

---

#### Lot 3 — Refactor CSS incrémental · modifications contrôlées

**Contrainte :** diffs courts, un fichier par passe, tests verts entre chaque passe.

- [ ] Supprimer les raw hex confirmés dans les feuilles métier — remplacer par `var(--bx-app-*)`
- [ ] Supprimer les rem en dur — remplacer par `var(--bx-sp-*)` / `var(--bx-radius-*)`
- [ ] Supprimer les classes doublons confirmées — remplacer par la primitive canonique
- [ ] Supprimer les classes quasi-identiques — fusionner sur la version canonique
- [ ] Aucun changement visuel non demandé : si une suppression change l'apparence, arbitrer avant de poursuivre
- [ ] Tests verts après chaque sous-lot

**Critère de sortie :** zéro raw hex/rem en dur dans les feuilles métier, tests verts.

---

#### Lot 4 — Mise en conformité des pages · modifications contrôlées

Pages à auditer et mettre en conformité avec la bible visuelle :

- [ ] Tableau de bord (`dashboard/`) — cards KPI, hero patrimoine, alertes, donut
- [ ] Mes comptes (`account/index`) — header, toggle modes, colonne statut, chevrons
- [ ] Détail compte (`account/show*`) — back rond, pills méta, alerte taux
- [ ] Patrimoine (`patrimoine/`) — layout accordéon, donut, logos
- [ ] Budget (`budget/`) — header, badges dépassement, barres progression
- [ ] Analyse budget (`budget/analyse`) — navigation temporelle, insights, Sankey
- [ ] Transactions (`transactions/`) — header sticky, tri, pagination mono
- [ ] À traiter (`a-traiter/`) — toolbar, inline qualification
- [ ] Centre d'actions (`action-center/`) — cards, états premium
- [ ] Pages admin concernées — bordures verticales (§14.5 bible), header standard

**Pour chaque page :**
- [ ] Vérifier usage cohérent : cards · headers · boutons · badges · alertes · tableaux · formulaires · graphiques
- [ ] Corriger uniquement les écarts à la bible visuelle
- [ ] Aucun changement artistique — uniquement mise en conformité
- [ ] Tests verts après chaque page

**Critère de sortie :** toutes les pages passent la checklist 14 points (bible §12).

---

#### Lot 5 — Nettoyage gouvernance `.claude` · modifications documentaires

- [ ] Résoudre le contenu suspect de `user-directives.md` (identique à `decision-log.md` ?)
- [ ] Ajouter note redirecting dans `engineering-standards.md §Design System` → pointe vers la bible (ne pas supprimer la section)
- [ ] Ajouter note redirecting dans `checklists/frontend-checklist.md` F12–F16 → pointe vers bible §12
- [ ] Identifier tout autre fichier `.claude` qui redéfinit une règle de design system
- [ ] Déplacer vers `.claude/archive/` les doublons confirmés (jamais supprimer directement)
- [ ] Mettre à jour `source-of-truth-map.md` si de nouveaux chevauchements sont découverts
- [ ] Vérifier que `decision-log.md` contient l'ADR-012 (bible visuelle comme source primaire)
- [ ] Vérifier que `active-focus.md` pointe vers ce sprint

**Critère de sortie :** un seul fichier est source primaire par sujet, zéro doublon actif non archivé.

---

#### Lot 6 — QA visuelle et validation finale

- [ ] Vérifier les 10 pages auditées (Lot 4) après refactor complet
- [ ] Vérifier que les composants restent cohérents entre eux (cards, boutons, pills, alertes)
- [ ] Lancer `php bin/phpunit --no-coverage` — zéro failure
- [ ] Vérifier qu'aucune nouvelle palette n'a été introduite (grep tokens CSS)
- [ ] Vérifier qu'aucun token non documenté dans la bible n'a été créé
- [ ] Vérifier qu'aucun raw hex ni rem en dur ne subsiste dans les feuilles métier
- [ ] Produire une checklist finale de conformité (14 points × 10 pages = tableau)
- [ ] Mettre à jour `active-focus.md` : sprint terminé
- [ ] Mettre à jour `roadmap.md` : cocher les lots

**Critère de sortie :** toutes les pages conformes, tests verts, zéro nouveau token, rapport final produit.

---

#### Analyse gouvernance — Fichiers `.claude` potentiellement redondants

Identifiés lors du cadrage 2026-05-11 — à traiter dans Lot 5.

| Fichier | Section concernée | Nature de l'overlap | Stratégie recommandée |
|---|---|---|---|
| `memory/engineering-standards.md` §Design System | Tokens `--bx-app-*`, primitives `.bx-*`, doctrine dark-first | Chevauchement modéré — rôle différent (règles d'application code) | **Conserver** — ajouter note redirecting vers la bible. Ne pas supprimer. |
| `checklists/frontend-checklist.md` F12–F16 | Règles d'application design system (bloquant) | Chevauchement contrôlé — checklist d'exécution vs doctrine | **Conserver** — ajouter pointeur vers bible §12. Ne pas supprimer. |
| `memory/user-directives.md` | Contenu retourné identique à `decision-log.md` | Doublon potentiel ou erreur de fichier | **Investiguer** — vérifier le contenu réel avant toute action |
| `references/reference-pack-frontend.md` | Bootstrap, Twig, WCAG — pas de doctrine design propre | Pas d'overlap — rôle différent | **Conserver tel quel** |

**Règle de traitement des doublons :**
1. Investiguer avant d'agir.
2. Conserver sauf preuve que la suppression ne crée pas de régression documentaire.
3. Si suppression : déplacer vers `.claude/archive/` avec note de raison et date.
4. Jamais supprimer directement sans archivage préalable.

---

#### Définition du Done — Sprint CSS

Ce sprint est terminé lorsque toutes les conditions suivantes sont remplies :

**Code**
- [ ] Zéro raw hex ni rem en dur dans les feuilles CSS métier (hors `colors_and_type.css`)
- [ ] Toutes les classes locales pouvant être remplacées par une primitive `.bx-*` l'ont été
- [ ] Aucun nouveau token non documenté dans la bible n'a été introduit
- [ ] Aucune nouvelle palette, aucun nouveau gradient décoratif

**Pages**
- [ ] Les 10 pages cibles passent la checklist 14 points (bible §12)
- [ ] Les 4 corrections §14 de la bible sont traitées ou arbitrées explicitement

**Tests**
- [ ] `php bin/phpunit --no-coverage` → zéro failure

**Gouvernance**
- [ ] `source-of-truth-map.md` à jour — aucun sujet sans source primaire unique
- [ ] `engineering-standards.md §Design System` pointe vers la bible
- [ ] `user-directives.md` résolu (contenu correct ou archivé)
- [ ] ADR-012 présent dans `decision-log.md`
- [ ] `active-focus.md` mis à jour (sprint terminé)

---

### Items Phase 24 encore à faire (à planifier hors sprints Powens)

- [ ] Impersonation ROLE_SUPER_ADMIN
- [ ] Codes de secours 2FA
- [ ] Appareils de confiance (scheb/2fa-trusted-device)
- [ ] Politique de mot de passe (historique 5 derniers)

---

## Post-socle — Crypto & Métaux précieux (planification différée)

**Décision produit : 2026-03-25**
Crypto et métaux précieux exclus du périmètre fonctionnel actuel.
Raison : la base produit (Phases A–E) doit être finalisée et stabilisée avant d'ouvrir des classes d'actifs complexes (valorisation temps réel, API tierces, volatilité).

**Conditions de retour en roadmap active :**
- Phases A–E complétées et en production stable
- Volume utilisateurs justifiant l'investissement de maintenance API
- Choix d'API de valorisation documenté et testé (CoinGecko, Gold-API ou équivalent)

**Périmètre prévu (différé) :**
- CRUD `/app/crypto-holdings` (entité `CryptoHolding` déjà en base)
- CRUD `/app/precious-metals` (entité `PreciousMetalHolding` déjà en base)
- Valorisation J-1 ou temps réel via API externe
- Intégration dans le net worth et le donut allocation
- Sync automatique des cours (via tâche planifiée ou webhook)
- Critère : CryptoHolding créé → net worth et donut mis à jour
