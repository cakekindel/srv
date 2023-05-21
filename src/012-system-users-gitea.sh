#! /usr/bin/bash

uid_git=${uid_git:-}

## backup gitea data to /tmp
mkdir -p /tmp/git
if id git &>/dev/null; then
  mkdir -p /tmp/git
  mv /home/git/data   /tmp/git/data
  mv /home/git/config /tmp/git/config
else
  mkdir /tmp/git
  mkdir /tmp/git/data
  mkdir /tmp/git/data/git
  mkdir /tmp/git/data/act_runner
  mkdir /tmp/git/config
fi

## delete and recreate `git` user
user_del_if_exist git

echo "$uid_git"
groupadd --gid "$uid_git" git
useradd \
  --gid "$uid_git" \
  --uid "$uid_git" \
  --create-home \
  --shell /bin/bash \
  git

read -rp "enter public ssh key allowing sessions as \`git\`:" git_ssh_pub
user_init git "$git_ssh_pub"

## restore homedir
mv /tmp/git/data   /home/git/
mv /tmp/git/config /home/git/

cp ./gitea-docker-compose.yml /home/git/docker-compose.yml
cp ./gitea-app.ini            /home/git/config/app.ini

touch /home/git/runner-config.yml
touch /home/git/.env.runner

chown -R git:git /home/git
chown -R git:git /home/git/runner-config.yml
chown -R git:git /home/git/.env.runner
chown -R git:git /home/git/data
chown -R git:git /home/git/data/git
chown -R git:git /home/git/data/act_runner
chown -R git:git /home/git/config

chmod -R 777 /home/git/data
chmod -R 777 /home/git/config
