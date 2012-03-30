#!/usr/bin/perl -s
#
#	The Pontifex Transform
#
#	From page 480 of Cryptonomicon
#
#	modified for clarification
#	I'm trying to add comments because this 
#	code is very cryptic.
#

$f=$d?-1:1;
$D=pack('C*',33..86); 						#	set $D = !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUV
$p=shift;										#	shift ARGC
$p=~y/a-z/A-Z/;								#	I think y is the same as tr
$U='$D=~s/(.*)U$/U$1/;$D=~s/U(.)/$1U/;';	#
($V=$U)=~s/U/V/g;								#	set $V = $U, then substitute Vs for Us in $V only
$p=~s/[A-Z]/$k=ord($&)-64,&e/eg;			#
$k=0;

while(<>)
{
	y/a-z/A-Z/;								#	capitalize (y is the same as tr)
	y/A-Z//dc;								#	if it ain't a capital letter, its gone
	$o.=$_;									#	append the result to $o
}

$o.='X' while length ($o)%5&&!$d;

#	The following line has been modified from the book version.
#	The book version only had 2 /'s.
#	I added the one between the . and chr.
#	I think that's where it goes.
$o=~s/./chr(($f*&e+ord($&)-13)%26+65)/eg;

$o=~s/X*$// if $d;
$o=~s/.{5}/$& /g;
print "$o\n";
exit;

sub v
{
	$v=ord(substr($D,$_[0]))-32;
	$v>53?53:$v;
}

sub w
{
	$D=~s/(.{$_[0]})(.*)(.)/$2$1$3/;
}

sub e
{
	eval "$U$V$V";
	$D=~s/(.*)([UV].*[UV])(.*)/$3$2$1/;
	&w(&v(53));
	$k?(&w($k)):($c=&v(&v(0)),$c>52?&e:$c);
}

