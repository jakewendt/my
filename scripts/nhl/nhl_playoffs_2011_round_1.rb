#!/usr/bin/env ruby

require 'rubygems'
require 'chronic'

File.open('nhl_playoffs_2011_round_1.ics','w') do |ics|
ics.puts <<EOF
BEGIN:VCALENDAR
BEGIN:VTIMEZONE
TZID:Eastern
BEGIN:STANDARD
DTSTART:16011104T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
TZOFFSETFROM:-0400
TZOFFSETTO:-0500
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16010311T020000
RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
TZOFFSETFROM:-0500
TZOFFSETTO:-0400
END:DAYLIGHT
END:VTIMEZONE
EOF
#File.open('nhl_playoffs_2011_round_1.txt','r') do |f|
#	while line = f.gets
	while line = DATA.gets
		matches = /\A(\d\d)-(\w{3})\s+([\w ]+)\s+([\w\d: ]+)\s+([\w ]+)\s+.*/.match(line)
#	I had considered dealing with times greater that 240000
#	but it doesn't seem to be necessary.
		time = Chronic.parse(matches[4])
		hour, end_hour, min = if time.nil?
			["10","22","00"]
		else
			[sprintf("%02d",time.hour), sprintf("%02d",time.hour + 3), sprintf("%02d",time.min)]
		end
		date = Chronic.parse("#{matches[2]} #{matches[1]}")
		month = sprintf("%02d",date.month)
		day = sprintf("%02d",date.day)
		visitor = matches[3].strip
		home = matches[5].strip
ics.puts <<EOF
BEGIN:VEVENT
DTSTART;TZID=Eastern:2011#{month}#{day}T#{hour}#{min}00
DTEND;TZID=Eastern:2011#{month}#{day}T#{end_hour}#{min}00
TRANSP:TRANSPARENT
SUMMARY:#{visitor} @ #{home}
END:VEVENT
EOF
	end
#end
ics.puts "END:VCALENDAR"
end


# Copied from ...
#	http://www.altiusdirectory.com/Sports/nhl-stanley-cup-playoffs-schedule.php
__END__
13-Apr 	New York Rangers 	7:30 PM 	Washington Capitals 	Verizon Center 	Versus(JIP), TSN
15-Apr 	New York Rangers 	7:30 PM 	Washington Capitals 	Verizon Center 	Versus, TSN
17-Apr 	Washington Capitals 	3:00 PM 	New York Rangers 	Madison Square Garden 	NBC, TSN
20-Apr 	Washington Capitals 	7:00 PM 	New York Rangers 	Madison Square Garden 	Versus, TSN
23-Apr 	New York Rangers 	3:00 PM 	Washington Capitals 	Verizon Center 	NBC, TSN
25-Apr 	Washington Capitals 	TBD 	New York Rangers 	Madison Square Garden 	TSN
27-Apr 	New York Rangers 	TBD 	Washington Capitals 	Verizon Center 	TSN
14-Apr 	Buffalo Sabres 	7:30 PM 	Philadelphia Flyers 	Wells Fargo Center 	Versus (JIP), TSN
16-Apr 	Buffalo Sabres 	5:00 PM 	Philadelphia Flyers 	Wells Fargo Center 	TSN2
18-Apr 	Philadelphia Flyers 	7:00 PM 	Buffalo Sabres 	HSBC Arena 	Versus, TSN
20-Apr 	Philadelphia Flyers 	7:30 PM 	Buffalo Sabres 	HSBC Arena 	Versus, TSN
22-Apr 	Buffalo Sabres 	7:30 PM 	Philadelphia Flyers 	Wells Fargo Center 	Versus (JIP), TSN
24-Apr 	Philadelphia Flyers 	3:00 PM 	Buffalo Sabres 	HSBC Arena 	NBC, TSN
26-Apr 	Buffalo Sabres 	TBD 	Philadelphia Flyers 	Wells Fargo Center 	TSN
14-Apr 	Montreal Canadiens 	7:00 PM 	Boston Bruins 	TD Garden 	Versus, RDS, CBC
16-Apr 	Montreal Canadiens 	7:00 PM 	Boston Bruins 	TD Garden 	Versus, RDS, CBC
18-Apr 	Boston Bruins 	7:30 PM 	Montreal Canadiens 	Bell Centre 	RDS, CBC
21-Apr 	Boston Bruins 	7:00 PM 	Montreal Canadiens 	Bell Centre 	Versus, RDS, CBC
23-Apr 	Montreal Canadiens 	7:00 PM 	Boston Bruins 	TD Garden 	Versus, RDS, CBC
26-Apr 	Boston Bruins 	TBD 	Montreal Canadiens 	Bell Centre 	RDS, CBC
27-Apr 	Montreal Canadiens 	TBD 	Boston Bruins 	TD Garden 	RDS, CBC
13-Apr 	Tampa Bay Lightning 	7:00 PM 	Pittsburgh Penguins 	Consol Energy Center 	CBC
15-Apr 	Tampa Bay Lightning 	7:00 PM 	Pittsburgh Penguins 	Consol Energy Center 	CBC
18-Apr 	Pittsburgh Penguins 	7:30 PM 	Tampa Bay Lightning 	St. Pete Times Forum 	Versus (JIP), CBC
20-Apr 	Pittsburgh Penguins 	7:00 PM 	Tampa Bay Lightning 	St. Pete Times Forum 	CBC
23-Apr 	Tampa Bay Lightning 	TBD 	Pittsburgh Penguins 	Consol Energy Center 	Versus (JIP), CBC
25-Apr 	Pittsburgh Penguins 	TBD 	Tampa Bay Lightning 	St. Pete Times Forum 	CBC
27-Apr 	Tampa Bay Lightning 	TBD 	Pittsburgh Penguins 	Consol Energy Center 	CBC
13-Apr 	Chicago Blackhawks 	10:00 PM 	Vancouver Canucks 	Rogers Arena 	Versus, CBC
15-Apr 	Chicago Blackhawks 	10:00 PM 	Vancouver Canucks 	Rogers Arena 	Versus, CBC
17-Apr 	Vancouver Canucks 	8:00 PM 	Chicago Blackhawks 	United Center 	Versus, CBC
19-Apr 	Vancouver Canucks 	8:00 PM 	Chicago Blackhawks 	United Center 	Versus, CBC
21-Apr 	Chicago Blackhawks 	10:00 PM 	Vancouver Canucks 	Rogers Arena 	Versus, CBC
24-Apr 	Vancouver Canucks 	7:30 PM 	Chicago Blackhawks 	United Center 	CBC
26-Apr 	Chicago Blackhawks 	TBD 	Vancouver Canucks 	Rogers Arena 	CBC
14-Apr 	Los Angeles Kings 	10:00 PM 	San Jose Sharks 	HP Pavilion 	Versus, TSN
16-Apr 	Los Angeles Kings 	10:00 PM 	San Jose Sharks 	HP Pavilion 	Versus, TSN
19-Apr 	San Jose Sharks 	10:30 PM 	Los Angeles Kings 	Staples Center 	Versus, TSN
21-Apr 	San Jose Sharks 	10:30 PM 	Los Angeles Kings 	Staples Center 	TSN
23-Apr 	Los Angeles Kings 	10:30 PM 	San Jose Sharks 	HP Pavilion 	Versus, TSN
25-Apr 	San Jose Sharks 	TBD 	Los Angeles Kings 	Staples Center 	TSN
27-Apr 	Los Angeles Kings 	TBD 	San Jose Sharks 	HP Pavilion 	TSN
13-Apr 	Phoenix Coytoes 	7:00 PM 	Detroit Red Wings 	Joe Louis Arena 	Versus,CBC
16-Apr 	Phoenix Coytoes 	1:00 PM 	Detroit Red Wings 	Joe Louis Arena 	NBC, CBC
18-Apr 	Detroit Red Wings 	10:30 PM 	Phoenix Coytoes 	Jobing.com Arena 	Versus,CBC
20-Apr 	Detroit Red Wings 	10:30 PM 	Phoenix Coytoes 	Jobing.com Arena 	Versus,CBC
22-Apr 	Phoenix Coytoes 	7:00 PM 	Detroit Red Wings 	Joe Louis Arena 	Versus,CBC
24-Apr 	Detroit Red Wings 	TBD 	Phoenix Coytoes 	Jobing.com Arena 	CBC
27-Apr 	Phoenix Coytoes 	TBD 	Detroit Red Wings 	Joe Louis Arena 	CBC
13-Apr 	Nashville Predators 	10:30 PM 	Anaheim Ducks 	Honda Center 	TSN
15-Apr 	Nashville Predators 	10:30 PM 	Anaheim Ducks 	Honda Center 	TSN
17-Apr 	Anaheim Ducks 	6:00 PM 	Nashville Predators 	Bridgestone Arena 	TSN
20-Apr 	Anaheim Ducks 	8:30 PM 	Nashville Predators 	Bridgestone Arena 	TSN
22-Apr 	Nashville Predators 	10:00 PM 	Anaheim Ducks 	Honda Center 	TSN
24-Apr 	Anaheim Ducks 	TBD 	Nashville Predators 	Bridgestone Arena 	TSN
26-Apr 	Nashville Predators 	TBD 	Anaheim Ducks 	Honda Center 	TSN
