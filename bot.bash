#!/usr/bin/env bash

function send {
    echo "-> $1"
    echo $1 >> botfile
}

line=""
started=""
rm botfile
mkfifo botfile
tail -f botfile | nc irc.cat.pdx.edu 6667 | while true ; do
    if [ -z $started ] ; then
        send "USER bdbot bdbot bdbot :I iz a bot"
        send "NICK bdbot"
        send "JOIN #notzombies"
        started="yes"
    fi
    read irc
    case `echo $irc | cut -d " " -f 1` in
        "PING") send "PONG :`hostname`" ;;
    esac
    echo "<- $irc"
    chan=`echo $irc | cut -d ' ' -f 3`
    barf=`echo $irc | cut -d ' ' -f 1-3`
    cmd=`echo ${irc##$barf :}|cut -d ' ' -f 1|tr -d "\r\n"`
    args=`echo ${irc##$barf :$cmd}|tr -d "\r\n"`
    nick="${irc%%!*}";nick="${nick#:}"
    if [ "`echo $cmd | cut -c1`" == "!" ] ; then
        echo "Got command $cmd from channel $chan with arguments $args"
    fi
    case $cmd in
        "!add") line="$args $line" ;;
        "!list") echo "PRIVMSG $chan :$line" >> botfile ;;
        "!clear") line=""
    esac
done

