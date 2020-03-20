FROM ubuntu:19.10
RUN apt update && apt upgrade -y
RUN apt install -y git autoconf automake libtool zlib1g-dev build-essential python

RUN git clone https://github.com/OasisLMF/ktools.git /ktools
RUN cd /ktools && ./autogen.sh && ./configure && make && make check && make install

ENTRYPOINT [ "bash" ]
