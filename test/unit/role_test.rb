require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RoleTest < ActiveSupport::TestCase
  test "creation" do
    assert_kind_of Role, Role.new
  end
end