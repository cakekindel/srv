#! /usr/bin/bash

user_del_if_exist orion
useradd --create-home --shell /bin/bash orion
read -rp "enter public ssh key allowing sessions as \`orion\`:" orion_ssh_pub
user_init orion "$orion_ssh_pub"
