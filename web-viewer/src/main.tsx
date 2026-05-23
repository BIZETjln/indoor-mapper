import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

// Point d'entrée : monte le composant App dans le div#root de index.html.
// StrictMode active des warnings utiles en dev (double-render de certains hooks pour détecter les effets impurs).
ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
