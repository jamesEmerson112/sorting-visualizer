FROM node:16.13.0

LABEL version="1.0"

LABEL description="This is the base docker image for my React app"

LABEL maintainer="james.emerson.vo.2503@gmail.com"

WORKDIR /usr/src/app

COPY ["package.json", "package-lock.json", "./"]

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]