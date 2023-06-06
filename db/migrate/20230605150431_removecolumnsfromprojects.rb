class Removecolumnsfromprojects < ActiveRecord::Migration[7.0]
  def change
    remove_columns :projects, :start_heating_date, :end_heating_date
    remove_reference :projects, :pipe, foreign_key: true
  end
end
