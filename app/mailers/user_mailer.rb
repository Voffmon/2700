class UserMailer < Devise::Mailer

  include MailerHelper

	# Overwrites Devise confirmation mail
  def confirmation_instructions(user, token, opts={})
    send_mail({
      :subject  => "My3605 Confirmation",
      :to       => user.email,
      :params   => {
        :user     => user,
        :token    => token
      }
    })
  end

  # Overwrites Devise reset password mail
  def reset_password_instructions(user, token, opts={})
    send_mail({
      :subject  => "My3605 Reset Password",
      :to       => user.email,
      :params   => {
        :user     => user,
        :token    => token
      }
    })
  end
end
