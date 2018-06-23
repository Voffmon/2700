class ApplicationController < ActionController::Base

  # Protect from CSFR
  protect_from_forgery with: :exception

  # For every call determine language
  before_action :set_locale

  # Allow call only if user is not blocked
  before_action :is_not_blocked?

  # Set locale from url
  def set_locale

    # If language is set in the url, use it
    if params[:locale].present? && I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]

    # If no language is set, guess it from the browser language
    elsif request.env["PATH_INFO"] == "/"
      redirect_to "/#{http_accept_language.compatible_language_from(I18n.available_locales)}"

    # Exception for omniauth and the api controller
    elsif ["omniauth", "api"].include?(params[:controller])
      # Do nothing

    # If the language does not exist redirect to 404
    else
      render "errors/404", :status => 404
    end
  end

  # Use locale for all url helpers
  def default_url_options(options = {})
    {:locale => I18n.locale}
  end

  private

    def is_not_blocked?
      render "errors/404" if user_signed_in? && current_user.state == "blocked" && session[:admin_id].blank?
    end
end
