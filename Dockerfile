ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm

COPY --from=composer:1.10.10 /usr/bin/composer /usr/bin/composer

# sh: 1: ps: not found
# sh: 1: git: not found
# the zip extension and unzip command are both missing, skipping.
RUN apt-get -qq update \
 && apt-get -qq install -y dpkg-sig gnupg gnupg2 git procps zlib1g-dev libzip-dev wget unzip rsyslog --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

ENV VERSION=1.0.0-beta1

COPY entrypoint.sh /bin
# MKDIR /repo_root
COPY sample_app.php /repo_root/

WORKDIR /repo_root

ENTRYPOINT ["/bin/entrypoint.sh"]
