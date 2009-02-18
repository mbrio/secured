class Application < ActiveRecord::Base
  cattr_accessor :name_regex, :name_within
  
  self.name_regex = /\A[[:alnum:]][[:alnum:]\.\-_@]*\z/
  self.name_within = 1..40
  
  has_many :users
  has_many :roles
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :within => Application.name_within
  validates_format_of :name, :with => Application.name_regex
  
  named_scope :by_name, lambda { |name| { :conditions => { :name => name }, :limit => 1 } }
end