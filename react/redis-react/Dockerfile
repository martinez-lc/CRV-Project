# Étape de build
FROM node:18-alpine as build

# Créer le répertoire de l'application
WORKDIR /app

# Copier les fichiers de l'application
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le code source
COPY . .

# Construire l'application
RUN npm run build

# Étape de production
FROM nginx:alpine

# Copier les fichiers de build
COPY --from=0 /app/build /usr/share/nginx/html

# Exposer le port
EXPOSE 80

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]
