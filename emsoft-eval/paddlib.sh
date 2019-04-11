#!/bin/sh

rm plog.o
rm libplogs.a
gcc -c -I. plog.c
ar -rc libplogs.a plog.o

