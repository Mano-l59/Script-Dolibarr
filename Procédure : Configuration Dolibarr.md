# Configuration Dolibarr

## Contexte

L'auto-installation de Dolibarr avec PostgreSQL et l'image Podman utilisée n'étant pas fonctionnelle, vous allez devoir configurer Dolibarr manuellement. Mais ne vous inquiétez pas : cette procédure est là pour ça.

## Pré-requis

Pour pouvoir vous connecter à votre solution Dolibarr à l'adresse `[nom].local:8080`,
vous devrez ajouter à votre fichier `/etc/hosts` la ligne suivante : `127.0.0.1 [nom].local:8080`.
Avec `[nom]` comme nom de client.

Lorsque vous vous connecterez pour la première fois à votre Dolibarr à l'adresse : `[nom].local:8080`
Vous devrez suivre les étapes et renseigner les bonnes informations, voici une suite de captures d'écran,
pour guider votre parcours :

## Captures de configuration (étapes)

### Étape 1
Choisissez la langue par défaut, puis continuez avec le bouton **Étape suivante**.
![Étape 1](Screens%20-%20Configuration%20Dolibarr/1.png)

### Étape 2
Appuyez sur le bouton **Démarrer**.
![Étape 2](Screens%20-%20Configuration%20Dolibarr/2.png)

### Étape 3
Renseignez les informations nécessaires pour vous connecter à votre base de données ;

- Nom de la base de données : `[nom]`
- Type du pilote : `pgsql`
- Identifiant : `[nom]`
- Mot de passe : `[mdp_donné_à_la_creation_du_client]`

Gardez bien les 2 cases décochées.
Et gardez les autres valeurs par défaut.
Vous pouvez ensuite cliquer sur **Étape suivante**.
![Étape 3](Screens%20-%20Configuration%20Dolibarr/3.png)

### Étape 4
Appuyez sur le bouton **Étape suivante**.
![Étape 4](Screens%20-%20Configuration%20Dolibarr/4.png)

### Étape 5
Après la validation de l'étape suivante, attendez quelques instants.
![Étape 5](Screens%20-%20Configuration%20Dolibarr/5.png)

### Étape 6
Vous pouvez ensuite appuyer sur le bouton **Étape suivante**.
![Étape 6](Screens%20-%20Configuration%20Dolibarr/6.png)

### Étape 7
Ensuite, renseignez les informations pour vous connecter en administrateur à Dolibarr (c'est la personne qui s'occupera de la configuration).
Attention, le mot de passe doit être supérieur ou égal à 8 caractères.
![Étape 7](Screens%20-%20Configuration%20Dolibarr/7.png)

### Étape 8
Félicitations, la configuration est terminée, vous pouvez désormais accéder à Dolibarr.
![Étape 8](Screens%20-%20Configuration%20Dolibarr/8.png)

### Étape 9
Connectez-vous à l'interface Dolibarr avec le compte administrateur créé à l'étape précédente.
![Étape 9](Screens%20-%20Configuration%20Dolibarr/9.png)

### Étape 10
Vérifiez que le tableau de bord s'affiche correctement : votre instance client est maintenant opérationnelle.
![Étape 10](Screens%20-%20Configuration%20Dolibarr/10.png)

