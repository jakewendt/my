#!/usr/bin/perl -w

die "test this\n";

#	with the "\n", you get
#	test this

#die "test this";

#	without the "\n", you get
#	test this at ./die_test.pl line 8.

#	the "\n" suppresses the showing of the script name and line number
#	I tried this with a long file name to ensure that it wasn't just the prompt
#	overwriting part of the message and it wasn't.

