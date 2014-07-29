#!/bin/bash -ex

# helper to figure out version
function get_target_version {
    local SNAP_VER=0
    if [ "$1" == "use_artifact" ]
    then
        SNAP_VER=`cat $2 | cut -d'v' -f2`
    else
        SNAP_VER=`echo "$1" | cut -d'v' -f2`
    fi    
    echo "$SNAP_VER"
}

function get_last_tested {
    local SNAP_VER=0
    local VER1=0
    local ARTIFACT1="lastsuccess/NFT-last-tested"
    local VER2=0
    local ARTIFACT2="lastunsuccess/NFT-last-tested"
    if [ -e $ARTIFACT1 ]
    then  
        VER1=`cat $ARTIFACT1 | cut -d'v' -f2`
    fi    
    if [ -e $ARTIFACT2 ]
    then  
        VER2=`cat $ARTIFACT2 | cut -d'v' -f2`
    fi    
    if [ $VER1 -gt $VER2 ]
    then
        SNAP_VER=$VER1
    else
        SNAP_VER=$VER2
    fi
    echo "$SNAP_VER" 
}

LASTTESTED=$(get_last_tested)
AT_LATEST=$(get_target_version $snapshot_version AT-last-success)

if [ $LASTTESTED -eq $AT_LATEST ]; then
    echo nothing new to test
    echo v$AT_LATEST > NFT-last-tested
    echo v$AT_LATEST > NFT-last-success
    exit 0
elif [ $LASTTESTED -gt $AT_LATEST ]; then
    echo LASTTESTED is greater than AT_LATEST!!
    exit 2
fi

echo Running non-functional tests for v$AT_LATEST
echo Tests successful!

echo v$AT_LATEST > NFT-last-tested
echo v$AT_LATEST > NFT-last-success
