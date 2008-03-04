require 'rubygems'
require 'action_controller'
require 'action_controller/test_process'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/secured'

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