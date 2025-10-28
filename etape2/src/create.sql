CREATE DATABASE IF NOT EXISTS my_app_db;
USE my_app_db;

CREATE TABLE IF NOT EXISTS counters (
    id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    count INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

INSERT INTO counters (id, count) VALUES (1, 0) ON DUPLICATE KEY UPDATE id=id;

-- Création de l'utilisateur pour l'application et définition d'un mot de passe simple.
-- Le '%' signifie que l'utilisateur peut se connecter depuis N'IMPORTE QUEL HÔTE (y compris le conteneur PHP).
CREATE USER 'app_user'@'%' IDENTIFIED BY 'app_password'; 

-- Donne tous les privilèges sur la base de données 'my_app_db' au nouvel utilisateur
GRANT ALL PRIVILEGES ON my_app_db.* TO 'app_user'@'%';

FLUSH PRIVILEGES;