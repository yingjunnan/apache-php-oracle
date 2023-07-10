FROM webdevops/php-apache:7.4
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



RUN mkdir /opt/oracle \
    && cd /opt/oracle \
    && wget https://download.oracle.com/otn/linux/instantclient/11204/instantclient-basic-linux.x64-11.2.0.4.0.zip?AuthParam=1688955983_912e3ee6db80d07495bfbdea5265cd63 \
    && wget https://download.oracle.com/otn/linux/instantclient/11204/instantclient-sdk-linux.x64-11.2.0.4.0.zip?AuthParam=1688956011_c36b482f5df52bde4f1e1731c11599e2 \
    && unzip instantclient-basic-linux.x64-11.2.0.4.0.zip \
    && unzip instantclient-sdk-linux.x64-11.2.0.4.0.zip \
    && rm instantclient-basic-linux.x64-11.2.0.4.0.zip \
    && rm instantclient-sdk-linux.x64-11.2.0.4.0.zip \
    && rm -rf /var/lib/apt/lists/*
# �~P��~T�Apache�~Z~Drewrite模�~]~W
# 设置Oracle Instant Client�~N��~C�~O~X�~G~O
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_11_2
ENV ORACLE_HOME=/opt/oracle/instantclient_11_2

RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/opt/oracle/instantclient_11_2 && \
    docker-php-ext-install oci8
    
RUN a2enmod rewrite


