#!/usr/bin/env ruby

#
#	http://develop.github.com/p/issues.html
#
#	Ex: curl http://github.com/api/v2/json/issues/list/jakewendt/my/open
#
#	curl http://github.com/api/v2/:format/issues/list/:login/:repo/open
#		:format => ( json, yaml )
#
#	curl http://github.com/api/v2/json/issues/list/:user/:repo/open
#	curl http://github.com/api/v2/json/issues/list/:user/:repo/closed
#
#
#	http://develop.github.com/p/gist.html
#
#	Ex: curl http://gist.github.com/api/v1/json/gists/jakewendt
#
#	curl http://gist.github.com/api/v1/:format/gists/:login
#
#	curl http://gist.github.com/api/v1/json/gists/jakewendt
#		=> gist titles
#
#	{"gists":[{"description":null,"public":true,"repo":"137373","files":["array_extension.rb"],
#		"owner":"jakewendt","created_at":"2009/06/28 14:15:20 -0700"},
#
#	curl http://gist.github.com/raw/:gist_id/:filename
#
#	curl http://gist.github.com/raw/137373/array_extension.rb
#

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'json'
require 'fileutils'
require 'erb'
require 'yaml'

class Array
	def extract_options!
		( last.is_a?(Hash) ) ? pop : {}
	end
	def empty?
		length <= 0
	end
end

module Github
	class User
		attr_accessor :login, :name, :location, :options
		attr_accessor :inclusions, :exclusions, :repositories
		def initialize(*args)
			@options = args.extract_options!
			@options.keys.each do |key|
				send("#{key}=",options[key]) if respond_to?(key)
			end

			@login = case 
				when !args.empty?       then args.first
				when !@options['user'].nil? then @options['user']
				else raise
			end
			puts "#\n#\tProcessing github user:#{login}\n#"

			@inclusions = ( options['only']   ) ? [options['only']].flatten   : []
			@exclusions = ( options['except'] ) ? [options['except']].flatten : []

			if File.exists?(login_path)
				unless File.directory?(login_path)
					puts
					puts	"#{login_path} is not a directory?  Skipping user"
					puts
					next
				end
			else
				puts "#"
				puts "#\t#{login_path} does not exist.  Creating..."
				puts "#"
				FileUtils.mkdir(login_path)
			end
			Dir.chdir(login_path)

			#	json = `curl http://github.com/api/v1/json/#{user}`

			r = Net::HTTP.get_response  "github.com","/api/v1/json/#{login}"
			raise unless r.code.to_s == '200'
			json = r.body

			user_response = JSON.parse(json)
			File.open("#{login}.yml",'w') { |f| f.puts user_response.to_yaml }
			@repositories = []
			(user_response['user']['repositories']||[]).each{ |repo|
				repositories << github_repo = Github::Repository.new(repo)
#	Wait until all wikis are new wikis (late September)
#				if github_repo.has_wiki
#					wiki = repo.clone
#					wiki['name'] += ".wiki"
#					repositories << ( github_repo = Github::Repository.new(wiki) )
#				end
			}
			self
		end
	protected
		def login_path
			"#{GITHUB['repo']}/#{login}"
		end
	end
	class Repository
		attr_accessor :options, :name, :owner, :has_wiki
		#	, :url	(http://github.com/jakewendt/my_core) not very helpful here
		#	:description
		#	:has_downloads
		#	:pushed_at
		#	:homepage
		#	:fork
		#	:open_issues
		#	:watchers
		#	:private
		#	:has_issues
		#	:forks
		#	:created_at
		def initialize(options)
			@options = options
			options.keys.each do |key|
				if respond_to?(key)
					send("#{key}=",options[key])
				end
			end
		end
		def git_url(current_user = '')
			((( owner == current_user ) ? "git@github.com:" : "git://github.com/" ) + "#{owner}/#{name}.git" )
		end
		def owner_path
			"#{GITHUB['repo']}/#{owner}"
		end
		def local_path
			"#{owner_path}/#{name}"
		end
		def update( current_user = '' )
#			puts git_url(current_user)
#			puts local_path
	
			if File.exists?(local_path)
				puts "-- #{@name} exists.  Updating."
				if File.directory?(local_path)
					Dir.chdir(local_path)
					puts `git pull`
					Dir.chdir(owner_path)
				else
					"-? #{name} is not a directory.  Skipping."
				end
			else
				puts "-! #{name} does not exist.  Cloning."
				puts `git clone #{git_url(current_user)}`
#-! rubycas-client.wiki does not exist.  Cloning.
#fatal: The remote end hung up unexpectedly
#Initialized empty Git repository in /Users/jake/github_repo/gunark/rubycas-client.wiki/.git/
			end
		end
	end
end

######################################################################

GITHUB = YAML::load(ERB.new(IO.read(
	File.join(File.dirname(__FILE__),'github_raider.yml'))).result)

GITHUB['repo'] = File.expand_path(GITHUB['repo'])

pwd = Dir.pwd
if File.exists?(GITHUB['repo'])
	if File.directory?(GITHUB['repo'])
		Dir.chdir(GITHUB['repo'])
	else
		puts	"\n#{GITHUB['repo']} is not a directory?\n"
		exit
	end
else
	puts "#{GITHUB['repo']} does not exist.  Creating..."
	FileUtils.mkdir(GITHUB['repo']) 
end

GITHUB['users'].each do |_user|
	github_user = Github::User.new(_user)
	github_user.repositories.each do |repo|
		next if !github_user.exclusions.empty? &&
			github_user.exclusions.include?(repo.name)
		next if !github_user.inclusions.empty? && (
			!github_user.inclusions.include?(repo.name) &&
			!github_user.inclusions.include?(repo.name.sub(/\.wiki$/,''))
		)
#			!github_user.inclusions.include?(repo.name + '.wiki')
#	add wiki exception here
		repo.update( GITHUB['login'] )
	end
	Dir.chdir("#{GITHUB['repo']}")
end
Dir.chdir(pwd)

#	last line
