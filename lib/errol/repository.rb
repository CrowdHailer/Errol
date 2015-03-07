module Errol
  class Repository
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

      def fetch(id)
        new.fetch(id)
      end
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
      dispatch(dataset.first(:id => id))
    end
  end
end
