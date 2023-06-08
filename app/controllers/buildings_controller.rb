class BuildingsController < ActionController::Base
  def edit
    @building = Building.find(params[:id])

  end

  def update
    @building = Building.find(params[:id])
    if @building.update(building_params)
      # redirect_to project_ground_types_path(@building.project_ids, @building)
      # redirect_to project_ground_types_path(@building)
      redirect_to project_building_ground_types_path(@building.projects, @building)
    else
      puts @building.errors.full_messages
    end
  end

  private

  def building_params
    params.require(:building).permit(:area, :building_type, :postal_code,:city_name,:category,:nominal_flow_rate)
  end

end
