/**
 * Types des messages échangés sur le canal "viewer" (PC → Web).
 * Doit rester synchronisé avec docs/architecture/v1-overview.md.
 */

export interface PointCloudDelta {
  type: "pointcloud_delta";
  timestamp_ns: number;
  // Chaque point : [x, y, z, r, g, b] (positions en mètres, couleurs 0-255).
  points: number[][];
}

export interface CameraPose {
  type: "camera_pose";
  timestamp_ns: number;
  position: [number, number, number];
  rotation_quat: [number, number, number, number]; // [qw, qx, qy, qz]
}

// Union discriminée sur le champ "type" : TypeScript saura affiner selon le contenu.
export type ViewerMessage = PointCloudDelta | CameraPose;
