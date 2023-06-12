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

    @seismes = fetch_risques_seismes(@building.city_insee_code)
    @radon = fetch_risques_radon(@building.city_insee_code)
  end

  def show
  end

  def fetch_risques_seismes(code_insee)
    url = "https://www.georisques.gouv.fr/api/v1/zonage_sismique?code_insee=#{code_insee}&page=1&page_size=10&rayon=1000"

    # response = URI.open(url).read
    # JSON.parse(response)
    response = JSON.parse((HTTParty.get(url)).body)
    zone_seismes = response["data"][0]["zone_sismicite"]
  end

  def fetch_risques_radon(code_insee)
    url ="https://www.georisques.gouv.fr/api/v1/radon?code_insee=#{code_insee}&page=1&page_size=10"
    # response = URI.open(url).read
    # JSON.parse(response)
    response = JSON.parse((HTTParty.get(url)).body)
    zone_radon = response["data"][0]["classe_potentiel"]
  end


end
