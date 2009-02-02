# Secured is a rails plugin that adds role based access priviledges
# to control actions
#
# Copyright (C) 2008-2009 Michael Diolosa <michael.diolosa@me.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author:: Michael Diolosa (mailto:michael.diolosa@me.com)
# Copyright:: Copyright (C) 2008-2009 Michael Diolosa <michael.diolosa@me.com>
# License:: Distributes under the AGPL

require File.join(File.dirname(__FILE__), '/../test_helper')

class SecuredTest < Test::Unit::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_not_secured
    @controller = Test::SecuredController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_only
    @controller = Test::SecuredOnlyController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_except
    @controller = Test::SecuredExceptController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_multi
    @controller = Test::SecuredMultiController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.error'
  end
  
  def test_guest
    @controller = Test::SecuredGuestController.new
    
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
    @controller = Test::SecuredRoleController.new
    
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
  
  def test_view_helpers
    @controller = Test::SecuredRoleController.new
    
    get :d
    assert_response :success
    assert_select 'div.users'
    assert_select 'div', :count => 1
  end
  
  def test_user_many_roles
    @controller = Test::SecuredUserManyRolesController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
    
    get :b
    assert_response :success
    assert_select 'div.success'
    
    get :c
    assert_response :success
    assert_select 'div.error'
  end

  def test_user_role_array
    @controller = Test::SecuredRoleArrayController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
    
    get :b
    assert_response :success
    assert_select 'div.success'
    
    get :c
    assert_response :success
    assert_select 'div.success'
  end
    
  def test_user_many_roles_array
    @controller = Test::SecuredUserManyRolesArrayController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
    
    get :b
    assert_response :success
    assert_select 'div.success'
    
    get :c
    assert_response :success
    assert_select 'div.success'
  end
  
  def test_user_no_roles
    @controller = Test::SecuredUserNoRolesController.new
    
    get :a
    assert_response :success
    assert_select 'div.error'
    
    get :b
    assert_response :success
    assert_select 'div.error'
    
    get :c
    assert_response :success
    assert_select 'div.error'
  end
  
  def test_user_custom_roles
    @controller = Test::SecuredUserCustomRolesController.new
    
    get :a
    assert_response :success
    assert_select 'div.success'
    
    get :b
    assert_response :success
    assert_select 'div.success'
    
    get :c
    assert_response :success
    assert_select 'div.success'
  end

  def test_secured_format
    @controller = Test::SecuredFormat.new
    
    get :a, :format => 'xml'
    assert_response :unauthorized
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    get :a, :format => 'html'
    assert_response :success
    assert_select 'div.success'

    get :b
    assert_response :success
    assert_select 'div.success'

    get :c
    assert_response :success
    assert_select 'div.success'
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    get :c, :format => 'xml'
    assert_response :success
    assert_select 'div.success'
    

    @controller = Test::SecuredGuestFormat.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    get :c
    assert_response :success
    assert_select 'div.success'
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    get :c, :format => 'xml'
    assert_response :unauthorized
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    get :c, :format => 'html'
    assert_response :success
    assert_select 'div.success'
    
    @controller = Test::SecuredFormat.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    get :d, :format => 'xml'
    assert_response :unauthorized
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    get :e, :format => 'html'
    assert_response :ok
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    get :e, :format => 'xml'
    assert_response :unauthorized
  end

  def test_secured_code
    @controller = Test::SecuredCode.new

    get :a
    assert_response :success
    assert_select 'div.success', /special permission/

    get :b
    assert_response :success
    assert_select 'div.success', /the permissions/

    get :c
    assert_response :success
    assert_select 'div.success'
  end
end
