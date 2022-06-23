#!/bin/sh

#MCH_HOME="/sdcard/mijia360-1g"
# Absolute path to this script is: <path>/<filename>
SCRIPT=$(readlink -f $0)
# Absolute path this script is: <path>
MCH_HOME=`dirname $SCRIPT`
#echo $MCH_HOME

if [ $# -ge 1 ] && [ "$1" = "on" ] || [ "$1" = "off" ] || [ "$1" = "auto" ]; then
    if [ "$1" = "off" ]; then
        sh "${MCH_HOME}/ircut.sh" off
        sh -c '(sleep 3; printf "%s\n" h d 0; sleep 1; printf "%s\n" q q;) | /usr/local/bin/test_image -i 1' >/dev/null
    elif [ "$1" = "on" ]; then
        sh -c '(sleep 3; printf "%s\n" h d 1; sleep 1; printf "%s\n" q q;) | /usr/local/bin/test_image -i 1' >/dev/null
        sh "${MCH_HOME}/ircut.sh" on $2
    elif [ "$1" = "auto" ]; then
        NIGHT_MODE=off
        THRESHOLD=80
        OLD_VALUE=
        while true; do
            ADC=$(cat /sys/devices/e8000000.apb/e801d000.adc/adcsys | grep adc2 | printf "%d" $(cut -d "=" -f 2))
            if [ -n "$OLD_VALUE" ]; then
                ADC_SUM=$((OLD_VALUE+ADC))
                ADC=$(printf "%d" $((ADC_SUM/2)))
            fi
            OLD_VALUE=$ADC
            if [ "$ADC" -lt "$THRESHOLD" ] && [ "$NIGHT_MODE" = "off" ]; then
                sh -c '(sleep 3; printf "%s\n" h d 1; usleep 500000; printf "%s\n" q q;) | /usr/local/bin/test_image -i 1' >/dev/null
                sh "${MCH_HOME}/ircut.sh" on
                NIGHT_MODE=on
            elif [ "$ADC" -ge "$THRESHOLD" ] && [ "$NIGHT_MODE" = "on" ]; then
                sh -c '(sleep 3; printf "%s\n" h d 0; usleep 500000; printf "%s\n" q q;) | /usr/local/bin/test_image -i 1' >/dev/null
                sh "${MCH_HOME}/ircut.sh" off
                NIGHT_MODE=off
            fi
            echo "ADC = ${ADC}"
            echo "NIGHT MODE = ${NIGHT_MODE}"
            usleep 250000
        done
    fi
else
    echo "Usage: day_night_switch.sh <off|on|auto>"
fi
