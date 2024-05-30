
rm port
touch port
PIDs=""
for i in {0..65535}; do

    printf "\r%06d " "$i"
    nc -vz -G 1 -w 1 '10.12.250.159' $i 2>> port &
    PIDs="$PIDs $!"
done

for i in $PIDS; do 
    wait $i
done
