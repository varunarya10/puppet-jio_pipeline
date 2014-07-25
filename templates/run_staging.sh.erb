#!/bin/bash -ex
LASTTESTED=0
if [ -e STAGE-last-tested ]; then
    LASTTESTED=`cat STAGE-last-tested | cut -d'v' -f2`
fi

NFT_LATEST=`cat NFT-last-success | cut -d'v' -f2`

if [ $LASTTESTED -eq $NFT_LATEST ]; then
    echo nothing new to test
    exit 0
elif [ $LASTTESTED -gt $NFT_LATEST ]; then
    echo LASTTESTED is greater than NFT_LATEST!!
    exit 2
fi

echo Running automated staging tests for v$NFT_LATEST
echo Tests successful!

echo v$NFT_LATEST > STAGE-last-tested
echo v$NFT_LATEST > STAGE-last-success
