class AddNameToWorkingWellSystems < ActiveRecord::Migration[7.0]
  def change
    add_column :working_well_systems, :name, :string

  end
end
