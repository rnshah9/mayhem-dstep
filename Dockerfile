FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential clang wget git

RUN wget http://downloads.dlang.org/releases/2.x/2.099.1/dmd_2.099.1-0_amd64.deb -O dmd.deb
RUN apt install -y ./dmd.deb

ADD . /repo
WORKDIR /repo
RUN ln -s /usr/lib/llvm-10/lib/libclang.so.1 /usr/lib/llvm-10/lib/libclang.so
RUN ./configure --llvm-path=/usr/lib/llvm-10/
RUN dub build

RUN mkdir -p /deps
RUN ldd /repo/bin/dstep | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/bin/dstep /repo/bin/dstep
ENV LD_LIBRARY_PATH=/deps
