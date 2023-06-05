class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :building, null: false, foreign_key: true
      t.references :ground_type, null: false, foreign_key: true
      t.references :pipe, null: false, foreign_key: true
      t.date :start_heating_date
      t.date :end_heating_date
      t.string :name

      t.timestamps
    end
  end
end
