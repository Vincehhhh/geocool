class ProjectsController < ApplicationController

  def index
    @my_projects = Project.where(user: current_user)
    @user = current_user

  end


  def new
    @project = Project.new
  end

  def create
    # TO DO :

    @building = Building.create!(area: 1, building_type: "Neuf", postal_code: 0, city_name: "0", category: "Bureaux", nominal_flow_rate: 2)
    @ground_type = GroundType.last
    @project = Project.new(set_params)
    @project.building = @building
    @project.ground_type = @ground_type
    @project.user = current_user

    if @project.save

      redirect_to edit_project_building_path(@project, @building)
    else
      # puts @project.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project = Project.find(params[:id])
    @ground_types = GroundType.all
    @pipes = Pipe.all
  end

  def update

    @project = Project.find(params[:id])
    redirect_to project_working_well_systems_path(@project)
    # @ground_type = GroundType.find(project_ground_params[:ground_type])
    # #@ground_type = GroundType.find(params[:project][:ground_type])
    # @project.ground_type = @ground_type
    # # raise
    # if @project.save
    #   # redirect_to project_ground_types_path(@building.project_ids, @building)
    #   # redirect_to project_ground_types_path(@building)
    #   redirect_to project_working_well_systems_path(@project)
    # else
    #   puts @building.errors.full_messages
    # end
  end

  private

  def set_params
    params.require(:project).permit(:name)
  end

  def project_ground_params
    params.require(:project).permit(:ground_type)
  end
end
