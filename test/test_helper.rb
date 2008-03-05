# Secured is a rails plugin that adds role based access priviledges
# to control actions
#
# Copyright (C) 2008 Michael Diolosa <michael.diolosa@gmail.com>
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
# Author:: Michael Diolosa (mailto:michael.diolosa@gmail.com)
# Copyright:: Copyright (C) 2008 Michael Diolosa <michael.diolosa@gmail.com>
# License:: Distributes under the AGPL

require 'test/unit'
require File.join(File.dirname(__FILE__), '/boot')
require 'action_controller'
require 'action_controller/test_process'

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

class User
  attr_accessor :role
  
  def guest?
    false
  end
  
  def is_in_role?(roles)
    roles = roles || []
    roles = [roles] unless roles.is_a?(Array)
    
    return true if role && roles.include?(role)
    false
  end
end

class SecuredController < ActionController::Base
  include Secured
  
  def rescue_action(exception)
    if exception.is_a?(Secured::SecurityError)
      render :text => %{ <div class="error">You do not have the permissions to view this page</div>
                         <div class="flash">#{flash[:notice]}</div> }
    end
  end
  
  def a
    render :text => %{ <div class="success">You have the permissions to view this page</div>
                       <div class="flash">#{flash[:notice]}</div> }
  end
  
  def b
    render :text => %{ <div class="success">You have the permissions to view this page</div>
                       <div class="flash">#{flash[:notice]}</div> }
  end

  def c
   render :text => %{ <div class="success">You have the permissions to view this page</div>
                      <div class="flash">#{flash[:notice]}</div> }
 end
end

class SecuredOnlyController < SecuredController
  include Secured
  
  secured :only => [:a]
end

class SecuredExceptController < SecuredController
  include Secured
  
  secured :except => [:b]
end

class SecuredMultiController < SecuredController
  include Secured

  secured :except => [:b]  
  secured :only => [:b]
end

class SecuredGuestController < SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a
  secured :only => :b, :for_roles => :administrator
  
  def initialize_user
    @user = Guest.new
  end
end

class SecuredRoleController < SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :user
  secured :only => :b, :for_roles => :administrator
  
  def initialize_user
    @user = User.new
    @user.role = :user
  end
end