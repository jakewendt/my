#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

$Firstname = "Christine";
$Lastname = "Turner";

print "1: ";
print $Firstname ge $Lastname;
print "\n\n";


$Name = "Tom";
$Lastname = "Wilkins";

print "2: ";
print $Name lt $Lastname;
print "\n\n";

