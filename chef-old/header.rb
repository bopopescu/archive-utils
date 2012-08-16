##
# Description
#
# @author   Bryan Kroger ( bryan@lockerz.com )
# @copyright 2011 lockerz.com

ssIORawReceived_ssIORawReceived
ssIORawSent_ssIORawSent
ssCpuUser_ssCpuUser

## wit

cap site:wit:reverseproxy chef:client &
cap site:wit:webfe chef:client &
cap site:wit:commerce chef:client &
cap pegasus:wit:webfe chef:client &
cap phoenix:wit:service chef:client &
cap phoenix:wit:argo chef:client &
cap dba:wit:mongo-master chef:client &


cap site:uat:reverseproxy chef:client &
cap site:uat:webfe chef:client &
cap pegasus:uat:webfe chef:client &
cap pegasus:uat:argo chef:client &


