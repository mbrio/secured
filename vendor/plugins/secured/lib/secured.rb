module Secured
  def self.included(controller)
    controller.extend(ClassMethods)
    controller.before_filter(:check_security)
  end
  
  module ClassMethods
    def secured(options={})
      only = options[:only] || nil
      except = options[:except] || nil
      
      write_inheritable_hash(:security_options, {:only => only, :except => except})
    end
  end
  
private
  def check_security
    options = self.class.read_inheritable_attribute(:security_options)
    
    return if options.nil?
    
    if options[:only]
      raise 'only' if options[:only].include?(action_name.to_sym)
    elsif options[:except]
      raise 'except' if !options[:except].include?(action_name.to_sym)
    else
      raise 'all secured'
    end
  end
end