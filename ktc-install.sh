#!/bin/sh
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
