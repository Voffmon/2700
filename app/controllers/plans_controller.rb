class PlansController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_position_owner!, :only => [:index, :create, :save, :plan_method, :save_plan_method]

  # Renders the position planning view
  def index
    @position = Position.find(params[:id])
    @category = @position.category
    @setup = @category.setup
  end

  # Show plan methods
  def plan_method
    @position = Position.find(params[:id])
    @category = @position.category
    @year = params[:year]
  end

  # Save plan methods
  def save_plan_method
    position = Position.find(params[:id])
    position.update_attributes(:sales_method => params[:sales_method], :costs_method => params[:costs_method])
    position.plan_months.delete_all
    redirect_to plan_path(position.id)
  end

  # Handles the saving of a plan for a position.
  def save

    # Try to get the position. This decides whether it has to be created or updated
    position = Position.find(params[:id])

    # If structure for that year exists already, only create plan months
    if position.plan_months.size == 0
      params[:plan_month].each do |month|
        PlanMonth.create!(plan_month_params(month).merge(:position_id => position.id, :month => month))
      end

    # If structure and plan month exists, only update the plan months
    else
      params[:plan_month].each do |month|
        PlanMonth.where(:position_id => position.id, :month => month).update(plan_month_params(month))
      end
    end

    # Update position
    position.update(position_params)

    # Redirect back to plan
    redirect_to position_path(position.id)
  end

  private

    # Only the owner of the category is allowed to perform certain actions
    def authenticate_position_owner!
      render "errors/404" unless Position.find(params[:id]).category.setup.venture.user_id == current_user.id
    end

    # Permit parameters for plan
    def position_params
      params.require(:position).permit(
        :field1, :field1_forecast, :field2, :field2_forecast,
        :field3, :field3_forecast, :field4, :field4_forecast,
        :field5, :field5_forecast, :needs_attention
      )
    end

    # Permit parameters for plan month
    def plan_month_params(month)
      params.require(:plan_month)[month].permit(
        :col1, :col1_forecast, :col1_is_user_generated, :col1_is_user_generated_forecast,
        :col2, :col2_forecast, :col2_is_user_generated, :col2_is_user_generated_forecast,
        :col3, :col3_forecast, :col3_is_user_generated, :col3_is_user_generated_forecast,
        :col4, :col4_forecast, :col4_is_user_generated, :col4_is_user_generated_forecast,
        :note, :note_forecast
      )
    end
end
