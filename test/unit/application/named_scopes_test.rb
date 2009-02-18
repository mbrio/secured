require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class ApplicationNamedScopesTest < ActiveSupport::TestCase
  test "named scopes by_name" do
    assert_equal Application.by_name("website").length, 1
    assert_equal Application.by_name("website").first.name, "website"
    
    assert_equal Application.by_name("a").length, 0
  end
end