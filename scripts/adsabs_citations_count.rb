#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'open-uri'

r = Net::HTTP.get_response "adsabs.harvard.edu",
	"/abs/2007A%26A...467..585B"
exit unless r.code.to_s == '200'

puts r.body.match(/Citations to the Article \((\d*)\)/)[1]
