#!/usr/bin/bash

# architecture
ARCHITECTURE=$(uname -a)

# number of CPU
CPU_PHYSICAL=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

# number of vCPU
V_CPU=$(grep "^processor" /proc/cpuinfo | wc -l)

# RAM usage
MEMORY_RESULT_MB=$(free -m)
MEMORY_USAGE_MB=$(printf "$MEMORY_RESULT_MB" | awk '/Mem/ { print $3 }')
TOTAL_MEMORY_MB=$(printf "$MEMORY_RESULT_MB" | awk '/Mem/ { print $2 }')
MEMORY_USAGE_PERCENTAGE=$(printf "$MEMORY_RESULT_MB" | awk '/Mem/ { printf "%.2f", $3 / $2 * 100 }')

# memory usage
DISK_USAGE_REPORT_MB=$(df -TBM -t ext4 -t ext2 --total | tail -1)
DISK_TOTAL_GB=$(echo $DISK_USAGE_REPORT_MB | awk '{ printf "%d", $3 / 1024}')
DISK_USAGE_MB=$(echo $DISK_USAGE_REPORT_MB | awk '{ printf "%d", $4 }')
DISK_USAGE_PERCENTAGE=$(echo $DISK_USAGE_REPORT_MB | awk '{ printf "%d", $6 }')

# cpu usage
CPU_IDLE=$(top -bn1 | grep '^%Cpu' | awk -v FS="," ' { print $4 }' | sed 's/ id//g')
CPU_LOAD=$(python3 -c "print (100 - $CPU_IDLE)")

# last boot
LAST_BOOT=$(who -b | grep -E --only-matching '[0-9].*$')

# is enable LVM
LVM_USE=$(lsblk -o TYPE | grep -q 'lvm' && echo 'yes' || echo 'no')

# TCP connections
CONNECTIONS_TCP=$(ss --tcp state established | tail +2 | wc -l)

# loggined Users
USER_LOG=$(users | wc -w)

# IPv4 and Mac
IP=$(hostname -I)
MAC=$(ip -br link show | grep -v 'lo' | awk '{print $3}')
NETWORK="IP $IP ($MAC)"

# number of executing sudo
SUDO=$(cat /var/log/sudo/seq | awk '{printf "%d", $1}')

wall "	#Architecture: $ARCHITECTURE
	#CPU physical : $CPU_PHYSICAL
	#vCPU : $V_CPU
	#Memory Usage: $MEMORY_USAGE_MB/${TOTAL_MEMORY_MB}MB ($MEMORY_USAGE_PERCENTAGE%)
	#Disk Usage: $DISK_USAGE_MB/${DISK_TOTAL_GB}Gb ($DISK_USAGE_PERCENTAGE%)
	#CPU load: $CPU_LOAD%
	#Last boot: $LAST_BOOT
	#LVM use: $LVM_USE
	#Connections TCP : $CONNECTIONS_TCP ESTABLISHED
	#User log: $USER_LOG
	#Network: $NETWORK
	#Sudo : $SUDO cmd"
