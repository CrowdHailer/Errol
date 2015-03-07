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
        new.dataset.first
      end
    end
  end
end
