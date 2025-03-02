# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.187.0/containers/python-3/.devcontainer/base.Dockerfile
# https://github.com/devcontainers/images/blob/main/src/typescript-node/.devcontainer/Dockerfile
# https://github.com/devcontainers/templates/blob/main/src/python/.devcontainer/devcontainer.json


# [Choice] Python version: 3, 3.11, 3.10, 3.9, 3.8, 3.7, 3.6
ARG VARIANT="3.12-bookworm"
FROM mcr.microsoft.com/devcontainers/python:1-${VARIANT}
#FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

ARG USERNAME="vscode"
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Create the user
RUN if [ "$USERNAME" != "vscode" ]; then groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi
RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then groupmod --gid $USER_GID $USERNAME && usermod --uid $USER_UID --gid $USER_GID $USERNAME; fi
# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME; fi

# [Option] Install Node.js
ARG INSTALL_NODE="true"
# lts/*, 20.17.0
ARG NODE_VERSION="22.7.0"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su $USERNAME -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install tslint, typescript. eslint is installed by javascript image
ARG NODE_MODULES="tslint-to-eslint-config typescript ts-node @types/node yarn"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su $USERNAME -c "umask 0002 && npm install -g ${NODE_MODULES}" \
    && npm cache clean --force > /dev/null 2>&1; fi

# [Option] Install Docker client
ARG INSTALL_DOCKER="true"
# Let's start with some basic stuff.
RUN if [ "${INSTALL_DOCKER}" = "true" ]; then apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables; fi
# Install Docker from Docker Inc. repositories.
RUN if [ "${INSTALL_DOCKER}" = "true" ]; then curl -sSL https://get.docker.com/ | sh; fi


# [Option] Install Docker client
ARG INSTALL_DENO="true"
ARG DENO_VERSION="v1.40.5"
RUN if [ "${INSTALL_DENO}" = "true" ]; then curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh -s ${DENO_VERSION}; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su ${USERNAME} -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME