#!/bin/bash

# cvs project setting

# ----- edit after here  -----
CVSROOT="CVS  SERVER"
MODULE="MODULE NAME"
# ----- edit above here  -----

# tools path setting

# ----- edit after here  -----
cvsimport=/usr/lib/git-core/git-cvsimport
git=/usr/bin/git
# ----- edit above here  -----

# color setting
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# status string
OK=${GREEN}OK${NC}
FAIL=${GREEN}FAIL${NC}

# check module
echo -ne check MODULE name
if [ -z $MODULE ];then
    echo -e " [$FAIL]\n"
    echo Please input module name.
    exit 1;
else
    echo -e " [$OK] .....$MODULE"
fi

# check git
echo -ne check git
if ! git_loc=$(type -p $git) || [ -z $git_loc ]; then
    echo -e " [$FAIL]\n"
    echo Install git-core.
    sudo apt-get install git-core
else
    echo -e " [$OK]"
fi

# check git-cvsimport
echo -ne check git-cvsimport
if ! cvsimport_loc=$(type -p $cvsimport) || [ -z $cvsimport_loc ]; then
    echo -e " [$FAIL]\n"
    echo Install git-cvsimport.
    sudo apt-get install git-cvs
else
    echo -e " [$OK]"
fi

# check MODULE is exist in cvs-server
echo -ne check cvs server \($CVSROOT\)
cvs -d $CVSROOT login 0 > /dev/null
if ! server_status=$?; then
    echo -e " [$FAIL]\n"
    exit 1;
else
    echo -e " [$OK]"
fi

# start convert cvs to git
time git cvsimport -C $MODULE -d $CVSROOT $MODULE
