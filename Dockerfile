FROM ubuntu:14.04

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF-8

WORKDIR /

RUN apt-get update
RUN apt-get -y -q install software-properties-common python-software-properties git automake automake1.4 gcc g++ make libtool maven

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-add-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get -y -q install oracle-java8-installer apt-transport-https scala git

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
RUN apt-get -y -q update
RUN apt-get -y -q install sbt

WORKDIR /
RUN git clone https://github.com/taku910/crfpp.git
WORKDIR /crfpp
RUN ls
RUN ./autogen.sh
RUN sed -i '/#include "winmain.h"/d' crf_test.cpp
RUN sed -i '/#include "winmain.h"/d' crf_learn.cpp
RUN make
RUN make install
RUN ldconfig

WORKDIR /
RUN git clone https://github.com/taku910/mecab.git
WORKDIR /mecab/mecab
RUN ./autogen.sh
RUN make
RUN make install
RUN ldconfig

WORKDIR /mecab/mecab-ipadic
RUN ./configure --with-charset=utf8
RUN make
RUN make install
RUN ldconfig

WORKDIR /
RUN git clone https://github.com/taku910/cabocha.git
WORKDIR /cabocha
RUN ./autogen.sh --with-charset=utf8
RUN make
RUN make install

WORKDIR /
RUN git clone https://github.com/mynlp/whatswrong_command.git
WORKDIR /whatswrong_command
RUN mvn assembly:assembly
RUN ldconfig
