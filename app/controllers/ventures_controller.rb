class VenturesController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_owner!, :only => [:show, :analysis, :edit, :update, :destroy]

  # Renders venture overview
  def index
    @ventures = current_user.ventures
  end

  # Renders venture detail
  def show
    @venture = Venture.find(params[:id])
    @setups = @venture.setups
  end

  # Renders the analysis partial
  def analysis
    venture = Venture.find(params[:id])
    setup = venture.setups.where(year: params[:year]).first
    render json: {
      :html => render_to_string(
        :partial => "analysis",
        :layout  => false,
        :locals  => {:setup => setup, :presets => venture.presets, :mode => params[:mode]})
    }
  end

  # Renders new venture page
  def new
    @venture = Venture.new
  end

  # Creates a new venture
  def create
    venture = Venture.create!(venture_params.merge(user_id: current_user.id))
    redirect_to setup_path(venture.id, venture.setups.first.year)
  end

  # Renders venture edit page
  def edit
    @venture = Venture.find(params[:id])
  end

  # Updates a venture
  def update
    Venture.update(params[:id], venture_params)
    redirect_to venture_path(params[:id])
  end

  # Destroys a venture
  def destroy
    Venture.find(params[:id]).destroy
    redirect_to ventures_path
  end


  private

    # Only the owner of a venture is allowed to show, update and delete
    def authenticate_owner!
      render "errors/404" unless Venture.exists?(id: params[:id], user_id: current_user.id)
    end

    # Permit parameters
    def venture_params
      params.require(:venture).permit(:name, :description, :currency, :vat, :taxes_report_cycle)
    end
end
