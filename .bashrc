#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias ll='ls -al'
alias hosts='sudo wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /etc/hosts'
alias rr='ranger'

PS1='[\u@\h \W]\$ '
export JAVA_HOME=/usr/lib/jvm/java-8-jdk
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export M2_HOME=/opt/maven
export PATH=$PATH:$JAVA_HOME/bin:$CLASSPATH:$M2_HOME


#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
