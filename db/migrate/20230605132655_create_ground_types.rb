class CreateGroundTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :ground_types do |t|
      t.string :name
      t.string :slug
      t.integer :thermal_conductivity
      t.integer :density
      t.integer :heat_capacity

      t.timestamps
    end
  end
end
