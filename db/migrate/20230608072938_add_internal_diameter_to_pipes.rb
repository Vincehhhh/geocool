class AddInternalDiameterToPipes < ActiveRecord::Migration[7.0]
  def change
    add_column :pipes, :diameter_int_mm, :integer
  end
end
