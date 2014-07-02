#!/bin/bash -ex
LASTTESTED=0
if [ -e AT-last-tested ]; then
    LASTTESTED=`cat AT-last-tested | cut -d'v' -f2`
fi
wget http://10.135.126.13/snapshots/latest-snapshot
REPOLATEST=`cat latest-snapshot | cut -d'v' -f2`
rm -f latest-snapshot 2> /dev/null

if [ $LASTTESTED -eq $REPOLATEST ]; then
    echo nothing new to test
    exit 0
elif [ $LASTTESTED -gt $REPOLATEST ]; then
    echo LASTTESTED is greater than REPOLATEST!!
    exit 2
fi

echo running tempest test for v$REPOLATEST

export http_proxy=http://10.135.121.138:3128
export https_proxy=http://10.135.121.138:3128
export no_proxy=localhost,127.0.0.1,10.1.1.2

if [[ ! -e tempest ]]; then
    git clone http://github.com/openstack/tempest
    cd tempest/
else
    cd tempest/
    git pull origin master
    rm etc/tempest.conf
fi

cp /home/rushi/dummy.tempest.conf etc/tempest.conf
 ./run_tempest.sh -N -- run tempest.cli.simple_read_only.test_keystone.SimpleReadOnlyKeystoneClientTest


echo tempest test successful!

echo v$REPOLATEST > AT-last-tested
echo v$REPOLATEST > AT-last-success

