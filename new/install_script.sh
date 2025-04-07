#!/bin/bash

# Detect package manager
if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v yum &> /dev/null; then
    PACKAGE_MANAGER="yum"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
else
    echo "No supported package manager found! Exiting..."
    exit 1
fi

# Function to check and install GLIBC 2.28
install_glibc() {
    REQUIRED_GLIBC="2.28"
    INSTALLED_GLIBC=$(ldd --version | head -n 1 | awk '{print $NF}')

    if [ "$(printf '%s\n' "$REQUIRED_GLIBC" "$INSTALLED_GLIBC" | sort -V | head -n1)" != "$REQUIRED_GLIBC" ]; then
        echo "Upgrading GLIBC to $REQUIRED_GLIBC..."
        sudo yum groupinstall "Development Tools" -y
        sudo yum install -y gcc glibc-devel man-pages

        cd /usr/local/src
        sudo wget http://ftp.gnu.org/gnu/libc/glibc-2.28.tar.gz
        sudo tar -xvzf glibc-2.28.tar.gz
        cd glibc-2.28

        mkdir build
        cd build
        sudo ../configure --prefix=/opt/glibc-2.28
        sudo make -j$(nproc)
        sudo make install

        echo 'export LD_LIBRARY_PATH=/opt/glibc-2.28/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
        source ~/.bashrc
    else
        echo "GLIBC $INSTALLED_GLIBC is already up to date."
    fi
}

# Function to install NVM
install_nvm() {
    if [ -d "$HOME/.nvm" ]; then
        echo "NVM is already installed."
    else
        echo "Installing NVM..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Function to install Node.js using NVM
install_node() {
    source ~/.bashrc
    source ~/.nvm/nvm.sh

    while true; do
        read -p "Enter the Node.js version you want to install (e.g., 18.17.0): " NODE_VERSION
        if [[ "$NODE_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            break
        else
            echo "Invalid version format! Example: 18.17.0"
        fi
    done

    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
    echo "Node.js version $(node -v) installed successfully."
}

# Function to install PHP
install_php() {
    while true; do
        read -p "Enter the PHP version you want to install (e.g., 8.1, 8.2): " PHP_VERSION
        if [[ "$PHP_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]; then
            break
        else
            echo "Invalid version format! Example: 8.1"
        fi
    done

    echo "Updating package lists..."
    sudo $PACKAGE_MANAGER update -y

    echo "Installing PHP $PHP_VERSION..."
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
        sudo apt install -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-mbstring php$PHP_VERSION-xml php$PHP_VERSION-curl
    else
        sudo yum install -y epel-release
        sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm
        sudo yum module enable -y php:remi-$PHP_VERSION
        sudo yum install -y php php-cli php-common php-mbstring php-xml php-curl
    fi

    echo "PHP version $(php -v | head -n 1) installed successfully."
}

# Run the functions
install_glibc
install_nvm
install_node
install_php

echo "Installation completed successfully!"
node -v
npm -v
php -v

