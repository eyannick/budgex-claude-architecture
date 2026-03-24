# roadmap.md
updated: 2026-03-24
version: V2

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

## PARTIE 2 — ROADMAP ACTIVE V2 (validée 2026-03-24)

Direction : rapprochement progressif niveau Finary — lisibilité patrimoine, synthèse globale, expérience fluide.

### Vue d'ensemble

```
Phase A — Fondations Powens      Sprint 1 ✅ · 2 · 3    P0
Phase B — Boucle transactions    Sprint 4 · 5            P0/P1
Phase C — Vision financière      Sprint 6 · 7            P1
Phase D — Patrimoine étendu      Sprint 8                P1
Phase E — Automatisation         Sprint 9 · 10           P2
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

#### Sprint 3 — Page bank-connections : complète et opérationnelle · P0

(fusion ex-Sprint connexions erreur + ex-Sprint UX bank-connections)
- Card enrichie : logo connecteur, badge santé (vert/orange/rouge), lastSyncedAt formaté, nb comptes, nb transactions ce mois
- Gestion erreurs : message lisible par errorCode, CTA "Reconnecter" → relance webview avec connection_id
- Stabilité connecteur : warning si stabilityStatus = unstable/down
- Stats par connexion : solde total, delta vs mois précédent
- Suppression : modal confirmation + liste données conservées
- Debug ?debug=1 déplacé vers /admin/powens-debug (ROLE_ADMIN uniquement)
- Critère : connexion erreur → badge rouge → CTA → webview → connexion rétablie

---

### Phase B — Boucle transactions

Objectif : transactions importées traitables rapidement, catégorisées intelligemment.

#### Sprint 4 — Workflow révision transactions · P0

- Compteur "X à réviser" dans nav + dashboard
- Vue filtrée isReviewed=false sur /app/transactions
- Action inline : catégorie + "Valider" → isReviewed=true (AJAX)
- Sélection multiple + action groupée (catégoriser + marquer révisé en masse)
- Persistance du filtre dans session
- Critère : bandeau compteur, révision en masse, compteur → 0

#### Sprint 5 — Auto-catégorisation Powens → Budgex · P1

- Table `powens_category_mapping` (powens_category_id ↔ category Budgex) + migration + admin UI
- Application dans PowensTransactionMapper à l'import
- Règles custom utilisateur : table `category_rule` (marchand/description contains → catégorie)
- Commande `app:powens:apply-category-rules` sur transactions existantes non catégorisées
- Critère : transaction avec powensCategoryId connu → catégorie assignée à l'import

---

### Phase C — Vision financière

Objectif : vision consolidée patrimoine + budget vs réel. Valeur produit maximale.

#### Sprint 6 — Dashboard patrimoine / net worth · P1

- Net worth = somme Account.currentBalance par assetClass (actifs − passifs)
- Donut répartition assetClass (Chart.js)
- Courbe évolution net worth 12 mois
- Vue "Cash disponible" vs "Patrimoine investi"
- Refonte dashboard : net worth haut, cash flow milieu, comptes groupés assetClass bas
- Placeholder "Compléter votre patrimoine" pour actifs non bancaires (pré-Sprint 8)
- Critère : net worth = somme vérifiable des soldes, donut cohérent, MAJ après sync

#### Sprint 7 — Budget vs réel + cash flow enrichi · P1

(monté devant actifs non bancaires : valeur immédiate, fonctionne sans saisie manuelle)
- Vue budget vs réel : montant alloué / consommé / pourcentage / barre de progression colorée
- Alertes budget déclenchées par sync Powens (BudgetService::checkAlerts depuis PowensSyncService)
- Graphique cash flow mensuel enrichi : revenus / dépenses / net / épargne (4 séries)
- Vue "Résumé du mois" sur dashboard : top 5 catégories, catégories dépassées, évolution vs M-1
- Critère : budget catégorie X → barre MAJ automatiquement après sync Powens

---

### Phase D — Patrimoine étendu

#### Sprint 8 — Actifs non bancaires : crypto, métaux, épargne · P1

(après Sprint 6 qui affiche le placeholder)
- CRUD /app/crypto-holdings (lié à Account)
- CRUD /app/precious-metals (lié à Account)
- Liaison SavingProductReference → Account + champ savingProduct FK + migration
- Intégration dans net worth Sprint 6 (remplacement du placeholder)
- Projection épargne via InterestProjectionService exposé sur Account::showInfo()
- Critère : CryptoHolding créé → net worth MAJ

---

### Phase E — Automatisation intelligente

#### Sprint 9 — Récurrences et règles intelligentes · P2

(nécessite historique > 3 mois de transactions catégorisées)
- Détection récurrences : même marchand ± 5% montant, même fréquence sur 3+ mois
- Marquage isRecurring automatique
- Vue "À venir ce mois" (récurrences attendues non encore importées)
- Règles catégorisation persistantes (description contains → category)
- Critère : abonnement mensuel détecté, apparaît dans "à venir"

#### Sprint 10 — Objectifs et projections · P2

- Liaison Goal ↔ compte épargne (progression automatique si solde évolue)
- Courbe progression actuel vs trajectoire cible
- Alerte si objectif à risque
- GoalContribution automatique depuis transaction épargne identifiée
- Critère : virement épargne importé → GoalContribution créée, progression affichée

---

### Items Phase 24 encore à faire (à planifier hors sprints Powens)

- [ ] Impersonation ROLE_SUPER_ADMIN
- [ ] Codes de secours 2FA
- [ ] Appareils de confiance (scheb/2fa-trusted-device)
- [ ] Politique de mot de passe (historique 5 derniers)
