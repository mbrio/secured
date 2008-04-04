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

require 'secured/security_error'
require 'secured/guest'
require 'secured/user'

# Used for securing an ActionController
module Secured
  # Called when the module is included on in a class.
  # Extends the secured ActionController class, and all
  # ActionView objects.
  class <<self
    def included(controller)
      # Extend the class methods
      controller.extend(ClassMethods)
    
      # include the view helpers into ActionView
      unless ActionView::Base.instance_methods.include? 'secured'
        ActionView::Base.class_eval { include ViewHelpers }
      end
    end
  end

  # These methods will be available to all ActionView
  # classes/instances
  module ViewHelpers
    # Retrieves whether a user is authorized
    def authorized?(options={})
      # Pass the user and roles to secure_me
      self.controller.secure_me(@user, options) { return true }
    end
    
    def secured(options={}, &block)
      # Pass the user and roles to secure_me
      self.controller.secure_me(@user, options) { yield }
    end
  end

  # These methods will be available to the secured controller
  module ClassMethods
    # Secures specific actions of the controller
    def secured(options={})
      filter_opts = { :only => options[:only], :except => options[:except] }

      # checks the security of the controller's action
      before_filter(filter_opts) do |controller|
        controller.check_security(options)
      end
    end
  end

  # Retrieves whether a user is authorized
  def authorized?(options={})
    # Pass the user and roles to secure_me
    self.secure_me(@user, options) { return true }
  end
    
  # Allows for specific bits of code to be secured
  def secured(options={}, &block)
    # Pass the user and roles to secure_me
    self.secure_me(@user, options) { yield }
  end
  
  # Runs secure_me on the user and passes the authorized
  # roles
  def check_security(options={})
    # Pass the user and roles to secure_me
    self.secure_me(@user, options) { return }
    
    raise Secured::SecurityError
  end

  # Checks to see if a user is not a guest and is within
  # the authorized roles
  def secure_me(user, options, &block)
    roles = option_to_array(options[:for_roles])

    if roles.empty?
      yield if !user.guest?
    else
      yield if user.is_in_role?(roles)
    end
  end
  
protected

  def option_to_array(options)
    arr = options || []
    arr = [arr] unless arr.is_a?(Array)
    
    arr
  end
end