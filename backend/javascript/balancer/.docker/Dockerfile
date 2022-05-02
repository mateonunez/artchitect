FROM node:16-alpine

WORKDIR /usr/src/architect/backend/javascript/balancer

COPY package*.json ./

RUN npm install

EXPOSE 5010

CMD ["./node_modules/nodemon/bin/nodemon.js", "src/index.js"]