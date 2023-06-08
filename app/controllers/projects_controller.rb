class ProjectsController < ApplicationController



  def new
    @project = Project.new
  end

  def create
    @building = Building.create!(area: 0, building_type: "Neuf", postal_code: 0, city_name: "0", category: "Bureaux", nominal_flow_rate: 0)
    @ground_type = GroundType.create!(name: "0", lambda_ground: 0, density: 0, heat_capacity: 0)
    @project = Project.new(set_params)
    @project.building = @building
    @project.ground_type = @ground_type
    @project.user = current_user

    if @project.save
      redirect_to edit_project_building_path(@project, @building)
    else
      puts @project.errors.full_messages
      # render :new, status: :unprocessable_entity
    end
  end

  private

  def set_params
    params.require(:project).permit(:name)
  end
end
