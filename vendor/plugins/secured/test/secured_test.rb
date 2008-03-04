require'test_helper'

class SecuredTest < Test::Unit::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_not_secured
    @controller = SecuredController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_only
    @controller = SecuredOnlyController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_except
    @controller = SecuredExceptController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_multi
    @controller = SecuredMultiController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.error'
  end

  def test_guest
    @controller = SecuredGuestController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.error'
    
    get :c
    assert_response :success
    assert_select 'div.success'
  end
    
  def test_role
    @controller = SecuredRoleController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
    
    get :b
    assert_response :success
    assert_select 'div.error'
    
    get :c
    assert_response :success
    assert_select 'div.success'
  end
end
