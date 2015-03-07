require_relative '../test_config'

class TestRepository < Errol::Repository

end

class RepositoryQueyTest < RecordTest
  def test_repository_starts_empty
    assert_equal true, TestRepository.empty?
  end

  def test_repository_starts_with_count_zero
    assert_equal 0, TestRepository.count
  end
end
