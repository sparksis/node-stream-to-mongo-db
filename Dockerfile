FROM node:8-alpine

RUN mkdir -p /data/db && apk add --no-cache mongodb git

ADD . /app
WORKDIR /app

RUN git clean -xfd

RUN mongod --fork --logpath /tmp/mongo.log && \
    npm install && \
    npm test || touch failure ; \
    mongod --shutdown; \
    echo 'This docker image is not suitable for use outside of light testing.'; \
    if [ -e "failure" ]; then exit 1; fi

ENTRYPOINT [ "false" ]
