
# GitLab Runner - Docker in Docker Version
# Environment Variables

| Variable | Description | Default/Example | Allowed Values |
|----------|-------------|---------|---------|
| DATA_DIR | Directory where the GitLab Runner configuration is stored | /etc/gitlab-runner ||
| CONFIG_FILE | Path to the GitLab Runner configuration file | $DATA_DIR/config.toml ||
| CA_CERTIFICATES_PATH | Path to the CA certificates file | $DATA_DIR/certs/ca.crt ||
| LOCAL_CA_PATH | Path to the local CA certificates file | /usr/local/share/ca-certificates/ca.crt ||
| GITLAB_URL | URL of the GitLab instance | https://10.10.10.10:8443 ||
| GITLAB_REGISTRATION_TOKEN | Registration token for the GitLab Runner | GLh.....YZ ||
| DEFAULT_IMAGE | Default Docker image for the GitLab Runner | gitlab/gitlab-runner-helper:ubuntu-x86_64-v14.10.2-pwsh ||
| TAG_LIST | Comma-separated list of tags for the GitLab Runner | docker,gitlab,dind ||
| SSH_PORT | Port number for SSH connections | 8443 ||
| EXECUTOR | Executor type for the GitLab Runner | docker+machine | shell, ssh, parallels, docker-windows, instance, custom, virtualbox, docker, docker+machine, kubernetes, docker-autoscaler |

# Running and Registering a GitLab Runner with this image

The minimum required environment to run and register this runner is below:

```bash
docker run -d --name gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /etc/gitlab-runner:/etc/gitlab-runner \
  -e GITLAB_URL=https://10.10.10.10:8443 \
  -e GITLAB_REGISTRATION_TOKEN=GLh.....YZ \
  armyguy255a/gitlab-runner:latest
```

You may need a .env file to store the environment variables when running docker compose. The file would look like this:

```text
HOST_IP=10.10.10.10
REGISTRATION_TOKEN=GLh.....YZ
```

# Integrated Build Environment VM (Hackathon)

This runner's docker compose file is designed specifically for the Hackathon project. A local GitLab instance is required to be running on the host machine. This runner will be able to dynamically register itself with the GitLab instance. There is a convenience Makefile that allows you to experiment and iterate quickly on different versions of the runner. The common make commands are listed below.

`make up` - Start the GitLab Runner \
`make down` - Destroy the GitLab Runner \
`make stop` - Stop the GitLab Runner \
`make start` - Start the GitLab Runner \
`make purge` - Destroy/Delete the GitLab Runner and all associated data 