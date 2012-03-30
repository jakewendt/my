def call_block
	yield('hello', '99')
end
call_block {|str, num| puts str + ' ' + 99.to_s}
