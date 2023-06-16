class AddTemporaryWellIdToWorkingWellSystems < ActiveRecord::Migration[7.0]
  def change
    add_column :working_well_systems, :temporary_well_id, :integer
  end
end
