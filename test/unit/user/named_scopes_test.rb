require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class UserNamedScopesTest < ActiveSupport::TestCase
  test "named scopes by_name" do
    assert_equal User.by_name("Administrator").length, 2
    assert_equal User.by_name("Administrator").first.name, "Administrator"
    
    assert_equal User.by_name("a").length, 0
  end
  
  test "named scopes for_app" do
    app = Application.by_name("website").first
  
    assert_equal User.for_app(app, "Administrator").length, 1
    assert_equal User.for_app(app, "Administrator").first.name, "Administrator"
    
    assert_equal User.for_app(app, "a").length, 0
  end
end