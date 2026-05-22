# Recherche & Apprentissage

Ce document liste les concepts à maîtriser pour mener le projet à bien. Tu peux le voir comme un syllabus.

## Niveau 1 — Avant US-04

**Capteurs inertiels (IMU)**
- Accéléromètre vs gyroscope : ce que chacun mesure
- Bruit, biais, drift, et pourquoi les fusionner
- Ressource : https://www.youtube.com/watch?v=hQUkiC5o0JI

**Coroutines Kotlin**
- `suspend`, `launch`, `async/await`, `Flow`
- Scopes (`viewModelScope`, `lifecycleScope`)
- Ressource : https://kotlinlang.org/docs/coroutines-guide.html

**asyncio Python**
- Event loop, `async def`, `await`
- Différence threading / multiprocessing / asyncio
- Ressource : https://realpython.com/async-io-python/

**WebSocket**
- Différence avec HTTP, full-duplex, frames
- Ressource : https://ably.com/topic/websockets

## Niveau 2 — Avant US-07

**Calibration caméra**
- Paramètres intrinsèques : focal length, principal point, distortion
- Méthode de Zhang (chessboard pattern)
- Tutoriel OpenCV : https://docs.opencv.org/4.x/dc/dbb/tutorial_py_calibration.html

**Géométrie 3D**
- Repères / frames / transformations
- Quaternions (et pourquoi pas les angles d'Euler)
- Matrices de rotation et translation 4×4
- Ressource : http://wiki.ros.org/tf2

**SLAM — concepts**
- Différence localisation vs mapping vs SLAM
- Loop closure et pourquoi c'est dur
- SLAM monoculaire vs RGB-D vs LiDAR
- Cours de Cyrill Stachniss (gratuit, excellent) : https://www.youtube.com/@CyrillStachniss

## Niveau 3 — Avant US-08

**ROS2**
- Nodes, topics, services, actions
- QoS (Quality of Service)
- Launch files
- Tutoriels officiels : https://docs.ros.org/en/humble/Tutorials.html

**OpenCV**
- Lecture/conversion d'images
- Calibration et undistort
- Feature detection (ORB, SIFT) si tu veux comprendre comment SLAM voit le monde

**Three.js / react-three-fiber**
- BufferGeometry et performance
- Camera, scene, renderer
- Doc R3F : https://r3f.docs.pmnd.rs/

## Niveau 4 — Pour la suite (drones)

**Vol autonome**
- PX4 / ArduPilot (firmwares open source)
- MAVLink (protocole communication drone)
- Crazyflie (plateforme nano-drone recherche)

**Frontier exploration**
- Comment un robot décide où aller pour explorer un espace inconnu
- Papier de référence : "A Frontier-Based Approach for Autonomous Exploration" (Yamauchi 1997)

**Swarm coordination**
- Algorithmes décentralisés
- Multi-robot SLAM (fusion de cartes)

---

## Livres recommandés

- *Probabilistic Robotics* (Thrun, Burgard, Fox) — la bible du SLAM
- *Multiple View Geometry in Computer Vision* (Hartley & Zisserman) — pour la partie vision
- *Robotics: Modelling, Planning and Control* (Siciliano) — fondamentaux

Ce sont des références universitaires denses, pas besoin de tout lire. Utilise-les comme bibliothèque de référence quand tu bloques sur un concept.
