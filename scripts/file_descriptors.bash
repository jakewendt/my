#!/usr/bin/env bash

{

	echo "This is going to go to STDOUT file descriptor 1, the screen."

	echo "This is not an error but is redirected to fd 2." 1>&2

	echo "This is a explicitly redirected to a file." 1> file_descriptors.1

	echo "This is an undefined file descriptor." 1>&3

	#	Claim file descriptor 7 (only 3-9 available)
	#	Don't use 5 though. Something about bash assigning it to child processes?
	exec 7<> file_descriptors.7
	echo "Test output to fd 7" >&7
	#	Close file descriptor 7
	exec 7>&-
	echo "This is now an unknown file descriptor so will generate an actual error in STDERR." 1>&7

	#	This inner script contents pass through the outer shell
	#	which redirects any implied fd redirection.

	#	Redirecting STDOUT to STDOUT with 1>&1 is pointless, but allowed.

} 1>&1 2>file_descriptors.2 3>&2 4>file_descriptors.4

