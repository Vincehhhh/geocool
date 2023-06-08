class RenameFloorAreaToBuildings < ActiveRecord::Migration[7.0]
  def change
    rename_column :buildings, :floor_area, :area
  end
end
