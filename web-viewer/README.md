# Web Viewer

App web qui se connecte au backend en WebSocket et affiche la 3D en temps réel.

## Stack

- React 18 + TypeScript
- Vite (dev server ultra rapide)
- Three.js + `@react-three/fiber` (intégration React de Three.js)
- `@react-three/drei` (helpers : OrbitControls, etc.)

## Setup

```bash
cd web-viewer
npm install
npm run dev
```

Ouvre http://localhost:5173. Le viewer se connecte automatiquement au backend sur `ws://localhost:8766` (configurable dans `src/config.ts`).

## Pourquoi react-three-fiber et pas Three.js direct ?

react-three-fiber permet d'écrire des scènes 3D de manière déclarative (comme du JSX) avec gestion automatique du cycle de vie. Beaucoup plus facile à maintenir que du Three.js impératif quand la scène se complexifie. Tu peux toujours descendre au Three.js bas niveau si besoin (`useThree`, refs).

## Architecture interne

```
src/
├── App.tsx              # Composant racine
├── config.ts            # URLs, ports
├── components/
│   ├── Scene.tsx        # Canvas Three.js
│   ├── PointCloud.tsx   # Affichage du nuage de points
│   ├── CameraGizmo.tsx  # Position courante du téléphone
│   └── ConnectionStatus.tsx
├── hooks/
│   ├── useWebSocket.ts  # Connexion WS avec reconnect auto
│   └── useSlamData.ts   # Parsing des messages map
└── types.ts             # Types TS des messages
```

## Build prod

```bash
npm run build
# génère dist/
```
