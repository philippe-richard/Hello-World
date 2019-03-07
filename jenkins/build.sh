#!/bin/bash
set +x

# Unlock the keyring
echo 'jenkins: step build' 

#echo " zosmf check status"
#zowe zosmf check status --zosmf-profile tx9 -H 9.212.128.238 -P 9143 -u $userid --pw $password --ru false 
echo 'jenkins: build'
# Will still print ****, which is cool.
echo 'userid:' $userid 'password:' $password


tries=20
wait=5
function submitJCL () {
    ds=$1
	echo 'dataset submitted is:' $ds
    echo 'zowe jobs submit data-set "'$ds'" --rff jobid --rft string'
    jobid=`zowe jobs submit data-set $ds --rff jobid --rft string -u $userid --pw $password --ru false`
    echo $jobid
    echo ''

    echo 'zowe jobs view job-status-by-jobid' $jobid '--rff retcode --rft string'
    retcode=`zowe jobs view job-status-by-jobid $jobid --rff retcode --rft string`
    echo $retcode
    echo ''
    
    counter=0
    while (("$counter" < $tries)) && [ "$retcode" == "null" ]; do
        ((counter++))
        sleep $wait
        
        echo 'zowe jobs view job-status-by-jobid' $jobid '--rff retcode --rft string'
        retcode=`zowe jobs view job-status-by-jobid $jobid --rff retcode --rft string`
        echo $retcode
        echo ''
    done

    if [ "$retcode" == "null" ]; then
       echo $ds 'timed out'
       echo ''
       exit 1
    elif [ "$retcode" != "CC 0000" ]; then
       echo $ds 'did not complete with CC 0000'
       echo ''
       exit 1
    else
       echo 'Success'
       echo ''
    fi
}

submitJCL "'PRICHAR.ZOWE.JCL(HELLOCMP)'"