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

# Function to install GLIBC 2.28
install_glibc() {
    echo "Upgrading glibc to 2.28..."
    cd /usr/local/src
    sudo wget http://ftp.gnu.org/gnu/libc/glibc-2.28.tar.gz
    sudo tar -xvzf glibc-2.28.tar.gz
    cd glibc-2.28

    mkdir build
    cd build
    sudo ../configure --prefix=/opt/glibc-2.28
    sudo make -j$(nproc)
    sudo make install

    # Update LD_LIBRARY_PATH
    echo 'export LD_LIBRARY_PATH=/opt/glibc-2.28/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
    source ~/.bashrc

    # Verify installation
    /opt/glibc-2.28/lib/ld-2.28.so --version
}

# Function to install Node.js
install_node() {
    echo "Installing Node.js..."
    NODE_VERSION="18.17.0"
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

# Function to install PHP
install_php() {
    PHP_VERSION="8.1"  # Example: Choose PHP 8.1 or a similar modern version
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
install_glibc
install_node
install_php

echo "Installation process completed successfully!"

