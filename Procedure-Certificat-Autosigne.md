# Procédure - Certificat autosigné (HTTPS)

## Contexte

Lorsque vous accédez à votre solution Dolibarr, le certificat HTTPS est auto-signé. Le navigateur affiche donc un avertissement de sécurité.

Dans le cadre de la SAÉ, cet avertissement est normal et ne bloque pas l’utilisation de l’application.

## Passer l'avertissement

1. Ouvrez l’URL HTTPS de votre client Dolibarr.
2. Sur la page d’alerte, cliquez sur **Avancé** (ou **Détails** selon le navigateur).
3. Cliquez sur **Accepter le risque et continuer**.
4. Si l’option est proposée, enregistrez l’exception pour éviter de refaire la validation à chaque accès.

## Vérification

Après validation, la page Dolibarr doit s’ouvrir normalement en HTTPS.