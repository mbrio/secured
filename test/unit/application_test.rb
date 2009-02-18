require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ApplicationTest < ActiveSupport::TestCase
  test "creation" do
    assert_kind_of Application, Application.new
    
    app = Application.new
    assert !app.save
    
    app.name = "test"
    assert app.save
  end
  
  test "query" do
    assert_not_nil Application.find_by_name("website")
  end
end