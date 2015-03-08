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
        new(requirements).count
      end

      def first(requirements={})
        new(requirements).first
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
        new(requirements).all
      end

      def raw_dataset
        record_class.dataset
      end
    end

    def initialize(requirements={})
      @requirements = requirements
      @inquiry = self.class.inquiry(requirements)
    end

    attr_reader :inquiry

    def count
      dataset.count
    end

    def first
      dispatch(dataset.first)
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
      dataset.map { |record| dispatch(record) }
    end

    def raw_dataset
      self.class.raw_dataset
    end

    private

    def dispatch(item)
      self.class.dispatch(item) if item
    end

    def record_absent(id)
      raise RecordAbsent, "#{self.class.name} contains no record with id: #{id}"
    end
  end
end
