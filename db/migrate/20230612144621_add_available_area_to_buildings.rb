class AddAvailableAreaToBuildings < ActiveRecord::Migration[7.0]
  def change
    add_column :buildings, :available_area, :integer
  end
end
