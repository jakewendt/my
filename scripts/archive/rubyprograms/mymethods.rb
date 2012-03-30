# A simple method
def hello
  puts 'Hello'
end
#use the method
hello

# Method with an argument - 1
def hello1(name)
  puts 'Hello ' + name
  return 'success'
end
puts(hello1('satish'))

# Method with an argument - 2
def hello2 name2
  puts 'Hello ' + name2
  return 'success'
end
puts(hello2 'talim')
