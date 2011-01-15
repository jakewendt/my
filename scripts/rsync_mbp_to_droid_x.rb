#!/usr/bin/env ruby

#Date=`date "+%y%m%d%H%M%S"`

Source = "/Users/Shared/iTunes/"

TargetDrive = "/Volumes/NO NAME"
unless File.directory?(TargetDrive)
	puts "#{TargetDrive} does not exist."
	exit
end
Target = "#{TargetDrive}/Music/"

puts "Preparing rsync command"

#	-a = -rlptgoD
#	g - groups have become a problem so I'm ignorin em
#	t - times have become a problem so I'm ignorin em
#	D - devices are pointless here so I'm ignorin em
#	r - recursive
#	l - links
#	p - permissions (don't work right when syncing to my droid x)
#	t - 
#	o - owner
#	v - verbose
#	z - compression
#	c - checksum (seems to be needed for the droid x as without it, all files would be synced all the time)
#	--delete --backup --backup-dir rsync-backup-$Date \
#	can't seem to sync Tool's Ænima even with wildcards. My guess Æ doesn't go over well.
# --exclude "/*" MUST be last or nothing gets copied
#	c takes too long so using --size-only

bands_and_albums = {
	"Betty Blowtorch" => nil,
	"Breaking Benjamin" => nil,
	"Godsmack" => nil,
	"Home Video" => nil,
	"Joseph Arthur" => nil,
	"Katy Perry" => nil,
	"Lily Allen" => ["Alright, Still"],
	"Massive Attack" => ["100th Window","Blue Lines",
		"Mezzanine","Protection"
	],
	"Nickelback" => nil,
	"Pantera" => nil,
	"Radiohead" => ["Amnesiac","Black Session","Go to Sleep (Single)",
		"Hail To The Thief","I Might Be Wrong - Live Recordings",
		"In Rainbows","Karma Police (Single)","Kid A",
		"Knives Out (Single)","No Surprises (CD 1)","OK Computer",
		"Pablo Honey","Paranoid Android (Single)",
		"Pyramid Song (Single)","The Bends",
		"The Best Of","There There (Single)" ],
	"South Park" => nil,
	"Tripping the Rift" => nil,
	"Eureka*" => nil,
	"Switchfoot" => nil,
	"Temper Trap" => nil,
	"The Cure" => ["Trilogy*"],
	"The Dresden Dolls" => nil,
	"Thom Yorke" => nil,
	"Tool" => ["10,000 Days","Lateralus","Opiate","Undertow","Ænima"],
	"We Are Scientists" => nil
}

command = "/usr/bin/rsync -rvz --size-only --progress "
 
bands_and_albums.each do |band,albums|
	command << "--include='#{band}' "
	if albums.is_a?(Array)
		albums.each do |album|
			command << "--include='#{band}/#{album}' "
		end
		#	Always exclude AFTER
		command << "--exclude='#{band}/*' "
	end
end

#	Always exclude AFTER
command << "--exclude='/*' "
command << "'#{Source}' '#{Target}'"

puts command
system command

