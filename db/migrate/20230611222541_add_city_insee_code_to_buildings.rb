class AddCityInseeCodeToBuildings < ActiveRecord::Migration[7.0]
  def change
    add_column :buildings, :city_insee_code, :string
  end
end
