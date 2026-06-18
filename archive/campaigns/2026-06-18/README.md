# Archive — Campagnes UI/UX closes (2026-06-18)

## Date d'archivage
2026-06-18

## Raison
Audit `AUDIT-DOCTRINE-UI-UX-BUDGEX` (2026-06-18) : ces trois dossiers représentaient
~70 % du volume documentaire UI/UX (10 111 lignes sur ~14 600 auditées), sous forme de
journaux d'audit de campagnes déjà closes (anomalies trouvées → corrigées → commitées).
Ils n'étaient référencés dans aucune entrée de `source-of-truth-map.md` — ni source
primaire, ni source secondaire autorisée — et risquaient d'être relus par de futurs
prompts Claude/Codex comme s'ils étaient une doctrine active, alors que leur contenu
durable a déjà été remonté dans `decision-log.md` (ADR) et `references/budgex-visual-bible.md`.

## Campagnes archivées
- `visual-campaigns/` — `global-visual-regression.md`, `global-visual-corrections.md`, `evidence/`
- `code-campaigns/` — `accounts-module.md`, `admin-module.md`, `budget-analysis-module.md`,
  `dashboard-module.md`, `patrimoine-module.md`, `shared-app-css.md`, `transactions-templates-js.md`
- `css-campaigns/` — `bank-css.md`, `transactions-css.md`

## HEAD applicatif de clôture
`21de5ef3649e543736cfa732c46aa651ee48b1f0` (dépôt principal Budgex, branche `master`)

## Statut
Campagnes closes / contenu historique. Toutes les anomalies qu'elles documentaient ont été
corrigées et commitées dans le dépôt applicatif avant l'archivage. Aucune action en attente
dans ces fichiers n'a été perdue — les dettes encore ouvertes qu'ils mentionnaient sont reportées
dans les sources vivantes suivantes :
- migration icônes `arrow_forward` → `chevron_right` (Patrimoine + admin/user) → `references/budgex-visual-bible.md` §6.J + `memory/decision-log.md` ADR-015
- tokenisation couleurs Chart.js admin (lot `admin-chartjs-tokens`) → `memory/roadmap.md`
- audit pages détail/formulaires Patrimoine → `memory/roadmap.md`

## Sources vivantes de remplacement
- `memory/decision-log.md` (ADR actifs)
- `references/budgex-visual-bible.md`
- `references/budgex-flash-toast-doctrine.md`
- `memory/engineering-standards.md`
- `memory/user-directives.md`
- `checklists/frontend-checklist.md`, `checklists/qa-checklist.md`
- `memory/roadmap.md`, `memory/open-risks.md`
- `source-of-truth-map.md`

## Règle d'usage
Ces fichiers archivés peuvent servir à l'historique et à la traçabilité (comprendre pourquoi
une décision a été prise, retrouver le détail d'une anomalie corrigée), mais **ne doivent plus
être utilisés comme source primaire ou secondaire de doctrine UI/UX active** dans les futurs
prompts Claude/Codex. En cas de besoin de contexte historique, citer ce README et les fichiers
archivés explicitement comme tels — jamais comme règle en vigueur.
