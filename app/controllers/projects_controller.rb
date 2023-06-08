class ProjectsController < ApplicationController



  def new
    @project = Project.new
  end

  def create
    raise
    @building = Building.create!(floor_area: 0,type: "maison", postal_code: 0, city_name: "0", category: "Bureaux", nominal_flow_rate: 0)
    @ground_type = GroundType.create!(name: "0", slug: "0", thermal_conductivity: 0, density: 0, heat_capacity: 0)
    @project = Project.new(set_params)
    if @project.save
      redirect_to root_path(@project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_params
    params.require(:project).permit(:name)
  end
end
