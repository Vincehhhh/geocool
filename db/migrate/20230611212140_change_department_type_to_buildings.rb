class ChangeDepartmentTypeToBuildings < ActiveRecord::Migration[7.0]
  def change
    change_column :buildings, :department, :string

  end
end
