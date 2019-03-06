#!/bin/bash
set +x
echo 'jenkins: profileCreation'

zowe profiles create zosmf-profile tx9 --host 9.212.128.238 --port 9143 -u $userid --pw $password --ru false --overwrite
# Will interpolate to their values correctly.
zowe zosmf check status --zosmf-profile tx9 -H 9.212.128.238 -P 9143 -u $userid --pw $password --ru false