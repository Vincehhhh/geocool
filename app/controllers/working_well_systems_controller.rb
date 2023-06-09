class WorkingWellSystemsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @building = @project.building
    @ground = @project.ground_type
    @pipes = Pipe.all

    input_json = {}

    input_json["building_data"] = @building.as_json
    input_json["ground"] = @ground.as_json
    input_json["pipes"] = @pipes.as_json

    input_json["building_data"] = JSON.pretty_generate(@building)
    input_json["ground"] = JSON.pretty_generate(@ground)
    input_json["pipes"] = JSON.pretty_generate(@pipes)

    # input_json_pipe = {}
    # input_json_pipe["pipes"] = JSON.parse(@pipes.to_json, symbolize_names: true))

    # File.open('test_ruby.json', 'w') do |f|
    #   f.write(input_json_pipe)
    # end

    File.open('lib/assets/python/input_from_ruby.json', 'w') do |f|
      f.write(input_json)
    end
    raise
    @working_wells = @project.working_well_systems.presence || GeoCoolSolver.compute("result_from_form")
    @sorted_working_wells = @working_wells.sort_by { |hash| hash["occupied_area"] }.first(3)

    # @working_well = @sorted_working_wells.first
    # raise
  end

  def show
  end

end
