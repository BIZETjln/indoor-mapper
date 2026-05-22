# Architecture v1

## Vue d'ensemble

Le système se découpe en 3 processus indépendants communiquant via WebSocket sur le réseau WiFi local.

## Flux de données

### Téléphone → PC (canal "sensor")

Le téléphone envoie deux flux multiplexés sur la même connexion WebSocket :

**Flux IMU (30 Hz)**

```json
{
  "type": "imu",
  "timestamp_ns": 1234567890,
  "accel": [ax, ay, az],
  "gyro": [gx, gy, gz],
  "orientation_quat": [qw, qx, qy, qz]
}
```

**Flux Vidéo (10 Hz, JPEG compressé pour économiser la bande passante)**

```json
{
  "type": "frame",
  "timestamp_ns": 1234567890,
  "width": 640,
  "height": 480,
  "encoding": "jpeg",
  "data_base64": "..."
}
```

Le choix de JPEG plutôt que H.264 simplifie le décodage côté Python (juste OpenCV) au prix d'un débit plus élevé. Acceptable sur WiFi local.

### PC → Viewer (canal "map")

Le PC envoie deux types de messages au viewer :

**Nuage de points (1 Hz, incrémental)**

```json
{
  "type": "pointcloud_delta",
  "timestamp_ns": 1234567890,
  "points": [[x, y, z, r, g, b], ...]
}
```

**Pose courante (10 Hz)**

```json
{
  "type": "camera_pose",
  "timestamp_ns": 1234567890,
  "position": [x, y, z],
  "rotation_quat": [qw, qx, qy, qz]
}
```

## Ports

| Service | Port | Description |
|---|---|---|
| PC Backend WebSocket (sensor) | 8765 | Le téléphone se connecte ici |
| PC Backend WebSocket (viewer) | 8766 | Le viewer se connecte ici |
| Web Viewer dev server | 5173 | Vite par défaut |

## Latence cible

Pour que l'utilisateur ait l'impression de "scanner en direct", l'objectif est une latence end-to-end inférieure à 300 ms :

- Capture caméra : ~50 ms
- Encodage JPEG + WebSocket : ~30 ms
- SLAM frame processing : ~100 ms
- Sérialisation + WebSocket viewer : ~20 ms
- Rendering Three.js : ~16 ms (60 fps)

Si la latence explose, c'est presque toujours le SLAM qui est en cause (CPU/GPU).

## Système de coordonnées

On utilise la convention ROS REP-103 : **x avant, y gauche, z haut**, en mètres. Le téléphone publie déjà ARCore en cette convention via une matrice de conversion (voir `android-sensor-app/docs/coordinates.md` à créer plus tard).

## Décisions techniques notables

**Pourquoi WebSocket et pas gRPC ou MQTT ?** WebSocket est natif dans le navigateur (viewer), supporté partout, et largement suffisant en débit pour du réseau local. gRPC ajouterait une couche de complexité (proto, codegen) sans bénéfice clair à cette échelle.

**Pourquoi RTAB-Map et pas ORB-SLAM3 ?** RTAB-Map a un package ROS2 maintenu, supporte RGB-D et monoculaire, et a un viewer intégré pour debug. ORB-SLAM3 est plus performant en pur monoculaire mais l'intégration ROS2 est moins clean.

**Pourquoi Python et pas C++ ?** Pour la v1 on prototype. La perf de Python suffit avec RTAB-Map qui tourne en C++ derrière. Si on a besoin de speed, on basculera des composants en C++ plus tard.
