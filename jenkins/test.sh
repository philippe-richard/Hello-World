#!/bin/bash
set +x

# Unlock the keyring
# echo 'jenkins' | gnome-keyring-daemon --unlock
echo 'jenkins: test'
npm test