#!/bin/bash

# Check if a container name argument has been provided
if [ -z "$1" ]; then
  echo "Usage: $0 <container_name>"
  exit 1
fi

containerName=$1

GITLAB_IP=$(ip addr show ens192 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
registrationToken=$(cat registration-token.txt )

docker exec -it $containerName /bin/bash entrypoint register \
  --non-interactive \
  --executor "docker" \
  --docker-image "gitlab/gitlab-runner-helper:ubuntu-x86_64-v14.10.2-pwsh" \
  --docker-volumes "/var/run/docker.sock" \
  --registration-token $registrationToken \
  --description "docker-runner" \
  --tag-list "docker,gitlab,dind" \
  --run-untagged="true" \
  --locked="false" \
  --url "https://$GITLAB_IP:8443" \
  --ssh-port "8443"
