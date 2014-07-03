#!/bin/bash -ex
if [ ! -e pipeline ]; then
    git clone https://github.com/rushiagr/pipeline
    cd pipeline/
else
    cd pipeline/
    git pull origin master
fi

chmod +x ./run_acceptance.sh
./run_acceptance.sh
