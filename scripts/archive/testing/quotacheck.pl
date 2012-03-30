#!/usr/bin/perl -w

my @output = `/usr/sbin/quota -v`;
my $thresh = 0.5;		#	ie. 50% of quota
my @outputcopy = @output;

#Assuming output like ...
#
#Disk quotas for isdc_int (uid 4948):
#Filesystem     usage  quota  limit    timeleft  files  quota  limit    timeleft
#/export/diskB1
#             5954558 10000000 10100000                  0      0      0            
#/export/diskA1
#              122121 250000 300000               6052      0      0   

for ( my $i = 0; $i <= $#output; $i++){
	next if ( $output[$i] =~ /^Disk/ );
	next if ( $output[$i] =~ /^Filesystem/ );
	chomp ( $output[$i] );
	chomp ( $output[$i+1] );
	my $diskdir = "$output[$i]";
	my @numbers = split ( '\s+', "$output[$i+1]" );
	my $usage   = $numbers[1];
	my $quota   = $numbers[2];
	my $limit   = $numbers[3];
	my $allowed = ($thresh * $quota);
	
	if ( $usage >= $allowed ) { 
		my $date = `date '+%Y%m%d'`;
		chomp $date;
		my $system = `uname -n`;
		chomp $system;
		`mkdir $ENV{HOME}/quotamails` if ( ! -d "$ENV{HOME}/quotamails" );
		my $mailfile = "$ENV{HOME}/quotamails/quotamail.${system}.${date}.${i}" 
			or die "-> Cannot open q$ENV{HOME}/uotamails/quotamail.${system}.${date}.${i}\n";

		open  MAIL,"> $mailfile";
		print MAIL "From:     jake.wendt\@obs.unige.ch\n";
		print MAIL "To:       jake.wendt\@obs.unige.ch\n";
		print MAIL "Subject:  Quota Check for $ENV{USER}\@${system} $date\n\n";
		print MAIL "Automated quota check for $ENV{USER}\@${system}\n";
		print MAIL "Disk  : $diskdir \n";
		print MAIL "usage = $usage kB\n";
		print MAIL "quota = $quota kB\n";
		print MAIL "limit = $limit kB\n\n";
		print MAIL "user thresh  = $thresh \n";
		print MAIL "user allowed = $allowed kB\n\n";
		print MAIL "@outputcopy";
		close MAIL;

		`/usr/lib/sendmail -t < $mailfile`;
	}

	$i++;
}

exit;


