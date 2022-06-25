FROM node:16-alpine as builder

ENV PORT 3000

ENV ARCHIVEL_ENDPOINT http://architect_nginx_laravel
ENV ARCHIFRONT_ENDPOINT http://archifront_nginx
ENV ARCHIFRONT_AUTHENTICATION_ENDPOINT http://archifront_authentication
ENV ARCHIFRONT_HOMEPAGE_ENDPOINT http://archifront_homepage

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/archifront/authentication/
WORKDIR /usr/src/architect/frontend/archifront/authentication/

# Install deps
COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

# Copy the app
COPY assets assets
COPY components components
COPY lib lib
COPY pages pages
COPY public public
COPY styles styles

COPY .env.local.example .env.local
COPY next-env.d.ts next-env.d.ts
COPY next-sitemap.config.js next-sitemap.config.js
COPY postcss.config.js postcss.config.js
COPY tailwind.config.js tailwind.config.js
COPY tsconfig.json tsconfig.json

RUN envsubst '${ARCHIVEL_ENDPOINT},${ARCHIFRONT_ENDPOINT},${ARCHIFRONT_AUTHENTICATION_ENDPOINT},${ARCHIFRONT_HOMEPAGE_ENDPOINT}' < .env.local

# Run the app
CMD ["npm", "run", "dev"]
