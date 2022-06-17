FROM python:3.7

RUN DEBIAN_FRONTEND="noninteractive" 
RUN apt-get update && apt-get install -y tzdata

RUN apt-get update && \
    apt-get install -y \
    git \
    php \
    xvfb \
    alien \
    nginx \
    omniorb \
    libaio1 \
    supervisor \
    libssl-dev \
    libgconf-2-4 \
    libsasl2-dev \
    libldap2-dev \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
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

RUN curl -LO https://razaoinfo.dl.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.3/omniORB-4.2.3.tar.bz2 && tar -xjvf omniORB-4.2.3.tar.bz2 -C /opt
WORKDIR /opt/omniORB-4.2.3
RUN ./configure
RUN make
RUN make install

RUN curl -LO https://ufpr.dl.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.3/omniORBpy-4.2.3.tar.bz2 && tar -xjvf omniORBpy-4.2.3.tar.bz2 -C /opt
WORKDIR /opt/omniORBpy-4.2.3
RUN ./configure --with-omniorb=/usr/local
RUN make
RUN make install
