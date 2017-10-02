FROM	      php:7.0-apache
MAINTAINER  Floris Vedder <florisvedder@hotmail.com>
RUN         apt-get update && apt-get install -y --fix-missing \
            cron \
            curl\
            git\
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libmcrypt-dev \
            libpng12-dev \
            mysql-client\
            nano \
            openssh-server \
            wget \
            zip\
            && rm -rf /var/lib/apt/lists/* ; \
            docker-php-ext-install -j$(nproc) iconv mcrypt \
            && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
            && docker-php-ext-install -j$(nproc) gd; \
            docker-php-ext-install \
            mysqli \
            pdo \
            pdo_mysql; \
            \
            \
            mkdir /var/run/sshd; \
            echo 'root:develop' | chpasswd; \
            sed -ri 's/^#?PermitRootlogin .*$/PermitRootlogin yes/gI' /etc/ssh/sshd_config && \
            sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
            service ssh reload; \
            update-rc.d ssh defaults; \
            \
            \
            echo 'PS1="\e[0;36m[\u:\H \W]\$ \e[m"' >> /root/.bashrc; \
            echo "if [ -t 1 ]; then" >> /root/.bashrc && \
            echo "bind '\"\e[A\": history-search-backward'" >> /root/.bashrc && \
            echo "bind '\"\e[B\": history-search-forward'" >> /root/.bashrc && \
            echo "fi" >> /root/.bashrc; \
            /bin/bash -c 'source $HOME/.bashrc'; \
            \
            \
            pecl install xdebug-2.5.0; \
            a2dissite 000-default.conf; \
            a2enmod vhost_alias; \
            a2enmod rewrite; \
            a2enmod headers; \
            \
            \
            curl -sS https://getcomposer.org/installer | \
            php -- --install-dir=/usr/local/bin --filename=composer; \
            composer global require squizlabs/php_codesniffer; \
            composer global require drush/drush:~8; \
            composer global require drupal/console:@stable; \
            echo "export PATH=$PATH:/root/.composer/vendor/bin/" >> /root/.bashrc; \
            /bin/bash -c 'source $HOME/.bashrc';

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 7.2.1
# @todo: below RUN for installing npm works when in docker but not yet from this script, so needs some fix.
#RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
#  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
#  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
#  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
#  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
#  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
#  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Fix permissions
RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

# Install Drupal Console
RUN curl https://drupalconsole.com/installer -o /usr/local/bin/drupal && \
        chmod +x /usr/local/bin/drupal


EXPOSE 8001-8099 2201-2299