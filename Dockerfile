FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev 
RUN git clone https://github.com/Bwar/CJsonObject
WORKDIR /CJsonObject
RUN mkdir /jsonCorpus
COPY testcase/*.json /jsonCorpus/
WORKDIR ./demo/
RUN make CC=afl-gcc CXX=afl-g++
COPY fuzzers/fuzz_cjson_parser.cpp .
RUN cp ../*.o .
RUN afl-g++ fuzz1.cpp -o /fuzzJsonParse CJsonObject.o cJSON.o -m64 -ggdb


ENTRYPOINT ["afl-fuzz", "-i", "/jsonCorpus", "-o", "/jsonOut"]
CMD ["/fuzzJsonParse", "@@"]
