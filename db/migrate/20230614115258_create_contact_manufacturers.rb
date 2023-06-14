class CreateContactManufacturers < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_manufacturers do |t|
      t.references :project, null: false, foreign_key: true
      t.references :manufacturer, null: false, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
