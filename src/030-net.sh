#! /usr/bin/bash

ufw default deny incoming
ufw default allow outgoing
ufw status verbose
ufw allow ssh
ufw allow 'Nginx Full'
ufw allow 8880/tcp
ufw --force enable
