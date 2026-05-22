# Indoor Mapper

> Cartographie 3D d'intérieur via téléphone (et plus tard flotte de drones)

## Vision

Construire un système qui scanne une pièce en 3D, génère un plan navigable, et qui à terme évoluera vers une flotte de drones autonomes cartographiant un bâtiment entier.

## Architecture v1

```
┌─────────────────┐    WebSocket    ┌──────────────────┐    WebSocket    ┌─────────────────┐
│  Téléphone      │ ───────────────>│   PC Backend     │ ───────────────>│  Web Viewer     │
│  (Capteur)      │   30 Hz IMU     │   (Cerveau SLAM) │   nuage de pts  │  (3D nav)       │
│                 │   10 Hz vidéo   │                  │                 │                 │
│  Android/Kotlin │                 │  Python + ROS2   │                 │  React + Three  │
└─────────────────┘                 └──────────────────┘                 └─────────────────┘
```

Le téléphone capture les images de la caméra et les données de l'IMU (gyroscope + accéléromètre), les envoie en temps réel au PC qui exécute l'algorithme SLAM (Simultaneous Localization And Mapping). Le PC produit un nuage de points 3D et la position courante de la caméra, et stream ces données au viewer web pour la visualisation interactive.

## Stack technique

| Composant | Tech | Justification |
|---|---|---|
| App Android | Kotlin + Jetpack Compose + CameraX + ARCore | Standard moderne Android, ARCore donne déjà la pose 6-DoF |
| Backend SLAM | Python 3.11 + ROS2 Humble + RTAB-Map | ROS2 = standard robotique, RTAB-Map = SLAM RGB-D mature |
| Visualisation | React + TypeScript + Three.js | Portable web, rendering 3D performant, tu connais React |
| Communication | WebSocket (WiFi local) | Latence faible, débit suffisant pour vidéo + IMU |

## Structure du repo

```
indoor-mapper/
├── android-sensor-app/    # App Kotlin qui capture et stream les données
├── pc-slam-backend/       # Python + ROS2, fait le SLAM et expose le nuage de points
├── web-viewer/            # React + Three.js, affiche la 3D
├── docs/                  # Architecture, user stories, recherches
└── .github/workflows/     # CI (lint, build, tests)
```

## Getting started

Voir le README de chaque sous-projet :
- [android-sensor-app/README.md](./android-sensor-app/README.md)
- [pc-slam-backend/README.md](./pc-slam-backend/README.md)
- [web-viewer/README.md](./web-viewer/README.md)

## Roadmap

- **v0.1** — Téléphone stream IMU + vidéo vers PC, PC affiche les données brutes
- **v0.2** — PC fait du SLAM avec RTAB-Map, produit un nuage de points
- **v0.3** — Web viewer affiche le nuage de points en temps réel
- **v0.4** — Navigation 3D fluide (orbit, pan, zoom) et export du nuage
- **v1.0** — Scan complet d'une pièce avec mesh maillé et plan 2D extrait
- **v2.0+** — Remplacement du téléphone par un drone FPV custom

## Licence

MIT
