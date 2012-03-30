def foo(*my_string) 
  my_string.each do |words| 
		puts words 
	end 
end 
foo('hello','world') 
foo()