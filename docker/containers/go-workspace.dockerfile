FROM golang:1.20-alpine

RUN apk add build-base

RUN mkdir /app

WORKDIR /app

