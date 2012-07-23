#!/usr/bin/env ruby
files={}
$*.each do |dir|
	puts "Processing dir:#{dir}:"
	Dir["#{dir}/**/*"].each do |file|
		files[File.basename(file)] ||= []
		files[File.basename(file)] << File.dirname(file)
	end
end

duplicates = files.select { |k,v|
	v.length > 1
}

puts duplicates.inspect
