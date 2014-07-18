#!/bin/bash -ex

# TODO(ynshenoy): remove hard-coding with values pulled from config
REPOSERVER="10.135.126.13:81"
PROXY="http://10.135.121.138:3128"
DEVSTACK_IP=19.0.0.9

# Deal with the proxy stuff on the dev/stage servers
export http_proxy=$PROXY
export https_proxy=$PROXY
export no_proxy="localhost,127.0.0.1,10.135.126.13,$DEVSTACK_IP"

LASTTESTED=0
if [ -e AT-last-tested ]; then
    LASTTESTED=`cat AT-last-tested | cut -d'v' -f2`
fi
wget http://$REPOSERVER/snapshots-temp/latest-snapshot --no-cache
REPOLATEST=`cat latest-snapshot | cut -d'v' -f2`
rm -f latest-snapshot 2> /dev/null

if [ $LASTTESTED -eq $REPOLATEST ]; then
    echo nothing new to test
    exit 0
elif [ $LASTTESTED -gt $REPOLATEST ]; then
    echo LASTTESTED is greater than REPOLATEST!!
    exit 2
fi

echo "Creating virtualized cloud in beta.jiocloud.com."
echo "Version number is v$REPOLATEST (though not used)."

source creds
svn checkout https://10.135.121.138/svn/devops/automation/spawn_resources --username $SVN_USERNAME --password $SVN_PASSWORD
cd spawn_resources
bash spawn_resources.bin -u $CLOUD_USERNAME -p $CLOUD_PASSWORD -l

echo "Virtualized cloud should be up now."
echo "Deleting cloud.."

bash spawn_resources.bin -u $CLOUD_USERNAME -p $CLOUD_PASSWORD -d

echo "Virtualized cloud deleted."

cd ..
rm -rf spawn_resources

echo "Virtualized env creation successful!"

#echo running tempest test for v$REPOLATEST

#if [[ ! -e tempest ]]; then
#    git clone http://github.com/openstack/tempest
#    cd tempest/
#else
#    cd tempest/
#    git pull origin master
#fi

# ASSUMPTION: tempest.conf for devstack VM is exposed from that machine, on port 81, at $DEVSTACK_IP:81/tempest.conf
# Still a temporary hack, but more easily reproducible than the previous one
#rm -f etc/tempest.conf* 2> /dev/null
#wget $DEVSTACK_IP:81/tempest.conf --no-cache
#mv tempest.conf etc/
#
# ./run_tempest.sh -N -- run tempest.cli.simple_read_only.test_keystone.SimpleReadOnlyKeystoneClientTest
#
#cd ..
#echo tempest test successful!

echo v$REPOLATEST > AT-last-tested
echo v$REPOLATEST > AT-last-success

