#! /usr/bin/bash

function user_del_if_exist {
  if id "$1" &>/dev/null; then
    set +x
    grp=`id -g $1`
    # https://i.imgflip.com/3ggbcq.jpg
    until userdel $1; do pkill -eU $1 || true; done;
    set -x
    groupdel $grp || true
    rm -rf /home/$1 || true
  fi
}

function user_init {
  loginctl enable-linger $1

  rm -r /home/$1/.ssh || true
  mkdir /home/$1/.ssh
  chown $1:$1 /home/$1/.ssh

  cp /root/.ssh/local_ed25519.pub /home/$1/.ssh/authorized_keys
  chown $1:$1 /home/$1/.ssh/authorized_keys
  chmod 600 /home/$1/.ssh/authorized_keys

  doas $1 "
  echo $2 >> ~/.ssh/authorized_keys;
  echo \"export DOCKER_HOST=unix:///run/user/`id -u $1`/docker.sock\" > ~/.bashrc;
  echo \"export PATH=/usr/bin:/usr/sbin:$PATH\" >> ~/.bashrc;
  source ~/.bashrc;
  dockerd-rootless-setuptool.sh install;
  systemctl --user enable docker;
  systemctl --user start docker;
  "
}

source ./012-system-users-gitea.sh
source ./013-system-users-other.sh
