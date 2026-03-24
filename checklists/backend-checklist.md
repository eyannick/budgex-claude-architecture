# Backend Checklist — budgex-backend

## Bloquant
- B1 route sensible protégée (auth, rôle, permission ou garde appropriée)
- B2 validation serveur présente sur toute entrée utilisateur ou système pertinente
- B3 aucune requête SQL brute injustifiée ou non sécurisée
- B4 intégrité métier et données préservées dans le flux modifié
- B5 cohérence Doctrine / entités / mapping si impact backend concerné
- B6 CSRF présent sur toute mutation concernée
- B7 aucune sortie de `SCOPE_IN`
- B8 tests exécutés si le changement modifie un comportement backend significatif ou si le profil l’exige

## Non bloquant
- B9 logique métier non poussée dans le contrôleur si une meilleure localisation évidente existe
- B10 comportement nouveau ou bugfix couvert par test si pertinent
- B11 risques legacy, dette ou limites explicitement signalés
- B12 rollback ou stratégie de reprise explicitée si profil `deep`
- B13 handoff vers `budgex-database` ou `budgex-qa` signalé si nécessaire