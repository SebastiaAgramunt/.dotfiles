#!/bin/bash

# change directories
alias ..='cd ..'
alias .1='cd ..'

alias ...='cd ../..'
alias .2='cd ../..'

alias ....='cd ../../..'
alias .3='cd ../../..'


# zsh specific
alias reload='source ~/.zshrc'

# handy short cuts
alias h='history'
alias j='jobs -l'

# git
alias gs='git status'

# lsd command line
alias lt='lsd -laht'

# useful
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'


# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'


## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'