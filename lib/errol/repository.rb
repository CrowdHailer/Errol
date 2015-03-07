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
      _dispatch(dataset.first)
    end

    def last
      _dispatch(dataset.last)
    end

    def [](id)
      _dispatch(dataset.first(:id => id))
    end

    def fetch(id)
      _dispatch(dataset.first(:id => id))
    end

    private
    def _dispatch(item)
      dispatch(item) if item
    end
  end
end
