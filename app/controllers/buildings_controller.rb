class BuildingsController < ActionController::Base
  def edit
    @building = Building.find(params[:id])

  end

  def update
    @building = Building.find(params[:id])
    @ground_type= GroundType.find(params[:id])
    if @building.update(building_params)
      redirect_to edit_project_ground_type_path(@building, @ground_type)
    else
      puts @project.errors.full_messages
    end
  end

  private

  def building_params
    params.require(:building).permit(:area, :building_type, :postal_code,:city_name,:category,:nominal_flow_rate)
  end

end
