require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def mock_repo
      @mock_repo ||= MiniTest::Mock.new
    end
  end
end
