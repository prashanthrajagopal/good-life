class InvitationsController < ApplicationController
  def new
    @user = current_user
    @invitation = Invitation.new
    @groups = @user.groups
  end

  def create
    @recipient_email = params["invitation"]["recipient_email"]
    if User.find_by_email(@recipient_email).nil?
      @invitation = Invitation.new(params[:invitation])
      @recipient_email = params[:recipient_email]
      token = @invitation.token
      @invitation.sender = current_user
      if @invitation.save
        InvitationMailer.send_invitation(@invitation, "/users/new?token=#{token}").deliver
        redirect_to root_url, :notice => "Successfully created invitation."
      else
        render :action => 'new'
      end
    else
      invite_existing_user(params["invitation"]["recipient_email"], params["invitation"]["group_id"])
    end
  end

  def invite_existing_user(user_email, group_id)
    user = User.find_by_email(user_email)
    if !user.groups.present?
      group = Group.where(:id => group_id).first
      group.user_groups.build(:user_id => user.id)
      group.save
      InvitationMailer.user_added_to_group(group, user_email).deliver
      redirect_to root_url, :notice => "User has been added to the group as he is already a Bill Titan user."
    else
      redirect_to root_url, :notice => "The user is already a member of the group you want to add him to."
    end
  end
end
