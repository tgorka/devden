# DevContainer Dockerfile for Debian-based development environment

# Base image configuration
ARG VARIANT="debian-12"
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

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
    zip \
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
ARG INSTALL_NODE="false"
ARG NODE_VERSION="22"
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

# [Option] Install Python via system packages and venv
ARG INSTALL_PYTHON="false"
ARG VERSION_PYTHON="3.12"
ENV PYTHON_ROOT=/usr/local/python
RUN if [ "${INSTALL_PYTHON}" = "true" ]; then \
    apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Install Python from Debian repositories
    && apt-get -y install --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
    # Create a virtual environment
    && python3 -m venv ${PYTHON_ROOT} \
    # Upgrade pip and install common packages
    && ${PYTHON_ROOT}/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
    && ${PYTHON_ROOT}/bin/pip install --no-cache-dir ipython \
    # Create symlinks
    && ln -sf ${PYTHON_ROOT}/bin/python /usr/local/bin/python \
    && ln -sf ${PYTHON_ROOT}/bin/pip /usr/local/bin/pip \
    # Set appropriate permissions
    && chown -R ${USERNAME}:${USERNAME} ${PYTHON_ROOT} \
    # Cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*; \
    fi

# [Option] Install Bun
ARG INSTALL_BUN="false"
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
ARG INSTALL_DENO="false"
ARG VERSION_DENO="1.40.5"
RUN if [ "${INSTALL_DENO}" = "true" ]; then \
    curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh -s v${VERSION_DENO} \
    && ln -s /usr/local/bin/deno /usr/bin/deno; \
    fi

# [Option] Install Docker client
ARG INSTALL_DOCKER="false"
RUN if [ "${INSTALL_DOCKER}" = "true" ]; then \
    apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install docker.io docker-compose \
    # Add the vscode user to the docker group to avoid permission issues
    && if getent group docker >/dev/null; then \
       usermod -aG docker ${USERNAME}; \
    fi \
    # Ensure docker.sock has appropriate permissions if it exists
    && if [ -e /var/run/docker.sock ]; then \
       chmod 666 /var/run/docker.sock || true; \
    fi \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*; \
    fi

# [Option] Install SDKMAN and Java/Kotlin
ARG INSTALL_JAVA="false"
ARG VERSION_JAVA="23"
ARG INSTALL_KOTLIN="false"
ARG VERSION_KOTLIN="1.9.22"

# Export ARGs to ENV variables so they're available at runtime
ENV INSTALL_JAVA=${INSTALL_JAVA}
ENV VERSION_JAVA=${VERSION_JAVA}
ENV INSTALL_KOTLIN=${INSTALL_KOTLIN}
ENV VERSION_KOTLIN=${VERSION_KOTLIN}
ENV SDKMAN_DIR=/usr/local/sdkman

# Install SDKMAN only
RUN apt-get update && apt-get install -y zip unzip \
    # Create SDKMAN directory with correct permissions first
    && mkdir -p ${SDKMAN_DIR} \
    && chown -R ${USERNAME}:${USERNAME} ${SDKMAN_DIR} \
    && chmod -R 755 ${SDKMAN_DIR} \
    # Create a setup script for SDKMAN that will be run as the vscode user
    && { \
        echo '#!/bin/bash'; \
        echo "export SDKMAN_DIR=${SDKMAN_DIR}"; \
        echo 'curl -s "https://get.sdkman.io" | bash'; \
        echo "sed -i -e 's|/home/${USERNAME}/.sdkman|${SDKMAN_DIR}|g' ${SDKMAN_DIR}/etc/config"; \
    } > /tmp/install_sdkman.sh \
    && chmod +x /tmp/install_sdkman.sh \
    # Run the installation as the vscode user
    && su ${USERNAME} -c "bash /tmp/install_sdkman.sh" \
    # Fix any remaining references to the default location
    && find ${SDKMAN_DIR} -type f -exec sed -i -e "s|/home/${USERNAME}/.sdkman|${SDKMAN_DIR}|g" {} \; 2>/dev/null || true \
    # Add SDKMAN to the bash environment
    && echo "export SDKMAN_DIR=${SDKMAN_DIR}" >> /etc/bash.bashrc \
    && echo "source ${SDKMAN_DIR}/bin/sdkman-init.sh" >> /etc/bash.bashrc \
    && echo "export SDKMAN_DIR=${SDKMAN_DIR}" >> /home/${USERNAME}/.bashrc \
    && echo "source ${SDKMAN_DIR}/bin/sdkman-init.sh" >> /home/${USERNAME}/.bashrc \
    # Double-check permissions
    && chown -R ${USERNAME}:${USERNAME} ${SDKMAN_DIR} \
    && chmod -R 755 ${SDKMAN_DIR} \
    # Cleanup
    && rm -f /tmp/install_sdkman.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Make scripts executable - using absolute paths with the build context
COPY install-java.sh install-kotlin.sh /tmp/
RUN chmod +x /tmp/install-java.sh /tmp/install-kotlin.sh \
    && mv /tmp/install-java.sh /tmp/install-kotlin.sh /usr/local/bin/

# [Option] Install GVM and Go
ARG INSTALL_GO="false"
ARG VERSION_GO="1.20.4"
ENV GVM_DIR=/home/vscode/.gvm
RUN if [ "${INSTALL_GO}" = "true" ]; then \
    apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install bison \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    # Download the installer script first
    && curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /tmp/gvm-installer \
    && chmod +x /tmp/gvm-installer \
    # Create the vscode user's directory with correct ownership
    && mkdir -p /home/${USERNAME} \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
    # Install GVM as the vscode user
    && su ${USERNAME} -c "bash /tmp/gvm-installer" \
    && rm -f /tmp/gvm-installer \
    # Ensure correct permissions
    && chown -R ${USERNAME}:${USERNAME} ${GVM_DIR} \
    && chmod -R 755 ${GVM_DIR} \
    # Create a shell script to install Go as the vscode user
    && { \
        echo '#!/bin/bash'; \
        echo "source ${GVM_DIR}/scripts/gvm"; \
        echo "gvm install go${VERSION_GO} -B"; \
        echo "gvm use go${VERSION_GO} --default"; \
    } > /tmp/install_go.sh \
    && chmod +x /tmp/install_go.sh \
    # Install Go as the vscode user
    && su ${USERNAME} -c "bash /tmp/install_go.sh" \
    # Add GVM to the bash environment
    && echo "export GVM_DIR=${GVM_DIR}" >> /etc/bash.bashrc \
    && echo "source ${GVM_DIR}/scripts/gvm" >> /etc/bash.bashrc \
    && echo "export GVM_DIR=${GVM_DIR}" >> /home/${USERNAME}/.bashrc \
    && echo "source ${GVM_DIR}/scripts/gvm" >> /home/${USERNAME}/.bashrc \
    # Cleanup
    && rm -f /tmp/install_go.sh; \
    fi

# [Option] Install RSVM and Rust
ARG INSTALL_RUST="false"
ARG VERSION_RUST="1.76.0"
ENV RSVM_DIR=/usr/local/rsvm
RUN if [ "${INSTALL_RUST}" = "true" ]; then \
    git clone https://github.com/sdepold/rsvm.git ${RSVM_DIR} \
    && cd ${RSVM_DIR} \
    && ./install.sh \
    && bash -c "source ${RSVM_DIR}/rsvm.sh && rsvm install ${VERSION_RUST} && rsvm use ${VERSION_RUST}" \
    && echo "source ${RSVM_DIR}/rsvm.sh" >> /etc/bash.bashrc \
    && echo "source ${RSVM_DIR}/rsvm.sh" >> /home/${USERNAME}/.bashrc; \
    fi

# [Option] Install oh-my-zsh
ARG INSTALL_OHMYZSH="false"
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
ARG INSTALL_KUBECTL="false"
ARG VERSION_KUBECTL="v1.29.0"
RUN if [ "${INSTALL_KUBECTL}" = "true" ]; then \
    curl -LO "https://dl.k8s.io/release/${VERSION_KUBECTL}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/; \
    fi

# [Option] Install minikube
ARG INSTALL_MINIKUBE="false"
ARG VERSION_MINIKUBE="v1.32.0"
RUN if [ "${INSTALL_MINIKUBE}" = "true" ]; then \
    curl -LO https://storage.googleapis.com/minikube/releases/${VERSION_MINIKUBE}/minikube-linux-amd64 \
    && chmod +x minikube-linux-amd64 \
    && mv minikube-linux-amd64 /usr/local/bin/minikube; \
    fi

# [Option] Install Homebrew
ARG INSTALL_HOMEBREW="false"
RUN if [ "${INSTALL_HOMEBREW}" = "true" ]; then \
    ARCH=$(uname -m) \
    && if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        echo "Warning: Homebrew on Linux is not supported on ARM processors. Skipping installation." \
        && echo "# Homebrew was not installed due to ARM architecture limitations" > /home/${USERNAME}/.no_homebrew; \
    else \
        apt-get update && export DEBIAN_FRONTEND=noninteractive \
        && apt-get -y install procps file \
        && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
        && mkdir -p /home/linuxbrew \
        && chown -R ${USERNAME}:${USERNAME} /home/linuxbrew \
        # Use the Linux-specific Homebrew installation approach
        && su ${USERNAME} -c "/bin/bash -c 'echo | bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"'" \
        && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /etc/bash.bashrc \
        && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/${USERNAME}/.bashrc; \
    fi; \
    fi

# Make environment configuration available for all users
RUN echo "source ${NVM_DIR}/nvm.sh" >> /etc/bash.bashrc \
    && chmod -R a+w ${NVM_DIR} 2>/dev/null || true \
    && echo 'export CONDA_DIR="${CONDA_DIR}"' >> /etc/bash.bashrc \
    && echo 'export PATH="${CONDA_DIR}/bin:$PATH"' >> /etc/bash.bashrc \
    && echo '[ -f "${CONDA_DIR}/etc/profile.d/conda.sh" ] && . "${CONDA_DIR}/etc/profile.d/conda.sh"' >> /etc/bash.bashrc \
    && echo 'export BUN_INSTALL="/usr/local/share/bun"' >> /etc/bash.bashrc \
    && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /etc/bash.bashrc \
    && echo 'export PATH="/usr/local/bin/deno:$PATH"' >> /etc/bash.bashrc

# Create verification script to help debug environment issues
RUN { \
    echo '#!/bin/bash'; \
    echo 'echo "Verifying environment configuration..."'; \
    echo 'echo "User: $(whoami)"'; \
    echo 'echo "SDKMAN_DIR: $SDKMAN_DIR"'; \
    echo 'echo "GVM_DIR: $GVM_DIR"'; \
    echo 'echo "RSVM_DIR: $RSVM_DIR"'; \
    echo 'echo "NVM_DIR: $NVM_DIR"'; \
    echo 'echo "BUN_INSTALL: $BUN_INSTALL"'; \
    echo ''; \
    echo '# Check SDKMAN'; \
    echo 'if [ -d "$SDKMAN_DIR" ]; then'; \
    echo '  echo "SDKMAN installation directory exists"'; \
    echo '  if [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then'; \
    echo '    echo "SDKMAN initialization script exists"'; \
    echo '    ls -la "$SDKMAN_DIR/bin/sdkman-init.sh"'; \
    echo '  else'; \
    echo '    echo "WARNING: SDKMAN initialization script not found"'; \
    echo '  fi'; \
    echo 'else'; \
    echo '  echo "WARNING: SDKMAN directory does not exist"'; \
    echo 'fi'; \
    echo ''; \
    echo '# Check GVM'; \
    echo 'if [ -d "$GVM_DIR" ]; then'; \
    echo '  echo "GVM installation directory exists"'; \
    echo '  if [ -f "$GVM_DIR/scripts/gvm" ]; then'; \
    echo '    echo "GVM initialization script exists"'; \
    echo '    ls -la "$GVM_DIR/scripts/gvm"'; \
    echo '  else'; \
    echo '    echo "WARNING: GVM initialization script not found"'; \
    echo '  fi'; \
    echo 'else'; \
    echo '  echo "WARNING: GVM directory not found at $GVM_DIR"'; \
    echo '  # Check if GVM exists in home directory'; \
    echo '  if [ -d "/home/vscode/.gvm" ]; then'; \
    echo '    echo "Found GVM in /home/vscode/.gvm instead"'; \
    echo '    export GVM_DIR="/home/vscode/.gvm"'; \
    echo '    echo "GVM_DIR updated to $GVM_DIR"'; \
    echo '  fi'; \
    echo 'fi'; \
    echo ''; \
    echo 'echo "Environment verification complete"'; \
    echo 'exit 0'; \
    } > /usr/local/bin/verify-env \
    && chmod +x /usr/local/bin/verify-env \
    && chown ${USERNAME}:${USERNAME} /usr/local/bin/verify-env

# Setup environment variables
ENV PATH="/usr/local/bin:${PATH}"
ENV SHELL="/bin/bash"
ENV LANG="C.UTF-8"

# Set default user
USER ${USERNAME}
WORKDIR /workspace/devden

CMD ["/bin/bash"]
