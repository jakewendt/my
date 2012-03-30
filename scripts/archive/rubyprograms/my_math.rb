class MyMath
	def MyMath.run(s)
    # strip of leading and trailing spaces
    s = s.strip
    # len is the length of the string
    len = s.length
    # i is the index of + or -
    # check if + is there
    if ((i = s.index('+')) != nil)
	    op = '+'
    elsif ((i = s.index('-')) != nil)
	    op = '-'
    end
    # x is the first number, stripped of spaces
    x = s.slice(0, i).strip.to_i
    # y is the second number, stripped of spaces
    y = s.slice(i + 1, len).strip.to_i
    # return the value of the expression
    if op == '+'
	    x + y
    else
	    x - y
    end
	end
end

# for + check that no double or more + signs used
# for - check how many -s and then use second -
