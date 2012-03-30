#!/usr/bin/perl -w

my $thresh = 0.85;		#	ie. 0.5 = 50% of quota
my $user = "";
my $status = "";
chomp ( my $date = `date '+%Y%m%d_%H:%M'` );
chomp ( my $system = `uname -n` );
`mkdir $ENV{HOME}/quotamails` if ( ! -d "$ENV{HOME}/quotamails" );
open LOG, ">> $ENV{HOME}/quotamails/quotamail.log"
	or die "-> Cannot open $ENV{HOME}/quotamails/quotamail.log";

my @output = `/usr/sbin/quota -v`;
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
	if ( $output[$i] =~ /^Disk/ ) {
		chomp ( $user = $output[$i] );
		$user =~ s/^Disk quotas for ([\w_]+).*/$1/;
		next;
	}
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
		my $mailfile = "$ENV{HOME}/quotamails/quotamail.${system}.${date}.${i}";

		open  MAIL,"> $mailfile" or die "-> Cannot open $mailfile";
		print MAIL "From:     jake.wendt\@obs.unige.ch\n";
		print MAIL "To:       jake.wendt\@obs.unige.ch\n";
		print MAIL "Subject:  Quota Check for ${user}\@${system} $date\n\n";
		print MAIL "Automated quota check for ${user}\@${system}\n";
		print MAIL "Disk  : $diskdir \n";
		print MAIL "usage = $usage kB\n";
		print MAIL "quota = $quota kB\n";
		print MAIL "limit = $limit kB\n\n";
		print MAIL "user thresh  = $thresh \n";
		print MAIL "user allowed = $allowed kB\n\n";
		print MAIL "@outputcopy";
		#	print MAIL `env`;
		#	HOME=/home/isdc_guest/isdc_int
		#	LOGNAME=isdc_int
		#	PATH=/usr/bin:
		#	SHELL=/usr/bin/sh
		#	TZ=MET
		close MAIL;

		`/usr/lib/sendmail -t < $mailfile`;
		$status = "-- OVER! --";
	}

	printf LOG "%-15s %-10s %-10s Current status of %-20s : %10s %10s %10s %10s %-11s\n",
		$date, $system, $user, $diskdir, $usage, $allowed, $quota, $limit, $status;

	$i++;
}

close LOG;

exit;


