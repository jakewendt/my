# Date Time Server - server side using thread
# usage: ruby dtserver.rb

require "socket"

dts = TCPserver.new('localhost', 20000)
loop do
  Thread.start(dts.accept) do |s|
    print(s, " is accepted\n")
    s.write(Time.now)
    print(s, " is gone\n")
    s.close
  end
end
