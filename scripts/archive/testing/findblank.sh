#!/bin/sh

input=$1

case "$input" in
	*[A-Za-z0-9]*)
		echo "Alphanumeric"
		;;
	*)
		echo "Not Alphanumeric"
		;;
esac
