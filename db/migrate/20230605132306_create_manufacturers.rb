class CreateManufacturers < ActiveRecord::Migration[7.0]
  def change
    create_table :manufacturers do |t|
      t.string :social_name
      t.string :address
      t.string :admin_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
