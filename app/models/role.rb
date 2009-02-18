class Role < ActiveRecord::Base
  belongs_to :application
  has_and_belongs_to_many :users
  
  validates_presence_of :application, :name
end