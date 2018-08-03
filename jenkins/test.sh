#!/usr/bin/env bash
set +x

# Unlock the keyring
echo 'jenkins' | gnome-keyring-daemon --unlock

npm test