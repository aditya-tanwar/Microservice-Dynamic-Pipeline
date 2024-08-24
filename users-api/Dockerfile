FROM openjdk:8-alpine AS build

EXPOSE 8083
WORKDIR /usr/src/app


COPY . .
COPY .mvn/ ./.mvn
RUN ./mvnw dependency:resolve && ./mvnw install

FROM alpine

COPY --from=build /usr/src/app .
RUN apk add openjdk8

CMD ["java", "-jar", "./target/users-api-0.0.1-SNAPSHOT.jar"]
