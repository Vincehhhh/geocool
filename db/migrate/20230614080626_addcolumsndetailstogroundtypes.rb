class Addcolumsndetailstogroundtypes < ActiveRecord::Migration[7.0]
  def change
    add_column :ground_types, :details, :text
  end
end
