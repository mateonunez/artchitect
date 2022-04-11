FROM node:16-alpine

WORKDIR /usr/src/architect/backend/javascript/watchful

COPY package*.json ./

RUN npm install

CMD ["./node_modules/nodemon/bin/nodemon.js", "src/index.ts"]
