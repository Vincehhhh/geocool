class CreatePipes < ActiveRecord::Migration[7.0]
  def change
    create_table :pipes do |t|
      t.string :material
      t.string :nominal_diameter_dn
      t.string :name
      t.references :manufacturer, null: false, foreign_key: true
      t.integer :thermal_conductivity
      t.integer :thickness_mm
      t.integer :diameter_ext_mm

      t.timestamps
    end
  end
end
