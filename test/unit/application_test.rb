require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ApplicationTest < ActiveSupport::TestCase
  test "creation" do
    assert_kind_of Application, Application.new
  end
end