require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class RoleNamedScopesTest < ActiveSupport::TestCase
  test "named scopes by_name" do
    assert_equal Role.by_name("Users").length, 2
    assert_equal Role.by_name("Users").first.name, "Users"
    
    assert_equal Role.by_name("a").length, 0
  end
  
  test "named scopes for_app" do
    app = Application.by_name("website").first

    assert_equal Role.for_app(app, "Users").length, 1
    assert_equal Role.for_app(app, "Users").first.name, "Users"
    
    assert_equal Role.for_app(app, "a").length, 0
  end
end