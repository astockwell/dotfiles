# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

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
	export PATH="$PATH:$HOME/bin"
fi
# Add Homebrew bins to path
if [ -d /usr/local/sbin ]; then
	export PATH="$PATH:/usr/local/sbin"
fi
# Add Go bins to path
if [ -d $HOME/go/bin ]; then
	export PATH="$PATH:$HOME/go/bin"
fi
# Add Python bins to path
if [ -d $HOME/.local/bin ]; then
	export PATH="$PATH:$HOME/.local/bin"
fi

# Backup shell command history
if [ -d $HOME/.logs/shell ]; then
	export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/shell/shell-history-$(date "+%Y-%m-%d").log; fi'
fi

# Homebrew Completions
if type brew &>/dev/null; then
	HOMEBREW_PREFIX="$(brew --prefix)"
	if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
		source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	else
		for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
			[[ -r "$COMPLETION" ]] && source "$COMPLETION"
		done
	fi
fi

# asdf-vm Completions
if [ -f /usr/local/opt/asdf/asdf.sh ]; then
	source /usr/local/opt/asdf/asdf.sh
fi
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
	source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

# Aliases
alias ll="ls -laF"

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

# G(NU)PG
export GPG_TTY=$(tty)
