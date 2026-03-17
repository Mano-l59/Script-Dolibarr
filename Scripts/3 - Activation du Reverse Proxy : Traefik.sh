#! /bin/bash

#Connection à dattier

ssh -T mano.lemaire.etu@dattier.iutinfo.fr << 'EOF'

cat > /tmp/activation_traefik.sh << 'EOS'
#!/bin/bash

echo "Installation de Podman..."
apt update
apt install -y podman

echo "Installation et activation du socket Podman..."

systemctl enable podman.socket
systemctl start podman.socket

echo "Suppression ancienne instance Traefik si existante..."
podman rm -f traefik 2>/dev/null

echo "Vérifie si le réseau traefik existe déjà et le créer si besoin..."
podman network exists traefik || podman network create traefik

echo "Lancement de Traefik..."

podman run -d \
  --name traefik \
  --network traefik \
  -p 80:80 \
  -p 443:443 \
  -v /run/podman/podman.sock:/run/podman/podman.sock:ro \
  docker.io/library/traefik:v2.10 \
  --providers.docker=true \
  --providers.docker.endpoint=unix:///run/podman/podman.sock \
  --providers.docker.exposedbydefault=false \
  --providers.docker.network=traefik \
  --entrypoints.web.address=:80

echo "Traefik lancé avec succès."
echo "Dashboard Traefik non exposé."
echo "Activation du reverse proxy terminée"

EOS

chmod +x /tmp/activation_traefik.sh
export SCRIPT=/tmp/activation_traefik.sh
vmiut exec SAE4dolibarr

EOF
