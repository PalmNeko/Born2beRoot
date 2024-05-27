
TotalCnt=0
FailCnt=0
SuccessCnt=0
SkipCnt=0
function testSweet() {
    echo
    echo "$1"
}

function it() {
    exitStatus="$?"
    testCase="$1"
    skip="$2"

    TotalCnt=$(expr $TotalCnt + 1)
    if [ "$skip" = "--skip" ]; then
        SkipCnt=$(expr $SkipCnt + 1)
        printf "  %b: $testCase\n" "\033[33m[skip]\033[m" 
    elif [ $exitStatus -eq 0 ]; then
        SuccessCnt=$(expr $SuccessCnt + 1)
        printf "  %b: $testCase\n" "\033[32m[OK]\033[m" 
    else
        FailCnt=$(expr $FailCnt + 1)
        printf "  %b: $testCase\n" "\033[31m[NG]\033[m"
    fi
}

function surround() {
    message="$1"
    len=$(printf "%b" "$message" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | wc -c)
    txt=$(yes "-" | head -n $len | tr -d "\n")
    txt='*--'"$txt"'--*'
    printf "%b\n" "$txt"
    printf "%b\n" '|  '"$message"'  |'
    printf "%b\n" "$txt"
}

## check Root
# if [ "\`whoami\`" != "root" ]; then
#   echo "Require root privilege"
#   exit 1
# fi

# if [ "\`logname\`" = "root" ]; then
#   echo "you have to start local user for sudo."
#   exit 1
# fi


surround '\033[36mTesting Born2Beroot!!\033[m'

# check disk
testSweet "block device and lvm"
{
    it "must be enable to lvm" $(
        lsblk -o TYPE | grep 'lvm'
    )
    it "must have encrypted partition." $(
        lsblk | grep -e 'crypt'
    )
    it "must have at least 2 encrypted partitions using LVM." $(
        CNT=$(lsblk | grep -e 'lvm' -e 'crypt' | wc -l)
        test $CNT -ge 3
    )
    it "must have LV named root in $HOSTNAME-vg group" $(
        LV_LIST="$(sudo lvdisplay -C -o lv_name,vg_name | grep "$HOSTNAME-vg")"
        echo -n "$LV_LIST" | grep 'root'
    )
    it "must have LV named home in $HOSTNAME-vg group" $(
        LV_LIST="$(sudo lvdisplay -C -o lv_name,vg_name | grep "$HOSTNAME-vg")"
        echo -n "$LV_LIST" | grep 'home'
    )
    it "must have LV named swap_1 in $HOSTNAME-vg group" $(
        LV_LIST="$(sudo lvdisplay -C -o lv_name,vg_name | grep "$HOSTNAME-vg")"
        echo -n "$LV_LIST" | grep 'swap_1'
    )
}

# SSH
testSweet "SSH Server"
it "must run in 4242 port" $(
    sudo ss -p '( dport = :4242 or sport = :4242 )' | grep "sshd"
)
it "must not be possible to connect using SSH as root" $(
    sudo sshd -T | grep 'permitrootlogin no'
)
it "is activate" $(
    service --status-all | grep '.*\+.*ssh'
)

# UFW
testSweet "UFW"
it "must open only 4242 port" $(

    LINES="$(sudo ufw status | grep "ALLOW" | grep "4242" | wc -l)"
    test $LINES -eq 2 -o $LINES -eq 1
)
it "is activate" $(
    ufw status | grep 'Status: active'
)


# check hostname
HOSTNAME=$(hostname)
testSweet "hostname"
it "should be partern \"*42\"" $(echo -n "$HOSTNAME" | grep '.*42')

# check user
testSweet "a user"
USERNAME="${HOSTNAME:0:-2}"
test -z "$USERNAME" && echo "empty username"
it "that named \`$USERNAME\` must exist." $(
    cat /etc/passwd | awk -F ":" '{ print $1 }' | grep -E "^$USERNAME$"
)
it "that named \`$USERNAME\` must belong to the user42 group" $(
    groups "$USERNAME" | grep -oE ':.*$' | tr ' ' '\n' | grep 'user42'
)
it "that named \`$USERNAME\` must belong to the sudo group" $(
    groups "$USERNAME" | grep -oE ':.*$' | tr ' ' '\n' | grep 'sudo'
)
it "that named \`$USERNAME\`'s changeable password min days must be 2." $(
    MIN=$(chage -l "$USERNAME" | grep 'Minimum number of days between password change' | awk -F ":" '{ print $2 }')
    test "$MIN" -eq 2
)
it "that named \`$USERNAME\`'s password has to expire every 30 days." $(
    MAX=$(chage -l "$USERNAME" | grep 'Maximum number of days between password change' | awk -F ":" '{ print $2 }')
    test "$MAX" -eq 30
)
it "that named \`$USERNAME\` must be received a warning message 7 days before their password expires." $(
    MSGDAY=$(chage -l "$USERNAME" | grep 'Number of days of warning before password expires' | awk -F ":" '{ print $2 }')
    test "$MSGDAY" -eq 7
)

it "that named root's changeable password min days must be 2." $(
    MIN=$(sudo chage -l "root" | grep 'Minimum number of days between password change' | awk -F ":" '{ print $2 }')
    test "$MIN" -eq 2
)
it "that named root's password has to expire every 30 days." $(
    MAX=$(sudo chage -l "root" | grep 'Maximum number of days between password change' | awk -F ":" '{ print $2 }')
    test "$MAX" -eq 30
)
it "that named root must be received a warning message 7 days before their password expires." $(
    MSGDAY=$(sudo chage -l "root" | grep 'Number of days of warning before password expires' | awk -F ":" '{ print $2 }')
    test "$MSGDAY" -eq 7
)
it "that a new user must be warned a message before 7 days in password expired." $(
    cat /etc/login.defs | grep -vE '^ *#.*' | grep -E 'PASS_WARN_AGE[[:space:]]+7'
)
it "that a new user's password must expire after 30 days." $(
    cat /etc/login.defs | grep -vE '^ *#.*' | grep -E 'PASS_MAX_DAYS[[:space:]]+30'
)
it "that a new user must be able to change their password after 2 days." $(
    cat /etc/login.defs | grep -vE '^ *#.*' | grep -E 'PASS_MIN_DAYS[[:space:]]+2'
)

# check password-policy
testSweet "password policy"
it "that password must be at least 10 characters long." $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'minlen=10'
)
it "that password must contain an uppercase letter" $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'ucredit=-1'
)
it "that password must contain a lowercase letter" $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'lcredit=-1'
)
it "that password must contain a number" $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'dcredit=-1'
)
it "that password must not contain more than 3 consecutive idential characters." $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'maxrepeat=3'
)
it "that password must not include the name of the user." $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'usercheck=1'
)
it "that password must have at least 7 characters that are not part of the former password." $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'difok=7'
)
it "must be made root comply." $(
    cat /etc/pam.d/common-password | grep -vE '^ *#.*' | grep 'enforce_for_root'
)

# sudoers
testSweet "sudoers"
it "setted password_tries 3 tiimes." $(
    sudo cat /etc/sudoers | grep -E '^Defaults[[:space:]]*passwd_tries=3'
)
it "setted show message when wrong password." $(
    sudo cat /etc/sudoers | grep -E '^Defaults[[:space:]]*badpass_message=.*'
)
it "setted logging to be saved in the /var/log/sudo/ folder." $(
    sudo cat /etc/sudoers | grep -E '^Defaults[[:space:]]*iolog_dir="/var/log/sudo/"'
)
it "enable The TTY mode." $(
    sudo cat /etc/sudoers | grep -E '^Defaults[[:space:]]*requiretty'
)
it "setted secure_path: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin" $(
    sudo cat /etc/sudoers | grep -E '^Defaults[[:space:]]*secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"'
)

# monitoring.sh
testSweet "monitoring"
it "has /root/monitoring.sh" $(
    test "$(sudo find "$HOME" -name 'monitoring.sh' | wc -l)" -ne 0
)
it "must set crontab" $(
    sudo crontab -l | grep -E '\*/10 *\* *\* *\* *\* *bash.*monitoring.sh'
)
it "check your monitoring.sh" --skip

#
# Envinron Error
#
testSweet "Test for this code working"
it "must be install command \`which\`" $(
    command which which
)
it "must be install command \`sudo\`" $(
    which sudo
)
it "must be install command \`grep\`" $(
    which grep
)
it "must be install command \`cat\`" $(
    which cat
)
it "must be install command \`test\`" $(
    which test
)
it "must be install command \`service\`" $(
    which service
)
it "must be install command \`groups\`" $(
    which groups
)
it "must be install command \`hostname\`" $(
    which hostname
)
it "must be install command \`wc\`" $(
    which wc
)
it "must be install command \`ufw\`" $(
    which ufw
)
it "must be install command \`ssh\`" $(
    which ssh
)
it "must be install command \`crontab\`" $(
    which crontab
)
it "must be install command \`chage\`" $(
    which chage
)
it "must be install command \`lvdisplay\`" $(
    which lvdisplay
)
it "must be install command \`ss\`" $(
    which ss
)
it "must be install command \`test\`" $(
    which test
)
#
# result
#
echo
surround '\033[36mOverview\033[m'

printf "%b\n" "total : $TotalCnt"
printf "%b\n" "fail  : \033[31m$FailCnt\033[m"
printf "%b\n" "pass  : \033[32m$SuccessCnt\033[m"
printf "%b\n" "skip  : \033[33m$SkipCnt\033[m"