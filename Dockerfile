FROM debian:10

RUN DEBIAN_FRONTEND="noninteractive" 
RUN apt-get update && apt-get install -y tzdata

RUN apt-get update && \
    apt-get install -y \
    vim \
    git \
    alien \
    nginx \
    python \
    libaio1 \
    python3 \
    python-dev \
    supervisor \
    libssl-dev \
    python3-dev \
    python3-pip \
    libsasl2-dev \
    libldap2-dev \
    default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

ADD oracle/*.rpm /

RUN alien -i oracle-instantclient18.3-basic-18.3.0.0.0-3.x86_64.rpm && \
    alien -i oracle-instantclient18.3-devel-18.3.0.0.0-3.x86_64.rpm && \
    alien -i oracle-instantclient18.3-sqlplus-18.3.0.0.0-3.x86_64.rpm  && \
    echo "/usr/lib/oracle/18.3/client64/lib/" > /etc/ld.so.conf.d/oracle.conf && \
    ldconfig && \
    ln -s /usr/bin/sqlplus64 /usr/bin/sqlplus && \
    rm -f /*.rpm

RUN curl -LO https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2 && tar -xjvf omniORB-4.2.4.tar.bz2 -C /opt
WORKDIR /opt/omniORB-4.2.4/build
RUN ../configure
RUN make
RUN make install

RUN curl -LO https://sourceforge.net/projects/omniorb/files/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2 && tar -xjvf omniORBpy-4.2.4.tar.bz2 -C /opt
WORKDIR /opt/omniORBpy-4.2.4/build
RUN ../configure --prefix=/usr/local/bin --with-omniorb=/usr/local
RUN make
RUN make install
