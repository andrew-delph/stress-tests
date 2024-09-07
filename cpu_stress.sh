#!/bin/bash

LOG_FILE="1.LOG"

echo ""
echo "###CPU STRESS TEST ###" | tee -a $LOG_FILE
echo "date: $(date)" | tee -a $LOG_FILE
echo ""

# Default value for seconds
seconds=10
# Check if an argument is provided
if [ ! -z "$1" ]; then
    seconds=$1
fi
# Echo the value of seconds
echo "testing for $seconds seconds."

# Start the CPU stress test in the background and log output to cpu_stress.log
sysbench --test=cpu --time=$seconds --report-interval=3 --threads=$(nproc) run | tee -a $LOG_FILE &

# Get the PID of the stress test process
STRESS_PID=$!
counter=0

# Loop to check the temperature every second while the stress test is running
while ps -p $STRESS_PID > /dev/null; do

	TEMP=$(sensors -j 2>/dev/null | jq '.["k10temp-pci-00c3"]["Tctl"]["temp1_input"]')

	echo "$counter) temp: $TEMP" | tee -a $LOG_FILE 

    	counter=$((counter + 1))
    	
	sleep 1
done


