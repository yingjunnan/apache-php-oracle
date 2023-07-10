FROM webdevops/php-apache:7.4
  
# we need libaio!
RUN apt-get update
RUN apt-get install -y libaio1 libaio-dev
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

# install
RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.2.0
RUN echo "extension=oci8" > $(pecl config-get ext_dir)/oci8.ini

# don't know if this is necessary
RUN docker-php-ext-enable oci8
#RUN ldd /usr/local/lib/php/extensions/no-debug-non-zts-20170718/oci8.so
RUN ldconfig

#restart apache
#RUN service apache2 restart

#show if oci8 is present
#RUN php -i | grep oci8

# export ports
EXPOSE 80 443
