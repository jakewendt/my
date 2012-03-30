#!/usr/bin/perl -w

#use strict;
use ISDCStep;


my $step = ISDCStep->new("Test just Name");
print $step->StepName()," -\n";

my @steps;
push @steps, ISDCStep->new("Test just Name in array");
print $steps[$#steps]->StepName()," -\n";
push @steps, ISDCStep->new("Test Name and Func in array", "testfunc");
print $steps[$#steps]->StepName()," -\n";

print "\$steps[0]->runme();\n";
$steps[0]->runme();
print "\$steps[1]->runme();\n";
$steps[1]->runme();



exit;


