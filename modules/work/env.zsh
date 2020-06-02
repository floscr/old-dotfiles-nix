#!/usr/bin/env zsh

export MEISTERLABS_DIR="$HOME/Code/Meisterlabs"
export MEISTERLABS_MINDMEISTER_BE_DIR="$MEISTERLABS_DIR/mindmeister"
export MEISTERLABS_MINDMEISTER_FE_DIR="$MEISTERLABS_DIR/mindmeister-web"
export MEISTERLABS_MINDMEISTER_DOCKER_DIR="$MEISTERLABS_DIR/docker-dev-environment"

function mm-sh {
    docker exec -it mm-rails /bin/bash
}

function mm-load {
    cd $MEISTERLABS_MINDMEISTER_DOCKER_DIR
    ./mindmeister/rake load
}

function mm-bundle {
    cd $MEISTERLABS_MINDMEISTER_DOCKER_DIR
    ./mindmeister/bundle
}

function mm-attach {
    cd $MEISTERLABS_MINDMEISTER_DOCKER_DIR
    ./mindmeister/attach
}
