#!/usr/bin/perl -w

use strict;

my @deck = (1..52);
print join(",",@deck)."\n";

@deck = sort{ int(0.5+rand()) } @deck;
@deck = sort{ int(0.5+rand()) } @deck;
@deck = sort{ int(0.5+rand()) } @deck;
@deck = sort{ int(0.5+rand()) } @deck;
print join(",",@deck)."\n";


#print int(0.5+rand())."\n";
#print rand()."\n";
