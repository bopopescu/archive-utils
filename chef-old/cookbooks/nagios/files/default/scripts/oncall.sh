#!/bin/bash
#

TMPFILE='/tmp/oncalladmin.tmp'
MSGFILE='/tmp/oncall-msg.txt'
ONCALLFILE='/etc/nagios/contacts/notifications-oncall.cfg'

/bin/rm -f ${TMPFILE} ${MSGFILE}

/etc/nagios/scripts/whosOnFirst.py >${TMPFILE} 2>${MSGFILE}
if [ $? -ne 0 ];then
	echo "ERROR: Unable to retrieve calendar. Exiting!"
	cat ${MSGFILE}
	exit 1
fi

if [ `diff ${ONCALLFILE} ${TMPFILE} | wc -l` -gt 0 ];then
        /bin/cp ${ONCALLFILE} ${ONCALLFILE}.bak
        if [ $? -ne 0 ];then
                echo "WARNING: Unable to backup ${ONCALLFILE}"
        fi
        /bin/mv ${TMPFILE} ${ONCALLFILE}
        if [ $? -ne 0 ];then
                echo "ERROR: Unable to replace ${ONCALLFILE}. Please investigate!"
                exit 1
        fi
        #/etc/init.d/nagios reload
        if [ $? -ne 0 ];then
                echo "ERROR: Unable to reload nagios. Please investigate!"
                exit 1
	else
		## Successfully reloaded nagios. Time to tell everyone.
		# First - let's set up the redirect on ooc@lockerz.com
		/tmp/lockerz/oocSetForwarding >> ${MSGFILE}

		## Send the email to everyone
		/bin/mailx -s 'Operations OnCall Roster' alerts@lockerz.com < ${MSGFILE}
        fi
else
        rm ${TMPFILE}
fi
