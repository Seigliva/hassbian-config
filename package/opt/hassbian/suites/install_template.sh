#!/bin/bash
#Scrtipt details
DESC_SHORT="Template installation script."
DESC_LONG="Template installation script for use with hassbian-config."
CONSEPT_BY="Ludeeus <https://github.com/ludeeus>"
MODIFIED_BY=""

function template-install-package {
  set -e
  suite-upgradeable #Check if there are any updates to hassbian-config.
  echo $DESC_LONG
  echo ""
  echo "Original concept by" $CONSEPT_BY
  if [ "$MODIFIED_BY" != "" ];then echo "Modified by" $MODIFIED_BY; fi
  echo ""
  #
  echo "Put installation script here :)"
  #
  echo "Checking the installation..." #Add some sort of check to the script
  validation=$(ps -ef | grep -v grep | grep homeassistant | wc -l)
  if [ "$validation" != "0" ]; then
  	echo ""
  	echo -e "\e[32mInstallation done.\e[0m"
  	echo ""
    echo "Home Assistant is running."
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
[[ $0 == "$BASH_SOURCE" ]] && template-install-package

#Changelog
# 1.0.0 - Initial release
