# A registered user
class User < ActiveRecord::Base
  cattr_accessor :name_regex, :name_within, :email_regex, :email_within
  
  self.name_regex = /\A[[:alnum:]][[:alnum:]\.\-_@]*\z/
  self.name_within = 6..40
  
  self.email_regex = Secured::Specifications.email
  self.email_within = 5..255
  
  belongs_to :application
  has_and_belongs_to_many :roles
  
  validates_presence_of :application, :roles, :name, :email
  
  validates_uniqueness_of :name, :scope => [:application_id]
  validates_length_of :name, :within => User.name_within
  validates_format_of :name, :with => User.name_regex
  
  validates_uniqueness_of :email, :scope => [:application_id]
  validates_length_of :email, :within => User.email_within
  validates_format_of :email, :with => User.email_regex
  
  named_scope :by_name, lambda { |name| { :conditions => { :name => name } } }
  named_scope :for_app, lambda { |application, name| { :conditions => { :name => name, :application_id => application }, :limit => 1 } }
  
  # Only allow safe accessors to be accessible this will prevent mass
  # assignement of protected accessors through bogus forms
  attr_accessible :name, :email

  # Determines whether the user is a guest
  #
  # This will always be true  
  def is_guest?;false;end

  # Checks to see whether the user is part of any or all of the roles
  # specified.
  #
  # Options:
  #   :all specifies whether the user must be part of all of the roles
  #
  # Examples:
  #
  #   user.is_in_roles?(admins)
  #   user.is_in_roles?(admins, users)  
  #   user.is_in_roles?(:all, admins)
  #   user.is_in_roles?(:all, admins, users)
  def is_in_roles?(*args)
    role_list = args.first.eql?(:all) ? args[1..-1] : args
    shared_roles = (roles & role_list)
    
    args.first.eql?(:all) ? shared_roles.length == role_list.length : shared_roles.length > 0
  end
end