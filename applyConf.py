#!/usr/bin/python3
# Script to push the configs into the final folder
#
# 2017-2019 Jorge Valentini
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# Please, see http://www.gnu.org/licenses/.

import argparse
import os
import sys
import shutil
import subprocess
from datetime import datetime

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('config', choices=['fluxbox', 'terminator', 'vim', 'zsh', 'all'],
                    help='Select the configs to apply')

args = parser.parse_args()

home=os.environ['HOME']
availableConfigs ={
	'fluxbox':[(home+'/.fluxbox','custom/fluxbox')],
	'terminator':[(home+'/.config/terminator','custom/terminator')],
	'vim':[(home+'/.vimrc','custom/vimrc')],
	#'zsh':[(home+'/.zshrc','custom/zshrc'),(home+'/.oh-my-zsh','custom/oh-my-zsh')],
	'zsh':[(home+'/.zshrc','custom/oh-my-zsh/zshrc'),(home+'/.oh-my-zsh/themes/sysadmin.zsh-theme','custom/oh-my-zsh/sysadmin.zsh-theme')],
}

def applysettings(config):
	if config == 'zsh':
		subprocess.Popen(sys.path[0] + "/custom/oh-my-zsh/install.sh", shell=True)
	if config == 'terminator':
		print('Install fonts-powerline for compatibility with Terminator config file')
	for pairs in availableConfigs[config]:
		source=sys.path[0] + '/' + pairs[1]
		dest=pairs[0]
		print('copying ' + source + ' to ' + dest)
		if os.path.exists(dest):
			os.rename(dest, dest + '.' + datetime.now().strftime('%y%m%d%H%M'))
			print('Backup file created')
		if os.path.isdir(source):shutil.copytree(source,dest)
		elif os.path.isfile(source): shutil.copyfile(source,dest)

if args.config == 'all':
	for key,value in availableConfigs.items():
		applysettings(key)
else:
	applysettings(args.config)

