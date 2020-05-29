#!/usr/bin/env bash

##########
VERSION=${1}

# These are the values we want to pass for Version and BuildTime
GITHASH=`git rev-parse HEAD 2>/dev/null`

BUILDAT=`date +%FT%T%z`

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS="-s -w -X github.com/xiaonian0430/ShareKnow/utils.GitHash=${GITHASH} -X github.com/xiaonian0430/ShareKnow/utils.BuildAt=${BUILDAT} -X github.com/xiaonian0430/ShareKnow/utils.Version=${VERSION} -X myquant.cn/algoserv/algoserv/admin.Binary=true"

##########

CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o output/mac/ShareKnow -ldflags "${LDFLAGS}"
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o output/linux/ShareKnow -ldflags "${LDFLAGS}"
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o output/windows/ShareKnow.exe -ldflags "${LDFLAGS}"
