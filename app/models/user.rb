class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :user_groups_attributes, :invitation_token
  attr_accessible :role_ids, :as => :admin
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  has_many :user_groups, :dependent => :destroy
  has_many :groups, :through => :user_groups
  attr_accessible :user_groups

  has_and_belongs_to_many :bills
  has_many :bill_splits 

  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  before_create :set_invitation_limit
  after_create :add_user_to_group
  
  private 

  def set_invitation_limit
    self.invitation_limit = 5
  end

  def add_user_to_group
    user_id = self.id
    invitation = Invitation.where(:recipient_email => self.email).first
    if invitation.present?
      group = Group.where(:id => invitation.group_id).first
      group.user_groups.build(:user_id => user_id)
      group.save
    end
  end
end

