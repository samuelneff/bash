
# Setup git prompt to highlight current branch and status
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=true
# .git-prompt.sh available here: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh
PROMPT_COMMAND='__git_ps1 "\e[35m\w\e[37m" "\\n\e[30m\\\$ "'

# title - sets the title of tab in Hyper
title() {
  if [ -z {$1+x} ]; then
    echo -e "\033]0;${$1-$PWD}"
  else
    echo -e "\033]0;$1"
  fi
}

# fm - Fetch and merge a branch into current branch
#      example:
# fm upstream dev
#
# same as
#
# git fetch upstream dev && git merge upstream/dev
#
fm() {
    git fetch $1 $2 && git merge $1/$2
}

#
# bd - branch delete
#
# bd [pattern]
#
# Deletes any ALREADY MERGED branches that match a pattern, but will never delete current, master, or dev branches
#
# Useful for cleaning up old branches and is always safe to run since it will only delete branches that are already
# merged to the current branch.
#
# Common use case is finish a feature branch, push it, create PR, merge PR, then on dev branch fm upstream dev,
# then you can bd your old feature branch to safely remove the feature branch knowing it's already been merged
# to current
#
bd() {
    git branch --merged | egrep -v "(^\*|^master$|^dev$)" | grep "$1" | xargs git branch -d
}

alias a='git add'
alias lb='git branch'
alias lbm='git branch --merged'
alias lbnm='git branch --no-merge'
alias lbr='git branch -r'

# c [message]
# git commit with the message
alias c='git commit -m'

# co [branch]
# git checkout the specified branch
alias co='git checkout'

alias d='git diff'

# s
# git status for current folder forward only (not whole repo)
alias s='git status ./'
alias f='git fetch'
alias m='git merge'
alias p='git push'

# pu
# pushes the current branch to origin and sets the upstream branch to match the current branch
# commonly used when creating a new feature branch, as in
#
# $ co dev
# $ co -b new-feature-branch-name
# $ pu
#
# sets the current branch new-feature-branch-name to track to origin/new-feature-branch-name
#
alias pu='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

#
# Shows nicely formatted git log for only your commits
#
# You must replace AUTHOR with somehting that uniquely idenfies you within the author field
# (can be partial), usually email address
#
alias mylog='git log --author=samuel --full-history --author-date-order --date=local --format="%ae %ad %s"'

# cdd
# change directory to development, which I always have as ~/projects
alias cdd='cd ~/projects'

# mvnr
# Runs MVN project fully
#alias mvnr='mvn clean verify && mvn spring-boot:run -Dspring.profiles.active=local'
alias mvnr='mvn clean verify && mvn spring-boot:run -Dspring-boot.run.profiles=local'

# cd.
# change directory up; one level for each . entered
# cd. up one level
# cd.. up two levels
# etc.
alias cd.='cd ..';
alias cd..='cd ../..'
alias cd...='cd ../../..';
alias cd....='cd ../../../..';
alias cd.....='cd ../../../../..'

# common mistypings ;)
alias cls=clear
alias .exit=exit

# print out the aliases when opening a new terminal to be helpful, does not include functions though like fm and bd
alias

export BASH_SILENCE_DEPRECATION_WARNING=1

export JAVA_HOME=$(/usr/libexec/java_home)
export GRADLE_HOME=/usr/local/Cellar/gradle/6.4/
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
