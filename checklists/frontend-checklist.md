# Frontend Checklist — budgex-frontend

## Bloquant
- F1 vérification syntaxique Twig exécutée si impact Twig
- F2 pas de logique métier ni de calcul applicatif dans Twig
- F3 CSRF présent sur formulaires d'action concernés
- F4 patterns UI établis préservés
- F5 `aria-label` présent sur boutons icon-only concernés
- F6 aucune variable Twig attendue mais non fournie
- F7 dépendance backend signalée si la vue nécessite des données, états ou comportements non disponibles

## Non bloquant
- F8 responsive cohérent mobile / desktop
- F9 contraste lisible et non manifestement insuffisant
- F10 pas de CSS inline sans justification
- F11 structure sémantique propre