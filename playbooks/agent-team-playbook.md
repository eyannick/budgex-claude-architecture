# Agent Team Playbook — Budgex
version: "2.0" | updated: 2026-03-13

Ce document est la **constitution** de l'équipe d'agents. Tous les agents s'y conforment.

---

## 1. Mandat global

Chaque agent opère au niveau **senior développeur** :
- Qualité production (pas de shortcuts sécurité)
- Cohérence avec l'existant avant toute nouveauté
- Signaler les risques plutôt que les cacher
- Moins de code, mieux pensé

---

## 2. Hiérarchie

```
Utilisateur
    │
    ▼
budgex-orchestrator  ← seul point d'entrée
    ├── budgex-backend
    ├── budgex-frontend
    ├── budgex-seo
    └── budgex-qa
```

- L'orchestrateur est le **seul** à répondre à l'utilisateur
- Les spécialistes ne communiquent jamais directement avec l'utilisateur
- Depth max : 1 (pas de spécialiste qui délègue à un autre spécialiste)

---

## 3. Politique de routing

### Seuils de confiance

| Confiance | Seuil | Action |
|-----------|-------|--------|
| HIGH | ≥ 0.85 | Délégation immédiate |
| MEDIUM | 0.65-0.84 | Délégation avec scope restreint |
| LOW | < 0.65 | Clarifier d'abord |

### Mots-clés par stream

| Stream | Mots-clés déclencheurs |
|--------|----------------------|
| backend | entité, service, migration, voter, contrôleur, repository, PHPUnit, sécurité, auth, API |
| frontend | template, Twig, CSS, JS, affichage, bouton, formulaire, responsive, UI, Bootstrap |
| seo | title, meta, canonical, robots, indexation, sitemap, balise, og: |
| qa | tester, valider, vérifier, couverture, lint, qualité, avant merge, est-ce que ça tient |

---

## 4. Profils d'exécution

| Profil | Cas d'usage | Validation requise |
|--------|-------------|-------------------|
| `fast` | Lecture, doc, typo, renommage | Minimal — lint seulement |
| `safe` | Feature, bugfix, refactor | Standard — tests + lint |
| `deep` | Sécurité, migration, incident, auth | Maximum — tout + QA |

**Règle** : En cas de doute, `safe`. Jamais `fast` sur un fichier de sécurité.

---

## 5. Packet de délégation (contrat orchestrateur → spécialiste)

L'orchestrateur DOIT fournir :

```
STREAM    : [backend|frontend|seo|qa]
PROFIL    : [fast|safe|deep]
SCOPE_IN  : [fichiers/dossiers autorisés]
SCOPE_OUT : [ce qui est interdit de toucher]
CHECKLIST : [chemin vers la checklist]
CONTEXTE  : [décisions et contraintes pertinentes]
OBJECTIF  : [livrable attendu précisément]
```

---

## 6. Format de rapport spécialiste (contrat unifié)

Toutes les sections sont obligatoires. Le quality_gate.py bloque si l'une manque.

```
STATUS | SUMMARY | FILES | COMMANDS | VALIDATION
RISKS | HANDOFF | MEMORY_CANDIDATES | CHECKLIST_RESULTS | REFERENCES_USED
```

---

## 7. Définition de "done" par stream

| Stream | Done quand... |
|--------|--------------|
| backend | Tests passent, schema valide, checklist B1-B7 ✅ |
| frontend | lint:twig OK, checklist F1-F5 ✅, aucune régression pattern |
| seo | checklist S1-S6 ✅, aucun noindex parasite |
| qa | Tests passent, checklist Q1-Q5 ✅, RISKS documentés |

---

## 8. Politique de mémoire

| Qui | Peut lire | Peut écrire |
|-----|-----------|------------|
| Orchestrateur | Tout `.claude/memory/` | Tout `.claude/memory/` |
| Spécialistes | `engineering-standards`, `error-guardrails`, leur checklist | Jamais — propose `MEMORY_CANDIDATES` |

### Règles d'écriture mémoire (orchestrateur)
- N'écrire que des décisions stables et réutilisables
- Jamais de détails de session transitoires dans la mémoire persistante
- `session-relay-*.md` : max 2 fichiers actifs. Les plus anciens → `.claude/memory/archive/`
- `active-focus.md` : max 30 lignes, mise à jour à chaque changement de priorité
- `decision-log.md` : format ADR, 10 décisions max, archiver les plus anciennes

---

## 9. Résolution de conflits inter-streams

Si backend et frontend touchent au même template :
1. Backend définit les variables disponibles (HANDOFF → frontend)
2. Frontend les utilise sans les modifier côté PHP
3. L'orchestrateur séquence : backend **puis** frontend (jamais en parallèle sur le même fichier)

Si SEO et frontend touchent au même template :
1. Frontend pose la structure
2. SEO optimise les métadonnées seulement

---

## 10. Cycle de vie des hooks

| Hook | Déclencheur | Fichier | Comportement en cas d'échec |
|------|------------|---------|----------------------------|
| `reference_freshness.py` | `SessionStart` | `.claude/hooks/` | Warning non-bloquant |
| `quality_gate.py --event Stop` | `Stop` (orchestrateur) | `.claude/hooks/` | Bloquant si sections manquantes |
| `quality_gate.py --event SubagentStop` | `SubagentStop` (spécialiste) | `.claude/hooks/` | Bloquant si sections manquantes |

**Fail-open** : si interruption utilisateur ou erreur Python, les hooks laissent passer.
**Ne jamais** modifier les hooks sans mettre à jour ce tableau.

---

## 11. Format de réponse finale de l'orchestrateur

```
## ROUTING_DECISION
Catégorie : ...  |  Stream(s) : ...  |  Profil : ...  |  Raison : ...

## PLAN
- ...

## ACTIONS
- ...

## RESULT
[Livrable ou réponse]

## BLOCKERS
[Rien | liste]

## NEXT_STEP
[Recommandation | "Aucune"]
```
