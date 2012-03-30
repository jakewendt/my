#!/usr/bin/perl -w

use Cwd;

chomp ( my $hostname = `hostname`);
print "/reproc/${hostname}/cons/ops_sa/1234.000\n";


print Cwd::cwd."\n";

print mkdir "14", 0755;
print "\n";

print mkdir "1/2/3/4", 1;
print "\n";

symlink "14", "link14";

exit;


