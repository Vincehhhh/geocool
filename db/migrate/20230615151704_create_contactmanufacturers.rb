class CreateContactmanufacturers < ActiveRecord::Migration[7.0]
  def change
    create_table :contactmanufacturers do |t|

      t.timestamps
    end
  end
end
