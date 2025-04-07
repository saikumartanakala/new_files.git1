#!/bin/bash

# Ensure script runs as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root or use sudo!"
   exit 1
fi

# Function to install Node.js
install_node() {
    echo "Available Node.js versions: 16, 18, 20 (latest LTS)"
    read -p "Enter Node.js version to install (default: 18): " NODE_VERSION
    NODE_VERSION=${NODE_VERSION:-18}  # Default to 18 if no input

    echo "Installing Node.js $NODE_VERSION using NVM..."
    
    # Install NVM (if not already installed)
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        echo "NVM is already installed."
    fi

    # Load NVM and install Node.js
    source ~/.nvm/nvm.sh
    nvm install $NODE_VERSION
    nvm use $NODE_VERSION
    nvm alias default $NODE_VERSION

    echo "Node.js $(node -v) installed successfully!"
}

# Function to install PHP
install_php() {
    echo "Available PHP versions: 7.4, 8.0, 8.1, 8.2"
    read -p "Enter PHP version to install (default: 8.1): " PHP_VERSION
    PHP_VERSION=${PHP_VERSION:-8.1}  # Default to 8.1 if no input

    echo "Installing PHP $PHP_VERSION..."
    
    # Enable Amazon Linux Extra repository
    amazon-linux-extras enable php$PHP_VERSION
    yum clean metadata
    yum install -y php php-cli php-mbstring php-xml php-bcmath php-json php-common php-fpm

    echo "PHP $(php -v | head -n 1) installed successfully!"
}

# Ask user what to install
echo "Select installation options:"
echo "1) Install Node.js"
echo "2) Install PHP"
echo "3) Install Both"
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        install_node
        ;;
    2)
        install_php
        ;;
    3)
        install_node
        install_php
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Installation complete!"
