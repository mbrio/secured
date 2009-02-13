class User < ActiveRecord::Base
  belongs_to :application
  has_and_belongs_to_many :roles
end