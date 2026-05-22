# PC SLAM Backend

Backend Python qui reçoit les données du téléphone, exécute le SLAM, et stream le nuage de points au viewer.

## Stack

- Python 3.11+
- `websockets` (serveur WS)
- `opencv-python` (décodage JPEG, calibration)
- `numpy`
- ROS2 Humble + RTAB-Map (à partir d'US-07)

## Setup (sans ROS2, pour les premières stories)

```bash
cd pc-slam-backend
python -m venv .venv
source .venv/bin/activate  # ou .venv\Scripts\activate sous Windows
pip install -r requirements.txt
```

## Lancer le serveur sensor

```bash
python src/sensor_server.py
```

Le serveur écoute sur `ws://0.0.0.0:8765`. Trouve ton IP locale (`ip addr` sous Linux, `ipconfig` sous Windows) et configure-la dans l'app Android.

## Setup ROS2 (pour US-07 et suivantes)

Suivre la doc officielle Humble : https://docs.ros.org/en/humble/Installation.html

Sous Windows, utilise WSL2 + Ubuntu 22.04. Sous macOS, utilise Docker.

## Architecture interne

```
src/
├── sensor_server.py    # Serveur WebSocket qui reçoit du téléphone
├── viewer_server.py    # Serveur WebSocket qui pousse au viewer
├── slam/               # Wrappers ROS2 et RTAB-Map (US-08+)
└── utils/              # Décodage JPEG, math, conversions
config/
├── camera_intrinsics.yaml  # Calibration caméra Xiaomi 15 (à générer)
tests/
```

## Calibration caméra

Avant US-08, tu dois calibrer la caméra du Xiaomi 15. C'est un script séparé `scripts/calibrate_camera.py` qui prend ~20 photos d'un échiquier imprimé sous différents angles et produit `config/camera_intrinsics.yaml`. Procédure détaillée dans `docs/calibration-guide.md` (à écrire dans US-08).
