class GeoCoolSolver < ApplicationRecord
  def self.compute(json_form)
    # Prochaine ligne à modifier quand le form sera fait !!
    json_form = File.open("lib/assets/python/sample_file.json").read

    result = `python3 lib/assets/python/geocool_dim.py '#{json_form.to_s}'`
    best_pipes = JSON.parse(result)["selected_wells"].first(3)

    @working_wells = []
    best_pipes.map do |result|
      data = {
        pipe: Pipe.last,
        proposed_length_lo: result["proposed_length_lo"],
        proposed_number_of_pipes: result["proposed_number_of_pipes"],
        occupied_area: result["occupied_area"],
        proposed_total_length: result["proposed_total_length"],
        nominal_speed: result["nominal_speed"].round(1),
      }
      @working_wells << WorkingWellSystem.new(data)
    end

    @working_wells
    # accepted_attributes =  WorkingWellSystem.new.attributes.keys.map(&:to_sym)

    # results.map do |result|
    #   WorkingWellSystem.new(result.with_indifferent_access.slice(accepted_attributes))
    # end
  end
end
