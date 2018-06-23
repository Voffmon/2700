class CategoriesController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_owner!, :only => [:update, :destroy]
  before_action :authenticate_setup_owner!, :only => [:create]

  # Creates a new category
  def create
    category = Category.create!(category_params)
    render json: {
      :html => render_to_string(
        :partial => "setups/category",
        :layout  => false,
        :locals  => {:category => category})
    }
  end

  # Updates a category
  def update
    category = Category.update(params[:category][:id], :name => params[:category][:name])
    render json: {
      :name => category.name
    }
  end

  # Sets the order of the categories
  # TODO: Refactor with acts_as_list Gem
  def set_category_order

    # Get venture for validation
    venture = Category.find(params[:ids].first).venture
    return unless venture.user_id == current_user.id

    # Get all category and position ids from user for validation
    category_ids = venture.categories.pluck(:id)

    # Validate that categories and positions really belong to user
    return unless (category_ids & params[:ids].map(&:to_i)).size == params[:ids].size

    # Update category positions
    params[:ids].each_with_index do |category_id, i|
      Category.update(category_id, :order => i)
    end
  end

  # Destroys a category
  def destroy
    category = Category.find(params[:id])

    # Rescue positions in that category
    dummy_category = Category.where(setup_id: category.setup_id, dimension: category.dimension, order: 0).first
    category.positions.each do |position|
      position.update_attributes(category_id: dummy_category.id)
    end

    # Recalculate the order
    category.positions.each_with_index do |position_id, i|
      Position.update(position_id, :order => i)
    end

    # Destroy category
    category.destroy!

    # Render dummy category because positions may just have been added
    render json: {
      :html => render_to_string(
        :partial => "setups/category",
        :layout  => false,
        :locals  => {:category => dummy_category})
    }
  end


  private

    # Only the owner of the category is allowed to perform certain actions
    # Also dummy categories are never allowed to be updated or deleted
    def authenticate_owner!
      category = Category.find(params[:id])
      render "errors/404" unless category.order != 0 && category.setup.venture.user_id == current_user.id
    end

    # Only the owner of the setup is allowed to perform certain actions
    def authenticate_setup_owner!
      render "errors/404" unless Setup.find(params[:category][:setup_id]).venture.user_id == current_user.id
    end

    # Permit parameters
    def category_params
      params.require(:category).permit(:id, :setup_id, :dimension, :name)
    end
end
