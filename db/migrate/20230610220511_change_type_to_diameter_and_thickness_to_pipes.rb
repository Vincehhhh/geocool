class ChangeTypeToDiameterAndThicknessToPipes < ActiveRecord::Migration[7.0]
  def change
    change_column :pipes, :thickness_mm, :float
    change_column :pipes, :diameter_ext_mm, :float

  end
end
