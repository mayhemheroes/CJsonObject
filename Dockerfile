FROM fuzzers/afl:2.52 as builder

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev
ADD . /CJsonObject
WORKDIR /CJsonObject
RUN mkdir /jsonCorpus
ADD testcase/*.json /jsonCorpus/
WORKDIR ./demo/
RUN make CC=afl-gcc CXX=afl-g++
ADD fuzzers/fuzz_cjson_parser.cpp .
RUN cp ../*.o .
RUN afl-g++ fuzz_cjson_parser.cpp -o /fuzzJsonParse CJsonObject.o cJSON.o -m64 -ggdb

FROM fuzzers/afl:2.52
COPY --from=builder /jsonCorpus /testsuite
COPY --from=builder /fuzzJsonParse /

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite", "-o", "/cjsonOut"]
CMD ["/fuzzJsonParse", "@@"]
