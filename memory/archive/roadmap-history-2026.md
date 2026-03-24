
# roadmap-history-2026.md
updated: 2026-03-24
status: archived

Historique détaillé de la roadmap Budgex 2026.
Ce document conserve les phases validées, les reports, les réorganisations et les arbitrages antérieurs.
Il n’est pas la source active de pilotage.

## Cap produit retenu

Le projet Budgex évolue vers une expérience plus lisible et synthétique, inspirée par le niveau de clarté de Finary, sans copie aveugle. :contentReference[oaicite:1]{index=1}

---

## Socle plateforme (Phases 1–12) — VALIDÉ le 08/03/2026

- Phase 1 — Sécurité auth
- Phase 2 — Cycle de vie utilisateur
- Phase 3 — Rôles & permissions
- Phase 4 — Dashboard admin
- Phase 5 — SiteConfig
- Phase 6 — Pages légales & système
- Phase 7 — Emails industrialisés
- Phase 8 — Audit trail
- Phase 9 — Standardisation technique
- Phase 10 — Tests automatiques
- Phase 11 — Documentation
- Phase 12 — Validation finale socle réutilisable

## Features métier Budgex — débloquées le 08/03/2026

- Comptes
- Catégories
- Libellés
- Transactions
- Dashboard v1

## UX & Sécurité (sessions mars 2026)

- Phase 13 — Navigation & shell
- Phase 14 — Dashboard premium
- Security hardening (2026-03-16)
- Dark mode (2026-03-17)
- 2FA TOTP (2026-03-17)
- Export DataTables (2026-03-17)

## Phases 15–23 — complétées (mars 2026)

- Phase 15 — Enrichissement vues
- Phase 16 — Responsive 5 niveaux
- Phase 17 — Tests couverture features récentes
- Phase 18 — Dashboard admin réel
- Phase 19 — Notifications utilisateur
- Phase 20 — Module Budgets
- Phase 21 — Module Objectifs
- Phase 22 — Module Rapports
- Phase 23 — Export données

---

## Phase 24 — Qualité & sécurité avancées (partiellement complétée)

### Complété
- Session management
- Rate limiting étendu
- Headers de sécurité HTTP

### Reste à faire
- Impersonation ROLE_SUPER_ADMIN
- Codes de secours 2FA
- Appareils de confiance
- Politique de mot de passe

---

## Phase 25 — Expérience utilisateur avancée (defer / partiellement reportée)

Items différés :
- Onboarding
- Recherche globale
- Tags libres sur transactions
- Transactions récurrentes
- Multi-devises avancé
- Mode hors-ligne

---

## Phase 26 — Intégration Powens (complétée, mars 2026)

Note historique :
dans l’ancienne roadmap, Powens était un item de Phase 26.
Il a été avancé et traité en profondeur. :contentReference[oaicite:2]{index=2}

### Complété
- Connexion bancaire Powens
- Sync incrémentale
- Staging comptes inconnus
- Catalogue connecteurs
- Logos bancaires
- Champs enrichis
- Debug payloads
- Sync automatique

---

## Phases reportées de l’ancienne roadmap

- API REST
- Webhooks sortants
- Application mobile

---

## Backlog non planifié conservé

- Mode multi-utilisateurs / partage de compte
- Thème couleur personnalisable
- Internationalisation complète
- Archivage de comptes
- Tableau de bord configurable
- Comparaison avec moyennes communautaires

---

## Historique de la V2 active validée le 2026-03-24

### Vue d'ensemble retenue
- Phase A — Fondations Powens
- Phase B — Boucle transactions
- Phase C — Vision financière
- Phase D — Patrimoine étendu
- Phase E — Automatisation intelligente

### Arbitrages structurants retenus
- Powens traité comme socle produit prioritaire
- budget vs réel monté avant patrimoine non bancaire complet
- automatisation intelligente repoussée après construction d’un historique exploitable
- mobile / API / webhooks exclus du périmètre immédiat

### Sprints V2 déjà complétés au moment de validation
- Sprint 1 — Sync automatique Powens
- Sprint 2 — Staging : flux de résolution complet

### Sprint V2 restant à lancer après validation
- Sprint 3 — Page bank-connections complète et opérationnelle
- Sprint 4 — Workflow révision transactions
- Sprint 5 — Auto-catégorisation
- Sprint 6 — Dashboard patrimoine / net worth
- Sprint 7 — Budget vs réel + cash flow enrichi
- Sprint 8 — Actifs non bancaires
- Sprint 9 — Récurrences et règles intelligentes
- Sprint 10 — Objectifs et projections