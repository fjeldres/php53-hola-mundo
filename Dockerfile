FROM debian:bullseye-slim

# Dependencias para compilar PHP 5.3 y Apache
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    apache2-dev \
    build-essential \
    wget \
    ca-certificates \
    libxml2-dev \
    libbz2-dev \
    && rm -rf /var/lib/apt/lists/*

# Compilar PHP 5.3.29 desde el museo oficial de PHP
# CFLAGS necesarios para compilar PHP 5.3 con GCC moderno (10+)
RUN wget -q https://museum.php.net/php5/php-5.3.29.tar.gz \
    && tar xzf php-5.3.29.tar.gz \
    && cd php-5.3.29 \
    && CFLAGS="-O2 \
               -Wno-implicit-function-declaration \
               -Wno-deprecated-declarations \
               -Wno-incompatible-pointer-types \
               -Wno-int-conversion \
               -Wno-stringop-truncation" \
       ./configure \
            --with-apxs2=/usr/bin/apxs2 \
            --enable-json \
            --enable-mbstring \
            --without-openssl \
            --without-mysql \
            --without-sqlite3 \
            --without-pdo-sqlite \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf php-5.3.29 php-5.3.29.tar.gz

# Activar módulo PHP en Apache
RUN echo 'LoadModule php5_module /usr/lib/apache2/modules/libphp5.so' \
        > /etc/apache2/mods-enabled/php5.load \
    && printf '<IfModule mod_php5.c>\n\
  AddType application/x-httpd-php .php\n\
  DirectoryIndex index.php index.html\n\
</IfModule>\n' > /etc/apache2/mods-enabled/php5.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2dismod mpm_event \
    && a2enmod mpm_prefork

COPY index.php /var/www/html/index.php

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
