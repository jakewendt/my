#!/usr/bin/env ruby

require 'rubygems'
#require 'fileutils'
require 'erb'
require 'yaml'

GEMS = YAML::load(ERB.new(IO.read(
	File.join(File.dirname(__FILE__),'gem_updater.yml'))).result)

to_install = []

GEMS['gems'].each do |gem|

	gem_name = if gem.is_a?(String)
		gem
	else
		gem['gem'] || gem['name']
	end

	gem_lib = if gem.is_a?(String)
		gem
	else
		gem['lib']
	end
	
	if !Gem.source_index.find_name(gem_name).empty?
#	if Gem.searcher.find(gem_lib)
		puts "Gem #{gem_name} found."
	else
		puts "Gem #{gem_name} not found."
		to_install.push(gem_name)
	end
end
if to_install.length > 0
	system("gem install #{to_install.join(' ')}")
end
system("gem update")
