#!/bin/bash

# Ensure script runs as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root or use sudo!"
   exit 1
fi

# Function to install Node.js (Amazon Linux compatible version)
install_node() {
    echo "Installing Node.js from Amazon Linux repository..."

    # Remove any existing Node.js and NVM
    rm -rf ~/.nvm ~/.npm

    # Install Amazon Linux version of Node.js
    yum install -y nodejs

    echo "Node.js $(node -v) installed successfully!"
}

# Function to install PHP (Only available versions)
install_php() {
    echo "Available PHP versions on Amazon Linux: 7.4, 8.1, 8.2"
    read -p "Enter PHP version to install (default: 8.1): " PHP_VERSION
    PHP_VERSION=${PHP_VERSION:-8.1}  # Default to 8.1 if no input

    # Check if the version is available
    if amazon-linux-extras list | grep -q "php$PHP_VERSION"; then
        amazon-linux-extras enable php$PHP_VERSION
        yum clean metadata
        yum install -y php php-cli php-mbstring php-xml php-bcmath php-json php-common php-fpm
        echo "PHP $(php -v | head -n 1) installed successfully!"
    else
        echo "PHP version $PHP_VERSION is NOT available on Amazon Linux. Exiting."
        exit 1
    fi
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
