# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less man wget tar git gzip unzip make cmake software-properties-common curl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y clang

RUN wget http://downloads.dlang.org/releases/2.x/2.099.1/dmd_2.099.1-0_amd64.deb -O dmd.deb
RUN apt install -y ./dmd.deb

ADD . /repo
WORKDIR /repo
RUN ln -s /usr/lib/llvm-10/lib/libclang.so.1 /usr/lib/llvm-10/lib/libclang.so
RUN ./configure --llvm-path=/usr/lib/llvm-10/
RUN dub build
