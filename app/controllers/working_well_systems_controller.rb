class WorkingWellSystemsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @working_wells = @project.working_wells.presence || GeoCoolSolver.compute("result_from_form")
    @sorted_working_wells = @working_wells.sort_by { |hash| hash["occupied_area"] }.first(3)

    # @results = GeoCoolSolver.compute("result_from_form")
    # @working_well = @results.first
  end

  def show
    
  end

end
