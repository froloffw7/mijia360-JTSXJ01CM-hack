#!/bin/sh

# Absolute path to this script is: <path>/<filename>
SCRIPT=$(readlink -f $0)
# Absolute path this script. <path>
SCRIPTS=`dirname $SCRIPT`
MCH_HOME=`dirname $SCRIPTS`


if [ -f $MCH_HOME/bin/rtsp_server ]; then
echo "----- Starting RTSP"
/usr/local/bin/test_encode -A -s -B -s --debug-enable 0
killall test_encode
killall rtsp_server
killall test_tuning
sleep 5
/usr/local/bin/test_tuning -a 0 &
#/usr/local/bin/test_encode --debug-enable 0
/usr/local/bin/test_encode -A -i 1920x1080 -f 25 --cvbs --enc-mode 4 --hdr-mode 1 --hdr-expo 2 --lens-warp 1 -J --btype off -K --btype off -X --bmaxsize 1080p --bsize 1080p --smaxsize 1080p -Y --bmaxsize 640x360 --bsize 640x360 -B --smaxsize 640x360
sleep 5
$MCH_HOME/bin/rtsp_server &
# /usr/local/bin/rtsp_server &
/usr/local/bin/test_encode -A -h 1080p -f 25 --bitrate 1000000 --profile 2 -N15 -e -B -m 640x360 -e
fi