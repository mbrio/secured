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

class Test::Guest
  include Secured::Guest
end

class Test::User
  include Secured::User
  attr_accessor :role
end

class Test::UserManyRoles
  include Secured::User
  attr_accessor :roles
end

class Test::UserNoRoles
  include Secured::User
end

class Test::UserCustomRoles
  include Secured::User
  
  def is_in_role?(role_list)
    return true
  end
end

class Test::SecuredController < ActionController::Base
  before_filter :initialize_user
    
  def initialize_user
    @user = Test::Guest.new
  end
  
  def rescue_action(exception)
    if exception.is_a?(Secured::SecurityError)
      render :inline => %{ <div class="error">You do not have the permissions to view this page</div>
                           <div class="flash">#{flash[:notice]}</div> }
    else
      raise exception
    end
  end
  
  def a
    render :inline => %{ <div class="success">You have the permissions to view this page</div>
                         <div class="flash">#{flash[:notice]}</div> }
  end
  
  def b
    render :inline => %{ <div class="success">You have the permissions to view this page</div>
                         <div class="flash">#{flash[:notice]}</div> }
  end

  def c
   render :inline => %{ <div class="success">You have the permissions to view this page</div>
                        <div class="flash">#{flash[:notice]}</div> }
  end
  
  def d
    render :inline => %{ <% secured(:for_roles => :administrators) do %><div class="administration">Only administrators can see this</div><% end %>
                         <% secured(:for_roles => :users) do %><div class="users">Only users can see this</div><% end %> }
  end
end

class Test::SecuredOnlyController < Test::SecuredController
  include Secured
  
  secured :only => [:a]
end

class Test::SecuredExceptController < Test::SecuredController
  include Secured
  
  secured :except => [:b]
end

class Test::SecuredMultiController < Test::SecuredController
  include Secured

  secured :except => [:b]  
  secured :only => [:b]
end

class Test::SecuredGuestController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a
  secured :only => :b, :for_roles => :administrators
  
  def initialize_user
    @user = Test::Guest.new
  end
end

class Test::SecuredRoleController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :users
  secured :only => :b, :for_roles => :administrators
  
  def initialize_user
    @user = Test::User.new
    @user.role = :users
  end
end

class Test::SecuredRoleArrayController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => [ :a, :b ], :for_roles => [ :users, :administrators ]
  
  def initialize_user
    @user = Test::User.new
    @user.role = :users
  end
end

class Test::SecuredUserManyRolesController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :users
  secured :only => :b, :for_roles => :administrators
  secured :only => :c, :for_roles => :editors
  
  def initialize_user
    @user = Test::UserManyRoles.new
    @user.roles = [:users, :administrators]
  end
end

class Test::SecuredUserManyRolesArrayController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => [ :a, :b, :c ], :for_roles => [ :users, :administrators, :editors ]
  
  def initialize_user
    @user = Test::UserManyRoles.new
    @user.roles = [ :users, :administrators ]
  end
end

class Test::SecuredUserNoRolesController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :users
  secured :only => :b, :for_roles => :administrators
  secured :only => :c, :for_roles => :editors
  
  def initialize_user
    @user = Test::UserNoRoles.new
  end
end

class Test::SecuredUserCustomRolesController < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :users
  secured :only => :b, :for_roles => :administrators
  secured :only => :c, :for_roles => :editors
  
  def initialize_user
    @user = Test::UserCustomRoles.new
  end
end

class Test::SecuredGuestFormat < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :users, :for_formats => :xml
  secured :only => :b, :for_roles => :administrators
  secured :only => :c, :for_formats => :xml
  
  def initialize_user
    @user = Test::Guest.new
  end
  
  def a    
    respond_to do |format|
      format.html do
        render :inline => %{ <div class="success">You have the permissions to view this page</div>
                             <div class="flash">#{flash[:notice]}</div> }
      end
      
      format.xml do
        render :xml => "<data><success>You have the permissions to view this page</success><notice>#{flash[:notice]}</notice></data>"
      end
    end
  end
end

class Test::SecuredFormat < Test::SecuredController
  include Secured

  before_filter :initialize_user
  secured :only => :a, :for_roles => :users, :for_formats => :xml
  secured :only => :b, :for_roles => :administrators
  secured :only => :c, :for_formats => :xml
  secured :only => :d, :for_roles => :users, :for_formats => :xml, :handler => :xml_unauthorized
  secured :only => :e, :for_roles => :users, :for_formats => :xml, :status_only => true
  
  def initialize_user
    @user = Test::User.new
    @user.role = :administrators
  end
  
  def xml_unauthorized
    head :unauthorized
  end
  
  def a    
    respond_to do |format|
      format.html do
        render :inline => %{ <div class="success">You have the permissions to view this page</div>
                             <div class="flash">#{flash[:notice]}</div> }
      end
      
      format.xml do
        render :xml => "<data><success>You have the permissions to view this page</success><notice>#{flash[:notice]}</notice></data>"
      end
    end
  end
  
  def e
    respond_to do |format|
      format.html do
        render :inline => %{ <div class="success">You have the permissions to view this page</div>
                             <div class="flash">#{flash[:notice]}</div> }
      end
      
      format.xml do
        render :xml => "<data><success>You have the permissions to view this page</success><notice>#{flash[:notice]}</notice></data>"
      end
    end
  end
end

class Test::SecuredCode < Test::SecuredController
  include Secured

  before_filter :initialize_user
  
  def initialize_user
    @user = Test::UserManyRoles.new
    @user.roles = [:users]
  end
  
  def a
    secured(:for_roles => [:users]) do
      render :inline => %{ <div class="success">You have special permission to view this page</div>
                           <div class="flash">#{flash[:notice]}</div> } and return
    end
    
    render :inline => %{ <div class="success">You have the permissions to view this page</div>
                         <div class="flash">#{flash[:notice]}</div> }
  end
  
  def b
    if authorized?(:for_roles => [:administrators])
      render :inline => %{ <div class="success">You have special permission to view this page</div>
                           <div class="flash">#{flash[:notice]}</div> }
    else    
      render :inline => %{ <div class="success">You have the permissions to view this page</div>
                           <div class="flash">#{flash[:notice]}</div> }
    end
  end
end