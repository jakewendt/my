#!/usr/bin/env ruby
files={}
$*.each do |dir|
	puts "Processing dir:#{dir}:"
	Dir["#{dir}/**/*"].each do |file|
		files[File.basename(file)] ||= []
#		files[File.basename(file)] << { :path => File.dirname(file) }
		files[File.basename(file)] << File.dirname(file)
	end
end

duplicates = files.select { |k,v|
	v.length > 1
}

duplicates.each do |k,v|
	puts k
#	puts v.collect{|v|v[:path]}
#	puts v
	v.each do |p|
		puts p
		puts `identify -quiet -format "%#" "#{p}/#{k}"`
	end
end
