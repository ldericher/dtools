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
    curl \
    gcc \
    make \
    musl-dev \
    patch \
    ; \
    \
    # get source 
    cd /package; \
    curl -L https://cr.yp.to/daemontools/daemontools-${DAEMONTOOLS_VERSION}.tar.gz \
    | tar -xzp; \
    cd admin/daemontools-${DAEMONTOOLS_VERSION}; \
    \
    # apply errno patch
    curl -L https://aur.archlinux.org/cgit/aur.git/plain/daemontools-${DAEMONTOOLS_VERSION}.errno.patch?h=daemontools \
    | patch -Np1; \
    # compile and install
    package/install; \
    cd && rm -rf /package/admin/daemontools-${DAEMONTOOLS_VERSION}/compile; \
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
    cd /package; \
    curl -L http://www.skarnet.org/software/skalibs/skalibs-${SKALIBS_VERSION}.tar.gz \
    | tar -xzp; \
    cd skalibs-${SKALIBS_VERSION}; \
    \
    # compile and install
    ./configure --disable-ipv6; \
    make -j$(nproc) && make install; \
    cd && rm -rf /package/skalibs-${SKALIBS_VERSION}; \
    \
    #########
    # runwhen
    #########
    \
    # get source 
    cd /package; \
    curl -L https://code.dogmap.org/runwhen/releases/runwhen-${RUNWHEN_VERSION}.tar.bz2 \
    | tar -xjp; \
    cd /package/admin/runwhen-${RUNWHEN_VERSION}; \
    \
    # compile and install
    ./package/install; \
    cd && rm -rf /package/admin/runwhen-${RUNWHEN_VERSION}/compile; \
    \
    # prerequisites 
    apk del --no-cache .rw-deps;

# add readlog script
COPY readlog /usr/local/bin
