#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# make utilities such as grep and ls use colored output
alias ls='ls -F --color=auto'
# PS1='[\u@\h \W]\$ '
eval $(dircolors -b)
alias grep='grep --color=auto'
alias diff=colordiff

# customize bash prompts
export PS1="[\w]\\$ "

cdls() { cd "$@" && ls; }

# Add emacs as editor
# -c creates a new frame (window)
# -a="" ensures the daemon will be opened if necessary
export EDITOR='emacsclient --create-frame --no-wait --alternate-editor=""'
e() { (emacsclient --create-frame --no-wait --alternate-editor="" "$@" &> /dev/null &) }

alias youtube-to-mp3='youtube-dl --extract-audio --audio-format mp3'

# limit mv and rm to prevent unintentional sadness
alias mv=' timeout 8 mv -iv'
alias rm=' timeout 3 rm -Iv --one-file-system'

alias ..='cd ..'
alias ...='cd ../..'

# add ~/.scripts to path
PATH=$PATH:~/.scripts:.

# add blog scripts to path
PATH=$PATH:~/blog/scripts/

# add ~/.local/bin to path
PATH=$PATH:~/.local/bin
export PATH=/usr/local/bin:${PATH}

# add sbin folders to path
export PATH=$PATH:/sbin
export PATH=$PATH:/usr/sbin

# add emacs bin to path
export PATH=$PATH:~/.emacs.d/bin

# Add ruby gem bin to path
export PATH=$PATH:/home/taylor/.gem/ruby/2.5.0/bin

# Add rust cargo to path
export PATH=$PATH:/home/taylor/.cargo/bin
export PATH=$PATH:/home/taylor/.cargo/env

# add asdf version manager to path
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# set the path for locate to the home directory
export LOCATE_PATH=/home/taylor/.locate.db

# Add go to path
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

# Add erlang libs to ERL_LIBS
export ERL_LIBS="/home/taylor/.asdf/installs/elixir/1.11.2/lib/elixir/lib"

# add pyenv to path
export PATH="/home/taylor/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Load nvm into path:
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# enable powerline for bash
source ~/.bash-powerline.sh

source ~/.bash_completion/alacritty

# export DPI setting for alacritty
export WINIT_HIDPI_FACTOR=1.0 alacritty

# import KDE custom environment variables (like Github command line token)
source $HOME/.config/plasma-workspace/env/path.sh
