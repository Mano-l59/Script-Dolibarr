# Procédure - Certificat autosigné (HTTPS)

## Contexte

Lorsque vous accéderez à votre solution Dolibarr, le certificat étant auto-signé, vous aurez un avertissement vous demandant si vous souhaitez continuer. Vous pouvez évidemment accepter et continuer. Cependant, si vous accédez souvent à ce lien, il peut devenir pénible de constamment valider et revalider. Cette procédure intervient donc pour enlever cet affichage.

## Utilisation

Exécutez ces commandes sur votre machine physique :

```bash
sudo apt-get install -y mkcert
mkcert -install
mkcert -cert-file traefik.crt -key-file traefik.key "*.dattier.iutinfo.fr" "dattier.iutinfo.fr" "localhost" "127.0.0.1"
```

Accédez à votre client Dolibarr en HTTPS sans avertissement certificat.
