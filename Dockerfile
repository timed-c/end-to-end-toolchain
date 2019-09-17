FROM ubuntu:16.04
LABEL maintainer="saranyan@kth.se"


RUN apt-get update && apt-get install -y ocaml ocaml-native-compilers opam m4
RUN apt-get install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev
RUN apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

RUN opam init
RUN opam config env
RUN opam depext conf-m4.1
RUN opam install cil
RUN opam install yojson
RUN opam install csv
RUN echo $(opam config env)

COPY ktc /opt/e2e/ktc
#COPY ktc/src/mftfg.ml /opt/e2e/ktc/mftfg.ml
COPY  np-schedulability-analysis/ /opt/e2e/timed-c-e2e-sched-analysis
COPY tbb44_20160128oss/include/tbb /opt/e2e/timed-c-e2e-sched-analysis/include/tbb
COPY sensitivity-analysis /opt/e2e/sensitivity-analysis
#COPY script-files/ opt/e2e/project/
COPY  bin opt/e2e/project
COPY  CMakeLists.txt  /opt/e2e/CMakeLists.txt
COPY tbb44_20160128oss/lib/intel64/gcc4.4 /opt/tbb44_20160128oss/lib/intel64/gcc4.4/
WORKDIR /opt/e2e/ktc
RUN ocaml -version
RUN opam --version
RUN ls -la
WORKDIR /opt/e2e/ktc
RUN pwd
RUN eval $(opam config env) && make
WORKDIR /opt/e2e/ktc/test
#RUN eval $(opam config env) && bash run-test.sh
#WORKDIR /opt/ktc/profile-test
#RUN eval $(opam config env) && bash run-end-docker.sh test1.c
WORKDIR /opt/e2e/sensitivity-analysis
RUN eval $(opam config env) && make


WORKDIR /opt
RUN wget https://cmake.org/files/v3.14/cmake-3.14.0-rc4.tar.gz
RUN tar -xzvf cmake-3.14.0-rc4.tar.gz
#COPY cmake-3.14.0-rc4/ /opt/cmake-3.14.0-rc4/
WORKDIR /opt/cmake-3.14.0-rc4/
RUN ./bootstrap
RUN make -j4
RUN make install
RUN cp /opt/e2e/CMakeLists.txt /opt/e2e/timed-c-e2e-sched-analysis/CMakeLists.txt
RUN /opt/cmake-3.14.0-rc4/bin/cmake --version
RUN rm -r /opt/e2e/timed-c-e2e-sched-analysis/build
RUN mkdir /opt/e2e/timed-c-e2e-sched-analysis/build
WORKDIR /opt/e2e/timed-c-e2e-sched-analysis/build
RUN /opt/cmake-3.14.0-rc4/bin/cmake -DUSE_JE_MALLOC=no -DUSE_TBB_MALLOC=no -S /opt/e2e/timed-c-e2e-sched-analysis/ -B /opt/e2e/timed-c-e2e-sched-analysis/build
RUN make

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

COPY sensitivity-analysis/src/sensitivity.ml /opt/e2e/sensitivity-analysis/src/sensitivity.ml
COPY profile-test /opt/e2e/profile-test

# `opam config env`
ENV CAML_LD_LIBRARY_PATH="/root/.opam/system/lib/stublibs:/usr/lib/ocaml/stublibs"
ENV MANPATH="/root/.opam/system/man:"
ENV PERL5LIB="/root/.opam/system/lib/perl5"
ENV OCAML_TOPLEVEL_PATH="/root/.opam/system/lib/toplevel"
ENV PATH="/root/.opam/system/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR /opt/e2e/project

#ENTRYPOINT [ "/opt/e2e/profile-test/run-end.sh" ]
#CMD [ "--help" ]
