#!/bin/bash
# nextint.sh

if [ $# -ne 1 ]; then :
  echo "Usage: nextint.sh int_file" >&2
  exit 1
fi

INTFILE="$1"
if [ "`wc -l <$INTFILE`" -ne 1 -o "`wc -w <$INTFILE`" -ne 3 ] ; then :
  echo "nextint: int_file $INTFILE not valid?" >&2
  exit 2
fi

MUTEX="/tmp/nextint-$INTFILE.mutex"
PID="$$"

mlock.sh $MUTEX $PID

set `cat $INTFILE`
LO=$1
HI=$2
I=$3
I=`expr $I + 1`
if [ $I -gt $HI ]; then
  I=$LO
fi

echo "$LO $HI $I" >$INTFILE

munlock.sh $MUTEX $PID

echo $I
