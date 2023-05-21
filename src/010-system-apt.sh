#! /usr/bin/bash

apt-get update -y
apt-get upgrade -y
apt-get install -fy \
  nginx \
  man \
  neovim \
  ca-certificates \
  gnupg \
  curl \
  wget \
  dbus-user-session \
  uidmap \
  ufw \
  certbot \
  python3-certbot-nginx \
  git \
  systemd-container \
  fuse-overlayfs \
  slirp4netns

install -m 0755 -d /etc/apt/keyrings
rm /etc/apt/keyrings/docker.gpg || true;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# shellcheck disable=SC2027,SC2046
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
