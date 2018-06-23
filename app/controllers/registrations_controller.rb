class RegistrationsController < Devise::RegistrationsController

  # User has to be logged in for certain actions
  prepend_before_filter :authenticate_scope!, :except => [:new, :create, :after]

  # Redirects the user after signing up
  def after_inactive_sign_up_path_for(resource)
    after_signup_path
  end

  # Renders the after signup page
  def after
  end

  # Renders edit account page
  def edit
    @connected_providers = current_user.identities.collect{ |identitiy| identitiy.provider }
    super
  end

  # Dont't require the user to enter the current password
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # Overwrite accept params for account updates
  def account_update_params
    params.require(:user).permit(:name, :email, :language, :password, :password_confirmation)
  end
end
