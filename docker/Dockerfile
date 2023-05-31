# Dockerfile

FROM node:18

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 3000

CMD ["npm", "run", "start", "host", "0.0.0.0", "-p", "3000"]

