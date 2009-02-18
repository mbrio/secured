class Application < ActiveRecord::Base
  has_many :users
  has_many :roles
  
  validates_presence_of :name
end