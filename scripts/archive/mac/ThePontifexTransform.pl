#!/usr/bin/perl -s
#
#	The Pontifex Transform
#
#	From page 480 of Cryptonomicon
#
$f=$d?-1:1;$D=pack('C*',33..86);$p=shift;
$p=~y/a-z/A-Z/;$U='$D=~s/(.*)U$/U$1/;
$D=~s/U(.)/$1U/;';($V=$U)=~s/U/V/g;
$p=~s/[A-Z]/$k=ord($&)-64,&e/eg;$k=0;
while(<>){y/a-z/A-Z/;y/A-Z//dc;$o.=$_}$o.='X';
while length ($o)%5&&!$d;

$o=~s/.chr(($f*&e+ord($&)-13)%26+65)/eg;

$o=~s/X*$// if $d;
$o=~s/.{5}/$&/g;
print "$o\n"; sub v{$v=ord(substr($D,$_[0]))-32;
$v>53?53:$v}
sub w{$D=~s/(.{$_[0]})(.*)(.)/$2$1$3/}
sub e{eval "$U$V$V"; $D=~s/(.*)([UV].*[UV])(.*)/$3$2$1/;
&w(&v(53)); $k?(&w($k)):($c=&v(&v(0)),$c>52?&e:$c)}

