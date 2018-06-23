Rails.application.routes.draw do

  # Devise routes for Omniauth, can not be scoped with locale
  devise_for :users,
    skip: [:session, :password, :registration, :confirmation],
    controllers: {omniauth_callbacks: "omniauth"}

  # Language scope
  scope "(:locale)" do

    # Root depending on logged in status
    authenticated :user do
      root :to => "ventures#index"
    end
    root "static#welcome"

    # Errors
    %w(404 422 500).each do |status|
      get status, :to => "errors#show", :status => status
    end

    # User routes
    devise_scope :user do

      # After signup
      get "/you-got-a-mail" => "registrations#after", :as => :after_signup

      # Login and logout
      get    "/login" => "devise/sessions#new", :as => :session
      post   "/login" => "devise/sessions#create"
      delete "/login" => "devise/sessions#destroy"

      # Signup
      get    "/signup" => "registrations#new", :as => :registration
      #post   "/signup" => "registrations#create"
      #delete "/signup" => "registrations#destroy"

      # Edit account
      get "/account" => "registrations#edit", :as => :edit_registration
      put "/account" => "registrations#update"

      # Resend confirmation
      get  "/resend-confirmation" => "confirmations#new", :as => :confirmation
      post "/resend-confirmation" => "confirmations#create"

      # Confirm user
      get   "/confirm/:confirmation_token" => "confirmations#show", :as => :confirm
      patch "/confirm/:confirmation_token" => "confirmations#confirm"

      # Reset password
      get  "/reset-password" => "devise/passwords#new", :as => :password
      post "/reset-password" => "devise/passwords#create"

      # Edit password
      get "/reset-password/:reset_password_token" => "devise/passwords#edit", :as => :edit_password
      put "/reset-password/:reset_password_token" => "devise/passwords#update", :as => :update_password
    end

    # Admin routes
    scope "admin" do
      get ""         => "admin#index", :as => :admin
      get "users"    => "admin#users", :as => :admin_users
      get "ventures" => "admin#ventures", :as => :admin_ventures
      post "login-as-user/:id" => "admin#login_as_user", :as => :login_as_user
      patch "set-user-state/:id/:state" => "admin#set_user_state", :as => :set_user_state
    end

    # Venture routes
    get "analysis/:id/:year/:mode" => "ventures#analysis", :as => :analysis
    resources :ventures

    # Setup routes
    get "setup/:venture_id/:year/archived-positions" => "setups#archived_positions", :as => :archived_positions
    get "setup/:venture_id/:year/deleted-positions" => "setups#deleted_positions", :as => :deleted_positions
    get "setup/:venture_id/:year/(:dimension)" => "setups#index", :as => :setup
    post "setup/create" => "setups#create", :as => :create_setup
    resources :setups

    # Category routes
    patch "categories/set-category-order" => "categories#set_category_order", :as => :update_category_order
    resources :categories

    # Position routes
    patch "positions/set-state/:id/:state" => "positions#set_active_state", :as => :set_position_state
    patch "positions/toggle-needs-attention/:id" => "positions#toggle_needs_attention", :as => :toggle_position_needs_attention
    patch "positions/set-position-order" => "positions#set_position_order", :as => :update_position_order
    resources :positions

    # Plan routes
    get "plan/:id" => "plans#index", :as => :plan
    put "plan/save" => "plans#save", :as => :save_plan
    get "plan-method/:id" => "plans#plan_method", :as => :plan_method
    post "plan-method" => "plans#save_plan_method", :as => :save_plan_method

    # Transaction routes
    get "transactions/:venture_id" => "transactions#index", :as => :transaction_path
    get "number-of-days" => "transactions#get_number_of_days", :as => :number_of_days
    get "positions-for-year" => "transactions#get_positions_for_year", :as => :positions_for_year
    resources :transactions

    # Preset routes
    resources :presets

    # Static pages
    get "thank-you" => "static#thank_you"
    get "good-bye"  => "static#good_bye"
    get "activity"  => "static#activity", :as => :activity
  end
end
