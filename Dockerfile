FROM golang:1.19.3-alpine as builder

# Install git and ca-certificates (needed to be able to call HTTPS)
RUN apk add --no-cache ca-certificates git
RUN apk add build-base
WORKDIR /src

# Restore dependencies
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Move to working directory /src
WORKDIR /src


# Copy the code into the container
COPY ./server .
COPY ./proto ./proto

# Skaffold passes in debug-oriented compiler flags
ARG SKAFFOLD_GO_GCFLAGS
RUN CGO_ENABLED=0 GOOS=linux go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /go/bin/greeting .

# Build the application's binary
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

FROM alpine:3.16.3 as release
RUN apk add --no-cache ca-certificates \
    busybox-extras net-tools bind-tools
WORKDIR /src
COPY --from=builder /go/bin/greeting /src/server

# Definition of this variable is used by 'skaffold debug' to identify a golang binary.
# Default behavior - a failure prints a stack trace for the current goroutine.
# See https://golang.org/pkg/runtime/
ENV GOTRACEBACK=single

EXPOSE 8080
# Command to run the application when starting the container
ENTRYPOINT ["/src/server"]
