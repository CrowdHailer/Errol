require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def test_entry_reader_sets_reader_method
      entity = Class.new Errol::Entity do
        entry_reader :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      record.test_attribute = :value
      assert_equal :value, instance.test_attribute
    end
  end
end
