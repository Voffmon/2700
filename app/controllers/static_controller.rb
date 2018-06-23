class StaticController < ApplicationController

  def welcome
    render layout: "preview"
  end

  def thank_you
    render layout: "preview"
  end

  def good_bye
    render layout: "preview"
  end

  def activity
  end
end
