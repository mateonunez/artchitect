FROM node:latest

ENV PORT 3010

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/archifront/authentication/
WORKDIR /usr/src/architect/frontend/archifront/authentication/

# Install deps
COPY package*.json /usr/src/architect/frontend/archifront/authentication/
RUN npm install

# Copy the app
COPY . /usr/src/architect/frontend/archifront/authentication/

# Run the app
CMD ["npm", "run", "dev"]