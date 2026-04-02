_default:
    @just --list --unsorted

fmt:
    fd -t f -g '*.fnl' -x fnlfmt --fix
