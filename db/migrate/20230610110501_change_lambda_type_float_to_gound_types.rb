class ChangeLambdaTypeFloatToGoundTypes < ActiveRecord::Migration[7.0]
  def change
    change_column :ground_types, :lambda_ground, :float

  end
end
