#!/usr/bin/env ruby

$*.each do |filename|
	puts "Read #{filename}"
	File.open(filename,'r') do |f|
		count = 0
		title, creators, price = nil
		while line = f.gets
			if line =~ /^\s*$/ and !title.nil? and !creators.nil?
#				puts "#{title} - #{creators} : #{price}"
				puts "#{title} - #{creators}"
#				puts "#{title}"
				title, creators, price = nil
				count+=1
			end
			if line =~ /^Title: (.*)$/
				title = $1
			end
			if line =~ /^Creators\(s\): (.*)$/
				creators = $1
			end
			if line =~ /Price: (.*)$/
				price = $1
			end
		end
	end
end

__END__


Title: Alive and Screamin'
Description: Media|Music|Cassette|Krokus|Alive and Screamin'|for sale||||||||5.00|1|5.00
Model:                        Serial: 
Cost: $5.00                   Value: $1.00                  Price: $1.00
Acquired on: 1980-01-01       Used on: 1980-01-01           Sold on: 
Creators(s): Krokus
Category(s): Media, Music, Cassette
Location(s): Oakland


