require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    user_1 = users :one
    user_2 = users :user_9
    @relationship = Relationship.new(follower_id: user_1.id,
                                     followed_id: user_2.id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require a follower id' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a followed id' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
