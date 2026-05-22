# Android Sensor App

App Android qui capture caméra + IMU et stream vers le PC backend en WebSocket.

## Stack

- Kotlin 2.0+
- Jetpack Compose
- CameraX
- OkHttp (WebSocket client)
- kotlinx.serialization (JSON)
- kotlinx.coroutines

## Prérequis

- Android Studio Hedgehog (2023.1) ou plus récent
- Téléphone Android 12+ (testé sur Xiaomi 15)
- Mode développeur + débogage USB activés

## Setup

1. Ouvrir le dossier `android-sensor-app/` dans Android Studio
2. Sync Gradle (auto au premier ouvrage)
3. Brancher le téléphone en USB
4. Run

## Configuration

Au premier lancement, l'app demande :
- Permission caméra
- L'IP du PC backend (par défaut tu peux mettre l'IP locale du PC, ex: `192.168.1.42`)
- Le port (par défaut `8765`)

## Architecture interne

```
ui/             # Écrans Jetpack Compose
sensors/        # Wrappers IMU et caméra
network/        # Client WebSocket et sérialisation
data/           # Modèles de données partagés
```

## Notes pour Xiaomi 15

Le Xiaomi 15 n'a pas de capteur ToF, donc on s'appuie sur :
- La caméra principale Leica 50 MP
- L'IMU (gyroscope + accéléromètre)
- Plus tard : ARCore pour récupérer la pose 6-DoF estimée

Voir [docs/architecture/v1-overview.md](../docs/architecture/v1-overview.md) pour la justification.
