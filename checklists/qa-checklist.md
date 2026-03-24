# QA Checklist — budgex-qa

## Bloquant
- Q1 tests exécutés sans échec, selon le périmètre pertinent de la tâche
- Q2 `doctrine:schema:validate` OK si impact Doctrine
- Q3 `lint:yaml` OK si impact config
- Q4 vérification syntaxique Twig OK si impact Twig
- Q5 vérification du container OK si profil `deep` ou impact config sensible
- Q6 pas de route sensible exposée sans protection
- Q7 pas de sortie de scope dans les fichiers modifiés

## Non bloquant
- Q8 baseline cohérente avec `memory/project-context.md`
- Q9 preuve de tests ou de validation cohérente avec le risque du changement
- Q10 nouveaux comportements couverts si risque notable
- Q11 pas de `dd()/dump()/var_dump()` dans le diff
- Q12 pas de `TODO/FIXME` introduit sans justification
- Q13 vérification statique exécutée si disponible, sinon absence explicitement signalée