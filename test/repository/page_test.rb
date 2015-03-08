require_relative '../test_config'
require_relative './query_test'

class DemoInquiry < Errol::Inquiry
  default :page, 1
  default :page_size, 2
end

class DemoRepository < Errol::Repository
  def self.record_class
    Item
  end

  def dataset
    # TODO this returns items
    dataset = raw_dataset
    # This returns hashes
    # items = DB['items']

    # inquiry.show_offers? ? dataset.where(:discounted) : dataset

  end

  def self.inquiry(requirements)
    DemoInquiry.new(requirements)
  end

  def self.dispatch(record)
    SimpleDelegator.new record
  end

  def self.receive(entity)
    entity.__getobj__
  end
end

class DemoRepositoryQueyTest < RecordTest
  def items
    DB[:items]
  end

  def first
    @first ||= items.insert({})
  end

  def second
    @second ||= items.insert({})
  end

  def third
    @third ||= items.insert({})
  end

  def fourth
    @fourth ||= items.insert({})
  end

  def setup
    first
    second
    third
    fourth
  end

  def teardown
    @first = nil
    @second = nil
    @third = nil
    @fourth = nil
  end

  def test_can_get_first_page
    page = DemoRepository.new
    assert_equal 1, page.current_page
  end

  def test_can_get_second_page
    page = DemoRepository.new :page => 2
    assert_equal 2, page.current_page
  end

  def test_can_get_all_items_on_second_page
    page = DemoRepository.new :page => 2
    assert_equal [third, fourth], page.all.map{ |entity| entity.id }
  end

  def test_can_get_first_item_on_second_page
    page = DemoRepository.new :page => 2
    assert_equal third, page.first.id
  end
end
