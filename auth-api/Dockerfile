
FROM golang:1.9-alpine  AS build 

EXPOSE 8081

WORKDIR /go/src/app
 
RUN ls && \
    apk --no-cache add curl git && \
    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

COPY . .
RUN dep ensure && \
    go build -o auth-api

FROM alpine:latest

COPY --from=build /go/src/app/auth-api .

CMD ["./auth-api"]

