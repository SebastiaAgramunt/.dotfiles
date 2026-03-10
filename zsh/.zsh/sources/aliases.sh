#!/bin/bash

# change directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."


# zsh specific
alias reload='source ~/.zshrc'

# handy short cuts
alias h='history'
alias j='jobs -l'

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

## specific aliases for custom programs
alias backup="$HOME/.dotfiles/zsh/scripts/backup.sh"

# command line aliases
alias eza='eza -lhgm -s modified --icons'