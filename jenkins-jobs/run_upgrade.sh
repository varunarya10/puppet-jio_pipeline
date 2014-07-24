#!/bin/bash -ex

# helper to figure out version
function get_snapshot_version {
    local SNAP_VER=0
    if [ "$1" == "use_artifact" ]
    then
        SNAP_VER=`cat $2 | cut -d'v' -f2`
    else 
        SNAP_VER=`echo "$1" | cut -d'v' -f2`
    fi
    echo "$SNAP_VER"
}

# Figure out the base and target versions
BASE_VERSION=$(get_snapshot_version $base_snapshot staging-version)
TARGET_VERSION=$(get_snapshot_version $target_snapshot NFT-last-success)

echo "base = ${BASE_VERSION} target = ${TARGET_VERSION}"
echo "Temp Upgrade Job is running"
sleep 10
echo "Temp Upgrade Job is done"
