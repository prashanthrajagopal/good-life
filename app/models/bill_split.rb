class BillSplit < ActiveRecord::Base
  attr_accessible :bill_id, :computed_amount, :group_id, :paid_amount, :pay_to, :user_id
  belongs_to :user
  belongs_to :bill  
  has_many :users
end
