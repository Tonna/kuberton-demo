FROM golang:1.12-alpine as builder
RUN apk add --no-cache ca-certificates git

ENV PROJECT github.com/arbrix/kuberton-demo
WORKDIR /go/src/$PROJECT

# restore dependencies
COPY . .
RUN GO111MODULE=on go mod download
RUN GO111MODULE=on go mod vendor
RUN go install .

FROM alpine as release
RUN apk add --no-cache ca-certificates \
    busybox-extras net-tools bind-tools
WORKDIR /shop
COPY --from=builder /go/bin/kuberton-demo /shop/server
COPY ./products.json ./products.json
COPY ./templates ./templates
COPY ./static ./static
EXPOSE 3000
ENTRYPOINT ["/shop/server"]
