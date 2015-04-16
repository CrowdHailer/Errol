require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def mock_repo
      @mock_repo ||= MiniTest::Mock.new
    end

    def mock_record
      @mock_record ||= MiniTest::Mock.new
    end

    def klass
      return @klass if @klass
      @klass = Class.new(Errol::Entity)
      @klass.repository = mock_repo
      @klass
    end

    def instance
      @instance ||= klass.new(mock_record)
    end

    def teardown
      @mock_repo = nil
      @mock_record = nil
      @klass = nil
      @instance = nil
    end

    def test_make_available_id
      mock_record.expect :id, 4
      assert_equal 4, instance.id
    end

    def test_equal_if_wrapping_same_record
      klass = Class.new(Errol::Entity)
      assert_equal klass.new(:a), klass.new(:a)
    end

    def test_not_equal_for_different_records
      klass = Class.new(Errol::Entity)
      refute_equal klass.new(:b), klass.new(:a)
    end

    def test_not_equal_if_different_classes
      klass1 = Class.new(Errol::Entity)
      klass2 = Class.new(Errol::Entity)
      refute_equal klass1.new(:a), klass2.new(:a)
    end


    def test_undefined_bang
      assert_raises NoMethodError do
        instance.random!
      end
    end
  end
end
