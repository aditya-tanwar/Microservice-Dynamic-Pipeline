FROM node:8-alpine AS build

EXPOSE 8082

WORKDIR /usr/src/app

COPY . . 

RUN npm install



FROM node:8-alpine 

COPY --from=build /usr/src/app /usr/src/app

CMD ["sh", "-c", "npm start" ]
