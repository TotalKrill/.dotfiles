if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

xhost +local:root > /dev/null 2>&1
#store tty in temp
echo $(tty) > /tmp/termtty

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export JAVA_FONTS=/usr/share/fonts/TTF
export EDITOR=/usr/bin/nvim

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -lh --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -lha --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nvim PKGBUILD'
alias fixit='sudo rm -f /var/lib/pacman/db.lck'
alias update='yaourt -Syua'
alias con='nvim $HOME/.i3/config'
alias comp='nvim $HOME/.config/compton.conf'
alias inst='sudo pacman -S'
alias mirrors='sudo pacman-mirrors -g'
alias printer='system-config-printer'


function open () {
    xdg-open "$*" &
}

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi

ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

# prompt
#PS1='[\u@\h \W]\$ '
PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

LS_COLORS=$LS_COLORS:'di=0,35:'; export LS_COLORS

function dual_wield {
    ~/.screenlayout/default.sh
}

function single {
    ~/.screenlayout/single.sh
}

function demotime {
    cd ~/localizationws
    source devel/setup.bash
    roslaunch all.launch
}

alias vim='nvim'
function rs {
    source devel/setup.bash
    export ROS_OS_OVERRIDE=arch:$(uname -r)
    export ROS_HOSTNAME=krille-pc
}
function rb {
   killall blueman-applet -9
   killall blueman-manager -9
   sudo systemctl restart bluetooth.service
   (blueman-applet &)
}

alias PY2='sudo rm /usr/bin/python; sudo ln -s /usr/bin/python2 /usr/bin/python'
alias PY3='sudo rm /usr/bin/python; sudo ln -s /usr/bin/python3 /usr/bin/python'

kicad_test() {
PYTHONPATH=/usr/local/lib/python2.7/site-packages \
LD_LIBRARY_PATH=/usr/local/bin:/tmp/kicad/usr/local/lib \
/usr/local/bin/$1
}


alias steam='STEAM_RUNTIME=0 steam'

exec fish

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
