#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'json'
require 'fileutils'
require 'erb'
require 'yaml'

GITHUB = YAML::load(ERB.new(IO.read(
	File.join(File.dirname(__FILE__),'github_raider.yml'))).result)

GITHUB['repo'] = File.expand_path(GITHUB['repo'])

pwd = Dir.pwd
if File.exists?(GITHUB['repo'])
	if File.directory?(GITHUB['repo'])
		Dir.chdir(GITHUB['repo'])
	else
		puts
		puts	"#{GITHUB['repo']} is not a directory?"
		puts
		exit
	end
else
	puts "#{GITHUB['repo']} does not exist.  Creating..."
	FileUtils.mkdir(GITHUB['repo']) 
end

GITHUB['users'].each do |_user|
	inclusions = []
	exclusions = []
	user = case _user
		when String then _user
		when Hash   then _user['user']
	end
	if _user.is_a?(Hash)
		inclusions = [_user['only']].flatten   if _user['only']
		exclusions = [_user['except']].flatten if _user['except']
	end

	puts user

	if File.exists?("#{GITHUB['repo']}/#{user}")
		unless File.directory?("#{GITHUB['repo']}/#{user}")
			puts
			puts	"#{GITHUB['repo']}/#{user} is not a directory?  Skipping user"
			puts
			next
		end
	else
		puts "#{GITHUB['repo']}/#{user} does not exist.  Creating..."
		FileUtils.mkdir("#{GITHUB['repo']}/#{user}") 
	end
	Dir.chdir("#{GITHUB['repo']}/#{user}")

#	json = `curl http://github.com/api/v1/json/#{user}`

	r = Net::HTTP.get_response  "github.com","/api/v1/json/#{user}"
	next unless r.code.to_s == '200'
	json = r.body
	
	response = JSON.parse(json)
	File.open("#{user}.yml",'w') { |f| f.puts response.to_yaml }

	#	happens for users without repos
	next if response['user']['repositories'].nil?
	response['user']['repositories'].each do |repo|
		next if !exclusions.empty? &&  exclusions.include?(repo['name'])
		next if !inclusions.empty? && !inclusions.include?(repo['name'])

		url = ( response['user']['login'] == (GITHUB['login']||'') ) ? 
			"git@github.com:" : "git://github.com/"
		url << "#{repo['owner']}/#{repo['name']}.git"
		puts url
	
		if File.exists?("#{GITHUB['repo']}/#{user}/#{repo['name']}")
			puts "#{repo['name']} exists.  Updating."
			if File.directory?("#{GITHUB['repo']}/#{user}/#{repo['name']}")
				Dir.chdir("#{GITHUB['repo']}/#{user}/#{repo['name']}")
				puts `git pull`
				Dir.chdir("#{GITHUB['repo']}/#{user}")
			else
				"#{repo['name']} is not a directory.  Skipping."
			end
		else
			puts "#{repo['name']} does not exist.  Cloning."
			puts `git clone #{url}`
		end
	end
	Dir.chdir("#{GITHUB['repo']}")
end
Dir.chdir(pwd)
