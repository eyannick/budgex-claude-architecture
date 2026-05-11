# decision-log.md
updated: 2026-05-11 (ADR-006 archivée · ordre ADR-009/015/016 corrigé)
managed_by: orchestrator_only
format: ADR
max_active_entries: 15
status: active

## Rôle du document

Ce fichier conserve les décisions d'architecture et de gouvernance durables du système Budgex.

Il ne stocke pas :
- les directives utilisateur persistantes ;
- les priorités temporaires ;
- la roadmap active ;
- les détails transitoires de session.

## ADR-001 — Orchestrateur unique comme point d'entrée
Date : 2026-03-09
Statut : Actif
Décision : un orchestrateur unique reçoit les demandes utilisateur et délègue si nécessaire.
Raison : cohérence des réponses, contrôle de la mémoire, limitation du scope drift.

## ADR-002 — Écriture mémoire réservée à l'orchestrateur
Date : 2026-03-09
Statut : Actif
Décision : les spécialistes ne font que proposer des `MEMORY_CANDIDATES`.
Raison : éviter la dérive contextuelle et les doublons.

## ADR-003 — `SCOPE_IN` nominatif obligatoire
Date : 2026-03-13
Statut : Actif
Décision : toute délégation doit lister précisément les fichiers ou dossiers autorisés.
Raison : réduire les effets de bord.

## ADR-004 — `safe` par défaut, `deep` pour sécurité et migration
Date : 2026-03-09
Statut : Actif
Décision : le profil standard du système est `safe`.
Raison : compromis robustesse / vitesse.

## ADR-005 — Finance comme stream consultatif officiel
Date : 2026-03-21
Statut : Actif
Décision : `budgex-finance` devient un stream officiel mais consultatif par défaut.
Raison : clarifier les règles comptables sans le laisser coder directement.

## ADR-007 — Directives utilisateur persistantes séparées des ADR
Date : 2026-03-21
Statut : Actif
Décision : toute règle durable demandée par l'utilisateur est stockée dans `user-directives.md` et non dans le `decision-log`.
Raison : séparer gouvernance technique et habitudes opératoires utilisateur.

## ADR-008 — `memory/product-pricing-spec.md` comme source de vérité unique pour le packaging Budgex
Date : 2026-04-25
Statut : Actif
Décision : le fichier `.claude/memory/product-pricing-spec.md` est la référence canonique et unique pour tout ce qui concerne le packaging Free / Premium / Premium+, les entitlements / capabilities, la logique d'offre, le positionnement des fonctionnalités et l'UX de monétisation.
Raison : centraliser en un seul endroit les arbitrages produit structurants pour éviter les contradictions, faciliter la maintenance et donner une base stable pour la pricing page, les specs d'entitlements et la roadmap de lancement.
Conséquence : aucun autre fichier `.claude` ne doit contenir une version complète ou concurrente de ces arbitrages. Les autres fichiers peuvent pointer vers `product-pricing-spec.md` ou en résumer un élément, pas le redéfinir.

## ADR-009 — Claude comme orchestrateur documentaire du périmètre pricing / packaging
Date : 2026-04-25
Statut : Actif
Décision : à chaque future décision structurante sur le packaging, le pricing, les entitlements, le Centre d'actions, l'automatisation, ou la taxonomie catégories / règles / libellés, Claude doit (1) mettre à jour `memory/product-pricing-spec.md`, (2) aligner les fichiers `.claude` secondaires si nécessaire, (3) maintenir la cohérence de la documentation produit sans créer de doublon concurrent.
Raison : la spec produit est un document vivant. Sans règle de maintenance explicite, elle se désynchronise dès le premier arbitrage non inscrit.
Déclencheurs d'application : décision sur Free / Premium / Premium+, changement de limite quantitative (règles, connexions), introduction d'une nouvelle capability, arbitrage UX sur les locks / badges, décision sur Powens en Free.

## ADR-010 — `memory/entitlements-spec.md` comme source de vérité pour l'architecture technique des droits d'accès
Date : 2026-04-25
Statut : Actif
Décision : le fichier `.claude/memory/entitlements-spec.md` est la référence canonique pour l'architecture technique du système d'entitlements : modèle Subscription, classe Capability, EntitlementService, CapabilityVoter, EntitlementExtension Twig, PlanLimitException, séquence d'implémentation et garde-fous.
Raison : séparer les arbitrages produit (product-pricing-spec.md) de leur traduction technique (entitlements-spec.md), conformément au principe de séparation des responsabilités documentaires.
Relation : entitlements-spec.md dépend de product-pricing-spec.md et doit rester cohérent avec lui. En cas de conflit, product-pricing-spec.md l'emporte sur les arbitrages produit ; entitlements-spec.md l'emporte sur les choix d'implémentation.

## ADR-011 — Stripe docs comme source documentaire officielle exclusive pour le billing
Date : 2026-04-27
Statut : Actif
Décision : https://docs.stripe.com/ est la seule source externe autorisée pour toute implémentation billing Stripe dans Budgex. Aucune documentation tierce (blog, article, tutoriel, exemple GitHub) ne peut servir de référence primaire pour des décisions billing.
Raison : les décisions billing (gestion de webhooks, statuts d'abonnement, sécurité des clés) ont un impact direct sur le chiffre d'affaires et la sécurité. Seule la doc officielle Stripe garantit l'exactitude.
Règles associées :
- Toute clé Stripe (secret, publishable, webhook secret, price ID) doit être lue uniquement via variable d'environnement.
- Jamais commiter une vraie valeur Stripe dans un fichier versionné.
- Toute clé exposée accidentellement doit être rotée immédiatement dans le Stripe Dashboard.
- Variables attendues : `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PREMIUM_PRICE_ID`.
- Référence technique détaillée : `references/reference-pack-billing.md`.

## ADR-012 — `references/budgex-visual-bible.md` comme source de vérité primaire pour la doctrine visuelle
Date : 2026-05-11
Statut : Actif
Décision : le fichier `.claude/references/budgex-visual-bible.md` est la référence canonique et unique pour toute la doctrine visuelle et UX/UI de Budgex : vision, principes, palette officielle, tokens `--bx-app-*`, typographie, layouts, composants, règles graphiques, tableaux, alertes, responsive, do/don't, checklist et archétypes de pages.
Raison : stabiliser la doctrine design dans un document unique, éviter les définitions concurrentes dispersées dans `engineering-standards.md`, les checklists et les prompts agents.
Conséquences :
- Les fichiers CSS (`colors_and_type.css`, `components.css`) restent la source **technique** d'exécution (vérité du code).
- La bible est la source **doctrinale** (vérité de l'intention).
- `memory/engineering-standards.md §Design System` est une source secondaire autorisée : elle peut résumer des règles d'application code, mais ne doit pas redéfinir les tokens ni la doctrine complète.
- `checklists/frontend-checklist.md` F12–F16 est une checklist d'application, pas une source doctrinale.
- Aucun nouveau token ne peut être créé sans décision explicite tracée ici.
- En cas de conflit entre la bible et un autre fichier `.claude`, la bible l'emporte.

## ADR-013 — Statut du thème light pour la V1 Budgex
Date : 2026-05-11
Statut : Actif
Décision :
- Le thème **dark est la V1 officielle** de la zone authentifiée (`/app/*`, `/admin/*`). Toutes les garanties de conformité visuelle et de QA s'appliquent exclusivement au dark.
- Le thème **light est toléré sans garantie V1** : il existe (`html[data-theme="light"]`), il fonctionne, mais il n'est pas audité dans le sprint CSS V1 et n'entre pas dans son périmètre.
- La dette connue `--bx-app-accent: #6200ea` en mode clair (couleur Material vs. brand `#7c3aed`) est documentée dans la bible visuelle §Annexe B.4 et dans ce log. Elle sera traitée si et quand le thème light devient officiellement supporté.
- **Aucune modification CSS** n'est autorisée pour le thème light dans le sprint CSS V1.
Raison : la bible visuelle est dark-first par décision produit. Auditer simultanément dark et light doublerait la charge sans apport utilisateur mesurable en V1.

## ADR-014 — Stratégie de déduplication `app.css` vs CSS métier
Date : 2026-05-11
Statut : Actif
Décision :
- **`components.css` est et reste la source des primitives `.bx-*`**. Aucune primitive ne doit être dupliquée ou redéfinie dans `app.css` ou un CSS métier.
- **`app.css` est en transition active** (9 980 lignes au 2026-05-11). Il contient :
  - des alias legacy (`--bx-space-*` → `--bx-sp-*`, `--bx-font-*` → `--bx-fs-*`) : tolérés en transition, à retirer lot par lot ;
  - des overrides intentionnels de tokens canoniques (`--bx-radius: 12px` vs canonique `8px`, `--bx-radius-sm: 8px` vs canonique `6.4px`) : documentés dans le code comme dette — à retirer per composant uniquement après vérification visuelle que la migration est transparente ;
  - du contenu page-spécifique mélangé au global : à déplacer vers les CSS métier concernés ou supprimer s'il est couvert par une primitive.
- **Les CSS métier** (`cashflow.css`, `patrimoine.css`, `accounts.css`, `transactions.css`, `dashboard.css`, `profile.css`, `legal.css`) portent les variantes spécifiques justifiées à leur domaine. Ils ne doivent pas absorber du global.
- **Règle de déduplication** : un style dans `app.css` est éligible à suppression uniquement si (1) il est couvert à l'identique par une primitive `components.css` ET (2) la suppression a été vérifiée visuellement sans régression.
- **Interdiction absolue de suppressions massives** : lot par lot, domaine par domaine, tests visuels entre chaque passe.
- **Ordre de priorité** : (a) raw hex / rem en dur → remplacer par tokens, (b) doublons exacts avec une primitive → supprimer, (c) aliases legacy → retirer une fois les consumers migrés, (d) overrides de radius → retirer per composant.
Raison : `app.css` a 9k sélecteurs actifs. Une suppression massive sans audit visuel risque des régressions silencieuses sur des pages non testées. La déduplication progressive est la seule approche sûre.

## ADR-015 — Convention d'usage `chevron_right` / `arrow_forward`
Date : 2026-05-11
Statut : Actif
Décision : deux icônes Material Icons ont des rôles sémantiques distincts et non interchangeables.
- `chevron_right` : ligne de tableau, ligne de liste, item ouvrant une fiche de détail dans la même hiérarchie.
- `arrow_forward` : CTA autonome, lien "Tout voir", lien de section, action qui quitte la vue courante.
Raison : le lot Accounts-Polish v1 a remplacé `arrow_forward` par `chevron_right` dans la liste des comptes. Cette décision a été généralisée en règle transverse pour éviter les incohérences futures.
Conséquences :
- La bible visuelle §6.J est la source doctrinale de cette règle.
- Les templates Patrimoine (× 7) et `admin/user/index.html.twig` constituent une dette connue à migrer en lot dédié.
- La classe `.bx-row-arrow` reste valide (wrapper de colonne) ; seule l'icône intérieure change.
- Le commentaire CSS `patrimoine.css:221` devra être corrigé lors du lot de migration.

## ADR-016 — Doctrine de largeur des pages et cards
Date : 2026-05-11
Statut : Actif
Décision : la largeur d'une card ou section est déterminée par l'usage utilisateur, selon trois archétypes :
- **Opérationnel** (comptes, transactions, admin) → `col-12` / full-width — scanner, comparer, gérer.
- **Analytique** (dashboard, patrimoine, cashflow) → full-width ou grille justifiée (`8/4`, `7/5`) — blocs complémentaires lus simultanément uniquement.
- **Formulaire / paramètres / lecture** (profil, édition, légal) → largeur contrainte (`col-lg-8`, max-width 720–900 px) — préserver la lisibilité à la saisie.
Raison : la page Comptes a posé la question d'une contrainte `col-lg-*` inutile. La décision a été généralisée en doctrine transverse pour éviter les incohérences futures de layout.
Conséquences : la bible visuelle §5 "Largeur des sections par type de page" est la source doctrinale. Aucun audit global immédiat — les corrections sont appliquées page par page lors des futurs lots de polish.

---

## ADR archivées

| ADR | Sujet | Archivée le | Raison |
|---|---|---|---|
| ADR-006 | Baseline QA officielle centralisée | 2026-05-11 | Règle entièrement encodée dans `source-of-truth-map.md` + action confirmée close dans `archive/refonte-summary-2026-03.md` |

Contenu complet → `.claude/archive/adr-archive.md`.
