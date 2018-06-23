class AdminController < ApplicationController

  # User has to be logged in for certain actions
   before_filter :authenticate_admin!

   # Renders the index page
   # If admin was logged in as a user, log back to admin
   def index
     if session[:admin_id].present? && current_user.id != session[:admin_id]
       sign_in(:user, User.find(session[:admin_id]), {:bypass => true})
       redirect_to :admin
     end
   end

   # Renders the user overview
   def users
   	@users = User.all.order(:id)
   end

   # Renders the ventures overview
   def ventures
     @ventures = Venture.all.order(:id)
   end

   # Sets the state of a user.
   def set_user_state
     User.find(params[:id]).update_attributes(:state => params[:state])
     render json: {:state => params[:state]}
   end

   # Logs an admin in as user while bypassing the last_signed_in and current_signed_in field
   # The admin session variable makes it possible to come back to the admin pannel
   def login_as_user
     # TODO: This line should be moved into the devise session controller
     session[:admin_id] = current_user.id

     sign_in(:user, User.find(params[:id]), {:bypass => true})
     redirect_to :root
   end

 private

   def authenticate_admin!
     redirect_to :root unless user_signed_in? && (current_user.role == "admin" || session[:admin_id].present?)
   end
end
