#! /bin/bash

#Connection à dattier

ssh -T mano.lemaire.etu@dattier.iutinfo.fr << 'EOF'

cat > /tmp/creation_save.sh << 'EOS'
#!/bin/bash

echo "Installation et configuration du serveur rsync..."

apt update
apt install -y rsync

# Dossier de stockage
mkdir -p /backups
chown -R nobody:nogroup /backups
chmod 700 /backups

# Configuration rsync daemon
cat > /etc/rsyncd.conf << EOCONF
uid = nobody
gid = nogroup
use chroot = no
max connections = 1
log file = /var/log/rsync.log
pid file = /var/run/rsyncd.pid

[backups]
    path = /backups
    comment = Dossier de sauvegarde SAEdb
    read only = false
    list = yes
    hosts allow = 10.42.173.11
EOCONF

# Activer rsync en mode démon
echo "RSYNC_ENABLE=true" > /etc/default/rsync
systemctl enable rsync
systemctl restart rsync

echo "Serveur rsync prêt sur port 873"
EOS

chmod +x /tmp/creation_save.sh
export SCRIPT=/tmp/creation_save.sh
vmiut exec SAE4save

cat > /tmp/transfert_save.sh << 'EOS'
#!/bin/bash

echo "Installation outils nécessaires..."
apt update
apt install -y rsync

echo "Création dossier local de dump..."
mkdir -p /tmp/postgres_dump

cat > /usr/local/bin/backup.sh << 'EOBACK'
#!/bin/bash

DATE=$(date +%Y%m%d-%H%M)
BACKUP_DIR="/tmp/postgres_dump/$DATE"

mkdir -p "$BACKUP_DIR"

echo "Dump des bases PostgreSQL..."

DBS=$(podman exec postgres_doli psql -U dolibarr -t -c \
"SELECT datname FROM pg_database WHERE datistemplate = false AND datname NOT IN ('postgres');")

for DB in $DBS; do
    echo "Sauvegarde de $DB"
    podman exec postgres_doli pg_dump -U dolibarr "$DB" > "$BACKUP_DIR/$DB.sql"
done


echo "Envoi vers serveur de sauvegarde via rsync daemon..."

rsync -a "$BACKUP_DIR/" rsync://10.42.173.12/backups/$DATE/

# Deleting backups older then 30 days to save storage
rm -rf "$BACKUP_DIR"
find $BACKUP_DIR/ -mindepth 1 -maxdepth 1 -type d -mtime +1 -exec rm -rf {} +

echo "Sauvegarde terminée : $DATE"
EOBACK

echo "Installation et activation de cron..."
apt install -y cron

echo "Configuration de la sauvegarde planifiée..."

#cron for backup every 2AM
cat > /etc/cron.d/backup_sae << EOCRON
0 2 * * * root /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
EOCRON

chmod 644 /etc/cron.d/backup_sae

systemctl enable cron
systemctl restart cron

echo "Sauvegarde automatique programmée tous les jours à 2h."

chmod +x /usr/local/bin/backup.sh
EOS

chmod +x /tmp/transfert_save.sh
export SCRIPT=/tmp/transfert_save.sh
vmiut exec SAE4db

echo "Mise en place des sauvegardes terminée"

EOF