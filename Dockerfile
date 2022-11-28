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

# Setting up ssh on host
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY kickstart.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/kickstart.sh
CMD ["/bin/bash", "/usr/local/bin/kickstart.sh"]
ADD VERSION .
CMD ["/usr/bin/supervisord"]
