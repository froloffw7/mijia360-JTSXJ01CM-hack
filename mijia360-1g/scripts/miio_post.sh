#
# Will run after /usr/imi/miio.sh
#
SCRIPTS=${XIAOMI_HACK_DEVICE_HOME}/scripts

echo "----- Initialising LEDs"
${SCRIPTS}/led.sh red   init
${SCRIPTS}/led.sh green init
${SCRIPTS}/led.sh blue  init

${SCRIPTS}/led.sh red   on
${SCRIPTS}/led.sh green off
${SCRIPTS}/led.sh blue  off

${SCRIPTS}/ircut.sh     init

echo "----- Connecting to Wi-Fi"
# Need to dump the output, TMI lol
#/etc/miio/wifi_start.sh > /sdcard/xiaomi_hack/logs/wifi_start.txt
#/dev/null 2>&1

if [ "${XIAOMI_HACK_MAC}" != "" ]; then
  echo "----- Set Wi-Fi MAC address"
  ip link set dev mlan0 down
  sleep 1
  ip link set dev mlan0 address "${XIAOMI_HACK_MAC}"
  sleep 1
  ip link set dev mlan0 up
fi
/usr/imi/config/marvell_wifi_setup.sh mlan0 sta nl80211 "Home Wi-Fi" "password"

echo "----- Check Wi-Fi connection"
ping  172.20.1.60 -c 3 -W 2
if [ "$?" != 0 ]; then
  echo "Wi-Fi Error -----"
else
  busybox ntpd -dnq -p 172.20.1.60
  ${SCRIPTS}/led.sh red   off
  ${SCRIPTS}/led.sh blue  on
  echo "Wi-Fi OK -----"
fi

if [ "${XIAOMI_HACK_RTSP_SERVER}" == "YES" ]; then
   if [ -f ${XIAOMI_HACK_DEVICE_HOME}/bin/rtsp_server ]; then
      echo "### Activating RTSP server ..."
      $SCRIPTS/rtsp.sh
      echo "### Auto adjust picture ..."
      # sh -c '(sleep 3; printf "%s\n" q;) | /usr/local/bin/test_image -i 1' >/dev/null
      echo "### Activate mjpeg http streamer ..."
      # default port 8080
      smart_ldc &
      echo "OK -----"
   else
      echo "Error: Unable to activate RTSP server"
   fi
fi
