# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
<<<<<<< HEAD
export PATH=$PATH:/usr/bin
=======
export LD_LIBRARY_PATH=/opt/glibc-2.28/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/node/bin:$PATH
export PATH=/usr/local/node/bin:$PATH
>>>>>>> f3b9858 (Initial commit)
