#!/bin/bash -ex

function get_last_tested {
    local SNAP_VER=0
    local VER1=0
    local ARTIFACT1="lastsuccess/STAGING-last-tested"
    local VER2=0
    local ARTIFACT2="lastunsuccess/STAGING-last-tested"
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
    echo v$LASTTESTED > STAGING-last-tested
    echo v$LASTTESTED > staging-version
    exit 0
elif [ $LASTTESTED -gt $UPGRADE_LATEST ]; then
    echo LASTTESTED is greater than NFT_LATEST!!
    exit 2
fi
WSPACE_DIR=`pwd`

echo Running automated staging tests for v$UPGRADE_LATEST
echo Tests successful!

cd $WSPACE_DIR
echo v$UPGRADE_LATEST > STAGING-last-tested
echo v$UPGRADE_LATEST > STAGING-last-success
echo v$UPGRADE_LATEST > staging-version
