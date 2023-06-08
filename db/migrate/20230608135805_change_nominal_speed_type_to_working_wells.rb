class ChangeNominalSpeedTypeToWorkingWells < ActiveRecord::Migration[7.0]
  def change
    change_column :working_well_systems, :nominal_speed, :float
  end
end
