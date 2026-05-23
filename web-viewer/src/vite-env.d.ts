/// <reference types="vite/client" />

// Étend ImportMeta pour typer les variables d'environnement custom (VITE_*).
interface ImportMetaEnv {
  readonly VITE_BACKEND_URL?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
