/**
 * Configuration centrale du viewer.
 * En production tu pourras override via des variables d'environnement Vite (VITE_*).
 */

export const config = {
  // URL du WebSocket backend (port 8766 = canal viewer).
  // En local : ws://localhost:8766
  // Si tu accèdes au viewer depuis un autre appareil sur le réseau, remplace par l'IP du PC.
  backendUrl: import.meta.env.VITE_BACKEND_URL ?? "ws://localhost:8766",

  // Délai entre deux tentatives de reconnexion automatique en cas de coupure (ms).
  reconnectDelayMs: 2000,
} as const;
