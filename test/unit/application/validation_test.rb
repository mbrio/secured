require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class ApplicationValidationTest < ActiveSupport::TestCase
  test "validation name presence" do
    params = ModelDefaults.application
    name = params.delete(:name)
    
    # invalid presence
    app = Application.new(params)
    assert !app.save
  
    # invalid length min
    app.name = ''
    assert !app.save
  
    # invalid length max
    app.name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert !app.save
  
    # correct
    app.name = name
    assert app.save
  end

  test "validation name uniqueness" do
    params = ModelDefaults.application
    
    # correct
    app = Application.new(params)
    assert app.save
  
    # invalid uniqueness
    app = Application.new(params)
    assert !app.save
  end

  test "validation name format" do
    params = ModelDefaults.application
    name = params.delete(:name)
    
    # invalid character
    app = Application.new(params.merge({ :name => '!' }))
    assert !app.save
  
    # invalid starting character
    app.name = '@a'
    assert !app.save
  
    # correct
    app.name = 'a0.-_@'
    assert app.save
  
    # correct
    app = Application.new(params.merge({ :name => '0a.-_@' }))
    assert app.save
  end
end