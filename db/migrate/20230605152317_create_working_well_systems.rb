class CreateWorkingWellSystems < ActiveRecord::Migration[7.0]
  def change
    create_table :working_well_systems do |t|
      t.references :project, null: false, foreign_key: true
      t.references :working_pipe, null: false, foreign_key: true
      t.integer :proposed_length_lo
      t.integer :proposed_number_of_pipes
      t.integer :occupied_area
      t.integer :proposed_total_length
      t.integer :nominal_speed

      t.timestamps
    end
  end
end
