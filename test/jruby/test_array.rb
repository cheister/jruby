require 'test/unit'

## NOTE: Most of the tests that were here have been moved to the RubySpec.

class TestArray < Test::Unit::TestCase
  ##### splat test #####
  class ATest
    def to_a; 1; end
  end

  def test_splatting
    proc { |a| assert_equal(1, a) }.call(*1)
    assert_raises(TypeError) { proc { |a| }.call(*ATest.new) }
  end

  def test_initialize_on_frozen_array
    assert_raises(RuntimeError) {
      [1, 2, 3].freeze.instance_eval { initialize }
    }
  end

  def test_uniq_with_block_after_slice
    assert_equal [1], [1, 1, 1][1,2].uniq { |x| x }
    assert_equal [1], [1, 1, 1][1,2].uniq! { |x| x }
  end

  # JRUBY-4157
  def test_shared_ary_slice
    assert_equal [4,5,6], [1,2,3,4,5,6].slice(1,5).slice!(2,3)
  end
  
  # JRUBY-4206
  def test_map
    methods = %w{map map! collect collect!}
    methods.each { |method|
      assert_no_match(/Enumerable/, [].method(method).to_s)
    }
  end

  # GH-4021
  def test_range_to_a
    assert_equal [ '2202702806' ], ("2202702806".."2202702806").to_a
    str = '12345678900000'; assert (str..str).include?(str)
    str = '2202702806'; assert_equal true, (str..str).member?(str)
    str = '2202702806'; assert_equal false, (str..str).member?(str.to_i)
  end

end
