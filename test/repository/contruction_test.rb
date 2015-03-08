require_relative '../test_config'
require_relative './query_test'

class Item < Sequel::Model(:items)
  def name=(name)
    super name.reverse
  end
end

class RepositoryQueyTest < RecordTest
  def test_can_build_new_record
    assert_equal Item.new, TestRepository.build.__getobj__
  end

  def test_can_build_new_record_with_name
    assert_equal 'ylurnu', TestRepository.build(:name => 'unruly').name
  end

  def test_build_yields_to_block
    mock = MiniTest::Mock.new
    mock.expect :record, true, [Item.new]
    TestRepository.build do |item|
      mock.record item.__getobj__
    end
    mock.verify
  end
end