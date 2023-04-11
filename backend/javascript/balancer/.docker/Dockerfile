FROM node:19-alpine@sha256:53741c7511b1836b5eb7e788a7b399c058b0b549f205d2c6af831ec1a9a81c31 as builder

# Setting env variables
ENV BALANCER_HOST balancer_rust
ENV BALANCER_PORT 5010

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Creating and checkout the directory
RUN mkdir -p /usr/src/architect/backend/javascript/balancer
WORKDIR /usr/src/architect/backend/javascript/balancer

# Installing dependencies
COPY package.json package.json
COPY package-lock.json package-lock.json

# Installing balancer dependencies
RUN npm install

# Copying the env file
COPY .env.example .env

# Copying the application
COPY src src

# Set the env variables
RUN envsubst '${BALANCER_HOST},${BALANCER_PORT}' < .env

# Run the application in dev mode
CMD ["npm", "run", "dev"]
