FROM node:19-alpine@sha256:53741c7511b1836b5eb7e788a7b399c058b0b549f205d2c6af831ec1a9a81c31 as builder 

# Set the environment variables
ENV MAILGUN_DOMAIN architect.com
ENV MAILGUN_API_URL https://api.mailgun.net/v3/architect.com
ENV MAILPUN_API_USER api
ENV MAILGUN_API_KEY architect_mailgun_api_key

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Create the directory
RUN mkdir -p /usr/src/architect/backend/typescript/mailman
WORKDIR /usr/src/architect/backend/typescript/mailman

# Copy packages
COPY package.json package.json
COPY package-lock.json package-lock.json

# Installing watchful dependencies
RUN npm install

# Copying the env file
COPY .env.example .env

# Replacing env variables
RUN envsubst '${HOST},${PORT},${MAILGUN_DOMAIN},${MAILGUN_API_URL},${MAILPUN_API_USER},${MAILGUN_API_KEY}' < .env

# Run the application in dev mode
CMD ["npm", "run", "dev"]
