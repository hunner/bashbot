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
    case `echo $irc | cut -d " " -f 1` in
        "PING") echo "PONG :`hostname`" >> botfile ;;
    esac
    #echo $irc
done

