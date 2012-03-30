def raise_and_rescue
  begin	
	  puts 'I am before the raise.'
		raise 'An error has occured.'
		puts 'Iam after the raise.'
	rescue
	  puts 'I am rescued.'
	end
	puts 'I am after the begin block.'
end
raise_and_rescue
