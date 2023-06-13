class AddColumnSource < ActiveRecord::Migration[7.0]
  def change
    add_column :ground_types, :source, :string
  end
end
