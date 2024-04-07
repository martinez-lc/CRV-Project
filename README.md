# Guide de Déploiement Kubernetes pour Redis, Node.js, React, Prometheus et Grafana

![Infraestructure](https://github.com/martinez-lc/CRV-Project/blob/main/Infrastructure.png)

Ce document décrit comment déployer une infrastructure Kubernetes incluant Redis, Node.js, React, Prometheus et Grafana.

## Prérequis

- **Avoir un cluster Kubernetes :** Pour ce guide, nous utilisons Minikube.

## Structure du Répertoire

Dans ce dossier, vous trouverez différents répertoires. Le répertoire `kubernetes` est le point de départ essentiel ; il contient tous les fichiers de configuration nécessaires, qui se terminent tous par `.yaml`, ainsi que les scripts de déploiement automatique. Il est important que le script soit situé dans le même répertoire que les fichiers `.yaml` pour fonctionner correctement.

## Utilisation

Suivez ces étapes pour déployer votre infrastructure :

1. **Télécharger le dossier** et naviguer au répertoire `kubernetes`.

2. **Rendre le script exécutable** avec la commande :

    ```bash
    chmod +x script.sh
    ```

3. **Exécuter le script** avec la commande :

    ```bash
    ./script.sh
    ```

Le script effectuera alors les actions suivantes :

- Déploiement de la configuration Redis (master, slave, service, exporter).
- Déploiement de la configuration Node.js (déploiement et service).
- Déploiement de la configuration Prometheus (déploiement et service).
- Déploiement de la configuration Grafana (déploiement et service).
- Ouverture du tunnel Minikube pour exposer les services en externe.
- Attente d’un laps de temps pour que le tunnel soit établi, en vérifiant que le service Node.js a une adresse IP externe.
- Récupération de l'adresse IP externe du service Node.js.
- Affichage de la liste des pods et services créés.

Une fois le déploiement terminé, vous pourrez accéder à l'application Prometheus/Grafana en utilisant l'adresse IP externe affichée, en ouvrant un navigateur web tel que Mozilla Firefox et en saisissant l’adresse IP récupérée.

### Configuration de la Source de Données Prometheus dans Grafana

Avant toute chose, assurez-vous d'avoir récupéré les adresses IP de Prometheus et Grafana grâce à `kubectl get service`. Ensuite :

1. Dans l'interface de Grafana, allez dans **Configuration > Data Sources**.
2. Cliquez sur **Add data source** et sélectionnez **Prometheus**.
3. Renseignez l'URL du service Prometheus de votre cluster Kubernetes : `http://prometheus.default.svc.cluster.local:9090`.
4. Remplissez les autres champs de configuration si nécessaire (authentification, timeouts, etc.).
5. Cliquez sur **Save & Test** pour vérifier la connexion.

### Pour faire Fonctionner React

1. Récupérez l'adresse IP externe du service Node.js obtenue lors de l'exécution du script.
2. Naviguez dans `/react`, puis `/src`.
3. Ouvrez le fichier `conf.js` de l'application React.
4. Mettez à jour la variable d'environnement `URL` avec l'adresse IP externe du service Node.js :

    ```javascript
    export const URL = 'http://<NODEJS_IP>:8080';
    ```

    Remplacez `<NODEJS_IP>` par l’adresse IP récupérée précédemment.

5. Enregistrez les modifications faites dans le fichier `src/conf.js`.

### Création et Publication de l'Image Docker pour React

1. Construisez l'image Docker de l'application React avec la commande :

    ```bash
    docker build -t my-react-app .
    ```

2. Connectez-vous à votre compte Docker Hub :

    ```bash
    docker login
    ```

3. Renommez votre image Docker avec votre nom d'utilisateur Docker Hub :

    ```bash
    docker tag my-react-app <DOCKER_USERNAME>/my-react-app
    ```

4. Publiez l'image sur Docker Hub :

    ```bash
    docker push <DOCKER_USERNAME>/my-react-app
    ```

5. Mettez à jour l'image Docker utilisée dans la section `spec.containers.image` du fichier `react-deployment.yaml` avec l'image que vous venez de publier.

6. Lancez le script `script_react.sh` pour déployer le service React, en vous assurant de rendre le script exécutable avec `chmod +x` puis de l'exécuter avec `./script_react.sh`.

Après ces étapes, l'application React sera déployée sur le cluster Kubernetes et accessible via l'adresse IP externe du service React.
