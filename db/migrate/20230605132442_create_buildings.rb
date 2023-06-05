class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.integer :floor_area
      t.string :type
      t.integer :postal_code
      t.string :city_name
      t.string :category
      t.integer :nominal_flow_rate

      t.timestamps
    end
  end
end
