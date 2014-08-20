Mirror, and the snapshotting operation is now set up, and is visible at `http://10.135.126.13/snapshots/`

All the snapshots, including the latest, are visible there. An example `sources.list` file is provided at the root of this repository.

If you want to use a specific snapshot, say v23, replace 'latest' in the `sources.list`  with 'v23'

A cron job is set up on this repo server, which calls `periodic-check.sh` hourly.

### Snapshots repository
It is assumed that snapshots directory is already existent at the provided
URL, and that it contains atleast two snapshot versions already.

The current setup is described here:

The original APT-mirror directory is `/home/repo/repo` on server
`10.135.126.13`

    # ls /home/repo/repo
    mirror  skel  var

The directory where snapshots are taken is `/home/repo/repo-snapshots`. To
take a snapshot manually, you need to run the following

    ./repo-sync/snapshot.sh /home/repo/repo /home/repo/repo-snapshots

In the current setup, `repo-snapshots` is symlinked to `/var/www/snapshots`, so
that the repository can be accessed at `http://10.135.126.13/snapshots`.
