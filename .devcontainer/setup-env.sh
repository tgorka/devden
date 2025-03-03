#!/bin/bash
set -e

echo "Setting up environment variables in .bashrc..."

# NVM (Node Version Manager)
echo 'source ${NVM_DIR}/nvm.sh' >> ~/.bashrc

# Python environment
echo 'export PYTHON_ROOT="${PYTHON_ROOT}" && export PATH="${PYTHON_ROOT}/bin:$PATH"' >> ~/.bashrc

# Bun
echo 'export BUN_INSTALL="/usr/local/share/bun" && export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc

# Homebrew
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null || true' >> ~/.bashrc

# SDKMAN
echo 'export SDKMAN_DIR="${SDKMAN_DIR}" && [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source ${SDKMAN_DIR}/bin/sdkman-init.sh || [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source ${HOME}/.sdkman/bin/sdkman-init.sh || true' >> ~/.bashrc

# GVM (Go Version Manager)
echo 'export GVM_DIR="${GVM_DIR}" && [[ -s "${GVM_DIR}/scripts/gvm" ]] && source ${GVM_DIR}/scripts/gvm || true' >> ~/.bashrc

# RSVM (Rust Version Manager)
echo '[[ -s "${RSVM_DIR}/rsvm.sh" ]] && source ${RSVM_DIR}/rsvm.sh || true' >> ~/.bashrc

# Call Java installation script
if [ -x "/usr/local/bin/install-java.sh" ]; then
    echo "Running Java installation script..."
    sudo chown -R vscode:vscode /usr/local/bin/install-java.sh
    /usr/local/bin/install-java.sh
fi

# Call Kotlin installation script
if [ -x "/usr/local/bin/install-kotlin.sh" ]; then
    echo "Running Kotlin installation script..."
    sudo chown -R vscode:vscode /usr/local/bin/install-kotlin.sh
    /usr/local/bin/install-kotlin.sh
fi

echo "Environment setup complete."
