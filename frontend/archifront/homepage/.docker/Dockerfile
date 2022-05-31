FROM node:latest

ENV PORT 3030
ENV ARCHIVEL_ENDPOINT http://architect_nginx_laravel

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

RUN envsubst '$ARCHIVEL_ENDPOINT' < /usr/src/architect/frontend/archifront/homepage/.env.local

# Run the app
CMD ["npm", "run", "dev"]