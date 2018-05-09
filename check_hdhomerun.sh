#!/bin/bash

# check_hdhomerun.sh
# Zachary McGibbon
# https://github.com/mzac/check_hdhomerun.git

# Adjust to point to your hdhomerun_config binary
HR_BIN="/usr/bin/hdhomerun_config"

if [ ! -f $HR_BIN ]; then
	echo "hdhomerun_config binary not found!"
	exit 3
fi

while getopts ":i:" opt; do
    case $opt in
        i)
            HR_ID=$OPTARG
        ;;
        
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 3
        ;;
        
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 3
        ;;
    esac
done

TUNER0_CH=`$HR_BIN $HR_ID get /tuner0/channel`
TUNER1_CH=`$HR_BIN $HR_ID get /tuner1/channel`

if [ "$TUNER0_CH" == "none" ] && [ "$TUNER1_CH" == "none" ]; then
	echo "No channels currently tuned"
	exit 0
fi
if [ "$TUNER0_CH" != "none" ] || [ "$TUNER1_CH" != "none" ]; then
	echo "Channel currently tuned:"
	if [ "$TUNER0_CH" != "none" ]; then
		echo "Tuner 0: $TUNER0_CH"
	fi
	if [ "$TUNER1_CH" != "none" ]; then
		echo "Tuner 1: $TUNER1_CH"
	fi
	exit 1
fi
