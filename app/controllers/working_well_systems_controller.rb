class WorkingWellSystemsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @building = @project.building
    @ground = @project.ground_type
    @pipes = Pipe.all
    global_hash = {}

    ground_hash = @ground.as_json(except: [:created_at, :updated_at])
    building_hash = @building.as_json(except: [:created_at, :updated_at])
    pipes_hash = @pipes.as_json(except: [:created_at, :updated_at])
    # ground_json = ground_hash.to_json
    # building_json = building_hash.to_json

    global_hash[:ground] = ground_hash
    global_hash[:building_data] = building_hash
    global_hash[:pipes] = pipes_hash

    # conversion en json du hash global
    global_json = global_hash.to_json

    File.open('lib/assets/python/input_from_ruby.json', 'w') do |f|
      f.write(global_json)
    end

    @working_wells = @project.working_well_systems.presence || GeoCoolSolver.compute(@project, 'lib/assets/python/input_from_ruby.json')

    # @sorted_working_wells = @working_wells.sort_by { |hash| hash["occupied_area"] }
    # @sorted_working_wells = @working_wells.sort_by { |hash| hash["proposed_length_lo"] }
    @sorted_working_wells = @working_wells.sort_by { |hash| hash["proposed_total_length"] }


  end

  def show
  end

end
