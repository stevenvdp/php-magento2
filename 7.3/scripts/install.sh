#!/bin/sh

set -e

# install packages
apt-get update

extensions -i bcmath gd intl mbstring mysql readline redis soap sodium xsl amqp

apt-get clean -y

# magento needs a bit more memory than 256M
sed -e 's/^\(memory_limit\).*/\1 = 1024M/' \
    -i /etc/php/${DW_PHP_VERSION}/mods-available/custom.ini

sed -e 's/\(max_nesting_level\).*/\1=1000/' \
    -i /etc/php/${DW_PHP_VERSION}/mods-available/xdebug.ini

# install magerun
curl -sS -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun2.phar
chmod +x /usr/local/bin/magerun

# install composer v1
if [[ -e /usr/local/bin/composer ]]; then
    rm /usr/local/bin/composer
fi

curl -LsS https://getcomposer.org/installer | \
    php -- --version=1.10.16 --install-dir=/usr/local/lib --filename=composer
chmod +x /usr/local/lib/composer
ln -s /usr/local/lib/composer /usr/local/bin/composer

# update permissions to allow rootless operation
/usr/local/bin/permissions
