#########################
# multi stage Dockerfile
# 1. set up the build environment and build the expath-package
# 2. run the eXist-db
#########################
FROM eclipse-temurin:21 AS builder

RUN apt-get update \
&& apt-get install -y --no-install-recommends ant 

WORKDIR /opt/app

COPY . .

RUN ant

#####################################
# Run exist-db and add xar-packages #
#####################################
FROM stadlerpeter/existdb:6.3.0

ARG EXIST_PASSWORD=korngold
ENV EXIST_PASSWORD=${EXIST_PASSWORD}

COPY --chown=wegajetty --from=builder /opt/app/build-xar/*.xar ${EXIST_HOME}/autodeploy/
