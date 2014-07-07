#!/bin/bash -e

# Usage: snapshot.sh SRCDIR SNAPDIR
#    If this is the first time, the script will take a full backup of
#    SRCDIR at SNAPDIR/v1. From next time onwards, an incremental backup
#    is taken at SNAPDIR/v2, SNAPDIR/v3, etc

SRCDIR="${1}"
SNAPDIR="${2}"
SNAPNAME=v1

mkdir -p "${SNAPDIR}"

if test -d "${SNAPDIR}/latest"
then
	CURRSNAPNUMBER=`readlink "${SNAPDIR}/latest" | cut -d'v' -f2`
	SNAPNAME=v$(($CURRSNAPNUMBER+1))
	echo snapname is $SNAPNAME

	cp -al "$(readlink -f ${SNAPDIR}/latest)" "${SNAPDIR}/${SNAPNAME}"
	rm "${SNAPDIR}/latest"
fi
rsync -a --delete "${SRCDIR}/" "${SNAPDIR}/${SNAPNAME}/"
ln -s "${SNAPNAME}" "${SNAPDIR}/latest"
echo $SNAPNAME > "${SNAPDIR}/latest-snapshot"
