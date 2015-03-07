require_relative '../test_config'

class Item < Sequel::Model(:items)

end

class TestRepository < Errol::Repository
  def dataset
    # TODO this returns items
    Item.dataset
    # This returns hashes
    # items = DB['items']
  end
end


class RepositoryQueyTest < RecordTest
  def items
    DB[:items]
  end

  def test_repository_starts_empty
    assert_equal true, TestRepository.empty?
  end

  def test_repository_starts_with_count_zero
    assert_equal 0, TestRepository.count
  end

  def test_respository_counts_one_item
    items.insert(:name => 'abc')
    assert_equal 1, TestRepository.count
  end

  def test_repository_not_empty_with_item
    items.insert(:name => 'abc')
    assert_equal false, TestRepository.empty?
  end

  def test_can_get_first_item
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.first
  end

end
