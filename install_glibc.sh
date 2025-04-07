#!/bin/bash

set -e  # Exit if any command fails

# Variables
GLIBC_VERSION="2.28"
GLIBC_INSTALL_DIR="/opt/glibc-$GLIBC_VERSION"
GLIBC_SOURCE_URL="http://ftp.gnu.org/gnu/libc/glibc-$GLIBC_VERSION.tar.gz"

# Function to install required dependencies
install_dependencies() {
    echo "Installing required build tools..."
    
    if command -v apt &> /dev/null; then
        sudo apt update -y
        sudo apt install -y build-essential manpages-dev gawk bison gcc make wget tar
    elif command -v yum &> /dev/null; then
        sudo yum groupinstall -y "Development Tools"
        sudo yum install -y glibc-devel glibc-headers man-pages wget tar gcc make bison
    elif command -v dnf &> /dev/null; then
        sudo dnf groupinstall -y "Development Tools"
        sudo dnf install -y glibc-devel glibc-headers man-pages wget tar gcc make bison
    else
        echo "No supported package manager found! Exiting..."
        exit 1
    fi
}

# Function to download and compile GLIBC
install_glibc() {
    echo "Downloading GLIBC $GLIBC_VERSION..."
    cd /usr/local/src
    sudo wget -c "$GLIBC_SOURCE_URL" -O "glibc-$GLIBC_VERSION.tar.gz"

    echo "Extracting GLIBC..."
    sudo tar -xvzf "glibc-$GLIBC_VERSION.tar.gz"
    cd "glibc-$GLIBC_VERSION"

    echo "Building GLIBC $GLIBC_VERSION..."
    sudo mkdir -p build
    cd build
    sudo ../configure --prefix="$GLIBC_INSTALL_DIR"
    sudo make -j$(nproc)
    sudo make install

    echo "GLIBC $GLIBC_VERSION installed in $GLIBC_INSTALL_DIR"
}

# Function to set up environment variables
setup_environment() {
    echo "Setting up environment variables..."
    
    # Add new GLIBC path
    echo "export LD_LIBRARY_PATH=$GLIBC_INSTALL_DIR/lib:\$LD_LIBRARY_PATH" | sudo tee -a /etc/profile.d/glibc.sh
    echo "export PATH=$GLIBC_INSTALL_DIR/bin:\$PATH" | sudo tee -a /etc/profile.d/glibc.sh
    
    # Apply changes
    source /etc/profile.d/glibc.sh
    echo "GLIBC $GLIBC_VERSION environment setup complete."
}

# Function to verify installation
verify_glibc() {
    echo "Verifying GLIBC version..."
    ldd --version
}

# Run functions
install_dependencies
install_glibc
setup_environment
verify_glibc

echo "✅ GLIBC $GLIBC_VERSION installed successfully!"


# Install dependencies
sudo yum groupinstall "Development Tools" -y
sudo yum install -y gcc glibc-devel man-pages

# Download and extract GLIBC 2.28
cd /usr/local/src
sudo wget http://ftp.gnu.org/gnu/libc/glibc-2.28.tar.gz
sudo tar -xvzf glibc-2.28.tar.gz
cd glibc-2.28

# Build and install
mkdir build
cd build
sudo ../configure --prefix=/opt/glibc-2.28
sudo make -j$(nproc)
sudo make install

# Set new GLIBC as default
echo 'export LD_LIBRARY_PATH=/opt/glibc-2.28/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

