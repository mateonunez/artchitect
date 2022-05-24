FROM node:latest

ENV PORT 3000

# Create the directory
RUN mkdir -p /usr/src/architect/frontend/react/homepage/
WORKDIR /usr/src/architect/frontend/react/homepage/

# Install deps
COPY package*.json /usr/src/architect/frontend/react/homepage/
RUN npm install

# Copy the app
COPY . /usr/src/architect/frontend/react/homepage/

EXPOSE 3030

# Run the app
CMD ["npm", "run", "build:start"]