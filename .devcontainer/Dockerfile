# DevContainer Dockerfile for Debian-based development environment

# Use Microsoft's base Dev Container
FROM mcr.microsoft.com/devcontainers/base:debian-12

# Default user configuration
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Additional installations and configurations
USER root

# Install basic tools and dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    apt-utils \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    nano \
    vim \
    unzip \
    sudo \
    zsh \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI if not already installed
RUN if ! [ -x "$(command -v gh)" ]; then \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y; \
    fi

# [Option] Install nvm and Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="20"
ENV NVM_DIR=/usr/local/share/nvm
RUN if [ "${INSTALL_NODE}" = "true" ]; then \
    mkdir -p ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && . ${NVM_DIR}/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default \
    && npm install -g npm yarn typescript ts-node @types/node; \
    fi

# [Option] Install pyenv and Python
ARG INSTALL_PYTHON="true"
ARG PYTHON_VERSION="3.11"
ENV PYENV_ROOT /usr/local/pyenv
RUN if [ "${INSTALL_PYTHON}" = "true" ]; then \
    git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT} \
    && cd ${PYENV_ROOT} && src/configure && make -C src \
    && echo 'export PYENV_ROOT="/usr/local/pyenv"' >> /etc/bash.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/bash.bashrc \
    && echo 'eval "$(pyenv init -)"' >> /etc/bash.bashrc \
    && export PYENV_ROOT="/usr/local/pyenv" \
    && export PATH="$PYENV_ROOT/bin:$PATH" \
    && eval "$(pyenv init -)" \
    && pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION} \
    && pip install --upgrade pip setuptools wheel; \
    fi

# [Option] Install Bun
ARG INSTALL_BUN="true"
ARG VERSION_BUN="1.0.35"
RUN if [ "${INSTALL_BUN}" = "true" ]; then \
    curl -fsSL https://bun.sh/install | bash \
    && mv /root/.bun /usr/local/share/bun \
    && chown -R ${USERNAME}:${USERNAME} /usr/local/share/bun \
    && echo 'export BUN_INSTALL="/usr/local/share/bun"' >> /etc/bash.bashrc \
    && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/bash.bashrc \
    && ln -s /usr/local/share/bun/bin/bun /usr/local/bin/bun; \
    fi

# [Option] Install Deno
ARG INSTALL_DENO="true"
ARG VERSION_DENO="1.40.5"
RUN if [ "${INSTALL_DENO}" = "true" ]; then \
    curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh -s v${VERSION_DENO} \
    && ln -s /usr/local/bin/deno /usr/bin/deno; \
    fi

# [Option] Install Docker client
ARG INSTALL_DOCKER="true"
RUN if [ "${INSTALL_DOCKER}" = "true" ]; then \
    apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install docker.io docker-compose \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*; \
    fi

# [Option] Install Java
ARG INSTALL_JAVA="true"
ARG VERSION_JAVA="17"
RUN if [ "${INSTALL_JAVA}" = "true" ]; then \
    apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install openjdk-${VERSION_JAVA}-jdk maven gradle \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*; \
    fi

# [Option] Install Go
ARG INSTALL_GO="true"
ARG VERSION_GO="1.22.2"
RUN if [ "${INSTALL_GO}" = "true" ]; then \
    wget https://golang.org/dl/go${VERSION_GO}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${VERSION_GO}.linux-amd64.tar.gz \
    && rm go${VERSION_GO}.linux-amd64.tar.gz \
    && echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/bash.bashrc; \
    fi

# [Option] Install Rust
ARG INSTALL_RUST="true"
ARG VERSION_RUST="stable"
RUN if [ "${INSTALL_RUST}" = "true" ]; then \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${VERSION_RUST} --no-modify-path \
    && echo "export PATH=/root/.cargo/bin:$PATH" >> /etc/bash.bashrc \
    && echo "export PATH=/home/${USERNAME}/.cargo/bin:$PATH" >> /home/${USERNAME}/.bashrc; \
    fi

# [Option] Install oh-my-zsh
ARG INSTALL_OHMYZSH="true"
RUN if [ "${INSTALL_OHMYZSH}" = "true" ]; then \
    if [ ! -d "/root/.oh-my-zsh" ]; then \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    fi \
    && if [ ! -d "/home/${USERNAME}/.oh-my-zsh" ]; then \
        mkdir -p /home/${USERNAME}/.oh-my-zsh \
        && cp -R /root/.oh-my-zsh/* /home/${USERNAME}/.oh-my-zsh/ \
        && cp /root/.zshrc /home/${USERNAME}/.zshrc 2>/dev/null || echo "No .zshrc found to copy" \
        && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.oh-my-zsh /home/${USERNAME}/.zshrc 2>/dev/null || true; \
    fi \
    && echo "exec zsh" >> /home/${USERNAME}/.bashrc; \
    fi

# [Option] Install kubectl
ARG INSTALL_KUBECTL="true"
ARG VERSION_KUBECTL="v1.29.0"
RUN if [ "${INSTALL_KUBECTL}" = "true" ]; then \
    curl -LO "https://dl.k8s.io/release/${VERSION_KUBECTL}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/; \
    fi

# [Option] Install minikube
ARG INSTALL_MINIKUBE="true"
ARG VERSION_MINIKUBE="v1.32.0"
RUN if [ "${INSTALL_MINIKUBE}" = "true" ]; then \
    curl -LO https://storage.googleapis.com/minikube/releases/${VERSION_MINIKUBE}/minikube-linux-amd64 \
    && chmod +x minikube-linux-amd64 \
    && mv minikube-linux-amd64 /usr/local/bin/minikube; \
    fi

# Make environment configuration available for all users
RUN echo "source ${NVM_DIR}/nvm.sh" >> /etc/bash.bashrc \
    && chmod -R a+w ${NVM_DIR} \
    && chmod -R a+w ${PYENV_ROOT} \
    && echo 'export BUN_INSTALL="/usr/local/share/bun"' >> /etc/bash.bashrc \
    && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/bash.bashrc \
    && echo 'export PATH="/usr/local/bin/deno:$PATH"' >> /etc/bash.bashrc

# Setup environment variables
ENV PATH="/usr/local/bin:${PATH}"
ENV SHELL="/bin/bash"
ENV LANG="C.UTF-8"

# Set default user
USER ${USERNAME}
WORKDIR /workspace/devden

CMD ["/bin/bash"]
