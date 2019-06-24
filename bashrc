fm() {
    git fetch $1 $2 && git merge $1/$2
}
bd() {
    git branch --merged | egrep -v "(^\*|master|dev)" | grep "$1" | xargs git branch -d
}
alias a='git add'
alias lb='git branch'
alias lbm='git branch --merged'
alias lbnm='git branch --no-merge'
alias lbr='git branch -r'
alias c='git commit -m'
alias co='git checkout'
alias d='git diff'
alias s='git status ./'
alias f='git fetch'
alias m='git merge'
alias p='git push'
alias pu='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias mylog='git log --author=AUTHOR --full-history --author-date-order --date=local --format="%ae %ad %s"'
alias cdd='cd ~/projects'
alias cd..='cd ..'
alias cls=clear
alias .exit=exit
cdd
alias

