module Errol
  class Repository
    class << self
      def empty?
        count == 0
      end

      def count
        new.dataset.count
      end
    end
  end
end
