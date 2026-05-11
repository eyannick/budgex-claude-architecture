# user-directives.md
updated: 2026-05-11
managed_by: orchestrator_only
status: active

## Rôle du document

Ce fichier stocke les directives durables posées par l'utilisateur (Yannick Erdmann) sur la façon de travailler dans ce projet.

Il ne stocke pas :
- les décisions d'architecture (→ `decision-log.md`) ;
- les priorités actives (→ `active-focus.md`) ;
- la roadmap (→ `roadmap.md`) ;
- les standards techniques généraux (→ `engineering-standards.md`).

En cas de conflit entre ce fichier et un fichier technique, les directives utilisateur l'emportent sur les préférences d'exécution mais pas sur les contraintes de sécurité.

**Historique :** ce fichier a été recréé le 2026-05-11. L'ancien fichier contenait une copie corrompue de `decision-log.md`. Il est archivé dans `.claude/archive/user-directives-migrated-2026-05-11.md`.

---

## D-01 — Refonte UI close · EN VIGUEUR depuis 2026-04-24

**Directive :** la grande phase de refonte UI est terminée. Le mode de travail est désormais : maintenance · micro-polish · feature native uniquement.

**Interdit sans preuve de problème réel :**
- refontes de layout à grande échelle ;
- changements de direction artistique ;
- introduction de nouveaux design systems parallèles.

**Autorisé :**
- corrections d'écarts à la bible visuelle (sprint CSS) ;
- ajout de nouveaux composants dans le respect des primitives existantes ;
- micro-ajustements documentés et justifiés.

---

## D-02 — Famille fonctionnelle complète · obligatoire

**Directive :** toujours auditer et traiter toute la famille fonctionnelle d'une fonctionnalité, jamais une page isolée.

**Périmètre obligatoire par fonctionnalité :**
- vue `new` + vue `edit` + vue `show` + partials associés + CSS + JS éventuels

**Interdit :** corriger uniquement la vue `show` sans auditer `new` et `edit`, ou vice-versa.

---

## D-03 — Méthode 5 phases · obligatoire sur tout chantier

**Directive :** tout chantier de développement suit les 5 phases dans l'ordre.

1. Audit — lire et comprendre l'existant
2. Proposition — proposer l'approche et la valider avec l'utilisateur
3. Implémentation — coder
4. Tests — exécuter les tests
5. Vérification — confirmer le résultat attendu

**Interdit :** démarrer l'implémentation sans avoir complété l'audit et obtenu validation.

---

## D-04 — Convention noms de fichiers uploads / documents

**Directive :** tout fichier livrable ou document suit le format :

```
AAAAMMJJ_BUDGEX_OBJET_NOM-PRENOM.ext
```

Exemple : `20260511_BUDGEX_BIBLE-VISUELLE_ERDMANN-YANNICK.pdf`

---

## D-05 — Commentaires développeur sur tout code produit

**Directive :** tout code produit doit inclure des commentaires développeur expliquant le pourquoi des choix non évidents. Les commentaires sur le "quoi" sont inutiles ; les commentaires sur le "pourquoi" sont obligatoires dès qu'une décision pourrait surprendre.

---

## D-06 — Responsive-first · mobile et desktop simultanément

**Directive :** toute nouvelle page ou composant doit être conçu et testé pour mobile et desktop simultanément dès le départ. Le responsive n'est pas un ajout final.

Breakpoints de référence : 375px · 768px · 1024px · 1280px (voir bible visuelle §10).

---

## D-07 — Pattern boutons responsive

**Directive :** les boutons doivent suivre le pattern responsive Budgex défini dans `components.css`. Pas de bouton plein-largeur non prévu par le design system, pas de bouton fixe sur mobile.

---

## D-08 — Checklist de fin de session · obligatoire

**Directive :** toute session de travail se termine par cette checklist dans l'ordre :

1. `php bin/phpunit --no-coverage` → tests au vert (ou justification documentée si failure préexistante)
2. Mettre à jour `roadmap.md` si un sprint ou lot est terminé
3. Mettre à jour `MEMORY.md` (pointeurs mis à jour)
4. `git commit` + `git push` → push GitHub obligatoire

**Interdit :** fermer une session sans push si du code a été produit.

---

## D-09 — Pas de ML/NLP pour la catégorisation

**Directive :** la catégorisation des transactions reste basée sur des règles explicites uniquement (table `category_rule`, `CategoryAutoAssignService`). Aucun modèle de machine learning, aucun NLP, aucune API d'IA externe pour cette fonctionnalité.

---

## D-10 — Pas de prix live crypto / or en V1

**Directive :** les valorisations crypto et métaux précieux ne feront pas appel à des APIs de cours en temps réel avant que le socle produit (Phases A–E) soit stabilisé. Présence UI légère uniquement (badges "À venir").

---

## D-11 — Push GitHub en fin de session · obligatoire

**Directive :** chaque session de travail doit se terminer par un commit propre et un push sur la branche courante. Aucune session ne se ferme avec des modifications non committées sauf si explicitement demandé.

Format de commit : `type(scope): description courte`
Exemples : `feat(billing): ...` · `fix(auth): ...` · `style(ui): ...` · `docs(claude): ...`
