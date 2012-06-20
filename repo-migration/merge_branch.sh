#!/bin/bash

if test $# -lt 3; then
    echo "args: <src_repo> <dest_repo> <branch_name>";
    exit 0;
fi

src_repo=$1
dest_repo=$2
branch_name=$3

cd ${src_repo};
subdir=${PWD##*/}

cd ${dest_repo}
git checkout master
remote_name="${subdir}_old"
git remote add -f ${remote_name} ${src_repo};
git checkout -b ${branch_name}
git merge -s subtree --squash --no-commit ${remote_name}/${branch_name}
git remote rm ${remote_name}

echo "branch was not commited, please check for conflicts"


