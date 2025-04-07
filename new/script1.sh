#!/bin/bash

# Detect package manager
if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v yum &> /dev/null; then
    PACKAGE_MANAGER="yum"
else
    echo "No supported package manager found! Exiting..."
    exit 1
fi

# Function to install Node.js (compatible with glibc 2.26)
install_node_compatible() {
    echo "Installing Node.js compatible with glibc 2.26..."

    # Use a precompiled binary for compatibility
    NODE_VERSION="16.20.0"  # Compatible Node.js version
    cd /usr/local/src
    wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
    tar -xvzf node-v$NODE_VERSION-linux-x64.tar.gz
    mv node-v$NODE_VERSION-linux-x64 /usr/local/node

    # Update PATH
    echo 'export PATH=/usr/local/node/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc

    # Verify installation
    echo "Node.js version:"
    /usr/local/node/bin/node -v
    echo "npm version:"
    /usr/local/node/bin/npm -v
}

# Function to install PHP (modern version compatible with glibc 2.26)
install_php() {
    PHP_VERSION="7.4"  # Example: Choose PHP 7.4 as the compatible version
    echo "Installing PHP $PHP_VERSION..."
    
    if [ "$PACKAGE_MANAGER" == "yum" ]; then
        sudo yum install -y epel-release
        sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm
        sudo yum module enable -y php:remi-$PHP_VERSION
        sudo yum install -y php php-cli php-common php-mbstring php-xml php-curl
    elif [ "$PACKAGE_MANAGER" == "apt" ]; then
        sudo apt update -y
        sudo apt install -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-mbstring php$PHP_VERSION-xml php$PHP_VERSION-curl
    fi

    echo "PHP version installed:"
    php -v
}

# Run the functions
install_node_compatible
install_php

echo "Installation process completed successfully!"

