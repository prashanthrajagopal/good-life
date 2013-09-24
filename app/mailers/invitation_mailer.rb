class InvitationMailer < ActionMailer::Base

  def send_invitation(invitation, signup_url)
    @invitation = invitation
    @url  = signup_url
    mail(:to => @invitation.recipient_email, 
     :subject => "Welcome to My Awesome Site",
     :body => "you have been invited to join out beta #{@url}"  
     )
    @invitation.update_attribute(:sent_at, DateTime.now)
  end

  def user_added_to_group(group, user_email)
    @group = group
    mail(:to => user_email, 
     :subject => "You have been added",
     :body => "You have been added to the group #{@group.name}"
     )
  end  	
end
