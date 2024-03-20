FROM alpine:latest

LABEL MAINTAINER "Patrick Saindon <pat.saindon@gmail.com>"
LABEL APP "bliss"

ENV VMARGS=-Dbliss_working_directory=/config

EXPOSE 3220 3221

VOLUME /config /music

RUN mkdir /bliss

ADD scripts/entrypoint.sh /bliss/
ADD scripts/bliss-runner.sh /bliss/

RUN chmod +x /bliss/bliss-runner.sh

# All one command to allow cleanup within the same container
RUN apk update ; \
    apk add --no-cache wget shadow openjdk8-jre-base su-exec ; \
    wget -qO- http://www.blisshq.com/app/latest-linux-version | xargs wget -O bliss-install-latest.jar -nv ; \
    echo INSTALL_PATH=/bliss > auto-install.properties ; \
    java -jar bliss-install-latest.jar -console -options auto-install.properties ; \
    apk del wget ; \
    rm bliss-install-latest.jar ; \
    rm /var/cache/apk/*

WORKDIR /bliss

ENTRYPOINT ["/bliss/entrypoint.sh"]
CMD ["/bliss/bliss-runner.sh"]
