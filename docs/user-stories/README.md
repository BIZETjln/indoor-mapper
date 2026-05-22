# User Stories

Chaque story suit le format :
- **Objectif** : ce que tu dois pouvoir faire à la fin
- **Critères d'acceptation** : comment tu sais que c'est fini
- **Outils** : technos à utiliser
- **À apprendre** : concepts que tu dois maîtriser avant ou pendant
- **Difficulté** : 🟢 facile / 🟡 moyen / 🔴 hard

---

## EPIC 1 — Pipeline de communication

### US-01 : Capturer l'IMU sur Android 🟢

**Objectif** : afficher en temps réel les valeurs de l'accéléromètre et du gyroscope sur l'écran du téléphone.

**Critères d'acceptation** :
- L'app affiche `ax, ay, az` mis à jour à au moins 30 Hz
- L'app affiche `gx, gy, gz` mis à jour à au moins 30 Hz
- Les valeurs sont stables au repos (proches de 0 sauf gravité sur Z)

**Outils** : Android Studio, Kotlin, Jetpack Compose, `android.hardware.SensorManager`

**À apprendre** :
- Le cycle de vie d'une app Android (Activity, lifecycle)
- Comment Jetpack Compose gère l'état (`State`, `remember`, `collectAsState`)
- Différence accéléromètre vs gyroscope vs IMU fusionné
- Les fréquences de sampling Android (`SENSOR_DELAY_GAME`, `SENSOR_DELAY_FASTEST`)

---

### US-02 : Capturer la caméra sur Android 🟢

**Objectif** : afficher le flux caméra dans l'app et capturer chaque frame en mémoire.

**Critères d'acceptation** :
- Aperçu caméra plein écran
- Possibilité de récupérer une frame brute (`ImageProxy`) à 10 Hz minimum
- Les permissions caméra sont demandées proprement

**Outils** : CameraX (`androidx.camera:camera-core`, `camera-camera2`, `camera-lifecycle`, `camera-view`)

**À apprendre** :
- Le système de permissions Android (runtime permissions)
- Architecture CameraX : `Preview`, `ImageAnalysis`, `UseCase`
- Formats d'image YUV vs RGB et conversions

---

### US-03 : Serveur WebSocket sur PC qui log les données reçues 🟢

**Objectif** : un script Python qui ouvre un WebSocket sur le port 8765 et affiche tout ce qu'il reçoit.

**Critères d'acceptation** :
- Le serveur démarre avec `python sensor_server.py`
- Quand un client se connecte, log "Client connected from <IP>"
- Chaque message reçu est parsé en JSON et affiché de manière lisible
- Le serveur ne crash pas si un client se déconnecte brutalement

**Outils** : Python 3.11, `websockets` (lib), `asyncio`, `json`

**À apprendre** :
- Le modèle async/await en Python (`asyncio`)
- Le protocole WebSocket (handshake HTTP, frames)
- Gestion d'exceptions dans un serveur long-running

---

### US-04 : L'app Android envoie les données au PC via WebSocket 🟡

**Objectif** : connecter l'app au serveur Python et streamer IMU + frames JPEG.

**Critères d'acceptation** :
- Configuration de l'IP du PC dans un écran réglages (pas hardcodé)
- L'app indique visuellement "Connecté" / "Déconnecté"
- L'IMU est streamé à 30 Hz
- Les frames JPEG (qualité 70) sont streamées à 10 Hz
- Si la connexion casse, l'app tente une reconnexion auto toutes les 2 s

**Outils** : `okhttp3` (WebSocket client Kotlin), `kotlinx.serialization` (JSON), `kotlinx.coroutines`

**À apprendre** :
- Les coroutines Kotlin (`launch`, `async`, `Flow`)
- Encodage JPEG depuis une frame YUV (utiliser `YuvImage` natif Android)
- Gestion d'un état réseau côté UI (`MutableStateFlow`)

---

## EPIC 2 — Visualisation basique

### US-05 : Web viewer affiche un cube qui tourne selon l'IMU 🟡

**Objectif** : valider toute la chaîne (téléphone → PC → web) avec une démo simple.

**Critères d'acceptation** :
- Le web viewer se connecte au PC sur le port 8766
- Un cube 3D s'affiche au centre
- Le cube tourne en miroir des rotations physiques du téléphone (latence < 200 ms)
- L'app web tourne sur `npm run dev`

**Outils** : React 18, Vite, TypeScript, Three.js, `@react-three/fiber`, `@react-three/drei`

**À apprendre** :
- Setup d'un projet Vite + React + TS
- `react-three-fiber` : `Canvas`, `useFrame`, `useThree`
- Quaternions vs angles d'Euler (et pourquoi on préfère les quaternions)
- WebSocket dans le navigateur (API native `WebSocket`)

---

### US-06 : Navigation 3D dans la scène 🟢

**Objectif** : pouvoir tourner autour du cube avec la souris.

**Critères d'acceptation** :
- Click gauche + drag = orbite autour du centre
- Click droit + drag = pan
- Molette = zoom
- Reset view avec touche `R`

**Outils** : `OrbitControls` de `@react-three/drei`

**À apprendre** :
- Les contrôles de caméra dans Three.js
- Comment Three.js gère les inputs

---

## EPIC 3 — SLAM

### US-07 : Installer ROS2 Humble et lancer RTAB-Map 🟡

**Objectif** : avoir une stack ROS2 fonctionnelle qui peut faire du SLAM sur un dataset de test.

**Critères d'acceptation** :
- `ros2 --version` retourne Humble
- `ros2 launch rtabmap_examples rgbd_dataset.launch.py` tourne sur un dataset public
- Le viewer RTAB-Map affiche un nuage de points

**Outils** : Ubuntu 22.04 (ou WSL2), ROS2 Humble, RTAB-Map, dataset TUM RGB-D

**À apprendre** :
- Concept ROS2 : nodes, topics, messages, launch files
- Lecture d'un bag file (`ros2 bag play`)
- Différence SLAM monoculaire vs RGB-D vs stéréo

⚠️ Cette story peut prendre 1-2 jours juste pour l'install. Documente tes galères dans `docs/research/ros2-install-notes.md` au fur et à mesure.

---

### US-08 : Bridge WebSocket ↔ ROS2 🔴

**Objectif** : transformer les données reçues du téléphone en messages ROS2 que RTAB-Map peut consommer.

**Critères d'acceptation** :
- Un node ROS2 Python lit le WebSocket sensor
- Il publie sur les topics `/camera/image_raw` (`sensor_msgs/Image`) et `/imu/data` (`sensor_msgs/Imu`)
- RTAB-Map en mode monoculaire+IMU reçoit les données et publie un nuage de points sur `/map_cloud`

**Outils** : `rclpy`, `cv_bridge`, `sensor_msgs`, `geometry_msgs`

**À apprendre** :
- Architecture pub/sub de ROS2
- Calibration caméra : intrinsèques (focal length, principal point, distortion). Tu vas devoir calibrer la caméra du Xiaomi 15 avec un échiquier (chessboard) et OpenCV. C'est l'étape la plus chiante mais critique.
- Format des `sensor_msgs/Image` (encoding, stride, header)
- Synchronisation temporelle entre IMU et frames

---

### US-09 : Stream du nuage de points vers le viewer 🟡

**Objectif** : ce que produit RTAB-Map s'affiche dans le web viewer.

**Critères d'acceptation** :
- Un second node ROS2 lit `/map_cloud`
- Il convertit les points en JSON et les push sur le WebSocket viewer (port 8766)
- Le viewer affiche le nuage de points en temps réel
- Performance acceptable jusqu'à 100k points

**Outils** : `sensor_msgs.point_cloud2`, `Points` ou `InstancedMesh` dans Three.js

**À apprendre** :
- Format PointCloud2 (lecture binaire)
- Rendering de points massifs avec Three.js (`BufferGeometry`, `Points`)
- Stratégies de décimation (envoyer 1 point sur N pour réduire la bande passante)

---

## EPIC 4 — Qualité du scan

### US-10 : Affichage de la pose courante de la caméra 🟢

**Objectif** : voir où "est" le téléphone dans la scène 3D, sous forme d'un petit gizmo.

**Critères d'acceptation** :
- Un objet 3D (cône ou frustum) représente le téléphone
- Il se déplace en temps réel selon la pose SLAM
- Un trail (ligne) montre le parcours effectué

---

### US-11 : Sauvegarder et recharger un scan 🟢

**Objectif** : exporter le nuage de points en `.ply` et pouvoir le réimporter.

**Critères d'acceptation** :
- Bouton "Save" dans le viewer → télécharge un fichier `.ply`
- Bouton "Load" → ouvre un picker et affiche le fichier
- Le fichier peut être ouvert dans MeshLab ou CloudCompare

**Outils** : `PLYLoader` et `PLYExporter` de Three.js

---

### US-12 : Extraction d'un plan 2D du sol 🔴

**Objectif** : à partir du nuage 3D, générer un plan vu de dessus comme un plan d'architecte.

**Critères d'acceptation** :
- Un bouton "Generate floor plan" lance le calcul
- Détection automatique du sol (plan horizontal le plus bas avec assez de points)
- Projection des points entre 50 cm et 2 m au-dessus du sol → image 2D
- Export en PNG

**À apprendre** :
- RANSAC pour détection de plan
- Filtrage de nuage de points (PCL ou Open3D)

---

## EPIC 5 — Polish

### US-13 : Tests unitaires et CI

**Objectif** : un workflow GitHub Actions qui lint et build chaque sous-projet.

### US-14 : Documentation utilisateur

**Objectif** : un guide "comment scanner une pièce" avec captures d'écran.

---

## Ordre de réalisation suggéré

```
US-01 → US-02 → US-03 → US-04 → US-05 → US-06
   (chaîne de comm validée avec démo cube)
                  ↓
US-07 → US-08 → US-09 → US-10
   (SLAM réel, nuage de points)
                  ↓
US-11 → US-12
   (export, plan 2D)
                  ↓
US-13 → US-14
   (qualité)
```

Compte ~1 week-end par story 🟢, 2-3 week-ends par story 🟡, et 1-2 semaines par story 🔴 en mode alternance/études.
