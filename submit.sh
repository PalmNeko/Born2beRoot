#!/bin/zsh

SCRIPT_DIR=$(cd $(dirname $0) ; pwd)
SUBMIT_DIR=submit
SUBMIT_REPO="git@vogsphere-v2.42tokyo.jp:vogsphere/intra-uuid-b07a0d59-2fdb-4912-90e6-51443c0f5475-5659958-tookuyam"

# submit

cd $SUBMIT_DIR
echo "\033[34msubmit\033[m" | xargs -0 printf "%b"

test -d .git || git init .
git add . && git commit -m "Submit" --allow-empty
git remote add origin ${SUBMIT_REPO}
git branch -M master
git push -f origin master
rm -rf .git

echo "\033[32msubmit: success\033[m" | xargs -0 printf "%b"

# test

cd $SCRIPT_DIR
echo "\033[34mtest\033[m" | xargs -0 printf "%b"

git clone "$SUBMIT_REPO" tmp_repo
bash test.sh tmp_repo
TMP=$?
rm -rf tmp_repo
test $TMP -ne 0 && exit 1

echo "\033[32mtest: success\033[m" | xargs -0 printf "%b"
cd $SCRIPT_DIR
