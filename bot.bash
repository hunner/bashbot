#!/usr/bin/env bash

IRCD=irc.cat.pdx.edu
IRCPORT=6697

line=""
started=""
rm botfile
mkfifo botfile
tail -f botfile | nc $IRCD $IRCPORT| while true ; do
	if [ -z $started ] ; then
		echo "USER bdbot 0 bdbot :I iz a bot" > botfile
		echo "NICK bdbot" >> botfile
		echo "MODE +b" >> botfile
		echo "JOIN #notzombies" >> botfile
		started="yes"
	fi
	read irc
	case `echo "$irc" | cut -d " " -f 1` in
		"PING") echo "PONG :`hostname`" >> botfile ;;
	esac
	#echo $irc
	chan=`echo "$irc" | cut -d ' ' -f 3`
	barf=`echo "$irc" | cut -d ' ' -f 1-3`
	cmd=`echo "${irc##$barf :}"|cut -d ' ' -f 1|tr -d "\r\n"`
	args=`echo "${irc##$barf :$cmd}"|tr -d "\r\n"`
	nick="${irc%%!*}";nick="${nick#:}"
	if [ "`echo "$cmd" | cut -c1`" == "!" ] ; then
		echo "Got command $cmd from channel $chan with arguments $args"
	fi
	case $cmd in
		"!add") line="$args $line" ;;
		"!list") echo "PRIVMSG $chan :$line" >> botfile ;;
	esac
done
