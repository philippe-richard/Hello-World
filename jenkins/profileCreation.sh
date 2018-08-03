#!/usr/bin/env bash
set +x

# Unlock the keyring
echo 'jenkins' | gnome-keyring-daemon --unlock

bright profiles create zosmf "test" --host $HOST --port $PORT --user $USERNAME --password $PASSWORD --reject-unauthorized false