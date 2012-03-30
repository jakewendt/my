#---
# Excerpted from "Enterprise Integration with Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_eir for more book information.
#---
class Circle < Struct.new(:x, :y, :r)
  def area
		p = Math::PI
		p * r * r
  end
end

c = Circle.new(0, 0, 1)
puts c.area
puts 'Müller'.upcase
puts 'MÜller'.length