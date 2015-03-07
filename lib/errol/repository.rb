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
    end

    def first
      dispatch(dataset.first)
    end
  end
end
