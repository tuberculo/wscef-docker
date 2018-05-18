# Run Warsaw in a container

# Base docker image
FROM ubuntu:latest
LABEL maintainer "Fabio Rodrigues Ribeiro <farribeiro@gmail.com>"

ADD https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw-setup-ubuntu_64.deb /src/warsaw.deb
COPY startup.sh /home/ff/

# Install Firefox
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
	language-pack-pt \
	openssl \
	libnss3-tools \
	firefox \
	firefox-locale-pt \
	xauth \
	sed \
	--no-install-recommends \
	&& groupadd -g 1000 -r ff \
	&& useradd -u 1000 -r -g ff -G audio,video ff -d /home/ff \
	&& chmod 744 /home/ff/startup.sh \
	&& chown -R ff:ff /home/ff \
	&& echo root:wscef | chpasswd \
	&& dpkg-deb -R /src/warsaw.deb /src/warsaw \
	&& sed -i 's/python-gpgme/python-gpg/g' /src/warsaw/DEBIAN/control \
	&& sed -i 's/libcurl3/libcurl4/g' /src/warsaw/DEBIAN/control \
	&& sed -i 's/gpgme/gpg/g' /src/warsaw/usr/bin/warsaw \
	&& dpkg-deb -b /src/warsaw /src/GBPCEFwr64.deb \
	&& apt-get purge --auto-remove -y \
	&& rm -rf /var/lib/apt/lists/*

# Run firefox as non privileged user
USER ff

# Add volume for recipes PDFs
VOLUME "/home/ff/Downloads"

# Autorun chrome
CMD [ "/home/ff/startup.sh" ]
