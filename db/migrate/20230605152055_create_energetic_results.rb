class CreateEnergeticResults < ActiveRecord::Migration[7.0]
  def change
    create_table :energetic_results do |t|
      t.references :energetic_study, null: false, foreign_key: true

      t.timestamps
    end
  end
end
