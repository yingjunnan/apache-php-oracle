# 使用官方的PHP 7.4作为基础镜像
FROM registry.cn-beijing.aliyuncs.com/yingjunnan/php:7.4-apache

# 安装所需的软件包和依赖
RUN apt-get update && apt-get install -y \
    unzip \
    libaio1 \
    libpq-dev \
    libzip-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV ORACLE_HOME=/opt/oracle/instantclient
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH

# 安装MySQL扩展
RUN docker-php-ext-install pdo_mysql mysqli

# 安装Redis扩展
RUN pecl install redis && docker-php-ext-enable redis

# 下载Oracle Instant Client安装包
ADD https://download.oracle.com/otn_software/linux/instantclient/19800/instantclient-basic-linux.x64-19.19.0.0.0dbru.zip /tmp/
ADD https://download.oracle.com/otn_software/linux/instantclient/1919000/instantclient-sdk-linux.x64-19.19.0.0.0dbru.zip /tmp/

RUN mkdir -p /opt/oracle/instantclient && chmod 777 /opt/oracle/instantclient

# 解压安装包并设置Oracle环境变量
RUN unzip /tmp/instantclient-basic-linux.x64-19.19.0.0.0dbru.zip -d /opt/oracle/instantclient && \
    unzip /tmp/instantclient-sdk-linux.x64-19.19.0.0.0dbru.zip -d /opt/oracle/instantclient && \
    rm /tmp/instantclient-basic-linux.x64-19.19.0.0.0dbru.zip && \
    rm /tmp/instantclient-sdk-linux.x64-19.19.0.0.0dbru.zip && \
    && ln -s /opt/oracle/instantclient/libclntsh.so.19.1 /opt/oracle/instantclient/libclntsh.so \
    && ln -s /opt/oracle/instantclient/libocci.so.19.1 /opt/oracle/instantclient/libocci.so \
    && echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

# 安装Oracle扩展
RUN echo 'instantclient,/opt/oracle/instantclient' | pecl install oci8-2.2.0 \
    && docker-php-ext-enable oci8

# 启用Apache的rewrite模块
RUN a2enmod rewrite

# 将Apache的默认网站目录设置为/var/www/html
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 将本地代码复制到容器中的/var/www/html目录
# COPY . /var/www/html

# 暴露Apache的80端口
EXPOSE 80

# 启动Apache服务器
CMD ["apache2-foreground"]
