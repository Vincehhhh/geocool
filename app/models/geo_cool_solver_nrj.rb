class GeoCoolSolverNrj < ApplicationRecord
  def self.compute(project, json_form, json_temperatures)
    # Prochaine ligne à modifier quand le form sera fait !!
    json_form = File.open("lib/assets/python/input_from_ruby.json").read
    # json_temperatures = File.open("lib/assets/python/temperatures.json").read
    # json_temperatures = File.open("lib/assets/python/temperatures.json").read

    json_path_input = "lib/assets/python/input_from_ruby.json"
    json_path_temperatures = "lib/assets/python/temperatures.json"
    # json_form = File.open("lib/assets/python/sample_file2.json").read

    # only sizing results :
    # result = `python3 lib/assets/python/geocool_dim.py '#{json_form.to_s}'`

    # with nrj results :

    # method for only sizing :
    # result = `python3 lib/assets/python/geocool_dim_with_nrj.py '#{json_form.to_s}' '#{json_temperatures.to_s}'`

    # method with energetics results :
    command = "python3 lib/assets/python/geocool_dim_with_nrj.py '#{json_path_input}' '#{json_path_temperatures}'"
    result = `#{command}`

    # best_pipes_all = JSON.parse(result)["selected_wells"].sort_by { |hash| hash["occupied_area"] }
    best_pipes_all = JSON.parse(result)["selected_wells"]
    @number_of_calculs = JSON.parse(result)["number_of_tests"]
    @weather_data = best_pipes_all.first["weather_stats"]
    @wells_results = best_pipes_all.each_with_index.map do |pipe,index|
      {
        temporary_well_id:index+1,
        pipe_id: pipe["pipe_id"],
        well_system_name:"#{pipe["proposed_number_of_pipes"]} x #{pipe["pipe_data"]["name"]}",
        summer_results: pipe["summer_perf"],
        winter_results: pipe["winter_perf"]
      }
    end

    @working_wells = best_pipes_all.each_with_index.map do |result,index|
      WorkingWellSystem.new(
        name: "#{result["proposed_number_of_pipes"]} x #{result["pipe_data"]["name"]}",
        pipe_id: result["pipe_id"],
        temporary_well_id:index+1,
        project_id: project.id,
        # pipe: Pipe.last,
        proposed_length_lo: result["proposed_length_lo"],
        proposed_number_of_pipes: result["proposed_number_of_pipes"],
        occupied_area: result["occupied_area"],
        proposed_total_length: result["proposed_total_length"],
        nominal_speed: result["nominal_speed"].round(2),
      )

      # {
      #   name: "#{result["proposed_number_of_pipes"]} x #{result["pipe_data"]["name"]}",
      #   pipe_id: result["pipe_id"],
      #   project_id: project.id,
      #   # pipe: Pipe.last,
      #   proposed_length_lo: result["proposed_length_lo"],
      #   proposed_number_of_pipes: result["proposed_number_of_pipes"],
      #   occupied_area: result["occupied_area"],
      #   proposed_total_length: result["proposed_total_length"],
      #   nominal_speed: result["nominal_speed"].round(2),
      # }
    end
    return {
      number_of_calculs: @number_of_calculs,
      working_wells: @working_wells,
      weather_data: @weather_data,
      wells_results: @wells_results
    }
    # accepted_attributes =  WorkingWellSystem.new.attributes.keys.map(&:to_sym)

    # results.map do |result|
    #   WorkingWellSystem.new(result.with_indifferent_access.slice(accepted_attributes))
    # end
  end
end
