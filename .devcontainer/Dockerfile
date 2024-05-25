FROM ubuntu:noble

ENV DEBIAN_FRONTEND noninteractive
ENV PACKER_VERSION 1.10.3

RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends --no-install-suggests -o=Dpkg::Use-Pty=0 \
        apt-utils \
        software-properties-common \
        libterm-readline-gnu-perl \
        curl \
        unzip \
        genisoimage \
        openssh-client \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN curl -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f packer_${PACKER_VERSION}_linux_amd64.zip \
    && chmod +x /usr/bin/packer

CMD ["/bin/bash"]
