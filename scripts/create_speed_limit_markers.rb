#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'

OUTDIR = "./speedlimits/"

if File.exists?(OUTDIR)
	unless File.directory?(OUTDIR)
		puts	"\n#{OUTDIR} is not a directory?\n"
		exit
	end
else
	puts "#{OUTDIR} does not exist.  Creating..."
	FileUtils.mkdir(OUTDIR)
end

(5..95).step(5) do |i| 
	cmd = "convert -size 31x31 xc:transparent -stroke black -strokewidth 1 -fill white -draw 'circle 15,15 15,30' -fill black -pointsize 22 -gravity Center -draw 'text 0,0 \"#{i}\"' #{OUTDIR}speedlimit#{i}.png"
	puts cmd
#	system cmd
end

vector_head="path 'M 0,0  l -15,-5  +5,+5  -5,+5  +15,-5 z'"
#indicator="path 'M 10,0  l +15,+5  -5,-5  +5,-5  -15,+5  m +10,0 +20,0 '"

#cmd = "convert -size 100x100 xc: -draw \"stroke black fill none  circle 20,50 23,50 push graphic-context stroke blue fill skyblue translate 20,50 rotate -35 line 0,0  70,0 translate 70,0 #{vector_head} pop graphic-context push graphic-context stroke firebrick fill tomato translate 20,50 rotate 40 #{indicator} translate 40,0 rotate -40 stroke none fill firebrick text 3,6 'Center' pop graphic-context \" arrow_with_tails.gif"

#cmd = "convert -size 63x63 xc: -draw \"stroke blue fill skyblue translate 20,50 rotate -35 line 0,0  70,0 translate 70,0 #{vector_head} push graphic-context stroke firebrick fill tomato translate 20,50 rotate 40 #{indicator} pop graphic-context \" arrow_with_tails.gif"

#	translate 31,31 makes the rotation about that point (the middle)
(0..360).step(10) do |i|
	cmd = "convert -size 63x63 xc:transparent -draw \"stroke black fill silver translate 31,31 rotate #{i-90} line 0,0  31,0 translate 31,0 #{vector_head}\" #{OUTDIR}arrow_with_tails#{i}.png"
	puts cmd
	system cmd
end
