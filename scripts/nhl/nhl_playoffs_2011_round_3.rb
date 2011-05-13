#!/usr/bin/env ruby

require 'rubygems'
require 'chronic'

File.open('nhl_playoffs_2011_round_3.ics','w') do |ics|
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


	while line = DATA.gets
		#13-Apr 	New York Rangers 	7:30 PM 	Washington Capitals 	Verizon Center 	Versus(JIP), TSN
#		matches = /\A(\d\d)-(\w{3})\s+([\w ]+)\s+([\w\d: ]+)\s+([\w ]+)\s+.*/.match(line)
		#Thu Apr 28, 2011 NASHVILLE - VANCOUVER @ 9:00 PM ET - VERSUS (HD),CBC (HD) PREVIEW › TICKETS › BUY/SELL ›
		matches = /\A\w{3}\s+(\w{3}\s+\d{1,2},\s+\d{4})\s+([\w\s]+)\s+-\s+([\w\s]+)\s+@\s+(.+)\s+-\s+/.match(line)
#	I had considered dealing with times greater that 240000
#	but it doesn't seem to be necessary.
		time = Chronic.parse(matches[4])
		hour, end_hour, min = if time.nil?
			["10","22","00"]
		else
			[sprintf("%02d",time.hour), sprintf("%02d",time.hour + 3), sprintf("%02d",time.min)]
		end
#		date = Chronic.parse("#{matches[2]} #{matches[1]}")
		date = Chronic.parse(matches[1])
		month = sprintf("%02d",date.month)
		day = sprintf("%02d",date.day)
#		visitor = matches[3].strip
		visitor = matches[2].strip.downcase.gsub(/\b(\w)/){|s| s.upcase }
#		home = matches[5].strip
#	> "SAN JOSE".downcase.gsub(/\b(\w)/){|s| s.upcase }
#	=> "San Jose"
		home = matches[3].strip.downcase.gsub(/\b(\w)/){|s| s.upcase }
ics.puts <<EOF
BEGIN:VEVENT
DTSTART;TZID=Eastern:2011#{month}#{day}T#{hour}#{min}00
DTEND;TZID=Eastern:2011#{month}#{day}T#{end_hour}#{min}00
TRANSP:TRANSPARENT
SUMMARY:#{visitor} @ #{home}
END:VEVENT
EOF
	end

ics.puts "END:VCALENDAR"
end


# Copied from ( and modified a bit ) ...
#	http://www.nhl.com/ice/schedulebymonth.htm?month=201105
__END__
Sat May 14, 2011 TAMPA BAY - BOSTON @ 8:00 PM ET - RDS (HD),CBC (HD),VERSUS (HD) TICKETS › BUY/SELL ›
Sun May 15, 2011 SAN JOSE - VANCOUVER @ 8:00 PM ET - VERSUS (HD),CBC (HD),RDS (HD) TICKETS › BUY/SELL ›
Tue May 17, 2011 TAMPA BAY - BOSTON @ 8:00 PM ET - RDS (HD),TSN (HD),VERSUS (HD) TICKETS › BUY/SELL ›
Wed May 18, 2011 SAN JOSE - VANCOUVER @ 9:00 PM ET - VERSUS (HD),CBC (HD),RDS (HD) TICKETS › BUY/SELL ›
Thu May 19, 2011 BOSTON - TAMPA BAY @ 8:00 PM ET - RDS (HD),TSN (HD),VERSUS (HD) TICKETS › BUY/SELL ›
Fri May 20, 2011 VANCOUVER - SAN JOSE @ 9:00 PM ET - VERSUS (HD),CBC (HD),RDS (HD) TICKETS › BUY/SELL ›
Sat May 21, 2011 BOSTON - TAMPA BAY @ 1:30 PM ET - RDS (HD),NBC (HD),TSN (HD) TICKETS › BUY/SELL ›
Sun May 22, 2011 VANCOUVER - SAN JOSE @ 3:00 PM ET - CBC (HD),NBC (HD),RDS (HD) TICKETS › BUY/SELL ›
Mon May 23, 2011 TAMPA BAY - BOSTON @ 8:00 PM ET - RDS (HD),CBC (HD),VERSUS (HD) TICKETS › BUY/SELL ›
Tue May 24, 2011 SAN JOSE - VANCOUVER @ 9:00 PM ET - VERSUS (HD),CBC (HD),RDS (HD) TICKETS › BUY/SELL ›
Wed May 25, 2011 BOSTON - TAMPA BAY @ 8:00 PM ET - RDS (HD),CBC (HD),VERSUS (HD) TICKETS › BUY/SELL ›
Thu May 26, 2011 VANCOUVER - SAN JOSE @ 9:00 PM ET - VERSUS (HD),CBC (HD),RDS (HD) TICKETS › BUY/SELL ›
Fri May 27, 2011 TAMPA BAY - BOSTON @ 8:00 PM ET - RDS (HD),CBC (HD),VERSUS (HD) TICKETS › BUY/SELL ›
Sat May 28, 2011 SAN JOSE - VANCOUVER @ 8:00 PM ET - VERSUS (HD),CBC (HD),RDS (HD) TICKETS › BUY/SELL ›
