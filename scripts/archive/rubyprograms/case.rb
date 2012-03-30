# File: case.rb
def f(x)
  case x
    when "foo"
      puts "#{x.class} foo"
    when /\d+.*/
      puts "mixed: #{x}" 
    when String
      puts "string #{x}"
    when 1000..1500
      puts "between 1000 and 1500: #{x}"
    when Fixnum
      puts "Fixnum #{x}"
    when Object
      puts "object #{x} #{x.class}"
  end
end

f("foo")
f("123abc")
f("bar")
f(1066)
f(1)
f(1.1)