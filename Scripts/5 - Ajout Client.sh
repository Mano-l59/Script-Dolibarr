#! /bin/bash

#Création de la variable client et vérification qu'il y a un argument

CLIENT=$1

#Si aucun argument n'est fourni, arrête le script.
if [ -z "$CLIENT" ]; then
    echo "Usage: $0 <nom_client>"
    exit 1
fi

#Si le nom client ne respecte pas [a-zA-Z0-9_], arrête le script.
if ! [[ "$CLIENT" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Nom client invalide (lettres, chiffres, underscore)"
    exit 1
fi

MACHINE_NAME_RAW=$(hostname -s 2>/dev/null || hostname)
MACHINE_NAME=$(echo "$MACHINE_NAME_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g')

if [ -z "$MACHINE_NAME" ]; then
    MACHINE_NAME="machine"
fi

#Génération d'un mdp aléatoire
MDP=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)

echo "Déploiement du client $CLIENT..."
echo "Nom machine détecté : $MACHINE_NAME"
echo "Mot de passe DB : $MDP"

#Connexion à dattier

ssh -T mano.lemaire.etu@dattier.iutinfo.fr "CLIENT='$CLIENT' MDP='$MDP' MACHINE_NAME='$MACHINE_NAME' bash -s" << 'EOF'

#Ajout de la base du client

cat > /tmp/ajout_client_psql.sh << EOS
#!/bin/bash

echo "Ajout de la base de $CLIENT..."
podman exec -i postgres_doli psql -U dolibarr << SQL
CREATE USER $CLIENT WITH PASSWORD '$MDP';
CREATE DATABASE $CLIENT OWNER $CLIENT;
\connect $CLIENT
GRANT USAGE, CREATE ON SCHEMA public TO $CLIENT;
SQL

EOS

cat > /tmp/ajout_client_dolibarr.sh << EOS
#!/bin/bash

echo "Lancement du conteneur Dolibarr de $CLIENT..."

podman network exists traefik || podman network create traefik

podman rm -f dolibarr_$CLIENT 2>/dev/null

podman run -d \
    --name dolibarr_$CLIENT \
    --network traefik \
    -e DOLI_DB_TYPE=pgsql \
    -e DOLI_DB_HOST=10.42.173.11 \
    -e DOLI_DB_PORT=5432 \
    -e DOLI_DB_HOST_PORT=5432 \
    -e DOLI_DB_NAME=$CLIENT \
    -e DOLI_DB_USER=$CLIENT \
    -e DOLI_DB_PASSWORD=$MDP \
    -e DOLI_URL_ROOT=http://$CLIENT.$MACHINE_NAME.iutinfo.fr \
    -e DOLI_INSTALL_AUTO=0 \
    -e DOLI_PROD=0 \
    --label traefik.enable=true \
    --label "traefik.http.routers.$CLIENT.rule=Host(\"$CLIENT.$MACHINE_NAME.iutinfo.fr\")" \
    --label "traefik.http.routers.$CLIENT.entrypoints=web" \
    --label "traefik.http.services.$CLIENT.loadbalancer.server.port=80" \
    docker.io/tuxgasy/dolibarr:latest

sleep 5
podman exec dolibarr_$CLIENT sh -lc 'rm -f /var/www/html/conf/conf.php /var/www/documents/install.lock'

echo "Conteneur lancé : dolibarr_\$CLIENT"
podman ps

echo "Déploiement du conteneur Dolibarr client terminé"
EOS

chmod +x /tmp/ajout_client_psql.sh
chmod +x /tmp/ajout_client_dolibarr.sh

export SCRIPT=/tmp/ajout_client_psql.sh
vmiut exec SAE4db

export SCRIPT=/tmp/ajout_client_dolibarr.sh
vmiut exec SAE4dolibarr

echo "Ajout du client $CLIENT terminé"
echo "URL client : http://$CLIENT.$MACHINE_NAME.iutinfo.fr"

EOF