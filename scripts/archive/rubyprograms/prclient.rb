require 'soap/rpc/driver'
driver = SOAP::RPC::Driver.new('http://217.160.200.122:12321/', 'urn:mySoapServer')
driver.add_method('sayhelloto', 'username')
puts driver.sayhelloto('PuneRuby')
