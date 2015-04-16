require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def mock_repo
      @mock_repo ||= MiniTest::Mock.new
    end

    def test_raises_informative_error_on_class_before_repository_set
      entity = Class.new Errol::Entity
      assert_raises Errol::Entity::RepositoryUndefined do
        entity.repository
      end
    end

    def test_raises_informative_error_on_instance_before_repository_set
      entity = Class.new Errol::Entity
      instance = entity.new :record
      assert_raises Errol::Entity::RepositoryUndefined do
        instance.repository
      end
    end

    def test_sets_repository_on_instance
      entity = Class.new Errol::Entity
      entity.repository = :repository
      instance = entity.new :record
      assert_equal :repository, instance.repository
    end

    def test_sets_repository_on_class
      entity = Class.new Errol::Entity
      entity.repository = :repository
      assert_equal :repository, entity.repository
    end

    def test_saves_self_to_repository
      entity = Class.new Errol::Entity
      mock = MiniTest::Mock.new
      entity.repository = mock
      instance = entity.new mock
      mock.expect :save, mock, [instance]
      instance.save
      mock_repo.verify
    end

  end
end
