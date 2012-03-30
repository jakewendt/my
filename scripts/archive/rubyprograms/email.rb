# RFC 1869, 2554, 2821 and 3207 
# ESMTP a SMTP service extension whereby a SMTP
# client may indicate an authentication mechanism to the server
require 'socket'
t = TCPSocket.new('auth.smtp.1and1.co.uk', 25)
STDOUT.write t.gets
# RFC 1869
t.write "EHLO auth.smtp.1and1.co.uk\r\n"
STDOUT.write t.gets
# RFC 3207
t.write "STARTTLS\r\n"
STDOUT.write t.gets
# RFC 2554
t.write "AUTH PLAIN LOGIN\r\n"
STDOUT.write t.gets
t.write "MAIL FROM:<satish@puneruby.com>\r\n"
STDOUT.write t.gets
t.write "RCPT TO:<satish.talim@gmail.com>\r\n"
STDOUT.write t.gets
t.write "DATA\r\n"
STDOUT.write t.gets
t.write "Test email from ruby\r\n"
#puts "That was #{c1} bytes of data"
t.write ".\n\n"
t.write "QUIT\r\n"
STDOUT.write t.gets
t.close
