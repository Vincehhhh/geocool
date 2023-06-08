class Changetypenameinbuildingtable < ActiveRecord::Migration[7.0]
  def change
    rename_column :buildings, :type, :building_type
  end
end
