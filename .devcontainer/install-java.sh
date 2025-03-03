#!/bin/bash
set -e

# Install Java if INSTALL_JAVA is true
if [ "${INSTALL_JAVA}" = "true" ]; then
    echo "Installing Java ${VERSION_JAVA} via SDKMAN..."

    # Source SDKMAN to ensure it's available
    export SDKMAN_DIR="${SDKMAN_DIR:-/usr/local/sdkman}"
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

    # Check if SDKMAN is available
    if ! command -v sdk &> /dev/null; then
        echo "Error: SDKMAN is not installed or not in PATH"
        exit 1
    fi

    # Install Java with the specified version
    sdk install java "${VERSION_JAVA}-open"

    # Set as default
    sdk default java "${VERSION_JAVA}-open"

    echo "Java ${VERSION_JAVA} installation complete"
else
    echo "Skipping Java installation (INSTALL_JAVA is not set to 'true')"
fi

# Set up environment variables for Java
echo "Setting up Java environment variables..."
echo 'export JAVA_HOME=$(sdk home java)' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
