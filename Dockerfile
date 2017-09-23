FROM	      php:7.0-apache
MAINTAINER  Floris Vedder <florisvedder@hotmail.com>
RUN         apt-get update && apt-get install -y --fix-missing \
            cron \
            git\
            mysql-client\
            nano \
            openssh-server \
            wget \
            zip\
            && rm -rf /var/lib/apt/lists/* ; \
            docker-php-ext-install \
            gd \
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
            composer global require drush/drush:dev-master; \
            echo "export PATH=$PATH:/root/.composer/vendor/bin/" >> /root/.bashrc; \
            /bin/bash -c 'source $HOME/.bashrc';
EXPOSE 8001-8099 2201-2299