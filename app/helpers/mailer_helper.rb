
# Using Sengrid API for all outbound and inbound mail
require "sendgrid-ruby"

module MailerHelper

  # This method is called from all mailers
  # We use Rails ActiveJob to enqueue the mailer calls in a background process
  def send_mail(params)

    # Default values
    params[:from]        ||= "support@my3605.com"
    params[:to]          ||= "support@my3605.com"
    params[:reply_to]    ||= "support@my3605.com"
    params[:from_name]   ||= "My3605 Support"
    params[:attachments] ||= []

    # Default template path, extracted from class name and method name of caller
    folder = caller_locations(1,1).first.path.to_s.match('[\w]+(?=_mailer.rb)')[0]
    file   = caller_locations(1,1).first.label

    params[:template] ||= "mails/" + folder + "/" + file

    # Initialize SendGrid
    sendgrid = SendGrid::Client.new(api_key: SENDGRID_KEY)

    # Render mail views into strings
    html_mail = render(:template => params[:template], :formats => [:html], :layout => false, :locals => params[:params])
    text_mail = render(:template => params[:template], :formats => [:text], :layout => false, :locals => params[:params])

    # Build message
    message = SendGrid::Mail.new do |m|
      m.subject   = params[:subject]
      m.from_name = params[:from_name]
      m.html      = html_mail
      m.text      = text_mail
      m.from      = params[:from]
      m.to        = params[:to]
      m.reply_to  = params[:reply_to]
    end

    # Append attachments
    params[:attachments].each do |attachment|
      message.add_attachment attachment, attachment.original_filename
    end

    # Send message
    sendgrid.send message
  end
end
