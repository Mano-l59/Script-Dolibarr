#! /bin/bash

#Connection à dattier

ssh -T mano.lemaire.etu@dattier.iutinfo.fr << 'EOF'

#vmiut exec sur SAE4db

cat > /tmp/install_postgres.sh << 'EOS'
#!/bin/bash

echo "Installation de Podman..."
apt update
apt install -y podman

echo "Création du volume PostgreSQL..."
podman volume exists pgdata || podman volume create pgdata

echo "Suppression ancien conteneur si présent..."
podman rm -f postgres_doli 2>/dev/null

echo "Suppression ancien volume si présent..."
podman volume rm pgdata 2>/dev/null

echo "Lancement du conteneur PostgreSQL..."
podman run -d \
    --name postgres_doli \
    -e POSTGRES_USER=dolibarr \
    -e POSTGRES_PASSWORD=dolibarr \
    -e POSTGRES_DB=dolibarr \
    -v pgdata:/var/lib/postgresql/data \
    -p 5432:5432 \
    docker.io/library/postgres:15

echo "Restriction d'accès PostgreSQL au strict nécessaire (SAE4dolibarr uniquement)..."
DEBIAN_FRONTEND=noninteractive apt install -y iptables netfilter-persistent iptables-persistent
iptables -C INPUT -p tcp --dport 5432 -s 127.0.0.1 -j ACCEPT 2>/dev/null || iptables -I INPUT -p tcp --dport 5432 -s 127.0.0.1 -j ACCEPT
iptables -C INPUT -p tcp --dport 5432 -s 10.42.173.10 -j ACCEPT 2>/dev/null || iptables -I INPUT -p tcp --dport 5432 -s 10.42.173.10 -j ACCEPT
iptables -C INPUT -p tcp --dport 5432 -j DROP 2>/dev/null || iptables -A INPUT -p tcp --dport 5432 -j DROP
netfilter-persistent save
systemctl enable netfilter-persistent
systemctl restart netfilter-persistent

echo "Conteneur PostgreSQL lancé"
podman ps

echo "Installation PostgreSQL terminée"
EOS

chmod +x /tmp/install_postgres.sh

export SCRIPT=/tmp/install_postgres.sh
vmiut exec SAE4db

EOF
