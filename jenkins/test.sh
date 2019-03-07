#!/bin/bash
set +x

# Unlock the keyring
# echo 'jenkins' | gnome-keyring-daemon --unlock
echo 'jenkins: test'
echo 'userid:' $userid
echo 'password:' $password 
npm test $userid $password