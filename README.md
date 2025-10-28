# Docker TP3
Ce dépôt contient le Travail Pratique \#3 (TP \#3) sur la conteneurisation de services web en utilisant **Docker** (mode `docker run`) et **Docker Compose**. L'objectif est d'implémenter et de faire communiquer trois conteneurs (HTTP, SCRIPT PHP, et DATA MariaDB) via un réseau Docker personnalisé, en passant d'une configuration en commandes unitaires à une orchestration par Compose.

### Structure du Projet

Le répertoire est organisé en sous-dossiers correspondant aux étapes du TP :

```
docker-tp3/
├── etape1/              # NGINX + PHP-FPM (Test phpinfo())
│   ├── config/          # Contient default.conf (config NGINX)
│   ├── src/             # Contient index.php
│   └── launch.sh        # Script d'exécution de l'étape 1
├── etape2/              # NGINX + PHP-FPM + MariaDB (Test CRUD)
│   ├── config/          # Contient default.conf (config NGINX)
│   ├── src/             # Contient index.php, test.php, create.sql
│   ├── php/             # Contient le Dockerfile pour ajouter l'extension mysqli
│   └── launch.sh        # Script d'exécution de l'étape 2 (avec docker build et docker run)
└── etape3/              # Conversion en Docker Compose
    ├── config/          # (Liens symboliques vers Etape 2/config)
    ├── src/             # (Liens symboliques vers Etape 2/src)
    ├── php/             # (Liens symboliques vers Etape 2/php)
    └── docker-compose.yml # Fichier d'orchestration Docker Compose
```

-----

## Objectifs Atteints

Le TP démontre la maîtrise des concepts suivants :

### Étape 1 : Configuration de Base

  * **Mise en place de deux conteneurs** : `HTTP` (NGINX) et `SCRIPT` (PHP-FPM).
  * Utilisation de **volumes *bind mount*** pour monter le code source (`index.php`) et le fichier de configuration NGINX (`default.conf`).
  * Configuration d'un **réseau commun** (`my-php-net`) pour la communication inter-conteneurs.
  * Validation de la communication PHP-FPM via l'affichage de `phpinfo()`.

  **Lien à consulter :** http://localhost:8080/

### Étape 2 : Ajout de la Base de Données (CRUD)

  * **Ajout du conteneur `DATA` (MariaDB)**.
  * **Initialisation de la base de données** (`my_app_db` et table `counters`) via le mécanisme `/docker-entrypoint-initdb.d` et le fichier `create.sql`.
  * **Personnalisation de l'image PHP** via `Dockerfile` pour inclure l'extension `mysqli`.
  * **Résolution des problèmes d'authentification** MariaDB en créant un utilisateur dédié (`app_user`) pour les connexions distantes (depuis le conteneur PHP).
  * Validation des requêtes **CRUD** (écriture/lecture) via la page `test.php` avec incrémentation du compteur.

**Liens à consulter :**

* Vérification NGINX/PHP : http://localhost:8080

* Validation CRUD/MariaDB : http://localhost:8080/test.php (Le compteur doit s'incrémenter à chaque rafraîchissement.)

### Étape 3 : Orchestration via Docker Compose 

  * **Conversion de l'intégralité de la configuration de l'Étape 2** en un seul fichier `docker-compose.yml`.
  * Utilisation de la commande `docker compose up -d` pour orchestrer les trois services et leurs dépendances (`depends_on`).

  **Liens à consulter :**

Validation CRUD/MariaDB (Identique à l'Étape 2): http://localhost:8080
                                                 http://localhost:8080/test.php

-----

## Remarques Techniques (Environnement)

  * **Environnement d'exécution :** Les scripts et commandes Docker ont été testés et optimisés pour un environnement **Windows** utilisant **Git Bash (MINGW64)**, notamment en corrigeant les problèmes de *bind mount* grâce à la syntaxe **`-v "$(pwd -W)/..."`** pour garantir la portabilité des chemins hôtes.
  * **PHP Version :** L'environnement utilise l'image **`php:8.2-fpm`** (ou l'équivalent utilisé lors des tests initiaux).


