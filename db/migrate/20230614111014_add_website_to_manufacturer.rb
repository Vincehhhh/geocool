class AddWebsiteToManufacturer < ActiveRecord::Migration[7.0]
  def change
    add_column :manufacturers, :website, :string

  end
end
