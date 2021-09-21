# METADATA
FROM alpine:3.14
LABEL maintainer="jmm@yavook.de"

ENV SLASHPACKAGE="/package"

RUN	set -ex; \
    ############## 
    # slashpackage 
    ############## 
    \
    mkdir -p "${SLASHPACKAGE}"; \
    chmod 1755 "${SLASHPACKAGE}";

RUN	set -ex; \
    #############
    # daemontools 
    #############
    \
    # prerequisites
    apk --no-cache --virtual .dt-deps add \
    curl \
    gcc \
    make \
    musl-dev \
    patch \
    ; \
    \
    # get source 
    cd "${SLASHPACKAGE}"; \
    curl -L https://cr.yp.to/daemontools/daemontools-0.76.tar.gz \
    | tar -xzp; \
    cd admin/daemontools-0.76; \
    \
    # apply errno patch
    curl -L https://aur.archlinux.org/cgit/aur.git/plain/daemontools-0.76.errno.patch?h=daemontools \
    | patch -Np1; \
    # compile and install
    ./package/install; \
    cd && rm -rf "${SLASHPACKAGE}"/admin/daemontools-0.76/compile; \
    \
    # remove prerequisites
    apk del --no-cache .dt-deps;

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
    curl \
    gcc \
    make \
    musl-dev \
    ; \
    \
    # get source
    cd "${SLASHPACKAGE}"; \
    curl -L http://www.skarnet.org/software/skalibs/skalibs-${SKALIBS_VERSION}.tar.gz \
    | tar -xzp; \
    cd skalibs-${SKALIBS_VERSION}; \
    \
    # compile and install
    ./configure --disable-ipv6; \
    make -j5 && make install; \
    cd && rm -rf "${SLASHPACKAGE}"/skalibs-${SKALIBS_VERSION}; \
    \
    #########
    # runwhen
    #########
    \
    # get source 
    cd "${SLASHPACKAGE}"; \
    curl -L https://code.dogmap.org/runwhen/releases/runwhen-${RUNWHEN_VERSION}.tar.bz2 \
    | tar -xjp; \
    cd "${SLASHPACKAGE}"/admin/runwhen-${RUNWHEN_VERSION}; \
    \
    # compile and install
    ./package/install; \
    cd && rm -rf "${SLASHPACKAGE}"/admin/runwhen-${RUNWHEN_VERSION}/compile; \
    \
    # prerequisites 
    apk del --no-cache .rw-deps;

# add my readlog script
COPY readlog /command
