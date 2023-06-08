class RenameDiameterIntToPipes < ActiveRecord::Migration[7.0]
  def change
    rename_column :pipes, :diameter_int_mm, :diameter_int
  end
end
