#!/bin/bash

# --- 1. Nettoyage de l'environnement ---
echo "--- Nettoyage des anciens containers/réseau (si existent) ---"
docker stop http script 2> /dev/null
docker rm http script 2> /dev/null
docker network rm my-php-net 2> /dev/null

# --- 2. Création du réseau commun ---
echo "--- Création du réseau 'my-php-net' ---"
docker network create my-php-net

# --- 3. Lancement du container SCRIPT (PHP-FPM) ---
echo "--- Lancement du container SCRIPT (PHP-FPM) ---"
docker container run -d \
    --name script \
    --network my-php-net \
    -v "$(pwd -W)/src:/app" \
    php:8.2-fpm

# --- 4. Lancement du container HTTP (NGINX) ---
echo "--- Lancement du container HTTP (NGINX) ---"
docker container run -d \
    --name http \
    --network my-php-net \
    -p 8080:8080 \
    -v "$(pwd -W)/src:/app" \
    -v "$(pwd -W)/config/default.conf:/etc/nginx/conf.d/default.conf" \
    nginx:latest

echo "--- Setup de l'Étape 1 terminé. ---"
echo "Vérifiez le résultat sur http://localhost:8080/"

# Optionnel: Afficher l'état
echo ""
docker ps