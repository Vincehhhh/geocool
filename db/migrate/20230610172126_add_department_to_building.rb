class AddDepartmentToBuilding < ActiveRecord::Migration[7.0]
  def change
    add_column :buildings, :department, :integer
  end
end
