FROM node:latest

ENV PORT 3030

ENV ARCHIVEL_ENDPOINT http://architect_nginx_laravel:8000
ENV ARCHIFRONT_ENDPOINT http://architect_nginx_archifront
ENV ARCHIFRONT_AUTHENTICATION_ENDPOINT http://architect_frontend_archifront_authentication:3010
ENV ARCHIFRONT_HOMEPAGE_ENDPOINT http://architect_frontend_archifront_homepage:3030

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  gettext

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/archifront/homepage/
WORKDIR /usr/src/architect/frontend/archifront/homepage/

# Install deps
COPY package*.json /usr/src/architect/frontend/archifront/homepage/
RUN npm install

# Copy the app
COPY . /usr/src/architect/frontend/archifront/homepage/

RUN envsubst '$ARCHIVEL_ENDPOINT,$ARCHIFRONT_ENDPOINT,$ARCHIFRONT_AUTHENTICATION_ENDPOINT,$ARCHIFRONT_HOMEPAGE_ENDPOINT' < /usr/src/architect/frontend/archifront/homepage/.env.local

# Run the app
CMD ["npm", "run", "dev"]