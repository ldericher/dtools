# METADATA
FROM alpine:3.13
LABEL maintainer="jmm@yavook.de"

RUN	set -ex; \
    ##############
    # slashpackage
    ##############
    \
    mkdir -p /usr/local/package; \
    ln -s /usr/local/package /; \
    chmod +t /package/.;

ARG DAEMONTOOLS_VERSION=0.76

RUN	set -ex; \
    #############
    # daemontools
    #############
    \
    # prerequisites
    apk --no-cache --virtual .dt-deps add \
    gcc \
    make \
    musl-dev \
    patch \
    ; \
    \
    # get source
    cd "/package"; \
    wget -qO - "https://cr.yp.to/daemontools/daemontools-${DAEMONTOOLS_VERSION}.tar.gz" \
    | tar -xzp; \
    # apply errno patch
    cd "admin/daemontools-${DAEMONTOOLS_VERSION}"; \
    wget -qO - "https://aur.archlinux.org/cgit/aur.git/plain/daemontools-${DAEMONTOOLS_VERSION}.errno.patch?h=daemontools" \
    | patch -Np1; \
    \
    # compile and install
    "package/install"; \
    rm -rf "compile"; \
    \
    # remove prerequisites
    apk --no-cache del .dt-deps;

# add /command to PATH
ENV PATH=/command:"${PATH}"

# start daemontools
CMD [ "/command/svscanboot" ]

ARG SKALIBS_VERSION=2.10.0.3
ARG RUNWHEN_VERSION=2021.04.30

RUN	set -ex; \
    #######################
    # skalibs (for runwhen)
    #######################
    \
    # prerequisites
    apk --no-cache --virtual .rw-deps add \
    gcc \
    make \
    musl-dev \
    ; \
    \
    # get source
    cd "/tmp"; \
    wget -qO - "http://www.skarnet.org/software/skalibs/skalibs-${SKALIBS_VERSION}.tar.gz" \
    | tar -xzp; \
    \
    # compile and install
    cd "skalibs-${SKALIBS_VERSION}"; \
    "./configure" --disable-ipv6; \
    make -j "$(( $(nproc) * 2 ))"; \
    make install; \
    cd; rm -rf "/tmp/skalibs-${SKALIBS_VERSION}"; \
    \
    #########
    # runwhen
    #########
    \
    # get source
    cd "/package"; \
    wget -qO - "https://code.dogmap.org/runwhen/releases/runwhen-${RUNWHEN_VERSION}.tar.bz2" \
    | tar -xjp; \
    \
    # compile and install
    cd "admin/runwhen-${RUNWHEN_VERSION}"; \
    "package/install"; \
    rm -rf "compile"; \
    \
    # prerequisites
    apk --no-cache del .rw-deps;

# add readlog script
COPY readlog /usr/local/bin
