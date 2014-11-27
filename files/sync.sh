#!/usr/bin/env bash

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

SSHCOMMAND="ssh -i $SSHKEY"
RSYNCCOMMAND="rsync -av -update -delete -e '$SSHCOMMAND'"

# Sync FROM source..
echo "FROM remote: $RSYNCCOMMAND $REMOTESYNCDIR/ $SYNCDIR"
FROM=`$RSYNCCOMMAND $REMOTESYNCDIR/ $SYNCDIR`

# Sync TO source..
echo "TO remote: $RSYNCCOMMAND $SYNCDIR/ $REMOTESYNCDIR"
TO=`$RSYNCCOMMAND $SYNCDIR/ $REMOTESYNCDIR`
