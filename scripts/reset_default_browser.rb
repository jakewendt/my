#!/usr/bin/env ruby

#	My default browser kept resetting on reboot. I’ve read 
#	that this has something to do with using File Vault. 
#	Since I can’t fix the problem, I’m gonna just fix the 
#	symptom. I intend on writing a small script that can be 
#	run at login each time setting the default browser. I 
#	looked into AppleScript as well as Automator, but no 
#	joy. I’m gonna try to keep it simple and use 
#	the ‘defaults’ command.

class Defaults
	attr_accessor :defaults
	def initialize(input)
		@defaults = []
		elements = input.gsub!(/[\(\)\n]/,'').gsub!(/\s+/,' ').strip!.split(/,/)
		elements.each do |e|
			h = {}
			e.gsub!(/[\{\}]/,'').strip!
			e.split(/;/).each do |kv|
				key, value = kv.split(/=/)
				h[key.strip] = value.strip
			end
			@defaults.push(h)
		end
	end
	def to_s
		d = "("
		d << @defaults.collect do |default|
				dd =  '{'
				dd << default.collect do |k,v|
						"#{k} = #{v};"
					end.join()
				dd << '}'
			end.join(',')
		d << ")"
	end
	def find(key,value)
		@defaults.detect{|h| h.has_key?(key) && h[key] == value }
	end
	def update(key,value,other_key,new_value)
		d = find(key,value)
		d[other_key] = new_value
		d
	end
#output = input.gsub(/\n/,'').gsub("com.apple.safari","org.mozilla.firefox")
end


#	Just in case I muck it up again
#input = '( { LSHandlerRoleAll = "org.mozilla.firefox"; LSHandlerURLScheme = http; }, { LSHandlerRoleAll = "org.mozilla.firefox"; LSHandlerURLScheme = https; }, { LSHandlerRoleAll = "org.mozilla.firefox"; LSHandlerURLScheme = ftp; }, { LSHandlerContentType = "public.html"; LSHandlerRoleAll = "org.mozilla.firefox"; }, { LSHandlerContentType = "com.microsoft.word.doc"; LSHandlerRoleAll = "com.apple.textedit"; }, { LSHandlerContentTag = yml; LSHandlerContentTagClass = "public.filename-extension"; LSHandlerRoleAll = "com.apple.textedit"; }, { LSHandlerContentType = "com.apple.ical.backup"; LSHandlerRoleAll = "com.apple.ical"; }, { LSHandlerContentTag = icalevent; LSHandlerContentTagClass = "public.filename-extension"; LSHandlerRoleAll = "com.apple.ical"; }, { LSHandlerContentTag = icaltodo; LSHandlerContentTagClass = "public.filename-extension"; LSHandlerRoleAll = "com.apple.ical"; }, { LSHandlerRoleAll = "com.apple.ical"; LSHandlerURLScheme = webcal; }, { LSHandlerContentTag = jake3; LSHandlerContentTagClass = "public.filename-extension"; LSHandlerRoleAll = "com.apple.textedit"; }, { LSHandlerContentType = "public.xhtml"; LSHandlerRoleAll = "org.mozilla.firefox"; })'


d = Defaults.new(`defaults read com.apple.LaunchServices LSHandlers`);
puts d.to_s

d.update("LSHandlerURLScheme","http","LSHandlerRoleAll","\"org.mozilla.firefox\"")
d.update("LSHandlerURLScheme","https","LSHandlerRoleAll","\"org.mozilla.firefox\"")
d.update("LSHandlerContentType","\"public.html\"","LSHandlerRoleAll","\"org.mozilla.firefox\"")
d.update("LSHandlerContentType","\"public.xhtml\"","LSHandlerRoleAll","\"org.mozilla.firefox\"")


puts d.to_s
cmd = "defaults write com.apple.LaunchServices LSHandlers '#{d.to_s}'"
puts cmd
`#{cmd}`

__END__

input = `defaults read com.apple.LaunchServices LSHandlers`
#	this is pretty bold, but effective for me
output = input.gsub(/\n/,'').gsub("com.apple.safari","org.mozilla.firefox")
cmd = "defaults write com.apple.LaunchServices LSHandlers '#{output}'"
puts cmd
`#{cmd}`


(
                {
            LSHandlerRoleAll = "org.mozilla.firefox";
            LSHandlerURLScheme = http;
        },
                {
            LSHandlerRoleAll = "org.mozilla.firefox";
            LSHandlerURLScheme = https;
        }
)
