#!/bin/bash
#Scrtipt details
DESC_SHORT="Upgrade script for Python."
DESC_LONG="Upgrades python to 3.6 and reinstalls Home Assistant with that."
CONSEPT_BY="Ludeeus <https://github.com/ludeeus>"
MODIFIED_BY=""

function python-upgrade-package {
  set -e
	echo $DESC_LONG
	echo ""
	echo "Original concept by" $CONSEPT_BY
	if [ "$MODIFIED_BY" != "" ];then echo "Modified by" $MODIFIED_BY; fi
	echo ""

  echo "Installing Python 3.6."
  sudo apt-get -y update
  sudo apt-get install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev
  cd /tmp
  wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
  tar xf Python-3.6.3.tar.xz
  cd Python-3.6.3
  ./configure
  make
  sudo make altinstall
  sudo apt -y autoremove
  sudo rm -r /tmp/Python-3.6.3
  sudo rm /tmp/Python-3.6.3.tar.xz
  echo "Done"

  echo "Stopping Home Assistant."
  sudo systemctl stop home-assistant@homeassistant.service

  echo "Backing up previous virutal enviorment."
  sudo mv /srv/homeassistant /srv/homeassistant_old

  echo "Creating new virutal enviorment using Python 3.6."
  sudo mkdir /srv/homeassistant
  sudo chown homeassistant:homeassistant /srv/homeassistant
  sudo mv /srv/homeassistant_old/hassbian /srv/homeassistant/hassbian
  sudo apt-get install python3-pip python3-dev
  sudo pip3 install --upgrade virtualenv
  sudo -u homeassistant -H /bin/bash << EOF
  virtualenv -p python3.6 /srv/homeassistant
  source /srv/homeassistant/bin/activate
  pip3 install --upgrade homeassistant
  deactivate
EOF

  echo "Starting Home Assistant."
  sudo curl -o /etc/systemd/system/home-assistant@homeassistant.service https://raw.githubusercontent.com/home-assistant/hassbian-scripts/dev/package/etc/systemd/system/home-assistant%40homeassistant.service
  sudo systemctl enable home-assistant@homeassistant.service
  sudo systemctl daemon-reload
  sudo systemctl start home-assistant@homeassistant.service

  echo "Checking if installation vas successful..."
  test -d "/usr/local/lib/python3.6/" && retval=0 || retval=1
  if [ "$retval" == "0" ]; then
      echo
      echo "Python 3.6 upgrade for Home Assistant is complete..."
      echo "Upgrade is done..."
  else
      echo
      echo "Installation failed..."
      echo "Aborting..."
      return 1
  fi

  echo
  echo "If you have issues with this script, please say something in the #Hassbian channel on Discord."
  echo
  return $retval
}

# Make this script function as it always has if run standalone, rather than issue a warning and do nothing.
[[ $0 == "$BASH_SOURCE" ]] && python-upgrade-package
