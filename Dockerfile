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
COPY --from=builder /app/src/static .
COPY --from=builder /app/src/views .
RUN mkdir conf
COPY --from=builder /app/src/conf/app.conf ./conf
EXPOSE 80
CMD ["./app"]
