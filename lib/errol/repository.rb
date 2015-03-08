module Errol
  class Repository
    RecordAbsent = Class.new(StandardError)

    class << self
      def build(entries={})
        entity = dispatch(record_class.new)
        entries.each do |attribute, value|
          entity.public_send "#{attribute}=", value
        end
        yield entity if block_given?
        entity
      end

      def create(*arguments, &block)
        build(*arguments, &block).tap(&method(:save))
      end

      def save(entity)
        receive(entity).save
        self
      end

      def remove(entity)
        begin
          receive(entity).destroy
        rescue Sequel::NoExistingObject
          raise RecordAbsent
        end
        self
      end

      def empty?(requirements={})
        count(requirements) == 0
      end

      def count(requirements={})
        new(requirements, false).count
      end

      def first(requirements={})
        new(requirements, false).first
      end

      def last(requirements={})
        new(requirements).last
      end

      def [](id, requirements={})
        new(requirements)[id]
      end

      def fetch(id, requirements={}, &block)
        new(requirements).fetch(id, &block)
      end

      def all(requirements={})
        new(requirements, false).all
      end

      def raw_dataset
        record_class.dataset
      end
    end

    def initialize(requirements={}, paginate=true)
      @requirements = requirements
      @inquiry = self.class.inquiry(requirements)
      @paginate = paginate
    end

    def current_page
      paginated_dataset.current_page
    end

    # delegate( #:page_size,
    #         #  :page_count,
    #          :current_page,
    #         #  :first_page?,
    #         #  :last_page?,
    #         #  :next_page,
    #         #  :prev_page,
    #         #  :page_range,
    #          :to => :records_page)

    attr_reader :inquiry

    def count
      dataset.count
    end

    def first
      if paginate?
        dispatch(paginated_dataset.first)
      else
        dispatch(dataset.first)
      end
    end

    def last
      dispatch(dataset.last)
    end

    def [](id)
      dispatch(dataset.first(:id => id))
    end

    def fetch(id)
      item = dispatch(dataset.first(:id => id))
      return item if item
      return yield id if block_given?
      record_absent(id)
    end

    def all
      if paginate?
        paginated_dataset.map { |record| dispatch(record) }
      else
        dataset.map { |record| dispatch(record) }
      end
    end

    def raw_dataset
      self.class.raw_dataset
    end

    def paginate?
      @paginate
    end

    private

    def dispatch(item)
      self.class.dispatch(item) if item
    end

    def record_absent(id)
      raise RecordAbsent, "#{self.class.name} contains no record with id: #{id}"
    end

    def paginated_dataset
      dataset.paginate(inquiry.page.to_i, inquiry.page_size.to_i)
    end
  end
end
