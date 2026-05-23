import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// Configuration Vite : https://vitejs.dev/config/
// Le plugin React active le Fast Refresh (HMR) et la compilation JSX.
export default defineConfig({
  plugins: [react()],
  server: {
    // Port de dev par défaut. Aligné avec ce qui est doc dans architecture/v1-overview.md.
    port: 5173,
    // Ouvre le navigateur au démarrage de `npm run dev`.
    open: true,
  },
});
