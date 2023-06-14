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
      @building.city_insee_code = fetch_code_insee(@building.city_name)
      dpt_number = @building.department.split(' =')[0]
      @building.department = dpt_number
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
    # params.require(:building).permit(:area, :building_type, :postal_code,:city_name,:category,:nominal_flow_rate)
    params.require(:building).permit(:area, :building_type, :department, :city_name,:category,:nominal_flow_rate, :available_area)

  end

  def fetch_code_insee(query)
    encoded_query = URI.encode_www_form_component(query)
    url = "https://geo.api.gouv.fr/communes?nom=#{encoded_query}&fields=codesPostaux&boost=population&limit=1"
    # response = URI.open(url).read
    # JSON.parse(response)
    response = JSON.parse((HTTParty.get(url)).body)
    code_insee = response[0]["code"]
  end

end
