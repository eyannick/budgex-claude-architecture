# Database Checklist — budgex-database

## Bloquant
- D1 intégrité référentielle préservée (FK, contraintes déclarées)
- D2 migration destructive accompagnée d'un rollback explicite
- D3 `doctrine:schema:validate` OK après modification
- D4 aucune migration modifiant des données existantes sans stratégie explicite
- D5 contraintes métier critiques portées par le schéma si possible
- D6 aucune sortie de scope

## Non bloquant
- D7 index présents sur colonnes filtrées ou triées fréquemment
- D8 requêtes complexes lisibles, commentées si non triviales
- D9 pas de N+1 évident introduit
- D10 stratégie de déploiement DB précisée si risque en production
- D11 dette de schéma signalée si détectée
- D12 cohérence Doctrine entity / migration vérifiée
- D13 données sensibles identifiées si champ nouveau
