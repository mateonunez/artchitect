FROM node:16-alpine

# Setting env variables
ENV BALANCER_HOST architect_backend_javascript_balancer
ENV BALANCER_PORT 5010

# Installing main dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommeds \
  gettext

# Setting the workdir
WORKDIR /usr/src/architect/backend/javascript/balancer

# Installing dependencies
COPY package.json package.json
COPY package-lock.json package-lock.json

# Installing balancer dependencies
RUN npm install

# Copying the application
COPY .env .env
COPY src src

# Set the env variables
RUN envsubst '${BALANCER_HOST},${BALANCER_PORT}' < .env

# Run the application in dev mode
RUN npm run dev
