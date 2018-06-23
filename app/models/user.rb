class User < ApplicationRecord

  # Relations
  has_many :identities
  has_many :ventures

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :timeoutable,
         :omniauthable

  validates :state, :inclusion => {:in => %w(approved blocked)}

  # User should be able to sign up without password
  def password_required?
    super if confirmed?
  end

  # Validates name and password for confirmation show view
  def password_match?
    locale_path = "activerecord.errors.models.user.attributes"

    # Validation for name
    self.errors[:name] << I18n.t(locale_path + ".name.blank") if name.blank?

    # Validation for password
    self.errors[:password] << I18n.t(locale_path + ".password.blank") if password.blank?
    self.errors[:password] << I18n.t(locale_path + ".password.length", :range => Devise.password_length.to_s) unless Devise.password_length.include?(password.size)

    # Validation for password confirmation
    self.errors[:password_confirmation] << I18n.t(locale_path + ".password_confirmation.blank") if password_confirmation.blank?
    self.errors[:password_confirmation] << I18n.t(locale_path + ".password_confirmation.match") if password != password_confirmation

    # Return
    password == password_confirmation && !password.blank? && Devise.password_length.include?(password.size)
  end

  # Connects identities with the current user
  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : identity.user

    # Extract email
    email = auth.info.email

    # Extract name
    name = auth.extra.raw_info.name
    name = auth.info.first_name + " " + auth.info.last_name if name.blank?
    name = extract_name_from_email(email) if name.blank?

    if user.nil?
      user = User.where(:email => email).first if email

      if user.nil?
        user = User.new(
          name: name,
          email: email,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      elsif user.confirmed_at.nil?
        user.update(:name => name) if user.name.blank?
        user.confirm
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end

  # Sends emails from devise with active job
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
