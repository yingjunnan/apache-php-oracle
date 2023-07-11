FROM webdevops/php-apache:7.4

# we need libaio!
RUN apt-get update
RUN apt-get install -y libaio1 libaio-dev zlib1g-dev 
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/
ADD instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/
RUN unzip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_11_2 /usr/local/instantclient
RUN ln -s /usr/local/instantclient/libclntsh.so.11.1 /usr/local/instantclient/libclntsh.so

# set path in environment for additional libraries!
ENV LD_LIBRARY_PATH /usr/local/instantclient_11_2/
ENV ORACLE_HOME /usr/local/instantclient_11_2/
# install
RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.2.0
RUN echo "extension=oci8" > $(pecl config-get ext_dir)/oci8.ini
COPY pdo_oci.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/
RUN echo "extension=pdo_oci" > $(pecl config-get ext_dir)/pdo_oci.ini
# don't know if this is necessary
RUN pecl install xlswriter
RUN docker-php-ext-enable oci8 xlswriter pdo_oci
#RUN ldd /usr/local/lib/php/extensions/no-debug-non-zts-20170718/oci8.so
RUN ldconfig

#restart apache
#RUN service apache2 restart

#show if oci8 is present
#RUN php -i | grep oci8

# export ports
EXPOSE 80 443 
