#!/bin/bash
set +x

# Unlock the keyring
# echo 'jenkins' | gnome-keyring-daemon --unlock

echo 'jenkins: deploy'
#echo " zosmf check status"
zowe zosmf check status --zosmf-profile tx9 -H 9.212.128.238 -P 9143 -u $userid --pw $password --ru false 

# set -x
# zowe files download ds "PRICHAR.SAMPLE.LOAD(HELLOWRD)" -f bin -b
echo 'zowe files list ds "PRICHAR.ZOWE.TEST.LOAD" | grep -q "PRICHAR.ZOWE.TEST.LOAD"'
if zowe files list ds "PRICHAR.ZOWE.TEST.LOAD" | grep -q "PRICHAR.ZOWE.TEST.LOAD"; then
    echo "PRICHAR.ZOWE.TEST.LOAD already exists"
else
    echo "PRICHAR.ZOWE.TEST.LOAD does not exist. Create it."
    echo 'zowe files create bin "PRICHAR.ZOWE.TEST.LOAD"'
    zowe files create bin "PRICHAR.ZOWE.TEST.LOAD"
fi

# zowe files upload ftds bin "PRICHAR.ZOWE.TEST.LOAD(HELLOWRD)" -b
tries=20
wait=2
function submitJCL () {
    ds=$1

    echo 'zowe jobs submit data-set "' $ds '--rff jobid --rft string"'
    jobid=`zowe jobs submit data-set $ds --rff jobid --rft string`
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

submitJCL "PRICHAR.ZOWE.JCL(IEBCOPY)"