#!/usr/bin/env bash

set -e

cd "$(dirname $0)"

export DOCKER_CLI_HINTS=false

build_date="$(date +%s)"

# Create a label for use during cleanup since the devcontainer CLI does
# not have a "remove" or "down" command yet (though this is planned).
id_label="ci-container=${build_date}"

cleanup() {
    # Clean up.
    echo -e "\nCleaning up..."
    docker rm -f $(docker ps -aq --filter label=${id_label})
}

trap cleanup SIGQUIT EXIT

if [ -z ${SSH_AUTH_SOCK} ]; then
    echo "ERROR: Please run ssh-agent and add corresponding private key."
    exit 1
fi

devcontainer up --id-label ${id_label} --mount "type=bind,source=${SSH_AUTH_SOCK},target=/tmp/ssh-agent.socket" --workspace-folder .

exec_cmd_devcontainer() {
    devcontainer exec \
        --remote-env "SSH_AUTH_SOCK=/tmp/ssh-agent.socket" \
        --remote-env PKR_VAR_proxmox_host=${PROXMOX_HOST} \
        --remote-env PKR_VAR_proxmox_node=${PROXMOX_NODE} \
        --remote-env PKR_VAR_proxmox_node_host=${PROXMOX_NODE_HOST} \
        --remote-env PKR_VAR_proxmox_username=${PROXMOX_USERNAME} \
        --remote-env PKR_VAR_proxmox_token=${PROXMOX_TOKEN} \
        --remote-env PROXMOX_USERNAME=${PROXMOX_USERNAME} \
        --remote-env PROXMOX_TOKEN=${PROXMOX_TOKEN} \
        --remote-env PKR_VAR_proxmox_node_ssh_username=${PROXMOX_NODE_SSH_USERNAME} \
        --remote-env PKR_VAR_proxmox_node_ssh_port=${PROXMOX_NODE_SSH_PORT} \
        --id-label ${id_label} \
        --workspace-folder . \
        $1
}

#exec_cmd_devcontainer "bash"

exec_cmd_devcontainer "packer init ubuntu-24.04-amd64"
exec_cmd_devcontainer "packer fmt ubuntu-24.04-amd64"
exec_cmd_devcontainer "packer validate ubuntu-24.04-amd64"

# Debug
#exec_cmd_devcontainer "--remote-env PACKER_LOG=1 packer build -var-file=ubuntu-24.04-amd64/ubuntu-24.04.pkrvars.hcl -debug ubuntu-24.04-amd64"
exec_cmd_devcontainer "packer build -var-file=ubuntu-24.04-amd64/ubuntu-24.04.pkrvars.hcl ubuntu-24.04-amd64"

# Build and push devcontainer
#devcontainer build --workspace-folder . --push true --image-name <my_image_name>:<optional_image_version>
