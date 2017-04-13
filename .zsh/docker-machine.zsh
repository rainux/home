function docker_machine_prompt_info() {
    [[ -z $DOCKER_MACHINE_NAME ]] && return
    echo " dm:(%{$fg[green]%}$DOCKER_MACHINE_NAME%{$reset_color%})"
}
