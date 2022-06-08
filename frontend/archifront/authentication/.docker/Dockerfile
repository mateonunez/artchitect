FROM node:latest

ENV PORT 3010
ENV ARCHIVEL_ENDPOINT http://architect_nginx_laravel:8000
ENV ARCHIFRONT_ENDPOINT http://architect_nginx_archifront
ENV ARCHIFRONT_AUTHENTICATION_ENDPOINT http://architect_frontend_archifront_authentication:3010

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  gettext

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/archifront/authentication/
WORKDIR /usr/src/architect/frontend/archifront/authentication/

# Install deps
COPY package*.json /usr/src/architect/frontend/archifront/authentication/
RUN npm install

# Copy the app
COPY . /usr/src/architect/frontend/archifront/authentication/

RUN envsubst '$ARCHIVEL_ENDPOINT,$ARCHIFRONT_ENDPOINT,$ARCHIFRONT_AUTHENTICATION_ENDPOINT' < /usr/src/architect/frontend/archifront/authentication/.env.local

# Run the app
CMD ["npm", "run", "dev"]
