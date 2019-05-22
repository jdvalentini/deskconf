# Zsh theme created for sysadmin purposes

# -- EMOJI -- *
emojis=(💩 🐦 🚀 🐞 🎨 🍕 🐭 👽 ☕️ 🔬 💀 🐷 🐼 🐶 🐸 🐧 🐳 🍔 🍣 🍻 🔮 💰 💎 💾 💜 🍪 🌞 🌍 🐌 🐓 🍄 )

# -- SYS INFO -- **
sys_load=`top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "☉ System load : %.1f%", 100-$1 }'`
sys_mem=`free -m | awk 'NR==2{printf "☉ Memory Usage: %.2f%", $3*100/$2 }'`
sys_disk=`df -h | awk '$NF=="/"{printf "☉ Disk Usage: %.1f%", $5}'`
sys_uptime=`uptime | awk -F'( |,|:)+' '{ if ($7=="min") m=$6; else { if ($7~/^day/) { d=$6; h=$8; m=$9} else {h=$6;m=$7}}}{print "☉ System uptime:",d+0,"days,",h+0,"hours"}'`

# Add sysinfo to an array for ordered printing
infolist=("$sys_load" "$sys_mem" "$sys_uptime")
sysinfo=`for value in "${infolist[@]}"; do printf "%-8s\n" "${value}"; done | column` # Use column -c $COLUMNS to adapt to terminal size
termdate="\n$FG[038]Today is `date`"

echo $sysinfo
print -P $termdate

# -- PROMPT --
# Working directory
WDmode=2
WD() {
	wdOptions=3
	defaultMode=1
	if [ -z $1 ]; then mode=defaultMode						# If no argument defaults
	elif ! [[ $1 =~ '^[0-9]+$' ]]; then mode=defaultMode	# If not integer defaults
	elif [ $1 -gt $wdOptions ]; then mode=$((($1-1)%$wdOptions+1))
	else mode=$1
	fi

	case $mode in
		1) print "%~";;
		2) #***
			echo $(pwd | perl -pe '
				BEGIN {
					binmode STDIN,  ":encoding(UTF-8)";
					binmode STDOUT, ":encoding(UTF-8)";
				}; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
			');;
		3) 
			escapedHome=$(echo $HOME | sed 's/\//\\\//g')
			fullPwd=$(pwd | sed "s/$escapedHome/~/g")
			if [[ $(echo $fullPwd | wc -m) -lt 40 ]]; then 
				print $fullPwd
			else
				print "$(pwd | cut -c 1-12)...$(pwd | rev | cut -c 1-23 | rev)"
			fi;;
	esac
}

changeWD() {
	WDmode=$(($WDmode+1))
	zle reset-prompt # Working Directory mode changed
}
zle -N changeWD
bindkey ^p changeWD

# Color coded local time ****
time_coded="%(?.%{$fg[magenta]%}.%{$fg[red]%})%*%{$reset_color%}" # If last process failed goes red
time_notcoded="%{$fg[magenta]%}%*%{$reset_color%}"
time=$time_coded

#PROMPT='%{$fg[magenta]%}[%c] %{$reset_color%}'
#PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%X]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} %{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '
#PROMPT=$'%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%2~%{$reset_color%} %{$fg_bold[blue]%}%#%{$reset_color%} '
#PROMPT='%{$fg[magenta]%}${time}%{$reset_color%}:%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@%m%{$reset_color%}:%{$fg[blue]%}%2~%{$reset_color%} %{$fg_bold[blue]%}%#%{$reset_color%} '
PROMPT='%{$fg[magenta]%}${time}%{$reset_color%}:%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@%m%{$reset_color%}:%{$fg[blue]%}$(WD $WDmode)%{$reset_color%} %{$fg_bold[blue]%}%#%{$reset_color%} '

#RPROMPT='%{$fg[magenta]%}${time}%{$reset_color%}'


# * Emoji array from https://gist.github.com/oshybystyi/2c30543cd48b2c9ecab0
# ** System information display from https://github.com/Saleh7/igeek-zsh-theme
# *** Collapsible working directory from Oh-My-Zsh Fishy at https://github.com/robbyrussell/oh-my-zsh/tree/master/themes
# **** Color coded local time from Oh-My-Zsh Wedisagree at https://github.com/robbyrussell/oh-my-zsh/tree/master/themes
