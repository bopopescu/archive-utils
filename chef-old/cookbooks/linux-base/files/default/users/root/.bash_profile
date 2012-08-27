# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

TMOUT=86400
MAILTO=""
DATE_FORMAT="%Y-%m-%d"
export MAILTO DATE_FORMAT
PATH=$PATH:/usr/local/rsi
alias ll='ls -l'

