# METADATA
FROM centos:7
LABEL maintainer="jmm@yavook.de"

RUN \
	# prerequisites \
	# daemontools \
	yum install -y gcc make patch &&\
	# readlog script \
	yum install -y less &&\
	\
	# DJB \
	mkdir -p /package &&\
	chmod 1755 /package &&\
	\
	# get source \
	cd /package &&\
	curl -L https://cr.yp.to/daemontools/daemontools-0.76.tar.gz \
	 | tar -xzp &&\
	\
	# apply errno patch \
	cd /package/admin/daemontools-0.76 &&\
	curl -L http://www.qmail.org/moni.csi.hu/pub/glibc-2.3.1/daemontools-0.76.errno.patch \
	 | patch -Np1 &&\
	\
	# compile and install \	
	/package/admin/daemontools-0.76/package/install

# add /command to PATH
ENV PATH="/command:${PATH}"

# add my readlog script
COPY readlog /command

# start daemontools
CMD [ "/command/svscanboot" ]
