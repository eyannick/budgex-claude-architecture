# Claude Budgex Architecture

> Architecture **Claude Code** dédiée au projet **Budgex** — pilotage robuste, lisible et contrôlé du développement via une équipe d'agents spécialisés.

---

## Table des matières

- [Objectif](../../../../Users/Utilisateur/Downloads/README.md#objectif)
- [Structure du dossier `.claude`](../../../../Users/Utilisateur/Downloads/README.md#structure-du-dossier-claude)
- [Composants principaux](../../../../Users/Utilisateur/Downloads/README.md#composants-principaux)
  - [Orchestrateur](../../../../Users/Utilisateur/Downloads/README.md#1-orchestrateur)
  - [Agents spécialisés](../../../../Users/Utilisateur/Downloads/README.md#2-agents-spécialisés)
  - [Gouvernance](../../../../Users/Utilisateur/Downloads/README.md#3-gouvernance)
  - [Mémoire projet](../../../../Users/Utilisateur/Downloads/README.md#4-mémoire-projet)
  - [Checklists](../../../../Users/Utilisateur/Downloads/README.md#5-checklists)
  - [Hooks](../../../../Users/Utilisateur/Downloads/README.md#6-hooks)
  - [Evals](../../../../Users/Utilisateur/Downloads/README.md#7-evals)
- [Principes de fonctionnement](../../../../Users/Utilisateur/Downloads/README.md#principes-de-fonctionnement)
- [Utilisation](../../../../Users/Utilisateur/Downloads/README.md#utilisation)
- [Outils opérationnels](../../../../Users/Utilisateur/Downloads/README.md#outils-opérationnels)
- [Recommandations](../../../../Users/Utilisateur/Downloads/README.md#recommandations)
- [Licence](../../../../Users/Utilisateur/Downloads/README.md#licence)

---

## Objectif

Cette architecture sert à :

- **Router** correctement les demandes entre agents spécialisés
- **Éviter** les doublons documentaires et les contradictions
- **Réduire** les dérives de scope
- **Conserver** une mémoire projet propre et stable
- **Imposer** des formats de sortie cohérents
- **Sécuriser** le workflow de développement
- **Évaluer** la qualité du comportement de l'orchestrateur

---

## Structure du dossier `.claude`

```text
.claude/
├── agents/              # Agents spécialisés + orchestrateur + catalogue
├── archive/             # Historique archivé des sessions et décisions
├── checklists/          # Checklists de validation par spécialité
├── evals/               # Cas d'évaluation et scoreur
├── hooks/               # Hooks Claude Code (pré/post tool use)
├── memory/              # Contexte projet, risques, roadmap, directives
├── ops/                 # Outils opérationnels et rapports
├── playbooks/           # Playbooks actifs
├── references/          # Packs de références par domaine
└── source-of-truth-map.md
```

---

## Composants principaux

### 1. Orchestrateur

**Fichier :** `agents/budgex-orchestrator.md`

Point d'entrée **unique** du système. Il :

- Classe chaque demande entrante
- Choisit le mode de traitement : `NO_DELEGATE`, `SINGLE_STREAM` ou `MULTI_STREAM`
- Délègue aux agents spécialisés si nécessaire
- Arbitre les conflits inter-agents
- Produit la réponse finale consolidée

| Mode | Description |
|------|-------------|
| `NO_DELEGATE` | L'orchestrateur traite directement (priorité) |
| `SINGLE_STREAM` | Délégation à un seul agent |
| `MULTI_STREAM` | Délégation à plusieurs agents en parallèle (si nécessaire) |

---

### 2. Agents spécialisés

Situés dans `agents/` :

| Agent | Fichier | Domaine |
|-------|---------|---------|
| Backend | `budgex-backend.md` | PHP / Symfony, API, services |
| Frontend | `budgex-frontend.md` | Twig, JS, UI/UX |
| Finance | `budgex-finance.md` | Logique métier budgétaire |
| Database | `budgex-database.md` | Doctrine, schéma, migrations |
| QA | `budgex-qa.md` | Tests, PHPUnit, qualité |
| SEO | `budgex-seo.md` | Référencement, performances |

Chaque agent dispose de :
- Une **mission claire** et un **périmètre strict**
- Des **handoffs définis** vers les autres agents
- Un **format de rapport obligatoire**

---

### 3. Gouvernance

Fichiers clés :

- `source-of-truth-map.md` — source primaire unique pour chaque règle
- `playbooks/agent-team-playbook.md` — fonctionnement de l'équipe d'agents
- `agents/agents-catalog.md` — référentiel des agents et de leurs responsabilités

Ces fichiers définissent **qui fait quoi**, **où vit chaque vérité documentaire** et les **règles globales de routing**.

---

### 4. Mémoire projet

Située dans `memory/` :

| Fichier | Contenu |
|---------|---------|
| `project-context.md` | Contexte stable du projet |
| `roadmap.md` | Planification et jalons |
| `routing-matrix.md` | Matrice de routing des demandes |
| `decision-log.md` | Journal des décisions durables |
| `user-directives.md` | Directives utilisateur persistantes |
| `active-focus.md` | Focus actif de la session en cours |
| `open-risks.md` | Risques ouverts identifiés |
| `engineering-standards.md` | Standards techniques du projet |
| `error-guardrails.md` | Garde-fous et gestion des erreurs |
| `execution-profiles.md` | Profils d'exécution disponibles |
| `memory-index.md` | Index de la mémoire projet |

---

### 5. Checklists

Situées dans `checklists/`, organisées par spécialité :

- `backend/`
- `frontend/`
- `database/`
- `qa/`
- `seo/`

Servent à **valider les changements** de façon rigoureuse, sans bureaucratie excessive.

---

### 6. Hooks

Situés dans `hooks/` :

| Hook | Rôle |
|------|------|
| `quality_gate.py` | Contrôle qualité avant exécution |
| `pre_tool_use_guard.py` | Sécurisation des appels d'outils |
| `post_tool_use_failure_hint.py` | Aide au diagnostic après échec |
| `reference_freshness.py` | Vérification de la fraîcheur des références |
| `session_close_trigger.py` | Actions déclenchées en fin de session |

Un hook visuel optionnel peut être activé pour améliorer la lisibilité en console (couleurs et labels par agent).

---

### 7. Evals

Situés dans `evals/` :

```text
evals/
├── eval-cases.json   # Cas de test de l'orchestrateur
├── run-evals.ps1     # Script d'exécution des evals
├── responses/        # Réponses générées
└── results/          # Résultats et scores
```

Les evals vérifient que l'orchestrateur :
- Route correctement les demandes
- Respecte les règles du système
- Évite les dérives de scope et de mémoire

---

## Principes de fonctionnement

### Source de vérité unique

Chaque règle importante possède une **source primaire unique**.  
Référence centrale : `source-of-truth-map.md`

### Simplicité avant tout

- Éviter l'usine à gaz
- Privilégier la solution la plus simple
- Limiter la multiplication des couches
- Ne corriger que ce qui apporte un gain réel

### Discipline documentaire

Les documents actifs ne doivent **pas** :
- Faire doublon
- Se contredire
- Porter plusieurs rôles simultanément

### Discipline de délégation

L'orchestrateur suit strictement cet ordre de préférence :

```
NO_DELEGATE  →  SINGLE_STREAM  →  MULTI_STREAM (seulement si nécessaire)
```

---

## Utilisation

### Routing

Le routing opérationnel s'appuie sur :

```
agents/agents-catalog.md
memory/routing-matrix.md
agents/budgex-orchestrator.md
```

### Profils d'exécution

Trois profils sont disponibles (définis dans `memory/execution-profiles.md`) :

| Profil | Usage |
|--------|-------|
| `fast` | Réponse rapide, validation légère |
| `safe` | Contrôles renforcés, risque minimal |
| `deep` | Analyse approfondie, couverture complète |

### Macros de fin de session

Les macros utilisateur sont définies dans `memory/user-directives.md`.

Exemples :
```
fin de session
fin de session, bonne nuit
```

---

## Outils opérationnels

### Lancer les evals

```powershell
# Tous les cas
.\.claude\evals\run-evals.ps1

# Un cas spécifique
.\.claude\evals\run-evals.ps1 -CaseId "eval-001" -Verbose
```

### Boucle qualité

```powershell
.\.claude\ops\run-quality-loop.ps1
```

Ce script lance les contrôles locaux principaux :

- PHPUnit
- `doctrine:schema:validate`
- Lint YAML
- Lint Twig
- PHPStan (si disponible)

---

## Recommandations

- Garder les **fichiers centraux stables** ; ne les modifier que si un besoin réel apparaît
- Modifier la **gouvernance** uniquement si un besoin réel est identifié
- Ne pas ajouter de nouveaux **agents ou hooks** sans justification claire
- Ne pas transformer les hooks ou les evals en **couche de gouvernance cachée**
- Prioriser toujours `NO_DELEGATE` avant d'envisager une délégation

---

## Licence

> À compléter selon le contexte d'utilisation.

Options suggérées :
- `MIT` — usage libre avec attribution
- `Apache-2.0` — usage commercial permis avec conditions
- Usage privé sans redistribution
