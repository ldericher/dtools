# METADATA
FROM centos:7
LABEL maintainer="jmm@yavook.de"

ENV SLASHPACKAGE="/package"

RUN	\
	############## \
	# slashpackage \
	############## \
	\
	mkdir -p "${SLASHPACKAGE}" &&\
	chmod 1755 "${SLASHPACKAGE}"

RUN	\
	############## \
	# daemontools \
	############## \
	\
	# prerequisites \
	yum install -y gcc make patch &&\
	\
	# get source \
	cd "${SLASHPACKAGE}" &&\
	curl -L https://cr.yp.to/daemontools/daemontools-0.76.tar.gz \
	 | tar -xzp &&\
	cd "${SLASHPACKAGE}"/admin/daemontools-0.76 &&\
	\
	# apply errno patch \
	curl -L http://www.qmail.org/moni.csi.hu/pub/glibc-2.3.1/daemontools-0.76.errno.patch \
	 | patch -Np1 &&\
	# compile and install \
	./package/install &&\
	cd && rm -rf "${SLASHPACKAGE}"/admin/daemontools-0.76/compile

# add /command to PATH
ENV PATH=/command:"${PATH}"

# start daemontools
CMD [ "/command/svscanboot" ]

RUN	\
	############## \
	# skalibs (for runwhen) \
	############## \
	\
	# get source \
	cd "${SLASHPACKAGE}" &&\
	curl -L http://www.skarnet.org/software/skalibs/skalibs-2.6.4.0.tar.gz \
	 | tar -xzp &&\
	cd skalibs-2.6.4.0 &&\
	\
	# compile and install \
	./configure --disable-ipv6 &&\
	make -j5 && make install &&\
	cd && rm -rf "${SLASHPACKAGE}"/skalibs-2.6.4.0

# add skalibs libraries
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}":/usr/lib

RUN	\
	############## \
	# runwhen \
	############## \
	\
	# prerequisites \
	yum install -y bzip2 &&\
	\
	# get source \
	cd "${SLASHPACKAGE}" &&\
	curl -L http://code.dogmap.org/runwhen/releases/runwhen-2015.02.24.tar.bz2 \
	 | tar -xjp &&\
	cd "${SLASHPACKAGE}"/admin/runwhen-2015.02.24 &&\
	\
	# compile and install \
	./package/install &&\
	cd && rm -rf "${SLASHPACKAGE}"/admin/runwhen-2015.02.24/compile

RUN	\
	############## \
	# readlog script needs less \
	############## \
	yum install -y less

# add my readlog script
COPY readlog /command
