# SAÉ B - Déploiement et Sécurisation de Services Dolibarr

## Procédure d'utilisation

Ce dépôt contient l'ensemble des scripts nécessaires pour mettre en place automatiquement une infrastructure d'hébergement pour la solution **Dolibarr**. Ce projet a été réalisé dans le cadre d'une SAÉ visant à simuler un rôle d'hébergeur professionnel.

### Présentation du Projet

L'objectif est de permettre le déploiement rapide et isolé d'instances Dolibarr pour différents clients. L'infrastructure repose sur la virtualisation et la conteneurisation pour garantir la sécurité et la maintenabilité.

#### Architecture Technique
L'infrastructure se compose de trois machines virtuelles, elles-mêmes hébergées sur Dattier :
* **SAE4db (10.42.173.11)** : Serveur PostgreSQL hébergeant les bases de données clients
* **SAE4dolibarr (10.42.173.10)** : Serveur d'applications utilisant **Podman** pour isoler chaque client dans un conteneur dédié
* **SAE4save (10.42.173.12)** : Serveur de sauvegarde centralisant les dumps SQL via un démon **rsync**

### Fonctionnalités des Scripts

Les scripts sont numérotés pour respecter l'ordre logique de déploiement :

1.  **Initialisation (`1 - Initialisation des VMs.sh`)** : Crée, démarre et configure le réseau statique des trois machines virtuelles sur la machine de virtualisation `dattier`
2.  **Installation Base de Données (`2 - Installation de PostgreSQL.sh`)** : Déploie un conteneur PostgreSQL 15 avec un volume persistant pour les données
3.  **Reverse Proxy (`3 - Activation du Reverse Proxy : Traefik.sh`)** : Active et configure **Traefik** pour exposer les instances Dolibarr via un point d'entrée unique
4.  **Configuration Application (`4 - Configuration de Dolibarr.sh`)** : Prépare l'environnement Podman et lance une instance de référence
5.  **Gestion des Clients (`5 - Ajout Client.sh`)** : Automatise l'ajout d'un nouveau client en créant :
    * Un utilisateur et une base de données PostgreSQL dédiés.
    * Un conteneur Dolibarr isolé sur un port spécifique
6.  **Sauvegardes (`6 - Mise en place des sauvegardes.sh`)** : 
    * Configure un serveur rsync sécurisé sur la VM de sauvegarde
    * Met en place un script de dump automatique sur le serveur DB
    * Planifie une tâche **cron** quotidienne à 02:00

### Utilisation

#### Pré-requis

Pour exécuter les scripts il faut avoir une clé ssh fonctionnelle vers la machine dattier.

#### Exécuter les scripts

Pour faire une installation fonctionnelle vous pouvez exécuter les scripts dans cet ordre : 1, 2, 3, 4, 5, 6.

Ou tout simplement exécuter le script principal qui les exécute 1 à 1.

Pour configurer un nouvel utilisateur il vous faudra aussi suivre la [Procédure : Configuration Dolibarr](Procédure%20:%20Configuration%20Dolibarr)