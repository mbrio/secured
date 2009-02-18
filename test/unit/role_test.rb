require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RoleTest < ActiveSupport::TestCase
  test "creation" do
    assert_kind_of Role, Role.new
    
    role = Role.new
    assert !role.save
    
    role.name = "test"
    assert !role.save
  end
  
  test "query" do
    administrators = Role.find_by_name("Administrators")
    assert_not_nil administrators
    
    assert_equal administrators.application.name, "website"
  end
end