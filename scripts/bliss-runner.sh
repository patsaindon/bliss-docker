#!/bin/sh
# Script to restart bliss after an update
# Only needed for the Docker build, to stop the container exiting after an update

# Trap various signals, to pass on to the child process
PID=1

trap_each() {
    func="$1" ; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

pass() {
    echo "Handled SIG"$1"" ;
    # Only kill the child process if it exists!  (PID 1 is this script)
    # Very unlikely race, but still worth this simple fix
    if [ "$PID" -ne 1 ] ; then
        kill -"$1" "$PID" ;
    fi
}

trap_each pass HUP INT QUIT KILL TERM

# Spawn the bliss.sh child process
while [ true ]
do
    # Start in the background and then wait, so $PID can contain the true pid
    # for signal handling purposes (see above)
    sh /bliss/bin/bliss.sh &
    PID="$!"
    echo "bliss.sh PID: "$PID""
    wait $PID
    if [ "$?" = "0" ]; then
        echo "bliss.sh exited, restarting..."
        sleep 2
    else
        echo "bliss.sh exited with a non-zero value, exiting..."
        exit 1
    fi
done
