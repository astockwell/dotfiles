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
alias ll="ls -laF --color=auto"

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

# GitHub Codespaces
if [ "$CODESPACES" == "true" ]; then
	# (Codespaces bash prompt theme)
	__bash_prompt() {
	    local userpart='`export XIT=$? \
		&& [ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} " || echo -n "\[\033[0;32m\]\u " \
		&& [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜"`'
	    local gitbranch='`\
		if [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then \
		    export BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); \
		    if [ "${BRANCH}" != "" ]; then \
			echo -n "\[\033[0;36m\](\[\033[1;31m\]${BRANCH}" \
			&& if git ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
				echo -n " \[\033[1;33m\]✗"; \
			fi \
			&& echo -n "\[\033[0;36m\]) "; \
		    fi; \
		fi`'
	    local lightblue='\[\033[1;34m\]'
	    local removecolor='\[\033[0m\]'
	    PS1="${userpart} ${lightblue}\w ${gitbranch}${removecolor}\$ "
	    unset -f __bash_prompt
	}
	__bash_prompt
	export PROMPT_DIRTRIM=4
fi
