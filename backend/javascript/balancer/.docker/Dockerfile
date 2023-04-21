FROM node:20-alpine@sha256:cc4e8f3d78a276fa05eae1803b6f8cbb43145441f54c828ab14e0c19dd95c6fd as builder

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
