#!/bin/bash

script_name=`basename $0`
LOGFILE="/var/log/puppetlabs/r10k/${script_name}.log"

check_process=`ps -ef | grep -v grep |grep 'r10k deploy environment'`

if [ -n "${check_process}" ]
then
  echo "r10k is still running. Exiting ...." >>$LOGFILE 2>&1
  exit 0
fi

start_time=`date +"%Y-%m-%d %H:%M:%S"`
echo "${start_time} : Executing r10k ...." >>$LOGFILE 2>&1
/opt/puppetlabs/puppet/bin/r10k deploy environment --puppetfile -v >>$LOGFILE 2>&1
end_time=`date +"%Y-%m-%d %H:%M:%S"`
echo "${end_time} : Deployement done...." >>$LOGFILE 2>&1
