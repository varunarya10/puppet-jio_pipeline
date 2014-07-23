#!/bin/bash -ex

# TODO(ynshenoy): remove hard-coding with values pulled from config
REPOSERVER="10.135.126.20:81"
PROXY="http://10.135.121.138:3128"
DEVSTACK_IP=19.0.0.9
SNAPDIR=snapshots

# Deal with the proxy stuff on the dev/stage servers
export http_proxy=$PROXY
export https_proxy=$PROXY
export no_proxy="localhost,127.0.0.1,10.135.126.13,$DEVSTACK_IP"

LASTTESTED=0
if [ -e AT-last-tested ]; then
    LASTTESTED=`cat AT-last-tested | cut -d'v' -f2`
fi
wget http://$REPOSERVER/$SNAPDIR/latest-snapshot --no-cache
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

git checkout http://10.135.126.20:81/devops-shell.git
cd devops-shell/spawn_resources/source
bash makebin.sh
cd ..
chmod 777 spawn_resources.bin
bash spawn_resources.bin -u $CLOUD_USERNAME -p $CLOUD_PASSWORD -t test_acceptance -l -n $REPOLATEST

echo "Virtualized cloud should be up now."
echo "Deleting cloud.."

bash spawn_resources.bin -u $CLOUD_USERNAME -p $CLOUD_PASSWORD -t test_acceptance -d

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

