require 'my_math'
require 'test/unit'
class MyMathTest < Test::Unit::TestCase
	def test_addition
		assert_equal 4, MyMath.run("2+2")
		assert_equal 4, MyMath.run("1+3")
		assert_equal 5, MyMath.run("5+0")
		assert_equal 0, MyMath.run("5 + -5")
	end

	def test_subtraction
		assert_equal 0, MyMath.run("2-2")
		assert_equal 1, MyMath.run("2-1")
		assert_equal -1, MyMath.run("2-3")
	end
end