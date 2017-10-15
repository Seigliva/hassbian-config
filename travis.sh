#!/bin/bash
set -e
echo "Travis CI Testing..."
echo "Building package..."
dpkg-deb --build package/

echo "Installing package..."
sudo apt install ./package.deb

echo "Making hassbian-config executable..."
sudo chmod +x /usr/local/bin/hassbian-config

echo "Running hassbian-config..."
sudo hassbian-config show

exit
