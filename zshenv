# Setup git prompt to highlight current branch and status
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=true
# .git-prompt.sh available here: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh
# PROMPT_COMMAND='__git_ps1 "\e[35m\w\e[37m" "\\n\e[30m\\\$ "'

NEWLINE=$'\n'

precmd() {
    __git_ps1 "%F{blue}%~${NEWLINE}" "%F{magenta} $ %F{black}" "%s"
}

# title - sets the title of tab in Hyper
title() {
  if [ -z {$1+x} ]; then
    echo -e "\033]0;${$1-$PWD}"
  else
    echo -e "\033]0;$1"
  fi
}

# fm - Fetch and merge a branch into current branch
#   Usage:
#
#        fm [remote] [branch]
#             remote - which remote to pull from, usually `origin`
#             branch - which branch to pull, usually either the current or `main`
#
#             if neither `remote` or `branch` are specified then they are assumed to
#             be `fm origin main`.
#
#    Example:
#
#         fm upstream dev
#
#         .. is equivalent to ..
#
#         git fetch upstream dev && git merge upstream/dev
#
fm() {
  ORIGIN="${1:-origin}"
  BRANCH="${2:-main}"
  git fetch $ORIGIN $BRANCH && git merge --no-edit $ORIGIN/$BRANCH
}

#
# bd - branch delete
#
# bd [pattern]
#
# Deletes any ALREADY MERGED branches that match a pattern, but will never delete current,
# `main`, `master`, or `dev` branches.
#
# Useful for cleaning up old branches and is always safe to run since it will only delete branches that are already
# merged to the current branch.
#
# Common use case is finish a feature branch, push it, create PR, merge PR, which should automatically delete
# the branch on remote (depends on GitHub settings). Then you can `bd`` your old feature branch to safely remove it
# knowing it's already been merged to current.
#
bd() {
    git branch --merged | egrep -v "(^\*|^main$|^master$|^dev$)" | grep "$1" | xargs git branch -d
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
alias m='git merge --no-edit'
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
# Still needs some work on the author sub-command.
#
# alias mylog="git log --perl-regexp --author='(`git config --get user.email`|`GH_DOMAIN=$(git remote -v | sed -nE 's/.+(git@[^:]+):.+\(push\)/\1/p') ` --full-history --author-date-order --date=format:'%Y-%m-%d %H:%M:%S' --format='%ae %ad %s'"

# cdd
# change directory to development, which I always have as ~/projects
alias cdd='cd ~/projects'

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

# other useful stuff
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias python=python3
alias ls='ls -AFGvw' # -d for directories not recurisve, but then need to modify if target is itself a directory

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
export PATH=$PATH:$HOME/Library/Python/3.9/bin
export PATH=/Users/samuelneff/projects/waterlily/waterlily-ltc-planning-app/node_modules/.bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

eval `ssh-agent -s` > /dev/null
