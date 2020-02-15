#!/bin/bash
# mlock.sh

if [ $# -ne 2 ]; then :
  echo "Usage: mlock.sh mutex_file caller_pid" >&2
  exit 1
fi

MUTEX="$1"
PID="$2"

if kill -0 $PID; then :
else :
  echo "mlock: PID $PID not valid?" >&2
  exit 2
fi
if touch $MUTEX; then :
else :
  echo "mlock: mutex $MUTEX not valid?" >&2
  exit 2
fi

echo $PID >>$MUTEX

CHK_PID=`head -1 $MUTEX`
while [ "$CHK_PID" != "$PID" ]; do :
  if kill -0 $CHK_PID; then echo sleep; sleep 0.3
  else
    echo "mlock.sh: Warning: cleaning up $MUTEX after $CHK_PID" >&2
    egrep -v "^$CHK_PID\$" $MUTEX >$MUTEX.$PID
    mv $MUTEX.$PID $MUTEX
  fi

  CHK_PID=`head -1 $MUTEX`
done
