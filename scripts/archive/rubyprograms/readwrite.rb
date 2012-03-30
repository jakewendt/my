# Open and read from a text file
File.open('Constructs.rb', 'r') do |f1|
	while line = f1.gets
		puts line
	end
end

# Create a new file and write to it
File.open('Test.rb', 'w') do |f2|
	# use "" for two lines of text
	f2.puts "Created by Satish\nThank God!"
end