#!/usr/bin/perl -w

dbmopen(%DATA, "my_database", 0644) 
  or die "Cannot create my_database: $!";

while (my($key, $value) = each(%DATA)) { 
  print "$key has value of $value\n"; 
}
#$DATA{'testkey'} = "test value";

dbmclose(%DATA);
