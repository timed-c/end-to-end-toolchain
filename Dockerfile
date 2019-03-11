FROM ubuntu:16.04
LABEL maintainer="saranyan@kth.se"

RUN apt-get update && apt-get install -y ocaml ocaml-native-compilers opam m4

RUN opam init
RUN opam config env
RUN opam depext conf-m4.1
RUN opam install cil
RUN opam install yojson
RUN opam install csv
RUN echo $(opam config env)

COPY ktc /opt/e2e/ktc
COPY timed-c-e2e-sched-analysis /opt/e2e/timed-c-e2e-sched-analysis
COPY tbb /opt/e2e/timed-c-e2e-sched-analysis/include
COPY sensitivity-analysis /opt/e2e/sensitivity-analysis
WORKDIR /opt/e2e/ktc
RUN ocaml -version
RUN opam --version
RUN ls -la
RUN eval $(opam config env) && make
WORKDIR /opt/e2e/ktc/test
RUN eval $(opam config env) && bash run-test.sh
#WORKDIR /opt/ktc/profile-test
#RUN eval $(opam config env) && bash run-end-docker.sh test1.c

WORKDIR /opt
RUN wget https://cmake.org/files/v3.14/cmake-3.14.0-rc4.tar.gz
RUN tar -xzvf cmake-3.14.0-rc4.tar.gz
WORKDIR /opt/cmake-3.14.0-rc4/
RUN ./bootstrap
RUN make -j4
RUN make install
RUN /opt/cmake-3.14.0-rc4/bin/cmake --version
WORKDIR /opt/e2e/timed-c-e2e-sched-analysis/build
RUN /opt/cmake-3.14.0-rc4/bin/cmake -S /opt/e2e/timed-c-e2e-sched-analysis/ -B /opt/e2e/timed-c-e2e-sched-analysis/build
RUN rm /opt/e2e/timed-c-e2e-sched-analysis/build/CMakeCache.txt
RUN make -j
WORKDIR /opt/e2e/sensitivity-analysis
RUN make



# `opam config env`
ENV CAML_LD_LIBRARY_PATH="/root/.opam/system/lib/stublibs:/usr/lib/ocaml/stublibs"
ENV MANPATH="/root/.opam/system/man:"
ENV PERL5LIB="/root/.opam/system/lib/perl5"
ENV OCAML_TOPLEVEL_PATH="/root/.opam/system/lib/toplevel"
ENV PATH="/root/.opam/system/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR /opt/e2e/

ENTRYPOINT [ "/opt/ktc/bin/ktc" ]
CMD [ "--help" ]
