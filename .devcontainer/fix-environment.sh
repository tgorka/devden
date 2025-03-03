#!/bin/bash
set -e

echo "Fixing development environment setup..."

# Fix SDKMAN
if [ ! -d "/usr/local/sdkman/bin" ]; then
    echo "Creating SDKMAN directory structure..."
    sudo mkdir -p /usr/local/sdkman/bin
    sudo chown -R vscode:vscode /usr/local/sdkman
fi

if [ ! -f "/usr/local/sdkman/bin/sdkman-init.sh" ]; then
    echo "Creating SDKMAN initialization script..."
    cat > /usr/local/sdkman/bin/sdkman-init.sh << 'EOF'
#!/bin/bash
export SDKMAN_DIR="/usr/local/sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
EOF
    chmod +x /usr/local/sdkman/bin/sdkman-init.sh
fi

# Install SDKMAN in home directory if not already installed
if [ ! -d "${HOME}/.sdkman" ]; then
    echo "Installing SDKMAN in home directory..."
    curl -s "https://get.sdkman.io" | bash
fi

# Fix Docker socket permissions
if [ -e /var/run/docker.sock ]; then
    echo "Fixing Docker socket permissions..."
    sudo chown -Rf vscode:vscode /var/run/docker.sock || true
else
    echo "Docker socket not found. Skipping permission change."
fi

# Fix permissions for development directories
echo "Fixing permissions for development directories..."
for dir in /usr/local/sdkman /home/vscode/.gvm /usr/local/rsvm /usr/local/share/nvm; do
    if [ -d "$dir" ]; then
        echo "Setting permissions for $dir"
        sudo chown -R vscode:vscode "$dir" 2>/dev/null || true
        sudo chmod -R 755 "$dir" 2>/dev/null || true
    else
        echo "Directory $dir does not exist, skipping"
    fi
done

echo "Environment setup complete."
