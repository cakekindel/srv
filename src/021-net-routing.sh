#! /usr/bin/bash

domain_root=${domain_root:-}

mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

rm -r "/etc/nginx/sites-available/$domain_root" 2>/dev/null || true
rm -r "/etc/nginx/sites-enabled/$domain_root" 2>/dev/null || true

touch "/etc/nginx/sites-available/$domain_root"
ln -s "/etc/nginx/sites-available/$domain_root" "/etc/nginx/sites-enabled/$domain_root"

cp ./nginx.conf "/etc/nginx/sites-available/$domain_root"
chmod 777 "/etc/nginx/sites-available/$domain_root"

systemctl enable nginx
systemctl start nginx
