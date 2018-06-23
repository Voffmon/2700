class PositionsController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_owner!, :only => [:show, :edit, :update, :set_active_state]
  before_action :authenticate_category_owner!, :only => [:create, :new]

  # Renders the position detail page
  def show
    @position = Position.find(params[:id])
    @plan_months = @position.plan_months.order(:month)
    @category = @position.category
    @dimension = @category.dimension
    @setup = @category.setup
    @venture = @setup.venture
  end

  # Renders new venture page
  def new
    @position = Position.new(category_id: params[:category_id])
    @category = @position.category
  end

  # Creates a new position
  def create
    position = Position.create!(position_params.merge(category_id: params[:category_id]))
    category = position.category
    setup = category.setup
    redirect_to setup_path(venture_id: setup.venture_id, year: setup.year, dimension: category.dimension)
  end

  # Renders venture edit page
  def edit
    @position = Position.find(params[:id])
    @category = @position.category
  end

  # Updates a venture
  def update
     Position.update(params[:id], position_params)
     redirect_to position_path(params[:id])
  end

  # Sets the order of the positions
  # Also changes the category if a position was moved between categories
  # TODO: Refactor with acts_as_list Gem
  def set_position_order

    # Get venture for validation
    venture = Category.find(params[:from]).setup.venture
    return unless venture.user_id == current_user.id

    # Get all category and position ids from user for validation
    category_ids = venture.categories.pluck(:id)
    position_ids = venture.positions.pluck(:id)

    # Validate that categories and positions really belong to user
    return unless category_ids.include?(params[:from].to_i) &&
                  category_ids.include?(params[:to].to_i) &&
                  (params[:from_ids].blank? || (position_ids & params[:from_ids].map(&:to_i)).size == params[:from_ids].size) &&
                  (position_ids & params[:to_ids].map(&:to_i)).size == params[:to_ids].size

    # Update from category positions
    if params[:from_ids].present?
      params[:from_ids].each_with_index do |position_id, i|
        Position.update(position_id, :order => i, :category_id => params[:from])
      end
    end

    # Update to category positions
    params[:to_ids].each_with_index do |position_id, i|
      Position.update(position_id, :order => i, :category_id => params[:to])
    end
  end

  # Updates the state of a position
  def set_active_state
    position = Position.find(params[:id])
    position.update_attributes(active_state: params[:state])

    render json: {
      :active_state => position.active_state
    }
  end

  # Toggles needs_attention of a position
  def toggle_needs_attention
    position = Position.find(params[:id])
    position.toggle!(:needs_attention)

    render json: {
      :needs_attention => position.needs_attention
    }
  end


  private

    # Only the owner of the position is allowed to perform certain actions
    def authenticate_owner!
      render "errors/404" unless Position.find(params[:id]).category.setup.venture.user_id == current_user.id
    end

    # Only the owner of the category is allowed to perform certain actions
    def authenticate_category_owner!
      render "errors/404" unless Category.find(params[:category_id]).setup.venture.user_id == current_user.id
    end

    # Permit parameters for position
    def position_params
      params.require(:position).permit(:category_id, :needs_attention, :name, :vat)
    end
end
