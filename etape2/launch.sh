#!/bin/bash

# --- 1. Nettoyage de l'environnement ---
echo "--- Nettoyage des anciens containers/réseau/images ---"
docker stop http script data 2>/dev/null
docker rm http script data 2>/dev/null
docker network rm my-php-net 2>/dev/null
# Suppression de l'ancienne image pour forcer la reconstruction avec mysqli
docker rmi -f tp3-php-mysqli 2>/dev/null

# --- Suppression des dossiers hôtes indésirables (Sécurité) ---
# Ceci supprime les dossiers étranges qui auraient pu être créés par des bind mounts échoués.
if [ -d "./src/create.sql;C" ]; then
    rm -r "./src/create.sql;C"
fi

# --- 2. Création du réseau commun ---
echo "--- Création du réseau 'my-php-net' ---"
docker network create my-php-net

# --- 3. Construction de l'image PHP avec mysqli ---
echo "--- Construction de l'image PHP avec mysqli (tp3-php-mysqli) ---"
# Assurez-vous que le Dockerfile existe dans le dossier ./php
docker build -t tp3-php-mysqli ./php

# --- 4. Lancement du container DATA (MariaDB) ---
echo "--- Lancement du container DATA (MariaDB) ---"
# Utilisation de $(pwd -W) pour le chemin HÔTE, prouvé fonctionnel.
docker container run -d \
    --name data \
    --network my-php-net \
    -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
    -e MARIADB_DATABASE=my_app_db \
    -v "$(pwd -W)/src/create.sql:/docker-entrypoint-initdb.d/create.sql" \
    mariadb:latest

# --- 5. Lancement du container SCRIPT (PHP-FPM) ---
echo "--- Lancement du container SCRIPT (PHP-FPM) ---"
# Utilisation de $(pwd -W) pour le chemin HÔTE.
docker container run -d \
    --name script \
    --network my-php-net \
    -v "$(pwd -W)/src:/app" \
    tp3-php-mysqli

# --- 6. Lancement du container HTTP (NGINX) ---
echo "--- Lancement du container HTTP (NGINX) ---"
# Utilisation de $(pwd -W) pour les chemins HÔTE.
docker container run -d \
    --name http \
    --network my-php-net \
    -p 8080:8080 \
    -v "$(pwd -W)/src:/app" \
    -v "$(pwd -W)/config/default.conf:/etc/nginx/conf.d/default.conf" \
    nginx:latest

echo "--- Setup de l'Étape 2 terminé. ---"
echo "Test : http://localhost:8080/test.php. Le compteur doit s'incrémenter à chaque rafraîchissement."