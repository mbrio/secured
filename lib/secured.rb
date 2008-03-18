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

module Secured
  def self.included(controller)
    controller.extend(ClassMethods)
    
    unless ActionView::Base.instance_methods.include? 'secured'
      ActionView::Base.class_eval { include ViewHelpers }
    end
  end

  module ViewHelpers
    def secured(options={}, &block)
      roles = options[:for_roles] || []
      roles = [roles] unless roles.is_a?(Array)

      self.controller.class.secure_me(@user, roles) { yield }
    end
  end

  module ClassMethods
    def secured(options={})
      filter_opts = { :only => options[:only], :except => options[:except] }

      before_filter(filter_opts) do |controller|
        controller.check_security(options)
      end
    end

    def secure_me(user, roles, &block)
      if roles.empty?
        yield if !user.guest?
      else
        yield if user.is_in_role?(roles)
      end
    end
  end

  def check_security(options={})
    roles = options[:for_roles] || []
    roles = [roles] unless roles.is_a?(Array)

    self.class.secure_me(@user, roles) { return }

    raise Secured::SecurityError
  end
end