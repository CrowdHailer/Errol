module Errol
  class Repository
    RecordAbsent = Class.new(StandardError)

    class << self
      def empty?
        count == 0
      end

      def count
        new.dataset.count
      end

      def first
        new.first
      end

      def last
        new.last
      end

      def [](id)
        new[id]
      end

      def fetch(id, &block)
        new.fetch(id, &block)
      end
    end

    def first
      _dispatch(dataset.first)
    end

    def last
      _dispatch(dataset.last)
    end

    def [](id)
      _dispatch(dataset.first(:id => id))
    end

    def fetch(id)
      item = _dispatch(dataset.first(:id => id))
      return item if item
      return yield id if block_given?
      record_absent(id)
    end

    private

    def _dispatch(item)
      dispatch(item) if item
    end

    def record_absent(id)
      raise RecordAbsent, "#{self.class.name} contains no record with id: #{id}"
    end
  end
end
