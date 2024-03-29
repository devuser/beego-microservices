FROM golang:alpine as builder
LABEL maintainer="devuser@gmail.com"
COPY . /app
WORKDIR /app
RUN apk update && apk add git \
    && export GO111MODULE=on  \
    && cd src \
    && go build -mod vendor -o ../app

# && go get -u github.com/gin-gonic/gin \
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/app .
EXPOSE 80
CMD ["./app"]
