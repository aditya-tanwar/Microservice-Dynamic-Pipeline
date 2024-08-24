FROM node:8-alpine AS build

EXPOSE 8080

WORKDIR /usr/src/app

COPY . .

RUN npm install

FROM alpine

RUN apk add --update nodejs npm

COPY --from=build /usr/src/app/ .

CMD ["sh", "-c", "npm start"]



