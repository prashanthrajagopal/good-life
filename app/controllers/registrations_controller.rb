class RegistrationsController < Devise::RegistrationsController
	def validate
		token = params[:invitation_token]
		@invitation = Invitation.where "token" => token 
		if @invitation.present?
			redirect_to new_user_registration_path
		else
			flash[:notice] = "Invalid Token. Cannot signup with this Link." 
		end
	end
end 