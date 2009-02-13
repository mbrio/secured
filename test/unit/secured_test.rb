require File.join(File.dirname(__FILE__), '..', 'test_helper')

class SecuredTest < ActiveSupport::TestCase
  test "something" do
    assert_kind_of Application, Application.new  
    assert_kind_of User, User.new
    assert_kind_of Role, Role.new
    
    assert_equal User.find(:all).length, 0
    
    user = User.new :name => 'michael'
    assert user.save
    
    assert_equal User.find(:all).length, 1
    
    user.destroy
    
    assert_equal User.find(:all).length, 0
  end
end