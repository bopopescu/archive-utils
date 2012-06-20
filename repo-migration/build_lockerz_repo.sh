#!/bin/bash

LOCKERZ_GIT_HOME=/Users/andrewm/git-repos/lockerz


cd ${LOCKERZ_GIT_HOME}/platz
git fetch upstream;
git checkout master;
git merge upstream/master;

cd ${LOCKERZ_GIT_HOME}/pegasus;
git fetch upstream;
git checkout develop;
git merge upstream/develop;

cd ${LOCKERZ_GIT_HOME}

rm -rf lockerz
mkdir lockerz
cd lockerz

git init

git config user.name "Andrew Murray"
git config user.email "andrew@lockerz.com"
touch .gitignore
git add .gitignore
git commit -m "initial commit"

git remote add -f platz ${LOCKERZ_GIT_HOME}/platz
git merge -s ours --no-commit platz/master
git read-tree --prefix=platz/ -u platz/master
git commit -m "merging platz into lockerz"

git remote add -f pegasus ${LOCKERZ_GIT_HOME}/pegasus
git merge -s ours --no-commit pegasus/develop
git read-tree --prefix=pegasus/ -u pegasus/develop
git commit -m "merging pegasus into lockerz"
