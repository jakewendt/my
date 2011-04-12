#!/usr/bin/env ruby

require 'rubygems'
require 'chronic'

#	22-Apr 	Phoenix Coytoes 	7:00 PM 	Detroit Red Wings 	Joe Louis Arena 	Versus,CBC
#	24-Apr 	Detroit Red Wings 	TBD 	Phoenix Coytoes 	Jobing.com Arena 	CBC
#	27-Apr 	Phoenix Coytoes 	TBD 	Detroit Red Wings 	Joe Louis Arena 	CBC
#	13-Apr 	Nashville Predators 	10:30 PM 	Anaheim Ducks 	Honda Center 	TSN
#	15-Apr 	Nashville Predators 	10:30 PM 	Anaheim Ducks 	Honda Center 	TSN
#	17-Apr 	Anaheim Ducks 	6:00 PM 	Nashville Predators 	Bridgestone Arena 	TSN
#	20-Apr 	Anaheim Ducks 	8:30 PM 	Nashville Predators 	Bridgestone Arena 	TSN
#	22-Apr 	Nashville Predators 	10:00 PM 	Anaheim Ducks 	Honda Center 	TSN
#	24-Apr 	Anaheim Ducks 	TBD 	Nashville Predators 	Bridgestone Arena 	TSN
#	26-Apr 	Nashville Predators 	TBD 	Anaheim Ducks 	Honda Center 	TSN


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
File.open('nhl_playoffs_2011_round_1.txt','r') do |f|
	while line = f.gets
		matches = /\A(\d\d)-(\w{3})\s+([\w ]+)\s+([\w\d: ]+)\s+([\w ]+)\s+.*/.match(line)
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
end
ics.puts "END:VCALENDAR"
end
