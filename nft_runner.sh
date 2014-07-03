#!/bin/bash -ex
LASTTESTED=0
if [ -e NFT-last-tested ]; then
    LASTTESTED=`cat NFT-last-tested | cut -d'v' -f2`
fi

AT_LATEST=`cat AT-last-success | cut -d'v' -f2`

if [ $LASTTESTED -eq $AT_LATEST ]; then
    echo nothing new to test
    exit 0
elif [ $LASTTESTED -gt $AT_LATEST ]; then
    echo LASTTESTED is greater than AT_LATEST!!
    exit 2
fi

echo Running non-functional tests for v$AT_LATEST
echo Tests successful!

echo v$AT_LATEST > NFT-last-tested
echo v$AT_LATEST > NFT-last-success
