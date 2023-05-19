#! /usr/bin/bash

# https://docs.gitea.io/en-us/installation/install-with-docker-rootless/#ssh-container-passthrough
cp ./sshd_config /etc/ssh/sshd_config
systemctl restart sshd
