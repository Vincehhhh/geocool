class BuildingsController < ActionController::Base
  def edit
    @building = Building.find(params[:id])
  end

end
