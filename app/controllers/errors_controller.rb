class ErrorsController < ApplicationController

  # Renders a custom dynamic error page depending on the status code
  # Also look at the routes for a list of error codes
  def show
    render status.to_s, :status => status
  end

  protected

    # Set defaul HTTP status to 500
    def status
      params[:status] || 500
    end
end
