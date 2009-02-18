class User < ActiveRecord::Base
  cattr_accessor :name_regex, :name_within
  
  self.name_regex = /\A[[:alnum:]][[:alnum:]\.\-_@]*\z/
  self.name_within = 6..40
  
  belongs_to :application
  has_and_belongs_to_many :roles
  
  validates_presence_of :application, :roles, :name
  validates_uniqueness_of :name, :scope => [:application_id]
  validates_length_of :name, :within => User.name_within
  validates_format_of :name, :with => User.name_regex
  
  named_scope :by_name, lambda { |name| { :conditions => { :name => name } } }
  named_scope :for_app, lambda { |application, name| { :conditions => { :name => name, :application_id => application }, :limit => 1 } }
end