#!/bin/bash
# See more examples here:
# https://github.com/home-assistant/hassbian-scripts/tree/dev/package/opt/hassbian/suites
#
# When you are done and you have tested it localy, please submit an PR here:
# https://github.com/home-assistant/hassbian-scripts/pulls
#

function homebridge-show-short-info {
    # Short informative description of the script.
	# Example:
    echo "Home Assistant install script for Hassbian"
}

function homebridge-show-long-info {
    # More detailed information of the script.
	# Example:
    echo "Installs the base homeassistant package onto this system."
}

function homebridge-show-copyright-info {
    # Your 0.4 seconds of fame, this line will show up when the script runs.
	# Example:
	echo ""
}

function homebridge-install-package {
homebridge-show-long-info
homebridge-show-copyright-info
echo "Prepearing system, and adding dependencies."
sudo apt update
sudo apt -y upgrade
sudo apt install -y make git
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y libavahi-compat-libdnssd-dev

echo "Installing homebridge for homeassistant."
sudo npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
sudo npm install -g homebridge-homeassistant

echo "Adding homebridge user, and creating config file."
sudo useradd -M --system homebridge
sudo mkdir /home/homebridge
sudo mkdir /home/homebridge/.homebridge
sudo touch /home/homebridge/.homebridge/config.json
echo '{"bridge": {"name": "Homebridge","username": "CC:22:3D:E3:CE:30","port": 51826,"pin": "031-45-154","manufacturer": "","model": "Homebridge","serialNumber": "0.4.20"},"description": "","platforms": [{"platform": "HomeAssistant","name": "HomeAssistant","host": "http://127.0.0.1:8123","password": "","supported_types": ["automation", "binary_sensor", "climate", "cover", "device_tracker", "fan", "group", "input_boolean", "light", "lock", "media_player", "remote", "scene", "sensor", "switch"],"default_visibility": "hidden","logging": false,"verify_ssl": false}]}'| sudo tee -a /home/homebridge/.homebridge/config.json
sudo chown -R homebridge /home/homebridge

echo "Creating system startup file."
cat > /etc/systemd/system/homebridge.service <<EOF
[Unit]
Description=Node.js HomeKit Server
After=syslog.target network-online.target
[Service]
Type=simple
User=homebridge
ExecStart=/usr/bin/homebridge
Restart=on-failure
RestartSec=10
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

echo "Enabling and starting service."
sudo systemctl daemon-reload
sudo systemctl enable homebridge.service
sudo systemctl start homebridge.service

echo
echo "Installation done."
echo
echo "Homebridge is now running and you can add it to your"
echo "home-kit app on your iOS device, when you are asked for a pin"
echo "use this: '031-45-154'"
echo "For more information see this repo:"
echo "https://github.com/home-assistant/homebridge-homeassistant#customization"
echo
echo "If you have issues with this script, please say something in the #Hassbian channel on Discord."
echo
return 0
}

# Make this script function as it always has if run standalone, rather than issue a warning and do nothing.
[[ $0 == "$BASH_SOURCE" ]] && homebridge-install-package
