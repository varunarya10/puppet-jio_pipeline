Mirror, and the snapshotting operation is now set up, and is visible at `http://10.135.126.13:81/snapshots/`

All the snapshots, including the latest, is visible here.

To start using this mirror to get the latest APT packages, put these lines into `/etc/apt/sources.list`:

    deb http://10.135.126.13:81/snapshots/latest/mirror/in.archive.ubuntu.com/ubuntu trusty main
    deb http://10.135.126.13:81/snapshots/latest/mirror/in.archive.ubuntu.com/ubuntu trusty-updates main
    deb http://10.135.126.13:81/snapshots/latest/mirror/in.archive.ubuntu.com/ubuntu trusty universe
    deb http://10.135.126.13:81/snapshots/latest/mirror/in.archive.ubuntu.com/ubuntu trusty-updates universe
    deb http://10.135.126.13:81/snapshots/latest/mirror/security.ubuntu.com/ubuntu trusty-security main
    deb http://10.135.126.13:81/snapshots/latest/mirror/security.ubuntu.com/ubuntu trusty-security universe

If you want to use a specific snapshot, e.g. v23, replace 'latest' above with 'v23'

A cron job is set up on this repo server, which calls `periodic-check.sh` hourly.
