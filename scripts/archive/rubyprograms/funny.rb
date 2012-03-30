# http://ola-bini.blogspot.com/2006/09/ruby-singleton-class.html
# http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
# Creates a new anonymous (unnamed) class of type Object
obj1 = Class.new

# Creates a new anonymous (unnamed) class with the given superclass
obj2 = Class.new(File)

# You can give a class a name by assigning the class object to a constant
Rectangle = obj1
InputOutput = obj2

# Returns the superclass of a class, or nil
puts Rectangle.superclass      # Object
puts Class.superclass            # Module
puts InputOutput.superclass   # File
puts Object.superclass          # nil

# Returns the class of an object
puts obj1.class
puts obj2.class

class Class
	# undef cancels the method definition. undef can not appear in the method body.
	undef new
end
obj3 = Class.new
