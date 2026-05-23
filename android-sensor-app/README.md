# Android Sensor App

App Android qui capture caméra + IMU et stream vers le PC backend en WebSocket.

## Stack

- Kotlin 2.0
- Jetpack Compose
- CameraX
- OkHttp (WebSocket client)
- kotlinx.serialization (JSON)
- kotlinx.coroutines

## Prérequis

- Android Studio Hedgehog (2023.1) ou plus récent
- JDK 17
- Téléphone Android 12+ (testé sur Xiaomi 15)
- Mode développeur + débogage USB activés

## Premier setup (à faire une fois)

Le repo ne contient pas les fichiers binaires du wrapper Gradle (`gradle-wrapper.jar`, `gradlew`, `gradlew.bat`). Tu dois les générer la première fois :

**Option A — depuis Android Studio (le plus simple)**

1. Ouvrir le dossier `android-sensor-app/` dans Android Studio
2. Au prompt "Gradle Wrapper not found", clique **"Setup wrapper"** ou laisse Android Studio le générer automatiquement
3. Sync Gradle

**Option B — en ligne de commande (si tu as Gradle installé localement)**

```bash
cd android-sensor-app
gradle wrapper --gradle-version 8.7
```

Cela génère `gradlew`, `gradlew.bat`, et `gradle/wrapper/gradle-wrapper.jar`. Ensuite tu peux **commit ces fichiers** (sauf `gradle-wrapper.jar` qui est dans le `.gitignore` par convention sur certains projets, mais pour un projet perso garde-le, c'est plus simple).

## Build & Run

```bash
./gradlew assembleDebug   # build l'APK
./gradlew installDebug    # build + installe sur le device branché
```

Ou simplement le bouton ▶ dans Android Studio.

## Configuration runtime

Au premier lancement, l'app demande :
- Permission caméra
- L'IP du PC backend (à entrer dans l'écran Settings, à implémenter en US-04)
- Le port (par défaut `8765`)

## Architecture interne cible (à implémenter au fil des US)

```
app/src/main/java/com/julien/indoormapper/
├── MainActivity.kt          # Point d'entrée (déjà créé)
├── ui/                      # Écrans Jetpack Compose (US-01, US-02)
├── sensors/                 # Wrappers IMU et caméra (US-01, US-02)
├── network/                 # Client WebSocket et sérialisation (US-04)
└── data/                    # Modèles de données partagés
```

## Notes pour Xiaomi 15

Le Xiaomi 15 n'a pas de capteur ToF, donc on s'appuie sur :
- La caméra principale Leica 50 MP
- L'IMU (gyroscope + accéléromètre)
- Plus tard : ARCore pour récupérer la pose 6-DoF estimée

Voir [docs/architecture/v1-overview.md](../docs/architecture/v1-overview.md) pour la justification.
