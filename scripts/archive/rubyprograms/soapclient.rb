require 'soap/rpc/driver'
driver = SOAP::RPC::Driver.new(
  'http://webservices.codingtheweb.com/bin/qotd',
	'urn:xmethods-qotd')
driver.add_method('getQuote')
puts driver.getQuote

