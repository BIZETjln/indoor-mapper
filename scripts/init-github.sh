#!/usr/bin/env bash
# scripts/init-github.sh
#
# Crée les milestones, labels et issues GitHub à partir des user stories.
# À exécuter UNE SEULE FOIS après avoir poussé le repo initial.
#
# Prérequis :
#   - gh CLI installé et authentifié (`gh auth login`)
#   - Exécuté depuis la racine du repo (où se trouve le dossier .github)
#
# Usage :
#   bash scripts/init-github.sh

set -euo pipefail

echo "==> Vérification de gh CLI..."
if ! command -v gh &> /dev/null; then
    echo "Erreur : gh CLI non installé. Voir https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Erreur : non authentifié. Lance 'gh auth login' d'abord."
    exit 1
fi

# ---------------------------------------------------------------------------
# LABELS
# ---------------------------------------------------------------------------
# On crée des labels custom pour catégoriser les issues.
# `gh label create` rate (exit code != 0) si le label existe déjà, d'où le `|| true`.

echo "==> Création des labels..."

# Labels par difficulté
gh label create "easy" --color "00ff00" --description "Difficulté facile" 2>/dev/null || true
gh label create "medium" --color "ffff00" --description "Difficulté moyenne" 2>/dev/null || true
gh label create "hard" --color "ff0000" --description "Difficulté élevée" 2>/dev/null || true

# Labels par composant
gh label create "android" --color "3ddc84" --description "App Android" 2>/dev/null || true
gh label create "backend" --color "306998" --description "PC backend Python" 2>/dev/null || true
gh label create "viewer" --color "61dafb" --description "Web viewer React" 2>/dev/null || true
gh label create "docs" --color "0075ca" --description "Documentation" 2>/dev/null || true

# Labels par epic
gh label create "epic-communication" --color "8B4513" --description "EPIC 1: pipeline de comm" 2>/dev/null || true
gh label create "epic-visualization" --color "8B4513" --description "EPIC 2: visualisation basique" 2>/dev/null || true
gh label create "epic-slam" --color "8B4513" --description "EPIC 3: SLAM" 2>/dev/null || true
gh label create "epic-quality" --color "8B4513" --description "EPIC 4: qualité du scan" 2>/dev/null || true
gh label create "epic-polish" --color "8B4513" --description "EPIC 5: polish" 2>/dev/null || true

# Label générique user story
gh label create "user-story" --color "a2eeef" --description "User story" 2>/dev/null || true

# ---------------------------------------------------------------------------
# MILESTONES
# ---------------------------------------------------------------------------
# Les milestones permettent de grouper les issues par version cible.
# gh ne permet pas (encore) la création de milestone directement -> on passe par l'API.

echo "==> Création des milestones..."

create_milestone() {
    local title="$1"
    local description="$2"
    # On vérifie d'abord s'il existe déjà.
    local existing
    existing=$(gh api "repos/{owner}/{repo}/milestones?state=all" --jq ".[] | select(.title == \"$title\") | .number" 2>/dev/null || echo "")
    if [ -n "$existing" ]; then
        echo "  Milestone '$title' existe déjà (#$existing), skip."
        return
    fi
    gh api "repos/{owner}/{repo}/milestones" \
        -f title="$title" \
        -f description="$description" \
        -f state="open" \
        --silent
    echo "  Milestone '$title' créé."
}

create_milestone "v0.1 - Pipeline de communication" "Le téléphone stream IMU + vidéo vers le PC, qui log les données."
create_milestone "v0.2 - Visualisation basique" "Web viewer affiche un cube qui réagit aux mouvements du téléphone."
create_milestone "v0.3 - SLAM fonctionnel" "RTAB-Map intégré, nuage de points produit et affiché."
create_milestone "v1.0 - Scan exploitable" "Export du nuage, plan 2D extrait, doc utilisateur."

# Récupère les numéros des milestones pour les assigner aux issues.
milestone_v01=$(gh api "repos/{owner}/{repo}/milestones?state=open" --jq '.[] | select(.title | startswith("v0.1")) | .number')
milestone_v02=$(gh api "repos/{owner}/{repo}/milestones?state=open" --jq '.[] | select(.title | startswith("v0.2")) | .number')
milestone_v03=$(gh api "repos/{owner}/{repo}/milestones?state=open" --jq '.[] | select(.title | startswith("v0.3")) | .number')
milestone_v10=$(gh api "repos/{owner}/{repo}/milestones?state=open" --jq '.[] | select(.title | startswith("v1.0")) | .number')

# ---------------------------------------------------------------------------
# ISSUES (user stories)
# ---------------------------------------------------------------------------

echo "==> Création des issues..."

# Fonction helper pour créer une issue avec les bonnes options.
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local milestone="$4"
    gh issue create \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        --milestone "$milestone" > /dev/null
    echo "  Issue créée : $title"
}

# --- EPIC 1 : Pipeline de communication ---

create_issue "[US-01] Capturer l'IMU sur Android" \
"## Objectif
Afficher en temps réel les valeurs de l'accéléromètre et du gyroscope sur l'écran du téléphone.

## Critères d'acceptation
- [ ] L'app affiche \`ax, ay, az\` mis à jour à au moins 30 Hz
- [ ] L'app affiche \`gx, gy, gz\` mis à jour à au moins 30 Hz
- [ ] Les valeurs sont stables au repos (proches de 0 sauf gravité sur Z)

## Outils
Android Studio, Kotlin, Jetpack Compose, \`android.hardware.SensorManager\`

## À apprendre
- Cycle de vie d'une app Android
- Jetpack Compose : \`State\`, \`remember\`, \`collectAsState\`
- Différence accéléromètre vs gyroscope
- Fréquences de sampling Android" \
"user-story,android,easy,epic-communication" \
"$milestone_v01"

create_issue "[US-02] Capturer la caméra sur Android" \
"## Objectif
Afficher le flux caméra dans l'app et capturer chaque frame en mémoire.

## Critères d'acceptation
- [ ] Aperçu caméra plein écran
- [ ] Possibilité de récupérer une frame brute (\`ImageProxy\`) à 10 Hz minimum
- [ ] Les permissions caméra sont demandées proprement

## Outils
CameraX

## À apprendre
- Permissions Android runtime
- Architecture CameraX : Preview, ImageAnalysis, UseCase
- Formats d'image YUV vs RGB" \
"user-story,android,easy,epic-communication" \
"$milestone_v01"

create_issue "[US-03] Serveur WebSocket sur PC qui log les données" \
"## Objectif
Un script Python qui ouvre un WebSocket sur le port 8765 et affiche tout ce qu'il reçoit.

## Critères d'acceptation
- [ ] Le serveur démarre avec \`python sensor_server.py\`
- [ ] Log 'Client connected from <IP>' à chaque connexion
- [ ] Parse chaque message JSON et l'affiche lisiblement
- [ ] Ne crash pas si un client se déconnecte brutalement

## Outils
Python 3.11, \`websockets\`, \`asyncio\`, \`json\`

Note : le squelette est déjà fourni dans \`pc-slam-backend/src/sensor_server.py\`." \
"user-story,backend,easy,epic-communication" \
"$milestone_v01"

create_issue "[US-04] App Android envoie les données au PC via WebSocket" \
"## Objectif
Connecter l'app au serveur Python et streamer IMU + frames JPEG.

## Critères d'acceptation
- [ ] Configuration de l'IP du PC dans un écran réglages (pas hardcodé)
- [ ] L'app indique visuellement 'Connecté' / 'Déconnecté'
- [ ] L'IMU est streamé à 30 Hz
- [ ] Les frames JPEG (qualité 70) sont streamées à 10 Hz
- [ ] Reconnexion auto toutes les 2 s si la connexion casse

## Outils
\`okhttp3\` (WebSocket client), \`kotlinx.serialization\`, \`kotlinx.coroutines\`

## À apprendre
- Coroutines Kotlin (Flow, launch, async)
- Encodage JPEG depuis frame YUV (\`YuvImage\`)
- Gestion état réseau côté UI" \
"user-story,android,medium,epic-communication" \
"$milestone_v01"

# --- EPIC 2 : Visualisation basique ---

create_issue "[US-05] Web viewer affiche un cube qui tourne selon l'IMU" \
"## Objectif
Valider toute la chaîne (téléphone → PC → web) avec une démo simple.

## Critères d'acceptation
- [ ] Le web viewer se connecte au PC sur le port 8766
- [ ] Un cube 3D s'affiche au centre
- [ ] Le cube tourne en miroir des rotations physiques du téléphone (latence < 200 ms)
- [ ] L'app web tourne sur \`npm run dev\`

## Outils
React 18, Vite, TypeScript, Three.js, \`@react-three/fiber\`, \`@react-three/drei\`

## À apprendre
- Setup Vite + React + TS
- react-three-fiber : Canvas, useFrame, useThree
- Quaternions vs angles d'Euler
- WebSocket dans le navigateur" \
"user-story,viewer,backend,medium,epic-visualization" \
"$milestone_v02"

create_issue "[US-06] Navigation 3D dans la scène" \
"## Objectif
Pouvoir tourner autour du cube avec la souris.

## Critères d'acceptation
- [ ] Click gauche + drag = orbite
- [ ] Click droit + drag = pan
- [ ] Molette = zoom
- [ ] Reset view avec touche R

## Outils
\`OrbitControls\` de \`@react-three/drei\`" \
"user-story,viewer,easy,epic-visualization" \
"$milestone_v02"

# --- EPIC 3 : SLAM ---

create_issue "[US-07] Installer ROS2 Humble et lancer RTAB-Map" \
"## Objectif
Avoir une stack ROS2 fonctionnelle qui peut faire du SLAM sur un dataset de test.

## Critères d'acceptation
- [ ] \`ros2 --version\` retourne Humble
- [ ] \`ros2 launch rtabmap_examples rgbd_dataset.launch.py\` tourne sur un dataset public
- [ ] Le viewer RTAB-Map affiche un nuage de points

## Outils
Ubuntu 22.04 (ou WSL2), ROS2 Humble, RTAB-Map, dataset TUM RGB-D

⚠️ Peut prendre 1-2 jours juste pour l'install. Documente les galères dans \`docs/research/ros2-install-notes.md\`." \
"user-story,backend,medium,epic-slam" \
"$milestone_v03"

create_issue "[US-08] Bridge WebSocket ↔ ROS2" \
"## Objectif
Transformer les données reçues du téléphone en messages ROS2 que RTAB-Map peut consommer.

## Critères d'acceptation
- [ ] Un node ROS2 Python lit le WebSocket sensor
- [ ] Publie sur \`/camera/image_raw\` et \`/imu/data\`
- [ ] RTAB-Map en mode monoculaire+IMU produit un nuage de points

## Outils
\`rclpy\`, \`cv_bridge\`, \`sensor_msgs\`, \`geometry_msgs\`

## À apprendre
- Architecture pub/sub ROS2
- Calibration caméra (intrinsèques) — étape critique
- Format \`sensor_msgs/Image\`
- Synchronisation temporelle IMU/frames" \
"user-story,backend,hard,epic-slam" \
"$milestone_v03"

create_issue "[US-09] Stream du nuage de points vers le viewer" \
"## Objectif
Ce que produit RTAB-Map s'affiche dans le web viewer.

## Critères d'acceptation
- [ ] Un node ROS2 lit \`/map_cloud\` et le push sur le WebSocket viewer
- [ ] Le viewer affiche le nuage de points en temps réel
- [ ] Performance acceptable jusqu'à 100k points

## Outils
\`sensor_msgs.point_cloud2\`, Three.js \`Points\` + \`BufferGeometry\`" \
"user-story,backend,viewer,medium,epic-slam" \
"$milestone_v03"

# --- EPIC 4 : Qualité du scan ---

create_issue "[US-10] Affichage de la pose courante de la caméra" \
"## Objectif
Voir où 'est' le téléphone dans la scène 3D, sous forme d'un gizmo.

## Critères d'acceptation
- [ ] Un objet 3D (cône/frustum) représente le téléphone
- [ ] Se déplace en temps réel selon la pose SLAM
- [ ] Trail (ligne) montre le parcours effectué" \
"user-story,viewer,easy,epic-quality" \
"$milestone_v03"

create_issue "[US-11] Sauvegarder et recharger un scan" \
"## Objectif
Exporter le nuage de points en .ply et pouvoir le réimporter.

## Critères d'acceptation
- [ ] Bouton 'Save' télécharge un fichier .ply
- [ ] Bouton 'Load' ouvre un picker et affiche le fichier
- [ ] Le fichier peut être ouvert dans MeshLab ou CloudCompare

## Outils
\`PLYLoader\` et \`PLYExporter\` de Three.js" \
"user-story,viewer,easy,epic-quality" \
"$milestone_v10"

create_issue "[US-12] Extraction d'un plan 2D du sol" \
"## Objectif
À partir du nuage 3D, générer un plan vu de dessus comme un plan d'architecte.

## Critères d'acceptation
- [ ] Bouton 'Generate floor plan' lance le calcul
- [ ] Détection automatique du sol (RANSAC)
- [ ] Projection des points entre 50 cm et 2 m → image 2D
- [ ] Export en PNG

## À apprendre
- RANSAC pour détection de plan
- Filtrage de nuage de points (Open3D ou PCL)" \
"user-story,backend,viewer,hard,epic-quality" \
"$milestone_v10"

# --- EPIC 5 : Polish ---

create_issue "[US-13] Tests unitaires et CI" \
"## Objectif
Une CI propre qui lint et build chaque sous-projet.

## Critères d'acceptation
- [ ] Le workflow .github/workflows/ci.yml passe au vert
- [ ] Au moins un test unitaire par composant majeur
- [ ] Lint actif sur les 3 sous-projets" \
"user-story,docs,easy,epic-polish" \
"$milestone_v10"

create_issue "[US-14] Documentation utilisateur" \
"## Objectif
Un guide 'comment scanner une pièce' avec captures d'écran.

## Critères d'acceptation
- [ ] Tutoriel pas à pas dans docs/user-guide.md
- [ ] Captures d'écran ou vidéo courte
- [ ] FAQ des problèmes courants" \
"user-story,docs,easy,epic-polish" \
"$milestone_v10"

echo ""
echo "==> ✅ Init GitHub terminé !"
echo "    14 issues créées, 4 milestones, 12 labels."
echo "    Va sur https://github.com/{owner}/{repo}/issues pour voir le résultat."
