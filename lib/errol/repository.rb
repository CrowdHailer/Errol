module Errol
  class Repository
    RecordAbsent = Class.new(StandardError)

    class << self
      def empty?(requirements={})
        count(requirements) == 0
      end

      def count(requirements={})
        new(requirements).count
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

      def all
        new.all
      end
    end

    def initialize(requirements={})
      @requirements = requirements
    end

    def count
      dataset.count
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

    def all
      dataset.map { |record| _dispatch(record) }
    end

    private

    def _dispatch(item)
      dispatch(item) if item
    end

    def record_absent(id)
      raise RecordAbsent, "#{self.class.name} contains no record with id: #{id}"
    end

    def requirements
      @requirements
    end
  end
end
