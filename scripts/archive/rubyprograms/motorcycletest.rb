require 'motorcycle'
m = MotorCycle.new('Yamaha', 'red')
m.startEngine

class MotorCycle
  def dispAttr
    puts 'Color of MotorCycle is ' + @color
    puts 'Make  of MotorCycle is ' + @make
  end
end
m.dispAttr
m.startEngine
puts self.class
puts self
puts MotorCycle.instance_methods(false).sort