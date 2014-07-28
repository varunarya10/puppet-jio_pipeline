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

