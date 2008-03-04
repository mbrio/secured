module Secured
  class SecurityError < StandardError
  end
  
  class Guest
    def guest?
      true
    end
    
    def is_in_role?(roles)
      false
    end
  end
  
  def self.included(controller)
    controller.extend(ClassMethods)
  end
  
  module ClassMethods
    def secured(options={})
      filter_opts = { :only => options[:only], :except => options[:except] }

      before_filter(filter_opts) do |c|
        c.send! :check_security, options
      end
    end
  end
  
private
  def check_security(options={})
    roles = options[:for_roles] || []
    roles = [roles] unless roles.is_a?(Array)
    
    # If a user is supplied and the roles have been left empty,
    # we need to be sure only that the user is not a guest
    if @user && roles.empty?
      if @user.respond_to?(:guest?) && !@user.guest?
        return
      end
      
    # If a user is supplied and the roles nave not been left empty,
    # we need to be sure the user is within one of the roles
    # supplied
    elsif @user && !roles.empty?
      if @user.respond_to?(:is_in_role?) && @user.is_in_role?(roles)
        return
      end
    end
    
    raise SecurityError
  end
end