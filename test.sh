#!/bin/sh

# precheck

if [ $# -lt 1 -o $# -gt 2 ];then
    echo "usage: $0 [test-dir [-n]]";
    echo "OPTION"
    echo "  -n: no stop"
    exit 1
fi

# init

function exit_trap() {
    if [ $? != 0 ]; then
        exit 1
    fi
}
test "$2" = "-n" || trap exit_trap ERR

# usage: err_message message [errno]
ERROR_FLAG=0
function err_message() {
    test -n "$1"
    test $ERROR_FLAG -eq 0 && ERROR_FLAG=1
    echo "\033[31mERROR:\033[m "$1 | xargs -0 printf "%b"
    return ${2:-1}
}

# start

cd $1

test -f signature.txt || err_message 'Should has a file: `signature.txt`'

test -s signature.txt || err_message 'Should has a size greater than zero: `signature.txt`'


test $ERROR_FLAG -eq 0 || exit 1
