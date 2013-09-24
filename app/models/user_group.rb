class UserGroup < ActiveRecord::Base
  attr_accessible  :user, :group, :group_id, :user_id
  belongs_to :user
  belongs_to :group

  validates_uniqueness_of :user_id,    :scope => :group_id
  validates_uniqueness_of :group_id,    :scope => :user_id
end
