# SAÉ B - Déploiement et Sécurisation de Services Dolibarr

Ce dépôt contient l'ensemble des scripts nécessaires pour mettre en place une infrastructure d'hébergement automatisée pour la solution ERP/CRM **Dolibarr**. Ce projet a été réalisé dans le cadre d'une SAÉ visant à simuler un rôle d'hébergeur professionnel.

## 📋 Présentation du Projet

L'objectif est de permettre le déploiement rapide et isolé d'instances Dolibarr pour différents clients. L'infrastructure repose sur la virtualisation et la conteneurisation pour garantir la sécurité et la maintenabilité.

### Architecture Technique
L'infrastructure se compose de trois machines virtuelles principales :
* **SAE4db (10.42.173.11)** : Serveur PostgreSQL hébergeant les bases de données clients
* **SAE4dolibarr (10.42.173.10)** : Serveur d'applications utilisant **Podman** pour isoler chaque client dans un conteneur dédié
* **SAE4save (10.42.173.12)** : Serveur de sauvegarde centralisant les dumps SQL via un démon **rsync**

## 🚀 Fonctionnalités des Scripts

Les scripts sont numérotés pour respecter l'ordre logique de déploiement :

1.  **Initialisation (`1 - Initialisation des VMs`)** : Crée, démarre et configure le réseau statique des trois machines virtuelles sur le serveur `dattier`
2.  **Installation Base de Données (`2 - Installation de PostgreSQL`)** : Déploie un conteneur PostgreSQL 15 avec un volume persistant pour les données
3.  **Configuration Application (`3 - Configuration de Dolibarr`)** : Prépare l'environnement Podman et lance une instance de référence
4.  **Gestion des Clients (`4 - Ajout Client`)** : Automatise l'ajout d'un nouveau client en créant :
    * Un utilisateur et une base de données PostgreSQL dédiés.
    * Un conteneur Dolibarr isolé sur un port spécifique
5.  **Sauvegardes (`5 - Mise en place des sauvegardes`)** : 
    * Configure un serveur rsync sécurisé sur la VM de sauvegarde
    * Met en place un script de dump automatique sur le serveur DB
    * Planifie une tâche **cron** quotidienne à 02:00

## 🛠️ Utilisation


### Déploiement de l'infrastructure
Exécutez les scripts dans l'ordre pour monter l'environnement complet :
```bash
./1-Initialisation_VMs.sh
./2-Installation_PostgreSQL.sh
./3-Configuration_Dolibarr.sh
./5-Mise_en_place_sauvegardes.sh

Mano Lemaire
Mark Zavadskyi