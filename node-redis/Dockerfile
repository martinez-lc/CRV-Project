# Define la imagen base
FROM node:18-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de dependencias
COPY package*.json ./

# Instala las dependencias
RUN yarn

# Copia el resto de los archivos de la aplicación
COPY . .

# Define el comando para iniciar la aplicación
CMD ["node", "main.js"]

