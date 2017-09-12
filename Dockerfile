FROM	      php:7.0-apache
MAINTAINER  Floris Vedder
RUN         apt-get update && apt-get install -y --fix-missing \
            nano \
            wget \
            openssh-server \
            git\
            zip\
            mysql-server\
            && rm -rf /var/lib/apt/lists/* ; \
            docker-php-ext-install mysqli; \
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
            \
            \
            curl --silent --show-error https://getcomposer.org/installer | php;\
            mv composer.phar /usr/local/bin/composer; \
            composer global require squizlabs/php_codesniffer; \
            echo "export PATH=$PATH:/root/.composer/vendor/bin/" >> /root/.bashrc; \
            /bin/bash -c 'source $HOME/.bashrc';
EXPOSE 8001-8099 2201-2299