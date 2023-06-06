class CreateEnergeticStudies < ActiveRecord::Migration[7.0]
  def change
    create_table :energetic_studies do |t|
      t.references :project, null: false, foreign_key: true
      t.date :start_heating_date
      t.date :end_heating_date
      t.integer :studied_length
      t.integer :number_of_branches
      t.integer :underground_depth

      t.timestamps
    end
  end
end
