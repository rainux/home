. ~/.zsh/rc.zsh

if [[ -x `which direnv` ]]; then
    eval "$(direnv hook $0)"
fi
