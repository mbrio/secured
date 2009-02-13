require File.join(File.dirname(__FILE__), '..', 'test_helper')

class UserTest < ActiveSupport::TestCase
  test "creation" do
    assert_kind_of User, User.new
  end
end