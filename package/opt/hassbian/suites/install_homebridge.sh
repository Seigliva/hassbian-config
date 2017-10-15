#!/bin/bash
#Scrtipt details
DESC_SHORT="Installs and configure homebridge for Home Assistant."
DESC_LONG="Installs and configure homebridge for Home Assistant, This will allow you to use HomeKit enabled devices to controll Home Assistant."
CONSEPT_BY="Ludeeus <https://github.com/ludeeus>"
MODIFIED_BY=""

function homebridge-install-package {
	set -e
	suite-upgradeable #Check if there are any updates to hassbian-config.
	echo $DESC_LONG
	echo ""
	echo "Original concept by" $CONSEPT_BY
	if [ "$MODIFIED_BY" != "" ];then echo "Modified by" $MODIFIED_BY; fi
	echo ""

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

	echo "Checking the installation..."
	validation=$(ps -ef | grep -v grep | grep homebridge | wc -l)
	if [ "$validation" != "0" ]; then
		echo ""
		echo -e "\e[32mInstallation done.\e[0m"
		echo ""
		echo "Homebridge is now running and you can add it to your"
		echo "home-kit app on your iOS device, when you are asked for a pin"
		echo "use this: '031-45-154'"
		echo "For more information see this repo:"
		echo "<https://github.com/home-assistant/homebridge-homeassistant#customization>"
		echo ""
		echo "If you have issues with this script, please say something in the #Hassbian channel on Discord."
	else
	    echo -e "\e[31mInstallation failed..."
	    echo -e "\e[31mAborting..."
		echo -e "\e[0mIf you have issues with this script, please say something in the #Hassbian channel on Discord."
	    return 1
	fi
	return 0
}

# Make this script function as it always has if run standalone, rather than issue a warning and do nothing.
[[ $0 == "$BASH_SOURCE" ]] && homebridge-install-package

#Changelog
# 1.0.0 - Initial release
