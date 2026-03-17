# Configuration Dolibarr

Pour pouvoir vous connectez à votre solution dolibarr à l'adresse "[nom].local:8080",
vous devrez ajouter à votre fichier /etc/hosts la ligne suivante : "127.0.0.1 [nom].local:8080".
Avec [nom] votre nom de client.

Lorsque vous vous connecterez pour la première fois à votre dolibarr à l'addresse : "[nom].local:8080"
Vous devrez suivres les étapes et mettre les bonnes informations, voici une suite de captures d'écrans,
pour guider votre parcours :

## Captures de configuration (étapes)

### Étape 1
Choisissez la langue par défaut continuez avec le bouton **Étape suivante**.
![Étape 1](Screens%20-%20Configuration%20Dolibarr/1.png)

### Étape 2
Appuyez sur le bouton **Démarrer**.
![Étape 2](Screens%20-%20Configuration%20Dolibarr/2.png)

### Étape 3
Renseignez les informations nécessaires pour vous connecter à votre base de données ;

- Nom de la base de données : [nom]
- Type du pilote : pgsql
- Identifiant : [nom]
- Mot de passe : [mdp_donné_à_la_creation_du_client]

Gardez bien les 2 cases déchochés.
Et gardez les autres valeurs par défaut.
Vous pouvez ensuite cliquez sur **Étape suivante**.
![Étape 3](Screens%20-%20Configuration%20Dolibarr/3.png)

### Étape 4
Appuyez sur le bouton **Étape suivante**.
![Étape 4](Screens%20-%20Configuration%20Dolibarr/4.png)

### Étape 5
Après la validation de l'étape suivante attendez quelques temps.
![Étape 5](Screens%20-%20Configuration%20Dolibarr/5.png)

### Étape 6
Vous pouvez ensuite appuyez sur le bouton **Étape suivante**.
![Étape 6](Screens%20-%20Configuration%20Dolibarr/6.png)

### Étape 7
Ensuite renseignez les informations pour se connecter en administrateur à dolibarr (c'est la personne qui s'occupera des configurations).
Attention le mot de passe doit être supérieur ou égal à 8 caractères.
![Étape 7](Screens%20-%20Configuration%20Dolibarr/7.png)

### Étape 8
Félicitations, la configuration est terminéee, vous pouvez désormais accéder à dolibarr.
![Étape 8](Screens%20-%20Configuration%20Dolibarr/8.png)

### Étape 9
Connectez-vous à l'interface Dolibarr avec le compte administrateur créé à l'étape précédente.
![Étape 9](Screens%20-%20Configuration%20Dolibarr/9.png)

### Étape 10
Vérifiez que le tableau de bord s'affiche correctement : votre instance client est maintenant opérationnelle.
![Étape 10](Screens%20-%20Configuration%20Dolibarr/10.png)

