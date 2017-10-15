#!/bin/bash
# See more examples here:
# https://github.com/home-assistant/hassbian-scripts/tree/dev/package/opt/hassbian/suites
#
# When you are done and you have tested it localy, please submit an PR here:
# https://github.com/home-assistant/hassbian-scripts/pulls
#

function template-show-short-info {
    # Short informative description of the script.
	# Example:
    echo "Template for hassbian-config installation scripts..."
}

function template-show-long-info {
    # More detailed information of the script.
	# Example:
    echo "Template for hassbian-config installation scripts..."
}

function template-show-copyright-info {
    # Your 0.4 seconds of fame, this line will show up when the script runs.
	# Example:
	echo "Original consept by Ludeeus <https://github.com/ludeeus>"
}

function template-install-package {
template-show-long-info
template-show-copyright-info
#
echo "Put installation script here :)"
#
echo
echo "Installation done."
echo
echo "Notes to user of the script"
echo
echo "If you have issues with this script, please say something in the #Hassbian channel on Discord."
echo
return 0
}

# Make this script function as it always has if run standalone, rather than issue a warning and do nothing.
[[ $0 == "$BASH_SOURCE" ]] && template-install-package
