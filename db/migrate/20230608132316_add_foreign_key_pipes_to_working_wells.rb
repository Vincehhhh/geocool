class AddForeignKeyPipesToWorkingWells < ActiveRecord::Migration[7.0]
  def change
    add_reference :working_well_systems, :pipe, foreign_key: true
  end
end
