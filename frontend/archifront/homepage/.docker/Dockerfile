FROM node:latest

ENV PORT 3030

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/archifront/homepage/
WORKDIR /usr/src/architect/frontend/archifront/homepage/

# Install deps
COPY package*.json /usr/src/architect/frontend/archifront/homepage/
RUN npm install

# Copy the app
COPY . /usr/src/architect/frontend/archifront/homepage/

# Run the app
CMD ["npm", "run", "dev"]