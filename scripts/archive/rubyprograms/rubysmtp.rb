# rubysmtp.rb
require 'net/smtp'
user_from = "satish@puneruby.com"
user_to = "satish.talim@gmail.com"
the_email = "From: satish@puneruby.com\nSubject: Hello\n\nEmail by Ruby.\n\n"
# handling exceptions
begin
  Net::SMTP.start('auth.smtp.1and1.co.uk', 25, '1and1.co.uk',
                         'satish@puneruby.com', 'talimruby', :login)	do |smtpclient|
    smtpclient.send_message(the_email, user_from, user_to)
  end
rescue Exception => e
  print "Exception occured: " + e
end
