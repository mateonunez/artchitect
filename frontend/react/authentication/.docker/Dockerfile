FROM node:latest

ENV PORT 3010

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/react/authentication/
WORKDIR /usr/src/architect/frontend/react/authentication/

# Install deps
COPY package*.json /usr/src/architect/frontend/react/authentication/
RUN npm install

# Copy the app
COPY . /usr/src/architect/frontend/react/authentication/

# Run the app
CMD ["npm", "run", "dev"]