# Contributing

Conventions pour bosser proprement sur ce repo.

## Workflow Git

```
main           ← branche stable, toujours buildable
└── feat/us-01-imu-capture     ← une branche par user story
└── fix/websocket-reconnect    ← une branche par bug
```

1. Crée une branche depuis `main` au format `feat/us-XX-description-courte` ou `fix/description`
2. Commit régulièrement (voir conventions ci-dessous)
3. Ouvre une PR vers `main` quand prêt
4. Merge en squash pour garder un historique linéaire propre

## Convention de commits (Conventional Commits)

```
<type>(<scope>): <description courte>

[corps optionnel]

[footer optionnel : Closes #issue]
```

**Types :**
- `feat` : nouvelle fonctionnalité
- `fix` : correction de bug
- `docs` : doc seulement
- `refactor` : refacto sans changement comportement
- `test` : tests
- `chore` : config, build, dépendances

**Scopes :**
- `android` : app Android
- `backend` : PC Python
- `viewer` : web viewer
- `docs` : documentation
- `ci` : CI/CD

**Exemples :**

```
feat(android): add IMU sensor capture

Adds SensorManager wrapper that exposes accel and gyro as Flow.
Sampled at SENSOR_DELAY_GAME (~50Hz).

Closes #1
```

```
fix(viewer): reconnect WebSocket on disconnect

Closes #12
```

## Code style

- **Android** : suivre les conventions Kotlin officielles. Lint via Android Studio.
- **Backend** : PEP 8. Utiliser `black` pour formatage auto.
- **Viewer** : ESLint config en place (`npm run lint`).

## Tests

Pour l'instant les tests sont optionnels (projet perso, prio sur l'apprentissage). Mais si tu touches au protocole WebSocket ou au format des messages, ajoute au moins un test pour figer le contrat.
