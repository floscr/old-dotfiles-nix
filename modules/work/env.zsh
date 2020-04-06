#!/usr/bin/env zsh

export MEISTERLABS_DIR="$HOME/Code/Meisterlabs"
export MEISTERLABS_MINDMEISTER_BE_DIR="$MEISTERLABS_DIR/mindmeister"
export MEISTERLABS_MINDMEISTER_FE_DIR="$MEISTERLABS_DIR/mindmeister-web"
export MEISTERLABS_MINDMEISTER_DOCKER_DIR="$MEISTERLABS_DIR/docker-dev-environment"

mm-build-bundle() {
    rm -rf build
    nice -n10 npm run "$1"
    notify-send "Bundle \"$1\" built."
    docker exec -it mm-rails /bin/bash -c "rm -rf /opt/mindmeister-web && mkdir -p /opt/mindmeister-web"
    docker cp build mm-rails:/opt/mindmeister-web
    cd $MEISTERLABS_MINDMEISTER_DOCKER_DIR
    ./mindmeister/rake "client:import_bundles_testing['$2']"
}
