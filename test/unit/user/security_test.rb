require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class UserSecurityTest < ActiveSupport::TestCase  
  test "within roles" do
    app = Application.by_name("website").first
    
    admins = app.roles.by_name("Administrators").first
    users = app.roles.by_name("Users").first
    
    admin = app.users.by_name("Administrator").first
    user = app.users.by_name("User").first
    
    assert !admin.is_guest?
    assert !admin.is_in_roles?()

    assert admin.is_in_roles?(admins)
    assert admin.is_in_roles?(users)
    assert admin.is_in_roles?(admins, users)
    
    assert admin.is_in_roles?(:all, admins)
    assert admin.is_in_roles?(:all, users)
    assert admin.is_in_roles?(:all, admins, users)
    
    assert !user.is_guest?
    assert !user.is_in_roles?()

    assert !user.is_in_roles?(admins)
    assert user.is_in_roles?(users)
    assert user.is_in_roles?(admins, users)
    
    assert !user.is_in_roles?(:all, admins)
    assert user.is_in_roles?(:all, users)
    assert !user.is_in_roles?(:all, admins, users)
  end
end