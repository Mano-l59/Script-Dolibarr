#! /bin/bash

#Connection à dattier

ssh -T mano.lemaire.etu@dattier.iutinfo.fr << 'EOF'

#Création et configuration des VMs

VM_LIST=("SAE4db" "SAE4dolibarr" "SAE4save")

for VM in "${VM_LIST[@]}"; do
    if vmiut lister | grep -q "$VM"; then
        vmiut supprimer "$VM"
    fi
    vmiut creer "$VM"
    vmiut demarrer "$VM"
done

echo "Attente démarrage..."
sleep 20

cat > /tmp/config_IPs.sh << 'EOS'
#!/bin/bash

declare -A VM_IPS=(
    [SAE4db]=10.42.173.11
    [SAE4dolibarr]=10.42.173.10
    [SAE4save]=10.42.173.12
)

for VM in "${!VM_IPS[@]}"; do
    IP=${VM_IPS[$VM]}
    echo "Configuration réseau pour $VM -> $IP"

    cat > /tmp/vm_net.sh << EONET_SCRIPT
#!/bin/bash

cat > /etc/network/interfaces <<EONET
auto lo
iface lo inet loopback

auto enp0s3
iface enp0s3 inet static
    address $IP
    netmask 255.255.255.0
    gateway 10.42.0.1
EONET

systemctl restart networking
EONET_SCRIPT

    chmod +x /tmp/vm_net.sh

    export SCRIPT=/tmp/vm_net.sh
    vmiut exec "$VM"
done

EOS

chmod +x /tmp/config_IPs.sh

/tmp/config_IPs.sh

EOF
