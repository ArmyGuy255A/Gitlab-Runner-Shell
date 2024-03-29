FROM gitlab/gitlab-runner:ubuntu-v16.10.0

LABEL Author="Phil Dieppa"
LABEL Email="mrdieppa@gmail.com"
LABEL GitHub="https://github.com/ArmyGuy255A"
LABEL BaseImage="ubuntu:20.04"

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

ARG PACKER_VERSION=1.10.0
ARG TERRAFORM_VERSION=1.7.3
ARG AZURE_CLI_VERSION=2.58.0
ARG POWERSHELL_VERSION=7.4.1

# update the base packages + add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip \
    zip ca-certificates apt-transport-https gpg software-properties-common && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install HashiCorp GPG Keys
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

# Install Azure CLI GPG Keys
RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list

# Install Terraform
RUN # install terraform and packer
RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    rm terraform.zip

# Add a non-sudo user called build-agent
RUN useradd -ms /bin/bash build-agent

# Create the Terraform plugin Cache directory
RUN mkdir /home/build-agent/.terraform.d/plugin-cache -p && \
    chown build-agent:build-agent /home/build-agent/.terraform.d -R && \
    chmod +x /home/build-agent/.terraform.d -R

# Create the Terraform Plugin Cache directory
RUN mkdir /home/build-agent/.terraform.d/plugin-cache -p && \
    chown build-agent:build-agent /home/build-agent/.terraform.d -R && \
    chmod +x /home/build-agent/.terraform.d -R

# Install Packer
RUN curl -L https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer.zip && \
    unzip packer.zip -d /usr/local/bin && \
    rm packer.zip

# Install Azure CLI and Hashicorp Vault
RUN apt-get update && \
    apt-get install -y azure-cli=${AZURE_CLI_VERSION}-1~$(lsb_release -cs) vault && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PowerShell
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb && \
    dpkg -i powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb && \
    apt-get update -y && apt-get install -f && \
    rm powershell_${POWERSHELL_VERSION}-1.deb_amd64.deb && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add Pester
ADD add/PesterTestTemplate /home/build-agent/PesterTestTemplate
ADD add/Pester /opt/microsoft/powershell/7/Modules/Pester

ADD scripts/unregister.sh /unregister.sh
ADD entrypoint /entrypoint
RUN chmod +x /entrypoint /unregister.sh

STOPSIGNAL SIGQUIT
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]