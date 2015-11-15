FROM thingmesh/base:latest

MAINTAINER Lars Boegild Thomsen <lth@reclaim-your-privacy.com>

RUN     export DEBIAN_FRONTEND=noninteractive && \
        apt-get -y update && \
        apt-get install -yq git build-essential

RUN	git glone https://github.com/ReclaimYourPrivacy/eschalot.git

RUN	(cd eschalot && make)

COPY eschalot /
RUN chmod +x ./eschalot

ENTRYPOINT	["./eschalot"]

