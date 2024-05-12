#!/bin/bash

cleanup() {
    echo "Shutting down..."
    kill -s SIGTERM $(jobs -p) # Send SIGTERM to all child jobs
    wait
    echo "Stopped."
}

# Trap SIGTERM and SIGINT to perform cleanup
trap cleanup SIGTERM SIGINT

./run.sh &

./usr/local/bin/healthcheck.sh &

wait -n

exit $?