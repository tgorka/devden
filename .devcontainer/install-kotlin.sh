#!/bin/bash
set -e

# Install Kotlin if INSTALL_KOTLIN is true
if [ "${INSTALL_KOTLIN}" = "true" ]; then
    echo "Installing Kotlin ${VERSION_KOTLIN} via SDKMAN..."

    # Source SDKMAN to ensure it's available
    export SDKMAN_DIR="${SDKMAN_DIR:-/usr/local/sdkman}"
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

    # Check if SDKMAN is available
    if ! command -v sdk &> /dev/null; then
        echo "Error: SDKMAN is not installed or not in PATH"
        exit 1
    fi

    # Install Kotlin with the specified version
    sdk install kotlin "${VERSION_KOTLIN}"

    # Set as default
    sdk default kotlin "${VERSION_KOTLIN}"

    echo "Kotlin ${VERSION_KOTLIN} installation complete"
else
    echo "Skipping Kotlin installation (INSTALL_KOTLIN is not set to 'true')"
fi

# Set up environment variables for Kotlin
echo "Setting up Kotlin environment variables..."
echo 'export KOTLIN_HOME=$(sdk home kotlin)' >> ~/.bashrc
echo 'export PATH="$KOTLIN_HOME/bin:$PATH"' >> ~/.bashrc
