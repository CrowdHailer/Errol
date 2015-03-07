require_relative '../test_config'

class TestRepository < Errol::Repository

end

class RepositoryQueyTest < RecordTest
  def test_repository_starts_empty
    assert_equal true, TestRepository.empty?
  end
end
