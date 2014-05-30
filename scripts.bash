#!/usr/bin/env bash

if [[ ! -f ./database ]] ; then
    touch database
fi

line=$(cat ./database)
read nick chan cmd args
case $cmd in
    "!add") line="$args $line" ; echo "Added!" ;;
    "!list") echo "> $line" ;;
    "!clear") line="" ; echo "Cleared!" ;;
esac

echo $line > ./database
