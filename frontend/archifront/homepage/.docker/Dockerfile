FROM node:20-alpine@sha256:cc4e8f3d78a276fa05eae1803b6f8cbb43145441f54c828ab14e0c19dd95c6fd as builder

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
