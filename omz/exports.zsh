# Ansible
export ANSIBLE_COW_SELECTION=random
export ANSIBLE_COW_PATH=cowsay

# DOCKER
export DOCKER_CLI_HINTS=false

# OS
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth
export GREP_COLOR="1;35"

# Pagers
export MANPAGER="less -X";
export PAGER="less -X";
export AWS_PAGER=

# Path
if [ "$(arch)" = "arm64" ]; then
  export PATH=/opt/homebrew/bin:$PATH
else
  export PATH=/usr/local/bin:$PATH
fi

# MySQL
export MYSQL_PS1='\u@\h \R:\m:\s mysql> '
