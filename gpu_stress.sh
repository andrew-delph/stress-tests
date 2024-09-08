#!/bin/bash

gpu_model=$(lspci | grep VGA | cut -d ':' -f3 | xargs  | sed 's/^ *//' | tr ' ' '_')

LOG_FILE="stress-$gpu_model.log"

echo ""| tee -a $LOG_FILE
echo "###GPU STRESS TEST ###" | tee -a $LOG_FILE
echo "date: $(date)" | tee -a $LOG_FILE
echo "LOG_FILE: $LOG_FILE" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# Default value for duration
duration=10
# Check if an argument is provided
if [ ! -z "$1" ]; then
    duration=$1
fi
# Echo the value of duration
echo "testing for $duration seconds." | tee -a $LOG_FILE

# Start the CPU stress test in the background and log output to cpu_stress.log
glmark2 -b desktop --off-screen --run-forever | tee -a $LOG_FILE &

# Get the PID of the stress test process
STRESS_PID=$!

# Set up a trap to kill the sysbench process if the script exits
trap "kill $STRESS_PID 2>/dev/null" EXIT

# Record the start time
start_time=$SECONDS

# Loop until the specified duration has passed
while [ $((SECONDS - start_time)) -lt $duration ]; do
    # Your commands go here
    echo "Looping..." | tee -a $LOG_FILE

    # Optional: sleep for a short duration to reduce CPU usage
    sleep 1
done


