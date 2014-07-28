#!/bin/bash -ex

# helper to figure out version
function get_snapshot_version {
    local SNAP_VER=-1
    if [ "$1" == "use_artifact" ]
    then
        if [ -e $2 ]
        then
            SNAP_VER=`cat $2 | cut -d'v' -f2`
        fi
    else 
        SNAP_VER=`echo "$1" | cut -d'v' -f2`
    fi
    echo "$SNAP_VER"
}

# Figure out the base and target versions
BASE_VERSION=$(get_snapshot_version $base_snapshot staging-version)
TARGET_VERSION=$(get_snapshot_version $target_snapshot NFT-last-success)

if [ $BASE_VERSION -eq -1 ]
then
    echo "No base (stage) version available, nothing to test."
    exit 0
fi

if [ $TARGET_VERSION -eq -1 ]
then
    echo "ERROR: Target version to upgrade to is not available."
    exit 1
fi

echo "base = ${BASE_VERSION} target = ${TARGET_VERSION}"
echo "Temp Upgrade Job is running"
sleep 10
echo "Temp Upgrade Job is done"
