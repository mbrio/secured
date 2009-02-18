require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class UserValidationTest < ActiveSupport::TestCase  
  test "validation name presence" do
    params = ModelDefaults.user
    app = params.delete(:application)
    roles = params.delete(:roles)
    name = params.delete(:name)
    
    # invalid presence
    user = User.new(params) do |u|
      u.application = app
      u.roles = roles
    end
    assert !user.save
  
    # invalid length min
    user.name = ''
    assert !user.save
  
    # invalid length max
    user.name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert !user.save
  
    # invalid length min
    user.name = "aaaaa"
    assert !user.save
    
    # correct
    user.name = name
    assert user.save
  end
  
  test "validation application presence" do
    params = ModelDefaults.user
    app = params.delete(:application)
    roles = params.delete(:roles)
    
    user = User.new(params) do |u|
      u.roles = roles
    end
    assert !user.save
    
    user.application = app
    assert user.save
  end
  
  test "validation role presence" do
    params = ModelDefaults.user
    app = params.delete(:application)
    roles = params.delete(:roles)
    
    user = User.new(params) do |u|
      u.application = app
    end
    assert !user.save
    
    user.roles = roles
    assert user.save
  end
  
  test "validation name uniqueness" do
    params = ModelDefaults.user
    app = params.delete(:application)
    roles = params.delete(:roles)
    other = Application.by_name("other").first    
    
    # correct
    user = User.new(params) do |u|
      u.application = app
      u.roles = roles
    end
    assert user.save
  
    # invalid uniqueness
    user = User.new(params) do |u|
      u.application = app
      u.roles = roles
    end
    assert !user.save
    
    # correct
    user = User.new(params) do |u|
      u.application = other
      u.roles = roles
    end
    assert user.save
    
    # invalid uniqueness
    user = User.new(params) do |u|
      u.application = other
      u.roles = roles
    end
    assert !user.save
  end
  
  test "validation name format" do
    params = ModelDefaults.user
    app = params.delete(:application)
    roles = params.delete(:roles)
    name = params.delete(:name)
    
    # invalid character
    user = User.new(params.merge({ :name => '!a0.-_' })) do |u|
      u.application = app
      u.roles = roles
    end
    assert !user.save
  
    # invalid starting character
    user.name = '@a0.-_'
    assert !user.save
  
    # correct
    user.name = 'a0.-_@'
    assert user.save
  
    # correct
    user = User.new(params.merge({ :name => '0a.-_@', :email => 'example2@example.com' })) do |u|
      u.application = app
      u.roles = roles
    end
    assert user.save
  end
end