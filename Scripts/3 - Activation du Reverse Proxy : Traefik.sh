#! /bin/bash

#Connexion à dattier

ssh -T mano.lemaire.etu@dattier.iutinfo.fr << 'EOF'

cat > /tmp/activation_traefik.sh << 'EOS'
#!/bin/bash

echo "Installation de Podman..."
apt update
apt install -y podman

echo "Installation d'OpenSSL pour les certificats autosignés..."
apt install -y openssl

echo "Installation et activation du socket Podman..."

systemctl enable podman.socket
systemctl start podman.socket

echo "Suppression ancienne instance Traefik si existante..."
podman rm -f traefik 2>/dev/null

echo "Vérifie si le réseau traefik existe déjà et le créer si besoin..."
podman network exists traefik || podman network create traefik

echo "Préparation de la configuration TLS de Traefik..."
mkdir -p /etc/traefik/certs
mkdir -p /etc/traefik/dynamic

if [ ! -f /etc/traefik/certs/cert.pem ] || [ ! -f /etc/traefik/certs/key.pem ]; then
  echo "Génération d'un certificat autosigné..."
  openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days 365 \
    -keyout /etc/traefik/certs/key.pem \
    -out /etc/traefik/certs/cert.pem \
    -subj "/CN=dattier.iutinfo.fr" \
    -addext "subjectAltName=DNS:dattier.iutinfo.fr,DNS:*.dattier.iutinfo.fr,DNS:localhost,IP:127.0.0.1"
fi

cat > /etc/traefik/dynamic/tls.yml << EOTLS
tls:
  certificates:
    - certFile: /etc/traefik/certs/cert.pem
      keyFile: /etc/traefik/certs/key.pem
EOTLS

echo "Lancement de Traefik..."

podman run -d \
  --name traefik \
  --network traefik \
  -p 80:80 \
  -p 443:443 \
  -v /run/podman/podman.sock:/run/podman/podman.sock:ro \
  -v /etc/traefik/certs:/etc/traefik/certs:ro \
  -v /etc/traefik/dynamic:/etc/traefik/dynamic:ro \
  docker.io/library/traefik:v2.10 \
  --providers.docker=true \
  --providers.docker.endpoint=unix:///run/podman/podman.sock \
  --providers.docker.exposedbydefault=false \
  --providers.file.filename=/etc/traefik/dynamic/tls.yml \
  --providers.docker.network=traefik \
  --entrypoints.web.address=:80 \
  --entrypoints.websecure.address=:443

echo "Traefik lancé avec succès."
echo "Dashboard Traefik non exposé."
echo "Activation du reverse proxy terminée"

EOS

chmod +x /tmp/activation_traefik.sh
export SCRIPT=/tmp/activation_traefik.sh
vmiut exec SAE4dolibarr

EOF
