FROM node:19-alpine@sha256:fcf4e6f4557788bcd3338f717e39dbaa5061bc0154e7d96bda0bca9447ec8056 as builder

ENV PORT 3000

ENV HOST archifront_nginx
ENV KONG_GATEWAY http://kong:8000
ENV ARCHIFRONT_ENDPOINT http://archifront_nginx

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/archifront/homepage/
WORKDIR /usr/src/architect/frontend/archifront/homepage/

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

RUN envsubst '${HOST},${KONG_GATEWAY},${ARCHIFRONT_ENDPOINT}' < .env.local

# Run the app
CMD ["npm", "run", "dev"]
