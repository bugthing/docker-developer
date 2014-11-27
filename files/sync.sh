#!/usr/bin/env bash

# Usage:
#  ./sync.sh <ssh key path> <remote ssh host and dir> <local dir>

SSHKEY=${1:-"$HOME/.ssh/sync_ssh_key"}
REMOTESYNCDIR=${2:-"sync@my-home-pc.no-ip.org:/raidarray/HomeSync"}
SYNCDIR=${3:-"$HOME/HomeSync"}

echo "**A Basic home made rsync sync**

  Using SSH key: $SSHKEY
  Remote dir: $REMOTESYNCDIR
  Local dir: $SYNCDIR

"

# Make dir to sync into (if required)..
if [ ! -d ${SYNCDIR} ]; then
  echo ".. creating local dir: $SYNCDIR"
  mkdir ${SYNCDIR}
fi

SSHCOMMAND="ssh -i ${SSHKEY}"
RSYNCARGS="-av -update -delete"

# Sync FROM source..
echo "FROM remote: rsync ${RSYNCARGS} -e \"${SSHCOMMAND}\" ${REMOTESYNCDIR}/ ${SYNCDIR}"
rsync ${RSYNCARGS} -e "${SSHCOMMAND}" ${REMOTESYNCDIR}/ ${SYNCDIR}

# Sync TO source..
echo "TO remote: rsync ${RSYNCARGS} -e \"${SSHCOMMAND}\" $SYNCDIR/ $REMOTESYNCDIR"
rsync ${RSYNCARGS} -e "${SSHCOMMAND}" $SYNCDIR/ $REMOTESYNCDIR
