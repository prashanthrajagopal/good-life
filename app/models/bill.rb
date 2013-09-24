class Bill < ActiveRecord::Base
  attr_accessible :bill_date, :group_id, :purpose, :total, :user_id, :bill_splits_attributes
  belongs_to :groups
  belongs_to :users
  has_many :users
  has_many :bill_splits, :dependent => :destroy, :autosave => true
  validates_presence_of :purpose, :bill_date, :total

  serialize :users_list, Hash
  accepts_nested_attributes_for :bill_splits, :allow_destroy => true

  before_save :update_computed_amount

  private

  def update_computed_amount
	self.bill_splits.each do |bs|
		bs.computed_amount = (self.total / self.bill_splits.length) - bs.paid_amount
	end
  end
end
