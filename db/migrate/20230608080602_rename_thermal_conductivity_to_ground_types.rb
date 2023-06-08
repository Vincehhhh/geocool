class RenameThermalConductivityToGroundTypes < ActiveRecord::Migration[7.0]
  def change
    rename_column :ground_types, :thermal_conductivity, :lambda_ground
  end
end
