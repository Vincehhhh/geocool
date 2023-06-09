class ChangeLambdaTypeFloatToPipes < ActiveRecord::Migration[7.0]
  def change
    change_column :pipes, :thermal_conductivity, :float

  end
end
