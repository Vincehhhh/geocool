class GeoCoolSolver < ApplicationRecord
  def self.compute(json_form)
    # Prochaine ligne à modifier quand le form sera fait !!
    json_form = File.open("lib/assets/python/input_from_ruby.json").read

    # json_form = File.open("lib/assets/python/sample_file.json").read

    result = `python3 lib/assets/python/geocool_dim.py '#{json_form.to_s}'`

    # best_pipes = JSON.parse(result)["selected_wells"].first(3)
    best_pipes_all = JSON.parse(result)["selected_wells"].sort_by { |hash| hash["occupied_area"] }

    @working_wells = best_pipes_all.map do |result|
      WorkingWellSystem.new(
        pipe: Pipe.last,
        proposed_length_lo: result["proposed_length_lo"],
        proposed_number_of_pipes: result["proposed_number_of_pipes"],
        occupied_area: result["occupied_area"],
        proposed_total_length: result["proposed_total_length"],
        nominal_speed: result["nominal_speed"].round(1),
      )
    end
    # accepted_attributes =  WorkingWellSystem.new.attributes.keys.map(&:to_sym)

    # results.map do |result|
    #   WorkingWellSystem.new(result.with_indifferent_access.slice(accepted_attributes))
    # end
  end
end
