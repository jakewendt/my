require 'test/unit' 
require 'radius' 
class TestRadius < Test::Unit::TestCase
  def test_key
    robj = Radius.new('78')
    assert_equal('78', robj.key)
		robj = Radius.new(78)
    assert_equal('78', robj.key)
		robj = Radius.new([78])
    assert_nil(robj.key)
  end
end


#def setup
  #robj = Radius.new('78')
#end
#def test_key
	#assert_equal('78', robj.key)
# additional functionality removed for brevity
#end