#! /bin/bash -eux

# Periodic job to keep the local mirror updated. This script takes snapshot
# of any arbitrary directory, if the update job actually says there ARE
# updates to be downloaded for one particular repository and one particular
# distribution. For example, you can say that for in.archive.ubuntu.com
# repository, for Precise, if there are any updates, take a snapshot.
# Currently, you cannot specify more than one repository, or distribution to
# take snapshot against.
#
# This script writes status to a file, so that this script can be added to
# a cron easily.

MIRRORCONF=/etc/apt/mirror.list

DIST=precise
RELEASE=/home/repo/repo/mirror/jiocloud.rustedhalo.com/ubuntu/dists/$DIST/Release

SNAPSRC=/home/repo/repo
SNAPDEST=/home/repo/repo-snapshots

STATUSFILE=/home/repo/sync-status.txt

OLDMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

echo "---------------------------------------------" >> $STATUSFILE 

echo `sudo apt-mirror $MIRRORCONF` >> $STATUSFILE

NEWMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

if [ "$OLDMD5" == "$NEWMD5" ]; then
    echo "time: `date`. No new packages found" >> $STATUSFILE
    echo "Old and new MD5: $OLDMD5 $NEWMD5" >> $STATUSFILE
else
    ./home/rushi/scripts/snapshot.sh $SNAPSRC $SNAPDEST
    echo "time: `date`. New packages found." >> $STATUSFILE
    echo "Old and new MD5: $OLDMD5 $NEWMD5" >> $STATUSFILE
fi

