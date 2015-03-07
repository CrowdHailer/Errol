require_relative '../test_config'

class Item < Sequel::Model(:items)
end

class Inquiry
  def initialize(requirements={})
    @requirements = requirements
  end

  def show_offers?
    @requirements[:show_offers]
  end
end

class TestRepository < Errol::Repository
  def dataset
    # TODO this returns items
    dataset = Item.dataset
    # This returns hashes
    # items = DB['items']

    inquiry.show_offers? ? dataset.where(:discounted) : dataset

  end

  def inquiry
    Inquiry.new(requirements)
  end

  def dispatch(record)
    SimpleDelegator.new record
  end
end


class RepositoryQueyTest < RecordTest
  def items
    DB[:items]
  end

  def test_repository_starts_empty
    assert_equal true, TestRepository.empty?
  end

  def test_repository_not_empty_with_item
    items.insert(:name => 'abc')
    assert_equal false, TestRepository.empty?
  end

  def test_filtered_repository_is_empty
    items.insert(:name => 'abc', :discounted => false)
    assert_equal true, TestRepository.empty?(:show_offers => true)
  end

  def test_repository_starts_with_count_zero
    assert_equal 0, TestRepository.count
  end

  def test_respository_counts_one_item
    items.insert(:name => 'abc')
    assert_equal 1, TestRepository.count
  end

  def test_filtered_repository_counts_zero_items
    items.insert(:name => 'abc', :discounted => false)
    assert_equal 0, TestRepository.count(:show_offers => true)
  end

  def test_can_get_first_item
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.first.__getobj__
  end

  def test_wraps_first_item
    items.insert(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository.first.class
  end

  def test_returns_nil_for_no_first_item
    assert_nil TestRepository.first
  end

  def test_can_get_last_item
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.last.__getobj__
  end

  def test_wraps_last_item
    items.insert(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository.last.class
  end

  def test_returns_nil_for_no_last_item
    assert_nil TestRepository.last
  end

  def test_can_find_item_by_id
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository[item.id].__getobj__
  end

  def test_wraps_found_item
    item = Item.create(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository[item.id].class
  end

  def test_returns_nil_for_no_found_item
    assert_nil TestRepository[2]
  end

  def test_can_fetch_item_by_id
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.fetch(item.id).__getobj__
  end

  def test_wraps_fetched_item
    item = Item.create(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository.fetch(item.id).class
  end

  def test_raises_error_for_no_fetched_item
    err = assert_raises Errol::Repository::RecordAbsent do
      TestRepository.fetch(2)
    end
    assert_equal 'TestRepository contains no record with id: 2', err.message
  end

  def test_fetch_calls_block_for_missing_item
    mock = MiniTest::Mock.new
    mock.expect :record, true, [2]
    TestRepository.fetch(2) { |id| mock.record id }
  end

  def test_returns_all_items
    item = Item.create(:name => 'abc')
    assert_equal [item], TestRepository.all.map(&:__getobj__)
  end

  def test_wraps_all_items
    item = Item.create(:name => 'abc')
    assert_equal [SimpleDelegator], TestRepository.all.map(&:class)
  end

end
