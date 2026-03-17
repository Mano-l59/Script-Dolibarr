#! /bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
	echo "Usage: $0 <nom_client>"
	exit 1
fi

if ! [[ "$CLIENT" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Nom client invalide (lettres, chiffres, underscore)"
    exit 1
fi

./"1 - Initialisation des VMs.sh"
./"2 - Installation de PostgreSQL.sh"
./"3 - Activation du Reverse Proxy : Traefik.sh"
./"4 - Configuration de Dolibarr.sh"
./"5 - Ajout Client.sh" "$CLIENT"
./"6 - Mise en place des sauvegardes.sh"