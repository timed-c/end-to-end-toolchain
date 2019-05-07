#!/bin/sh

rm mplog.o
rm libmplogs.a
gcc -c -I. mplog.c
ar -rc libmplogs.a mplog.o

