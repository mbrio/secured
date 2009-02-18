# Application roles that determine security levels of users
class Role < ActiveRecord::Base
  cattr_accessor :name_regex, :name_within
  
  self.name_regex = /\A[[:alnum:]][[:alnum:]\.\-_@]*\z/
  self.name_within = 1..40
  
  belongs_to :application
  has_and_belongs_to_many :users
  
  validates_presence_of :application, :name
  
  validates_uniqueness_of :name, :scope => [:application_id]
  validates_length_of :name, :within => Role.name_within
  validates_format_of :name, :with => Role.name_regex
  
  named_scope :by_name, lambda { |name| { :conditions => { :name => name } } }
  named_scope :for_app, lambda { |application, name| { :conditions => { :name => name, :application_id => application }, :limit => 1 } }
  
  # Only allow safe accessors to be accessible
  # this will prevent mass assignement of protected
  # accessors through bogus forms
  attr_accessible :name
end