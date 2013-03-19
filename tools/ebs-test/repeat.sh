#!/bin/sh
DIR=$(pwd | cut -d '/' -f2)
PROG=$1
if [ "$PROG" = "" ];then
	echo "USAGE:  $0 <random-io-program>\n"
	exit 1
fi

DT=$(date +%b%d-%H:%M)

OUTF=$PROG.$DT.out
ERRF=$PROG.$DT.err
> $OUTF
> $ERRF

TIMELOG=$PROG.$DT.times
> $TIMELOG

echo "NOTE:  running /root/$PROG > $OUTF 2> $ERRF"
echo "       saving time outputs to $TIMELOG\n"


while true; do
	time /root/$PROG > $OUTF 2> $ERRF
	RC=$?
	if [ $RC -ne 0 ];then
		echo "FATAL:  [RC=$RC]\n"
		exit $RC
	fi
done 2> $TIMELOG

