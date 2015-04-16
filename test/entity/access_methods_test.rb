require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def test_access_record
      entity = Class.new Errol::Entity
      instance = entity.new :record
      assert_equal :record, instance.record
    end
  end
end
