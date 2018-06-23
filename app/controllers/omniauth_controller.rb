class OmniauthController < Devise::OmniauthCallbacksController

  # Callback for all providers
  def callback
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)

    set_flash_message(:notice, :success, kind: env["omniauth.auth"]["provider"].capitalize)

    # If user is currently logged in, redirect back to account page
    if current_user.present?
      redirect_to edit_registration_path
    else
      sign_in_and_redirect @user, event: :authentication
    end
  end

  # Generates callbacks for all providers
  # We use alias_methods as a trick to auto generate an action for each provider
  [:facebook, :google_oauth2].each do |provider|
    alias_method provider, :callback
  end
end
