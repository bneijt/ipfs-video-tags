FROM debian:buster

RUN apt-get update &&\
    apt-get upgrade -y && \
    apt-get install -y haskell-stack build-essential libtagc0-dev zlib1g-dev git
RUN useradd -m builder
USER builder
WORKDIR /home/builder
ENV PATH=/home/builder/.local/bin:$PATH

RUN stack upgrade

RUN stack update

#Install GHC etc. by building empty stack project
RUN stack new temp && \
    cd temp && \
    stack build && \
    cd .. && \
    rm -rf temp

COPY build.sh /home/builder/.local/bin
ENTRYPOINT /home/builder/.local/bin/build.sh
