class RemoveForeignKeyWorkingPipesToWorkingWells < ActiveRecord::Migration[7.0]
  def change
    # remove_foreign_key :working_well_systems, :working_pipe
    remove_reference :working_well_systems, :working_pipe, index: true, foreign_key: true

  end
end
