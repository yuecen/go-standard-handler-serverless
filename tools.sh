#!/bin/bash

export DEVELOPMENT_IMAGE='go-serverless:1.x'
export AWS_ACCESS_KEY_ID='<YOUR_KEY_ID>'
export AWS_SECRET_ACCESS_KEY='<YOUR_ACCESS_KEY>'

case $1 in
init)
    docker build -t ${DEVELOPMENT_IMAGE} . -f-<<EOF
FROM golang:1.12.7-alpine3.10
WORKDIR /workspace
RUN apk add --no-cache npm && npm install -g serverless && apk add --no-cache git
CMD ["sh"]
EOF
    ;;
build)
    docker run -it --rm --name go-serverless-`date "+%s"` \
      -v ${PWD}/bin:/workspace/bin \
      -v ${PWD}/src:/workspace/src \
      -v ${PWD}/go.mod:/workspace/go.mod:ro \
      -v ${PWD}/go.sum:/workspace/go.sum:ro \
      -e GO111MODULE=on \
      ${DEVELOPMENT_IMAGE} \
      env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o /workspace/bin/main /workspace/src/main.go
    ;;
deploy)
    docker run -it --rm --name go-serverless-`date "+%s"` \
      -v ${PWD}/bin:/workspace/bin \
      -v ${PWD}/serverless.yml:/workspace/serverless.yml:ro \
      -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
      -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
      ${DEVELOPMENT_IMAGE} \
      serverless deploy
    ;;
remove)
    docker run -it --rm --name go-serverless-`date "+%s"` \
      -v ${PWD}/bin:/workspace/bin \
      -v ${PWD}/serverless.yml:/workspace/serverless.yml:ro \
      -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
      -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
      ${DEVELOPMENT_IMAGE} \
      serverless remove
    ;;
*)
    # export local_dir=${1:-$(pwd)}
    # Do nothing, loading as build tool
    ;;
esac