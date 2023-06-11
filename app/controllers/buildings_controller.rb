class BuildingsController < ApplicationController

  def edit
    @building = Building.find(params[:id])
    file = File.read("lib/assets/departements-region.json")
    file_dpt_data = JSON.parse(file)
    @dpt_list = file_dpt_data.map { |hash| "#{hash["num_dep"]} - #{hash["dep_name"]}"}
    @cities = []
  end

  def update
    @building = Building.find(params[:id])
    @project = Project.find(@building.project_ids)
    if @building.update(building_params)
      @building.department = @building.postal_code / 1000
      @building.save
      # redirect_to project_ground_types_path(@building.project_ids, @building)
      # redirect_to project_ground_types_path(@building)
      redirect_to edit_project_path(@project)
    else
      puts @building.errors.full_messages
    end
  end

  private

  def building_params
    params.require(:building).permit(:area, :building_type, :postal_code,:city_name,:category,:nominal_flow_rate)
  end

  def fetch_communes()
    url = 'https://geo.api.gouv.fr/departements/01/communes'
    # response = URI.open(url).read
    # JSON.parse(response)
    response = HTTParty.get(url)
    JSON.parse(response.body)

  end

end
