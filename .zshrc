# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Make zsh arrow-key modifiers respect slashes like bash does
autoload -U select-word-style
select-word-style bash

# Add includes specific to each computer
if [ -d $HOME/.localizedrc ]; then
	if stat -t $HOME/.localizedrc/.*rc > /dev/null 2>&1
	then
		for f in $HOME/.localizedrc/.*rc
	    do
	    	source $f
	    done
	else
		echo No .localizedrc files found
	fi
fi

# Add Static bins to path
if [ -d $HOME/bin ]; then
	path+=("$HOME/bin")
fi
# Add Homebrew bins to path
if [ -d /usr/local/sbin ]; then
	path+=("/usr/local/sbin")
fi
# Add Go bins to path
if [ -d $HOME/go/bin ]; then
	path+=("$HOME/go/bin")
fi
# Add Python bins to path
if [ -d $HOME/.local/bin ]; then
	path+=("$HOME/.local/bin")
fi
# Finalize PATH
export PATH

# Backup shell command history
if [ -d $HOME/.logs/shell ]; then
	export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history -1)" >> ~/.logs/shell/shell-history-$(date "+%Y-%m-%d").log; fi'
	precmd() { eval "$PROMPT_COMMAND" }
fi

# Homebrew Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# asdf-vm Completions
if [ -f /usr/local/opt/asdf/asdf.sh ]; then
	source /usr/local/opt/asdf/asdf.sh
fi
if [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
	source /usr/local/opt/asdf/libexec/asdf.sh
fi
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
	source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

# Aliases
alias ll="ls -laF"
alias cl='fc -ln -1 | awk "{\$1=\$1}1" | pbcopy'

# Git aliases
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gl='git logg'
alias gp='git push'
alias gs='git status'
alias gt='git tag'

# Git Undo Helpers
alias gitup="if [ ! -d .git ]; then
	git init;
	git add .;
	git commit -am 'initial commit';
	git status;
fi"
alias gitjk='while true; do
	cat .gitignore;
	git clean -n -d;
	read -p "This is destructive, are you sure? " yn;
	case $yn in
		[Yy]* ) git clean -f -d; git checkout -- .; git status; break;;
		[Nn]* ) echo nevermind, no changes made; break;;
		* ) break;;
	esac;
done'
alias gitdown='while true; do
        read -p "Delete repo, are you sure? " yn;
        case $yn in
                [Yy]* ) rm -Rf .git/; break;;
                [Nn]* ) echo nevermind, no changes made; break;;
                * ) break;;
        esac;
done'

alias cdgo='cd ~/Dropbox/Code/Go'

# Docker aliases (via https://github.com/docker/docker/issues/23371)
# Clear containers
alias dcc='docker rm -f $(docker ps -a -q)'
# Clear images
alias dci='docker rmi -f $(docker images -a -q)'
# Clear volumes
alias dcv='docker volume rm $(docker volume ls -q)'
# Better cp
alias cpx='rsync -ahz --progress'

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# Encrypt/Decrypt aliases
fnencrypt() {
	tar cz $1 | openssl enc -aes-256-cbc -e
}
fndecrypt() {
	openssl enc -aes-256-cbc -d -in $1 | tar xz
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# G(NU)PG
export GPG_TTY=$(tty)

# Python poetry dependency manager
if [ -d $HOME/.poetry ]; then
	path+=("$HOME/.poetry/bin")
fi

### GITHUB CODESPACES-SPECIFIC ADDITIONS ###
if [ "$CODESPACES" == "true" ]; then
	# Git auto-completion (including branch-names)
	if [ -f ~/.oh-my-zsh/plugins/gitfast/git-completion.bash ]; then
	  . ~/.oh-my-zsh/plugins/gitfast/git-completion.bash
	fi
fi
