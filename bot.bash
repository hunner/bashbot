#!/usr/bin/env bash

line=""
started=""
rm botfile
mkfifo botfile
tail -f botfile | nc irc.cat.pdx.edu 6667 | while true ; do
    if [ -z $started ] ; then
        echo "USER bdbot 0 bdbot :I iz a bot" > botfile
        echo "NICK bdbot" >> botfile
        echo "JOIN #notzombies" >> botfile
        started="yes"
    fi
    read irc
    #echo $irc
done

