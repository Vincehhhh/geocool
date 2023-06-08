class GeoCoolSolver < ApplicationRecord
  def self.compute(json_form)
    # Prochaine ligne à modifier quand le form sera fait !!
    json_form = File.open("lib/assets/python/sample_file.json").read

    result = `python3 lib/assets/python/geocool_dim.py '#{json_form.to_s}'`

    results = JSON.parse(result)["selected_wells"].first(3)
    # accepted_attributes =  WorkingWellSystem.new.attributes.keys.map(&:to_sym)

    # results.map do |result|
    #   WorkingWellSystem.new(result.with_indifferent_access.slice(accepted_attributes))
    # end
  end
end
