# Etap 1
#Tworzenie obrazu bazowego z Alpine
FROM scratch as builder

# Dodanie systemu plików Alpine
ADD alpine-minirootfs-3.19.1-x86_64.tar /

# Aktualizacja i instalacja Node.js oraz npm
RUN apk update && \
   apk upgrade && \
   apk add --no-cache nodejs=20.12.1-r0 \
   npm=10.2.5-r0 && \
   rm -rf /etc/apk/cache

# Ustalenie katalogu roboczego i kopiowanie plików
WORKDIR /home/node/app
COPY server.js ./server.js
COPY package.json ./package.json

# Instalacja zależności z npm
RUN npm install

# Etap 2
FROM node:18-alpine3.18

# Dodanie autora
LABEL org.opencontainers.image.authors="Mykhailo Krylov"

# Utworzenie katalogu
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Skopiowanie plików z buildera
COPY --from=builder  /home/node/app/server.js ./server.js
COPY --from=builder  /home/node/app/node_modules ./node_modules

# Ustawienie portu
EXPOSE 3000

# Kontrola zdrowia 
HEALTHCHECK --interval=4s --timeout=20s --start-period=2s --retries=3 \
   CMD curl -f http://localhost:3000/ || exit 1

# Uruchomienie serwera 
ENTRYPOINT ["node", "server.js"]
