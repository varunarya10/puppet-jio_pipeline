#! /bin/bash -eux

MIRRORCONF=/etc/apt/mirror.list
DIST=precise-security
SNAPSRC=/home/repo/repo/skel
SNAPDEST=/home/rushi/repo/snapshots
MIRRORSRC=/home/repo/repo/mirror
RELEASE=/home/repo/repo/mirror/security.ubuntu.com/ubuntu/dists/$DIST/Release

STATUSFILE=/home/rushi/repo/sync-status.txt

OLDMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`


echo "\n---------------------------------------------" >> $STATUSFILE 

echo `sudo apt-mirror $MIRRORCONF` >> $STATUSFILE

NEWMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

if [ "$OLDMD5" == "$NEWMD5" ]; then
    echo "time: `date`. No new packages found" >> $STATUSFILE
    echo "Old and new MD5: $OLDMD5 $NEWMD5" >> $STATUSFILE
else
    ./home/rushi/scripts/periodic-check.sh $SNAPSRC $SNAPDEST
    echo "time: `date`. New packages found." >> $STATUSFILE
    echo "Old and new MD5: $OLDMD5 $NEWMD5" >> $STATUSFILE
fi

