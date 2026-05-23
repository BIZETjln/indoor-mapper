import { Canvas } from "@react-three/fiber";
import { OrbitControls } from "@react-three/drei";

/**
 * Composant racine de l'app.
 *
 * Affiche une scène 3D minimale : un cube orange + contrôles d'orbite (souris).
 * Sert de point de départ pour US-05 (cube qui tourne selon l'IMU) et US-06 (nav).
 *
 * Pour le tester :
 *   npm run dev
 * puis ouvrir http://localhost:5173
 */
export default function App() {
  return (
    <div style={{ width: "100vw", height: "100vh" }}>
      <Canvas camera={{ position: [3, 3, 3], fov: 50 }}>
        {/* Lumière ambiante = éclaire uniformément, pour qu'on voie quelque chose. */}
        <ambientLight intensity={0.5} />
        {/* Lumière directionnelle = simule un soleil, donne du relief. */}
        <directionalLight position={[5, 5, 5]} intensity={1} />

        {/* Le cube de référence : 1m de côté, orange. */}
        <mesh>
          <boxGeometry args={[1, 1, 1]} />
          <meshStandardMaterial color="orange" />
        </mesh>

        {/* Une grille au sol pour avoir un repère spatial. */}
        <gridHelper args={[10, 10]} />

        {/* OrbitControls active : drag = rotation, scroll = zoom, drag droit = pan. */}
        <OrbitControls />
      </Canvas>
    </div>
  );
}
