#!/bin/bash
#Scrtipt details
DESC_SHORT="Echo/Home/Mycroft Emulated Hue install script for Hassbian."
DESC_LONG="Configures the Python executable to allow usage of low numbered ports for use with Amazon Echo, Google Home and Mycroft.ai."
CONSEPT_BY="Fredrik Lindqvist <https://github.com/Landrash>"
MODIFIED_BY=""

function hue-install-package {
  set -e
  echo $DESC_LONG
  echo ""
  echo "Original concept by" $CONSEPT_BY
  if [ "$MODIFIED_BY" != "" ];then echo "Modified by" $MODIFIED_BY; fi
  echo ""

  if [ "$(id -u)" != "0" ]; then
      echo "This script must be run with sudo. Use \"sudo ${0} ${*}\"" 1>&2
      return 1
  fi
  if [ -d "/usr/lib/python3.5" ]; then
    echo "Setting permissions for Python 3.5"
    sudo setcap 'cap_net_bind_service=+ep' /usr/bin/python3.5
    else
    echo "Setting permissions for Python 3.4"
    sudo setcap 'cap_net_bind_service=+ep' /usr/bin/python3.4
  fi
  echo
  echo -e "\e[32mInstallation done.\e[0m"
  echo
  echo "To continue have a look at https://home-assistant.io/components/emulated_hue/"
  echo
  echo "If you have issues with this script, please say something in the #Hassbian channel on Discord."
  echo
return 0
}

[[ $_ == $0 ]] && echo "hassbian-config helper script; do not run directly, use hassbian-config install instead"
#Changelog
# 1.0.0 - Initial release
