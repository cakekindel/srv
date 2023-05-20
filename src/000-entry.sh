#! /usr/bin/bash

set -xo pipefail

domain_root="${DOMAIN_ROOT:-orionkindel.com}"
subdomain_gitea="${SUBDOMAIN_GITEA:-git}"

uid_git="${UID_GIT:-1000}"

# Creates a login session for `user` (positional argument 1) in their home directory,
# and executes a bash command string (positional argument 2) as `user`.
#
# Differs from `su` in that the new session is entirely isolated from the current
# environment and allows using user-space session utils like systemctl.
#
# Currently uses `ssh $1@localhost` using `/root/.ssh/local_ed25519`, meaning user
# must have `/root/.ssh/local_ed25519.pub` in their `authorized_keys`.
#
# ```sh
# > doas orion "pwd"
# /home/orion/
# > export FOO=bar
# > doas orion "echo $FOO"
# bar
# > doas orion "echo \$FOO"
# > doas orion "systemctl --user status docker"
# ...
# ```
function doas {
  ssh -F /dev/null -o IdentitiesOnly=yes -i /root/.ssh/local_ed25519 $1@localhost "set -xo pipefail; $2"
}

rm /root/.ssh/local_ed25519 || true;
rm /root/.ssh/local_ed25519.pub || true;
ssh-keygen -t ed25519 -C "local" -f /root/.ssh/local_ed25519 -P ''

cp ./sshd_config.presetup /etc/ssh/sshd_config
systemctl restart sshd

source ./010-system-apt.sh
source ./011-system-users.sh
source ./020-net.sh
source ./021-net-routing.sh
source ./022-net-ssl.sh
source ./030-gitea-actions.sh
source ./031-gitea.sh
source ./999-post.sh
