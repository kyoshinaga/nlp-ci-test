FROM ubuntu:14.04

RUN apt-get -y -q update
RUN apt-get -y -q install gcc make
