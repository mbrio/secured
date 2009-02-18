require File.join(File.dirname(__FILE__), 'boot') unless defined?(ActiveRecord)

module ModelDefaults
  def self.application
    { :name => 'a' }
  end
  
  def self.role
    app = Application.by_name("website").first
    
    { :name => 'a', :application => app }
  end
  
  def self.user
    app = Application.by_name("website").first
    role = app.roles.by_name("Users").first
    
    { :name => 'aaaaaa', :application => app, :roles => [ role ] }
  end
end