module DeviseHelper
  def devise_error_messages!
    if resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.present?
    	flash.now[:error] = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join()
    	nil
    end
  end

end