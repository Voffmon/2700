class PresetsController < ApplicationController

  # Filters
  before_action :authenticate_user!
  before_action :authenticate_owner!, :only => [:destroy]
  before_action :authenticate_venture_owner!, :only => [:create]

  # Creates a new preset
  def create
    preset = Preset.create!(preset_params.merge(venture_id: params[:venture_id]))
    render json: {
      :html => render_to_string(
        :partial => "ventures/preset",
        :layout  => false,
        :locals  => {:preset => preset}
    )}
  end

  # Destroys a preset
  def destroy
    Preset.destroy(params[:id])
  end


  private

    # Only the owner of the preset is allowed to perform certain actions
    def authenticate_owner!
      render "errors/404" unless Preset.find(params[:id]).venture.user_id == current_user.id
    end

    # Only the owner of the venture is allowed to perform certain actions
    def authenticate_venture_owner!
      render "errors/404" unless Venture.find(params[:venture_id]).user_id == current_user.id
    end

    # Permit parameters for preset
    def preset_params
      params.require(:preset).permit(:name, :data)
    end
end
