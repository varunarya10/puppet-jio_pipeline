Mirror, and the snapshotting operation is now set up, and is visible at `http://10.135.126.13/snapshots/`

All the snapshots, including the latest, are visible there. An example `sources.list` file is provided at the root of this repository.

If you want to use a specific snapshot, say v23, replace 'latest' in the `sources.list`  with 'v23'

A cron job is set up on this repo server, which calls `periodic-check.sh` hourly.
