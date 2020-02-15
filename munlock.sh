#!/bin/bash
# munlock.sh

if [ $# -ne 2 ]; then :
  echo "Usage: munlock.sh mutex_file caller_pid" >&2
  exit 1
fi

MUTEX="$1"
PID="$2"

if kill -0 $PID; then :
else :
  echo "munlock: PID $PID not valid?" >&2
  exit 2
fi
if touch $MUTEX; then :
else :
  echo "munlock: mutex $MUTEX not valid?" >&2
  exit 2
fi

CHK_PID=`head -1 $MUTEX`
if [ "$CHK_PID" != "$PID" ]; then :
  echo "munlock: Warning: PID $PID not own mutex $MUTEX? (CHK_PID=$CHK_PID)" >&2
fi

egrep -v "^$PID\$" $MUTEX >$MUTEX.$PID
mv $MUTEX.$PID $MUTEX
