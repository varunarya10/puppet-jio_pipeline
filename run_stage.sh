#!/bin/bash -ex
LASTTESTED=0
if [ -e STAGE-last-tested ]; then
    LASTTESTED=`cat STAGE-last-tested | cut -d'v' -f2`
fi

STAGE_LATEST=`cat STAGE-last-success | cut -d'v' -f2`

if [ $LASTTESTED -eq $STAGE_LATEST ]; then
    echo nothing new to test
    exit 0
elif [ $LASTTESTED -gt $STAGE_LATEST ]; then
    echo LASTTESTED is greater than STAGE_LATEST!!
    exit 2
fi

echo Running automated staging tests for v$STAGE_LATEST
echo Tests successful!

echo v$STAGE_LATEST > STAGE-last-tested
echo v$STAGE_LATEST > STAGE-last-success
