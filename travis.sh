#!/bin/bash
set -e
set -o pipefail
echo "Travis CI Testing..."
echo "Building package..."
dpkg-deb --build package/

echo "Installing package..."
sudo apt install ./package.deb

echo "Making hassbian-config executable..."
sudo chmod +x /usr/local/bin/hassbian-config

echo "Installing Home Assistant..."
sudo pip3 install --upgrade virtualenv
sudo adduser --system homeassistant
sudo addgroup homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
sudo hassbian-config install homeassistant

#echo "Runing included installer scripts..."
#installers=$(find /opt/hassbian/suites/ -maxdepth 1 -type f -name 'install_*' | grep -v 'install_homeassistant.sh' | awk -F'/|_' ' {print $NF}' | awk -F. '{print $1}')
#for i in $installers
#do
#  sudo hassbian-config install $i
#done

echo "Runing included upgrade scripts..."
#upgrade=$(find /opt/hassbian/suites/ -maxdepth 1 -type f -name 'upgrade_*' | grep -v 'install_homeassistant.sh' | awk -F'/|_' ' {print $NF}' | awk -F. '{print $1}')
#for i in $upgrade
#do
#  sudo hassbian-config upgrade $i
#done
sudo hassbian-config upgrade python
exit
