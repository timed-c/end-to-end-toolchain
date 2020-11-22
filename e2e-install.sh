#!/bin/sh
git submodule init
git pull
git submodule init
git submodule update
cd /vagrant
git submodule init
git submodule update
echo "********Installing KTC********"
sudo apt-get update && apt-get install -y ocaml ocaml-native-compilers opam m4
opam init
opam config env
opam depext conf-m4.1
opam install ocamlbuild
opam install cil
opam install yojson
opam install csv
echo $(opam config env)
ocaml -version
opam --version
cd /vagrant/ktc
eval $(opam config env) && make
echo "********KTC Install Complete********"
echo "********Installing Sensitivity Analysis********"
cd /vagrant/sensitivity-analysis/
eval $(opam config env) && make
echo "********Sensitivity Analysis Install Complete********"
echo "********Installing CMAKE********"
#cd /vagrant
#wget https://cmake.org/files/v3.14/cmake-3.14.0-rc4.tar.gz
#tar -xzvf cmake-3.14.0-rc4.tar.gz
#rm cmake-3.14.0-rc4.tar.gz
#cd /vagrant/cmake-3.14.0-rc4/
#./bootstrap
#make -j4
#make install
echo "********CMAKE Install Complete********"
echo "********Installing np-schedulability-analysis********"
#cd /vagrant
#cp -r /vagrant/tbb44_20160128oss/include/tbb /vagrant/np-schedulability-analysis/include/tbb
#cp /vagrant/CMakeLists.txt /vagrant/np-schedulability-analysis/CMakeLists.txt
#rm -r /vagrant/np-schedulability-analysis/build
#mkdir /vagrant/np-schedulability-analysis/build
#cd /vagrant/np-schedulability-analysis/build
#/vagrant/cmake-3.14.0-rc4/bin/cmake -DUSE_JE_MALLOC=no -DUSE_TBB_MALLOC=no -S /vagrant/np-schedulability-analysis/ -B /vagrant/np-schedulability-analysis/build
#make 
echo "********np-schedulability-analysis install Complete********"
apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip
echo "********Install MCB32********"
sudo apt-get install bzip2 make libftdi-dev
cd /vagrant/mcb 
chmod +x mcb32tools-v2.2-x86_64-linux-gnu.run
sudo ./mcb32tools-v2.2-x86_64-linux-gnu.run
cd /vagrant 
git clone https://github.com/timed-c/kta.git
cd /vagrant/kta 
make
export KTA_WCET_RUNTIME_PATH=/vagrant/kta/runtime
echo "********Installing OTAWA********"
cd /vagrant/otawa 
wget www.tracesgroup.net/otawa/packages/otawa-build-3.tgz
tar -xvzf otawa-build-3.tgz
rm -r otawa-build-3.tgz
rm -r otawa-build-3.tgz.1
wget http://www.tracesgroup.net/otawa/packages/otawa-install.py
chmod 777 otawa-install.py
sudo apt-get -y install libxml2-dev
sudo apt-get -y install libxslt1-dev 
sudo apt-get -y install flex bison
./otawa-install.py -R /vagrant/otawa
cd /vagrant/otawa/bin 
chmod 777 otawa-install.py
./otawa-install.py elm
./otawa-install.py buddybdd
./otawa-install.py otawa-lpc2138
./otawa-install.py otawa-lp_solve5
./otawa-install.py otawa-arm
./otawa-install.py gel 
./otawa-install.py otawa-tricore
./otawa-install.py otawa
./otawa-install.py orange
echo "********Install KTC command-line*******"
cd /vagrant 
make clean && make

