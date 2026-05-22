"""
Serveur WebSocket qui reçoit les données capteurs depuis le téléphone.

Lancement :
    python src/sensor_server.py

Le serveur écoute sur 0.0.0.0:8765 et log chaque message reçu.
Format des messages attendu : voir docs/architecture/v1-overview.md
"""

# asyncio est la lib standard Python pour la programmation asynchrone (coroutines).
import asyncio
import json
import logging

# La lib `websockets` fournit un serveur WebSocket simple basé sur asyncio.
import websockets
from websockets.server import WebSocketServerProtocol

# Configuration du logging : on veut voir l'heure, le niveau, et le message.
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger("sensor_server")

# Adresse d'écoute : 0.0.0.0 = toutes les interfaces réseau (sinon le téléphone ne peut pas se connecter).
HOST = "0.0.0.0"
PORT = 8765


async def handle_client(websocket: WebSocketServerProtocol) -> None:
    """Gère une connexion entrante (un téléphone) : reçoit les messages et les log."""
    # `websocket.remote_address` donne l'IP et le port du client.
    client_ip = websocket.remote_address[0]
    log.info("Client connected from %s", client_ip)

    # Compteurs pour avoir une idée du débit reçu.
    imu_count = 0
    frame_count = 0

    try:
        # `async for` itère sur les messages au fur et à mesure qu'ils arrivent.
        async for raw_message in websocket:
            try:
                # On parse le JSON ; si malformé, on log et on continue.
                msg = json.loads(raw_message)
            except json.JSONDecodeError:
                log.warning("Received malformed JSON: %s", raw_message[:80])
                continue

            msg_type = msg.get("type")

            if msg_type == "imu":
                imu_count += 1
                # On affiche 1 message IMU sur 30 pour éviter de spammer la console.
                if imu_count % 30 == 0:
                    log.info(
                        "IMU #%d | accel=%s gyro=%s",
                        imu_count,
                        msg.get("accel"),
                        msg.get("gyro"),
                    )
            elif msg_type == "frame":
                frame_count += 1
                # Pour les frames, on log juste la taille pour ne pas dump le base64.
                size_kb = len(msg.get("data_base64", "")) * 3 / 4 / 1024
                log.info(
                    "Frame #%d | %dx%d | %.1f kB",
                    frame_count,
                    msg.get("width", 0),
                    msg.get("height", 0),
                    size_kb,
                )
            else:
                log.warning("Unknown message type: %s", msg_type)

    except websockets.ConnectionClosed:
        # Cas normal quand le téléphone se déconnecte.
        log.info("Client %s disconnected (received %d IMU, %d frames)",
                 client_ip, imu_count, frame_count)


async def main() -> None:
    """Démarre le serveur WebSocket et tourne jusqu'à Ctrl+C."""
    log.info("Starting sensor server on ws://%s:%d", HOST, PORT)
    # `serve` retourne un context manager qui ferme proprement le serveur à la sortie.
    async with websockets.serve(handle_client, HOST, PORT):
        # `Future()` sans résultat = on attend indéfiniment.
        await asyncio.Future()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        log.info("Server stopped by user")
