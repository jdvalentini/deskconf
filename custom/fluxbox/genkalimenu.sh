#!/bin/bash
# Script to generate Fluxbox Menu for Kali based on XDG menu settings from the distribution

#    This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
#    Please, see http://www.gnu.org/licenses/.

kaliXDG="/usr/share/applications/kali-*.desktop"
tmpMenu=$(mktemp /tmp/fbm.XXXXX) || { echo "Error creating temp"; exit 1; }
fbMenu="$HOME/.fluxbox/kalimenu"

for category in $(grep "^Categories" $kaliXDG | cut -d"=" -f2 | cut -d";" -f1 | sort | uniq | grep -vE "^[0-9][0-9]-[0-9][0-9]"); do
	echo "[submenu] ($(echo $category | sed 's/-/ /g;s/\b\(.\)/\u\1/g'))" >> $tmpMenu
	for app in $(grep "^Categories=${category:0:2}" $kaliXDG | cut -d":" -f1); do
		appTerm=`grep "^Terminal" $app | cut -d"=" -f 2`
		appCat=`grep "^Categories" $app | cut -d"=" -f 2 | cut -d";" -f 1`
		appExec=`grep "^Exec" $app | cut -d"=" -f 2`
		appName=`grep "^Name" $app | cut -d"=" -f 2`
		if [ "$appTerm" == "false" ]; then
			echo "   [exec] ($appName) {$appExec}" >> $tmpMenu
		else
			appExec=$(echo $appExec | cut -d'"' -f2 | cut -d";" -f1)
			echo "   [exec] ($appName) {xterm -bg black -fa 'Monospace' -fs 11 -e '$appExec ; bash'}" >> $tmpMenu
		fi
	done
	echo "[end]" >> $tmpMenu
done

cp $tmpMenu $fbMenu
exit 0
