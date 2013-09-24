class Group < ActiveRecord::Base
  attr_accessible :description, :name
  attr_accessible :user_groups
  has_many :bills
  has_many :user_groups, :dependent => :destroy
  has_many :users, :through=>:user_groups
  validates :description, :name, :presence => true
  validates :name, :uniqueness => true
end
