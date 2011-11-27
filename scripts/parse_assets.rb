#!/usr/bin/env ruby

String.class_eval do
	def squish
		self.gsub(/^\s*/,'').gsub(/\s*$/,'')
	end
end

$*.each do |filename|
#	puts "Read #{filename}"
	assets = Array.new
	File.open(filename,'r') do |f|
		count = 0
		title, creators, model, price = nil
		asset = Hash.new
		while line = f.gets
			if line =~ /^\s*$/ and !title.nil? and !creators.nil?
				assets.push asset
				asset = Hash.new
#				puts "#{title} - #{creators} : #{price}"
#				puts "#{title} - #{creators}"
#				puts "#{title}"
				title, creators, price = nil
				count+=1
			end
			if line =~ /^Title: (.*)$/
				asset[:title] = title = $1.squish
			end
			if line =~ /^Creators\(s\): (.*)$/
				asset[:creators] = creators = $1.squish
			end
			if line =~ /Price: (.*)$/
				asset[:price] = price = $1.squish
			end
			if line =~ /Model: (.*)Serial:/
				asset[:model] = model = $1.squish
			end
		end
assets.sort_by{|x| x[:creators] }.each{|a|
	puts "#{a[:creators]} - #{a[:title]}"
}
#assets.sort_by{|x| x[:title] }.each{|a|
#	puts "#{a[:title]} - #{a[:creators]} - #{a[:model]} : #{a[:price]}"
#}
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


