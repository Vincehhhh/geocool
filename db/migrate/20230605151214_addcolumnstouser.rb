class Addcolumnstouser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :company_name, :string
    add_column :users, :premium_status, :boolean
  end
end
