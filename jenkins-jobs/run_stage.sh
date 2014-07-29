#!/bin/bash -ex

function get_last_tested {
    local SNAP_VER=0
    local VER1=0
    local ARTIFACT1="lastsuccess/STAGE-last-tested"
    local VER2=0
    local ARTIFACT2="lastunsuccess/STAGE-last-tested"
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
UPGRADE_LATEST=`cat UPGRADE-last-success | cut -d'v' -f2`

if [ $LASTTESTED -eq $UPGRADE_LATEST ]; then
    echo nothing new to test
    echo v$LASTTESTED > STAGE-last-tested
    echo v$LASTTESTED > stage-version
    exit 0
elif [ $LASTTESTED -gt $UPGRADE_LATEST ]; then
    echo LASTTESTED is greater than NFT_LATEST!!
    exit 2
fi

echo Running automated staging tests for v$UPGRADE_LATEST
echo Tests successful!

echo v$UPGRADE_LATEST > STAGE-last-tested
echo v$UPGRADE_LATEST > STAGE-last-success
echo v$UPGRADE_LATEST > stage-version
