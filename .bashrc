#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias ll='ls -al'

PS1='[\u@\h \W]\$ '
export JAVA_HOME=/usr/lib/jvm/java-8-jdk
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin:$CLASSPATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
