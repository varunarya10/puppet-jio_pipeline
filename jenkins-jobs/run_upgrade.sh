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

function get_last_tested {
    local SNAP_VER=0
    local VER1=0
    local ARTIFACT1="lastsuccess/UPGRADE-last-tested"
    local VER2=0
    local ARTIFACT2="lastunsuccess/UPGRADE-last-tested"
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

# Figure out the base and target versions
BASE_VERSION=$(get_snapshot_version $base_snapshot staging-version)
TARGET_VERSION=$(get_snapshot_version $target_snapshot NFT-last-success)
LASTTESTED=$(get_last_tested)

if [ $BASE_VERSION -eq -1 ]
then
    echo "No base (stage) version available, nothing to test."
    echo v$TARGET_VERSION >> UPGRADE-last-tested
    exit 0
fi

if [ $TARGET_VERSION -eq -1 ]
then
    echo "ERROR: Target version to upgrade to is not available."
    exit 1
fi

if [ $LASTTESTED -eq $TARGET_VERSION ]
then
    echo "Nothing new to test"
    echo v$TARGET_VERSION > UPGRADE-last-tested
    echo v$TARGET_VERSION > UPGRADE-last-success
    exit 0
elif [ $LASTTESTED -gt $TARGET_VERSION ]
then
    echo "LASTTESTED is greater than TARGET_VERSION"
    exit 2
fi

unset http_proxy https_proxy no_proxy

if [ -e devops-shell ]; then
  rm -rf devops-shell
fi

echo "base = ${BASE_VERSION} target = ${TARGET_VERSION}"

git clone ssh://root@10.135.126.20/var/www/devops-shell.git -b new-script
cd devops-shell/new/upgrade
./generate-userdata.sh -b $BASE_VERSION -u $TARGET_VERSION
./spawn.sh upgrade$$

echo "Upgrade successful. Now time to run tempest tests against it!"
echo "Tempest tests successful! Done"

./destroy.sh upgrade$$

echo v$TARGET_VERSION > UPGRADE-last-tested
echo v$TARGET_VERSION > UPGRADE-last-success
