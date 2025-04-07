# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
<<<<<<< HEAD
=======

export M2_HOME=/opt/maven
export PATH=$M2_HOME/bin:$PATH

export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
export PATH=$JAVA_HOME/bin:$PATH
>>>>>>> f3b9858 (Initial commit)
