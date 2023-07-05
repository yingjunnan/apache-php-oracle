FROM webdevops/php-apache:7.4
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/oracle \
    && cd /opt/oracle \
    && wget https://download.oracle.com/otn_software/linux/instantclient/199000/instantclient-basic-linux.x64-19.9.0.0.0dbru.zip \
    && unzip instantclient-basic-linux.x64-19.9.0.0.0dbru.zip \
    && rm instantclient-basic-linux.x64-19.9.0.0.0dbru.zip \
    && rm -rf /var/lib/apt/lists/*
# �~P��~T�Apache�~Z~Drewrite模�~]~W
RUN a2enmod rewrite

# 设置Oracle Instant Client�~N��~C�~O~X�~G~O
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_9
