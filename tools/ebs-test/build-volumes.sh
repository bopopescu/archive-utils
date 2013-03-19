#!/bin/sh

STDO=/tmp/hi.out
>$STDO
STDE=/tmp/hi.err
>$STDE
HOST=$(/bin/hostname | cut -d"." -f1)
ADMIN_SERVER=omoplata
PERF_SERVER=decalz-slave
ZONE="us-east-1a"
DEBUG=1

VOLFILE=/tmp/vols.$(/bin/date +%Y-%m-%d)






Usage()
{
	echo
	echo "USAGE:  $0  <-h|-H|--help> \n"
	echo "\n ... or ...\n"
	echo "USAGE:  $0  [-s size] <-i Instance-ID>\n"
	echo "\n ... or ...\n"
	echo "USAGE:  $0  --fsonly\n"
	exit 0
}



Debug()
{
	if [ $DEBUG -gt 0 ]; then
		echo "DEBUG:  $*"
	fi
	#exec $*
}



ShouldRun()
{
	CMD=$*
	echo "$CMD"
	$CMD >>$STDO 2>>$STDE
	RC=$?
	if [ $RC -ne 0 ];then
		echo "ERROR: [RC=$RC, CMD=$CMD]\n"
		return 1;
	fi
}


MustRun()
{
	CMD=$*
	echo "$CMD"
	$CMD >$STDO 2>$STDE
	RC=$?
	if [ $RC -ne 0 ];then
		echo
		echo "FATAL: [RC=$RC, CMD=$CMD]"
		exit 1;
	fi
}




BuildVols()
{

	if [ "$HOST" != "$ADMIN_SERVER" ];then
		echo "WARNING: run BuildVols only on $ADMIN_SERVER.\n"
		exit 0
	fi	

	echo "Building Test Volumes of size [$SIZE] on EC2 instance [$IID]."
	

	# Sample command & return string:
	#omoplata:~/PERF$ ec2-create-volume -z us-east-1a -s 15
	#VOLUME	vol-e14ad19f	15		us-east-1a	creating	2013-01-15T00:05:54+0000	standard


	> $VOLFILE
	echo
	
	# EBS Config:  No RAID, Single EBS vol
	DEVS="e"
	Debug "SZ=[$SIZE],DEV=[$DEVS]"
	for DEV in $DEVS; do 
		MustRun ec2-create-volume -z us-east-1a -s $SIZE 
		VOL=$(awk '$1 == "VOLUME" {print $2}' $STDO)
		echo $VOL >> $VOLFILE
		MustRun ec2-attach-volume $VOL -i $IID -d /dev/sd$DEV
	done


	# EBS Config:  No RAID, Single Provisioned IOPS EBS vol
	# IOPS capped at lower of: a) 10 IOPS/gig or b)2000/vol.  This only uses 10/gig limit
	IOPS=`expr $SIZE \\* 10`
	DEVS="f"
	Debug "SZ=[$SIZE],DEV=[$DEVS],IOPS=[$IOPS]"
	for DEV in $DEVS; do 
		MustRun ec2-create-volume -z us-east-1a -s $SIZE -t io1 -i $IOPS
		VOL=$(awk '$1 == "VOLUME" {print $2}' $STDO)
		echo $VOL >> $VOLFILE
		MustRun ec2-attach-volume $VOL -i $IID -d /dev/sd$DEV
	done


	# EBS Config:  RAID0, 4 EBS vols
	SLICE=`expr $SIZE / 4`
	DEVS="g h i j"
	Debug "SLICE=[$SLICE],DEVS=[$DEVS]"
	for DEV in $DEVS; do 
		MustRun ec2-create-volume -z us-east-1a -s $SLICE
		VOL=$(awk '$1 == "VOLUME" {print $2}' $STDO)
		echo $VOL >> $VOLFILE
		MustRun ec2-attach-volume $VOL -i $IID -d /dev/sd$DEV
	done


	# EBS Config:  RAID0, 12 EBS vols
	SLICE=`expr $SIZE / 12`
	DEVS="k l m n o p q r s t u v"
	Debug "SLICE=[$SLICE],DEVS=[$DEVS]"
	for DEV in $DEVS; do 
		MustRun ec2-create-volume -z us-east-1a -s $SLICE
		VOL=$(awk '$1 == "VOLUME" {print $2}' $STDO)
		echo $VOL >> $VOLFILE
		MustRun ec2-attach-volume $VOL -i $IID -d /dev/sd$DEV
	done

}



CleanupVols ()
{
	if [ "$HOST" != "$ADMIN_SERVER" ];then
		Debug "WARNING: run CleanupVols only on $ADMIN_SERVER.\n"
		return 0
	fi	


	A='omoplata:~/PERF$ ec2-describe-volumes | grep -i avail
VOLUME	vol-3a72d055	10	snap-16620b6b	us-east-1a	available	2012-04-17T00:47:55+0000	standard	
VOLUME	vol-1c19ed63	125		us-east-1a	available	2012-12-04T20:37:55+0000	standard	
VOLUME	vol-fb19ed84	125		us-east-1a	available	2012-12-04T20:38:00+0000	standard	
VOLUME	vol-9519edea	125		us-east-1a	available	2012-12-04T20:38:09+0000	standard	
VOLUME	vol-351aee4a	125		us-east-1a	available	2012-12-04T20:38:16+0000	standard	
VOLUME	vol-f0d8438e	100		us-east-1a	available	2013-01-14T22:50:33+0000	standard'


	DELVOL=$(ls /tmp/vol* | tail -1)

	echo "\n ENTER a vol file, the word 'avail' for all 'available', or enter to default to [$DELVOL]\n"

	read FNAME
	if [ "$FNAME" = "" ];then
		Debug "No filename entered, using [$DELVOL]."
	elif [ "$FNAME" = "avail" ];then
		DELVOL="avail"
	else
		DELVOL=$FNAME
	fi	

	
	if [ "$DELVOL" = "avail" ];then
		ec2-describe-volumes > $STDO
		VOLS=$(cat $STDO |  awk '$5 == "available" || $6 == "available" {print $2}')
		for VOL in $VOLS; do
			MustRun ec2-delete-volume $VOL
		done

	else
		for VOL in $(cat $DELVOL); do
			ShouldRun ec2-detach-volume $VOL
			#echo
		done
		sleep 90
		for VOL in $(cat $DELVOL); do
			ShouldRun ec2-delete-volume $VOL
		done
	fi


}


BuildFS()
{
	if [ "$HOST" != "$PERF_SERVER" ];then
		echo "WARNING: run this only on $PERF_SERVER.\n"
		exit 0
	fi	

	if [ 0 -gt 1 ];then
	MustRun mkfs.xfs -f /dev/xvde
	MustRun mkfs.xfs -f /dev/xvdf
	MustRun mdadm --create --verbose /dev/md0 --level=0 --raid-devices=4 /dev/xvdg /dev/xvdh /dev/xvdi /dev/xvdj
	MustRun mkfs.xfs -f /dev/md0
	MustRun mdadm --create --verbose /dev/md1 --level=0 --raid-devices=12 /dev/xvdk /dev/xvdl /dev/xvdm /dev/xvdn /dev/xvdo /dev/xvdp /dev/xvdq /dev/xvdr /dev/xvds /dev/xvdt /dev/xvdu /dev/xvdv
	MustRun mkfs.xfs -f /dev/md1
	fi

	MustRun mount /dev/xvde /mnt/noraid-1vol
	MustRun mount /dev/xvdf /mnt/noraid-PIOPS
	MustRun mount /dev/md0 /mnt/raid0-4vol
	MustRun mount /dev/md1 /mnt/raid0-12vol
}



CleanupFS()
{
	if [ "$HOST" != "$PERF_SERVER" ];then
		echo "WARNING: run CleanupFS only on $PERF_SERVER.\n"
		return 0
	fi	


	MustRun umount /mnt/noraid-1vol 
	MustRun umount /mnt/noraid-PIOPS
	MustRun umount /mnt/raid0-4vol
	MustRun umount /mnt/raid0-12vol 

	MustRun mdadm --stop /dev/md0
	MustRun mdadm --stop /dev/md1

}



############################################################
# MAIN

	
	if [ $# -eq 0 ];then
		Usage
	fi

	IID=""
	SIZE=50  # Just picked a default

	while [ $# -gt 0 ]; do
	
		OPT=$1
		Debug "REM={$*} CNT={$#}, OPT={$OPT}"
		shift

		case $OPT in 
	
		--help|-help|help|-h|--h|-H|--H)
			Usage
			exit 0
			;;

		--clean|-c)
			CleanupFS
			CleanupVols
			exit 0
			;;
	
	
		--fsonly|-fs)
			BuildFS
			exit 0
			;;

		-i)
			IID=$1
			shift
			;;

	
		-s)
			SIZE=$1
			shift
			;;
	
		*)
			#echo "Please select an instance ID.   Run 'ldi' if you know the hostname but not its ID.\n"
			Usage
			exit 1
			;;
	
		esac
	done

	if [ "$IID" = "" ];then
		Usage
	fi
	BuildVols
	Debug "IID=$IID, SIZE=$SIZE"

