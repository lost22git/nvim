_default:
    @just --list --unsorted

fmt:
    fd -t f -g '*.fnl' -x fnlfmt --fix

[unix]
init:
    # -p to ignore exist-error
    mkdir -p ~/.config
    ln -s {{ justfile_directory() }} ~/.config/nvim

[windows]
init:
    ./init.ps1
