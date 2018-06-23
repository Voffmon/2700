class SetupsController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_venture_owner!, :only => [:index, :create, :archived_positions, :deleted_positions]

  # Renders venture setup page
  def index
    @venture = Venture.find(params[:venture_id])
    @setups = @venture.setups.order(:year)
    @selected_setup = @setups.where(year: params[:year]).first
    @categories = @selected_setup.categories
    @dimension = params[:dimension]
  end

  # Renders archived positions page
  def archived_positions
    @positions = Venture.find(params[:venture_id]).setups.where(year: params[:year]).first.positions.archived
  end

  # Renders deleted positions page
  def deleted_positions
    @positions = Venture.find(params[:venture_id]).setups.where(year: params[:year]).first.positions.deleted
  end

  # Creates a new setup
  def create

    from_setup = Setup.where(venture_id: params[:venture_id], year: params[:from_year]).first
    to_setup = Setup.where(venture_id: params[:venture_id], year: params[:to_year]).first

    # It is possible to overwrite the setup
    to_setup.destroy! if to_setup.present?

    # Create to year setup and copy all categories and positions and plan months
    if params[:mode] == "complete"
      return if from_setup.blank?
      to_setup = Setup.copy_setup_with_plan_months(from_setup, params[:to_year])

    # Create to year setup and copy all categories and positions
    elsif params[:mode] == "structure"
      return if from_setup.blank?
      to_setup = Setup.copy_setup(from_setup, params[:to_year])

    # Create to year setup
    elsif params[:mode] == "scratch"
      to_setup = Setup.create!(venture_id: from_setup.venture_id, year: params[:to_year])
    end

    redirect_to setup_path(to_setup.venture_id, to_setup.year)
  end


  private

    # Only the owner of the venture is allowed to perform certain actions
    def authenticate_venture_owner!
      render "errors/404" unless Venture.find(params[:venture_id]).user_id == current_user.id
    end

    # Permit parameters for setup
    def setup_params
      params.require(:setup).permit(:year)
    end
end
