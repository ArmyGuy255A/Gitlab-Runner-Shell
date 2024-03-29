docker run -d -e "GIT_SSL_NO_VERIFY=1" --name gitlab-dind-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./volumes/config:/etc/gitlab-runner \
  armyguy255a/gitlab-runner:latest run