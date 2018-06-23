class ConfirmationsController < Devise::ConfirmationsController

  # Sets the user
  before_action :set_user

  # Renders the confirmation show view
  def show

    # Render a link expired page if user not exists or user has already been confirmed
    if resource.blank? || resource.confirmed_at.present?
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  # This action is performed when submitting the confirmation show view
  def confirm

    # Assign attributes to user
    resource.assign_attributes(permitted_params) unless params[resource_name].nil?

    # If user exists and form validated then confirm
    if resource.valid? && resource.password_match?
      self.resource.confirm!
      set_flash_message :notice, :confirmed
      sign_in_and_redirect resource_name, resource
    else
      render :action => 'show'
    end
  end


  private

    # Before filter: Extract resource from confirmation token
    def set_user
      @confirmation_token = params[:confirmation_token] || params[resource_name].try(:[], :confirmation_token)
      self.resource = resource_class.find_by_confirmation_token @confirmation_token
    end

    # Permit parameters
    def permitted_params
      params.require(resource_name).permit(:confirmation_token, :name, :password, :password_confirmation)
    end
end
