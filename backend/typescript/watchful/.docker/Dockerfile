FROM node:16-alpine as builder 

# Set the environment variables
ENV RABBITMQ_HOST architect_rabbitmq
ENV RABBITMQ_PORT 5672
ENV RABBITMQ_USER architect
ENV RABBITMQ_PASSWORD architect

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Create the directory
RUN mkdir -p /usr/src/architect/backend/typescript/watchful
WORKDIR /usr/src/architect/backend/typescript/watchful

# Copy packages
COPY package.json package.json
COPY package-lock.json package-lock.json

# Installing watchful dependencies
RUN npm install

# Copying the env file
COPY .env .env

# Replacing env variables
RUN envsubst '${RABBITMQ_HOST},${RABBITMQ_PORT},${RABBITMQ_USER},${RABBITMQ_PASSWORD}' < .env

# Run the application in dev mode
CMD ["npm", "run", "dev"]
