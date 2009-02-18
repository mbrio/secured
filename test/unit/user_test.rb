require File.join(File.dirname(__FILE__), '..', 'test_helper')

class UserTest < ActiveSupport::TestCase
  test "creation" do
    assert_kind_of User, User.new
    
    user = User.new
    assert !user.save
  end
  
  test "query" do
    administrator = User.find_by_name("Administrator")
    assert_not_nil administrator
    
    assert_equal administrator.application.name, "website"
    assert_equal administrator.roles.length, 2
    
    assert_equal administrator.roles.first.name, "Administrators"
    assert_equal administrator.roles.last.name, "Users"
  end
end