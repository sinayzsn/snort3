FROM ubuntu:22.04

RUN apt-get update
RUN apt install build-essential libpcap-dev libpcre3-dev \
    libnet1-dev zlib1g-dev luajit hwloc libdnet-dev \
    libdumbnet-dev bison flex liblzma-dev openssl libssl-dev \
    pkg-config libhwloc-dev cmake cpputest libsqlite3-dev uuid-dev \
    libcmocka-dev libnetfilter-queue-dev libmnl-dev autotools-dev \
    libluajit-5.1-dev libunwind-dev libfl-dev git wget -y


# Fetch source
RUN mkdir snort-source-files && cd snort-source-files && \
    git clone https://github.com/snort3/libdaq.git && \
    cd libdaq && \
    ./bootstrap && \
    ./configure && \
    make && \
    make install 

# Install google’s thread-caching malloc
RUN cd ../ && \
    wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz && \
    tar xzf gperftools-2.9.1.tar.gz && \
    cd gperftools-2.9.1/ && \
    ./configure && \
    make && \
    make install

# Install Snort3
RUN wget https://github.com/snort3/snort3/archive/refs/tags/3.1.28.0.tar.gz && \
    tar xzf 3.1.28.0.tar.gz && \
    cd snort3-3.1.28.0 && \
    ./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc && \
    cd build && \
    make && \
    make install