#!/usr/bin/env ruby

require 'rubygems'
require 'chronic'

File.open('nhl_playoffs_2011_round_2.ics','w') do |ics|
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
#	http://www.nhl.com/ice/schedulebymonth.htm?month=201104
#	http://www.nhl.com/ice/schedulebymonth.htm?month=201105
__END__
Thu Apr 28, 2011 NASHVILLE - VANCOUVER @ 9:00 PM ET - VERSUS (HD),CBC (HD) PREVIEW › TICKETS › BUY/SELL ›
Fri Apr 29, 2011 TAMPA BAY - WASHINGTON @ 7:00 PM ET - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Fri Apr 29, 2011 DETROIT - SAN JOSE @ 10:00 PM ET - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Sat Apr 30, 2011 BOSTON - PHILADELPHIA @ 3:00 PM ET - CBC (HD),NBC (HD) TICKETS › BUY/SELL ›
Sat Apr 30, 2011 NASHVILLE - VANCOUVER @ 9:00 PM ET - VERSUS (HD),CBC (HD) 
Sun May 1, 2011 DETROIT - SAN JOSE @ 3:00 PM ET - TSN (HD),NBC (HD) TICKETS › BUY/SELL ›
Sun May 1, 2011 TAMPA BAY - WASHINGTON @ 7:00 PM ET - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Mon May 2, 2011 BOSTON - PHILADELPHIA @ 7:30 PM ET - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Tue May 3, 2011 WASHINGTON - TAMPA BAY @ TBD - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Tue May 3, 2011 VANCOUVER - NASHVILLE @ TBD - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Wed May 4, 2011 WASHINGTON - TAMPA BAY @ 7:00 PM ET - TSN (HD) TICKETS › BUY/SELL ›
Wed May 4, 2011 PHILADELPHIA - BOSTON @ 7:00 PM ET - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Wed May 4, 2011 SAN JOSE - DETROIT @ 8:00 PM ET - VERSUS,TSN (HD) TICKETS › BUY/SELL ›
Thu May 5, 2011 VANCOUVER - NASHVILLE @ TBD - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Fri May 6, 2011 SAN JOSE - DETROIT @ 7:00 PM ET - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Fri May 6, 2011 PHILADELPHIA - BOSTON @ 8:00 PM ET - VERSUS,CBC (HD) TICKETS › BUY/SELL ›
Sat May 7, 2011 TAMPA BAY - WASHINGTON @ 12:30 PM ET - TSN (HD),NBC (HD) TICKETS › BUY/SELL ›
Sat May 7, 2011 NASHVILLE - VANCOUVER @ 8:00 PM ET - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Sun May 8, 2011 BOSTON - PHILADELPHIA @ 3:00 PM ET - CBC (HD),NBC (HD) TICKETS › BUY/SELL ›
Sun May 8, 2011 DETROIT - SAN JOSE @ 8:00 PM ET - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Mon May 9, 2011 WASHINGTON - TAMPA BAY @ TBD - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Mon May 9, 2011 VANCOUVER - NASHVILLE @ TBD - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Tue May 10, 2011 PHILADELPHIA - BOSTON @ TBD - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Tue May 10, 2011 SAN JOSE - DETROIT @ TBD - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Wed May 11, 2011 TAMPA BAY - WASHINGTON @ TBD - VERSUS (HD),TSN (HD) TICKETS › BUY/SELL ›
Wed May 11, 2011 NASHVILLE - VANCOUVER @ TBD - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Thu May 12, 2011 BOSTON - PHILADELPHIA @ TBD - VERSUS (HD),CBC (HD) TICKETS › BUY/SELL ›
Thu May 12, 2011 DETROIT - SAN JOSE @ TBD - VERSUS (HD),TSN (HD) 
