FROM openjdk:8-jdk-alpine

ARG VERSION

ENV DIST_MIRROR             https://archive.apache.org/dist/nifi/nifi-registry
ENV NIFI_REGISTRY_HOME      /opt/nifi-registry
#ENV VERSION                 0.3.0

RUN set -x && \
    apk --no-cache add tar wget && \
	mkdir -p ${NIFI_REGISTRY_HOME} && \
	wget -qO- ${DIST_MIRROR}/nifi-registry-${VERSION}/nifi-registry-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_REGISTRY_HOME} --strip-components=1 && \
    addgroup nifi && \
    adduser -D -G nifi nifi && \
    chown -R nifi:nifi ${NIFI_REGISTRY_HOME}

USER nifi
WORKDIR ${NIFI_REGISTRY_HOME}
COPY ./providers.xml /opt/nifi-registry/conf/providers.xml

CMD ["bin/nifi-registry.sh","run"]