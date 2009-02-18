require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class RoleValidationTest < ActiveSupport::TestCase
  test "validation name presence" do
    params = ModelDefaults.role
    name = params.delete(:name)
    
    # invalid presence
    role = Role.new(params)
    assert !role.save
  
    # invalid length min
    role.name = ''
    assert !role.save
  
    # invalid length max
    role.name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert !role.save
  
    # correct
    role.name = name
    assert role.save
  end
  
  test "validation application presence" do
    params = ModelDefaults.role
    app = params.delete(:application)
    
    role = Role.new(params)
    assert !role.save
    
    role.application = app
    assert role.save
  end

  test "validation name uniqueness" do
    params = ModelDefaults.role
    other = Application.by_name("other").first    
    
    # correct
    role = Role.new(params)
    assert role.save
  
    # invalid uniqueness
    role = Role.new(params)
    assert !role.save
    
    # correct
    role = Role.new(params.merge!({ :application => other }))
    assert role.save
    
    # invalid uniqueness
    role = Role.new(params)
    assert !role.save
  end

  test "validation name format" do
    params = ModelDefaults.role
    name = params.delete(:name)
    
    # invalid character
    role = Role.new(params.merge({ :name => '!' }))
    assert !role.save
  
    # invalid starting character
    role.name = '@a'
    assert !role.save
  
    # correct
    role.name = 'a0.-_@'
    assert role.save
  
    # correct
    role = Role.new(params.merge({ :name => '0a.-_@' }))
    assert role.save
  end
end