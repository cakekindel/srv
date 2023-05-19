#! /usr/bin/bash

doas git "
docker container ls -q | xargs -I{} docker container stop {};
docker container ls -aq | xargs -I{} docker container rm -f {};

docker compose pull;
docker compose up -d;
"

## SSH Passthrough
## https://docs.gitea.io/en-us/installation/install-with-docker-rootless/#ssh-container-passthrough
##
## Note: 999-post.sh adds a rule to sshd_config and restarts sshd, which
## is required for SSH passthrough to work.
rm /usr/local/bin/gitea-shell || true;

cat << "EOF" >> /usr/local/bin/gitea-shell
#!/bin/sh
/usr/bin/docker context use rootless
/usr/bin/docker exec -i \
  --env SSH_ORIGINAL_COMMAND="$SSH_ORIGINAL_COMMAND" \
  gitea \
  sh "$@"
EOF

chmod +x /usr/local/bin/gitea-shell
usermod -s /usr/local/bin/gitea-shell git
