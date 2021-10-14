#!/bin/bash


set -e

CHAPEL_GIT=${CHAPEL_GIT:-$HOME/chapel}
CHAPEL_TMP=${CHAPEL_TMP:-`mktemp -du`}
CHAPEL_URL=${CHAPEL_URL:-https://github.com/chapel-lang/chapel.git}
CHAPEL_VIM=${CHAPEL_VIM:-$HOME/chapel.vim}

[ -d $CHAPEL_GIT ] || git clone $CHAPEL_URL $CHAPEL_GIT

cd $CHAPEL_GIT
git pull

mkdir -p $CHAPEL_TMP
cp -a .git $CHAPEL_TMP/
cp -a --parents highlight/vim $CHAPEL_TMP/

cd $CHAPEL_TMP
git filter-repo --subdirectory-filter highlight/vim --force

cd $CHAPEL_VIM
git pull --no-edit $CHAPEL_TMP
git log -1 --pretty=oneline | grep -q $CHAPEL_TMP && git commit --amend -m "Merge upstream into main"
git push origin main
rm -rf $CHAPEL_TMP
