#!/bin/bash
set +x

# Unlock the keyring
# echo 'jenkins' | gnome-keyring-daemon --unlock

echo 'jenkins: build'
# Will still print ****, which is cool.
echo 'userid:' $userid 'password:' $password


tries=20
wait=5
function submitJCL () {
    ds=$1

    echo 'bright jobs submit data-set "' $ds '--rff jobid --rft string"'
    jobid=`bright jobs submit data-set $ds --rff jobid --rft string`
    echo $jobid
    echo ''

    echo 'bright jobs view job-status-by-jobid' $jobid '--rff retcode --rft string'
    retcode=`bright jobs view job-status-by-jobid $jobid --rff retcode --rft string`
    echo $retcode
    echo ''
    
    counter=0
    while (("$counter" < $tries)) && [ "$retcode" == "null" ]; do
        ((counter++))
        sleep $wait
        
        echo 'bright jobs view job-status-by-jobid' $jobid '--rff retcode --rft string'
        retcode=`bright jobs view job-status-by-jobid $jobid --rff retcode --rft string`
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

submitJCL "PRICHAR.ZOWE.JCL(HELLOCMP)"